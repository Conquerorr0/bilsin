import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../models/department.dart';
import '../services/firebase_service.dart';

class AnnouncementProvider with ChangeNotifier {
  List<Announcement> _announcements = [];
  List<Announcement> _filteredAnnouncements = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedDepartmentFilter;
  List<String> _followedDepartments = [];

  // Getters
  List<Announcement> get announcements => _filteredAnnouncements;
  List<Announcement> get allAnnouncements => _announcements;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedDepartmentFilter => _selectedDepartmentFilter;
  List<String> get followedDepartments => _followedDepartments;

  // Constructor
  AnnouncementProvider() {
    _initialize();
  }

  // Initialize
  void _initialize() {
    // Başlangıçta boş liste
    _announcements = [];
    _applyFilters();
  }

  // Takip edilen bölümleri güncelle
  void updateFollowedDepartments(
    List<String> departmentIds, {
    bool isNewInstall = false,
  }) {
    print(
      'DEBUG: updateFollowedDepartments called with: $departmentIds, isNewInstall: $isNewInstall',
    );
    _followedDepartments = departmentIds;
    if (departmentIds.isNotEmpty) {
      if (isNewInstall) {
        print('DEBUG: Loading recent announcements for new install');
        loadRecentAnnouncements(departmentIds);
      } else {
        print('DEBUG: Loading followed announcements');
        loadFollowedAnnouncements(departmentIds);
      }
    } else {
      print('DEBUG: No departments selected, showing empty list');
      // Hiç bölüm seçili değilse boş liste göster
      _announcements = [];
      _applyFilters();
      notifyListeners();
    }
  }

  // Yeni kurulum için son 5 duyuruyu yükle
  void loadRecentAnnouncements(List<String> departmentIds) async {
    print('DEBUG: loadRecentAnnouncements called with: $departmentIds');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final announcements = await FirebaseService.getRecentAnnouncements(
        departmentIds,
        limit: 5,
      );
      print('DEBUG: Received ${announcements.length} recent announcements');
      _announcements = announcements;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error loading recent announcements: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Takip edilen bölümlerin duyurularını yükle
  void loadFollowedAnnouncements(
    List<String> departmentIds, {
    bool isNewInstall = false,
  }) {
    print('DEBUG: loadFollowedAnnouncements called with: $departmentIds');
    _isLoading = true;
    _error = null;
    notifyListeners();

    FirebaseService.getAnnouncementsStream(departmentIds).listen(
      (announcements) {
        print(
          'DEBUG: Received ${announcements.length} announcements from stream',
        );
        _announcements = announcements;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        print('DEBUG: Error in stream: $error');
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Arama sorgusu güncelle
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Bölüm filtresi güncelle
  void updateDepartmentFilter(String? departmentId) {
    _selectedDepartmentFilter = departmentId;
    _applyFilters();
    notifyListeners();
  }

  // Filtreleri uygula
  void _applyFilters() {
    // Tekrar eden duyuruları temizle (id bazında)
    final uniqueAnnouncements = <String, Announcement>{};
    for (final announcement in _announcements) {
      uniqueAnnouncements[announcement.id] = announcement;
    }
    final deduplicatedAnnouncements = uniqueAnnouncements.values.toList();

    _filteredAnnouncements = deduplicatedAnnouncements.where((announcement) {
      // Arama filtresi
      if (_searchQuery.isNotEmpty) {
        final searchMatch =
            announcement.baslik.toLowerCase().contains(_searchQuery) ||
            announcement.icerik.toLowerCase().contains(_searchQuery) ||
            announcement.bolumAdi.toLowerCase().contains(_searchQuery);
        if (!searchMatch) return false;
      }

      // Bölüm filtresi
      if (_selectedDepartmentFilter != null) {
        if (announcement.bolumId != _selectedDepartmentFilter) return false;
      }

      return true;
    }).toList();

    // Yayınlanma tarihine göre sırala (en yeni önce)
    _filteredAnnouncements.sort((a, b) {
      final dateA = a.yayinlanmaTarihi ?? a.tarih;
      final dateB = b.yayinlanmaTarihi ?? b.tarih;
      return dateB.compareTo(dateA);
    });
  }

  // Duyuru detayını getir
  Announcement? getAnnouncementById(String id) {
    try {
      return _announcements.firstWhere((announcement) => announcement.id == id);
    } catch (e) {
      return null;
    }
  }

  // Bölüm bazında duyuru sayısı
  Map<String, int> getAnnouncementCountsByDepartment() {
    Map<String, int> counts = {};

    for (final announcement in _announcements) {
      counts[announcement.bolumId] = (counts[announcement.bolumId] ?? 0) + 1;
    }

    return counts;
  }

  // En çok duyuru olan bölümler
  List<MapEntry<String, int>> getTopDepartments({int limit = 5}) {
    final counts = getAnnouncementCountsByDepartment();
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(limit).toList();
  }

  // Son 24 saatteki duyurular
  List<Announcement> getRecentAnnouncements({int hours = 24}) {
    final cutoff = DateTime.now().subtract(Duration(hours: hours));
    return _announcements
        .where((announcement) => announcement.olusturmaZamani.isAfter(cutoff))
        .toList();
  }

  // Bölüm adını getir
  String getDepartmentName(String departmentId) {
    final department = Department.allDepartments.firstWhere(
      (d) => d.id == departmentId,
      orElse: () => Department(
        id: departmentId,
        name: 'Bilinmeyen Bölüm',
        url: '',
        color: Colors.grey,
      ),
    );
    return department.name;
  }

  // Filtreleri temizle
  void clearFilters() {
    _searchQuery = '';
    _selectedDepartmentFilter = null;
    _applyFilters();
    notifyListeners();
  }

  // Hata temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Yenile
  void refresh() {
    if (_followedDepartments.isNotEmpty) {
      loadFollowedAnnouncements(_followedDepartments);
    } else {
      // Hiç bölüm seçili değilse boş liste göster
      _announcements = [];
      _applyFilters();
      notifyListeners();
    }
  }

  // İstatistikler
  Map<String, dynamic> getStatistics() {
    final total = _announcements.length;
    final recent = getRecentAnnouncements().length;
    final departments = _announcements.map((a) => a.bolumId).toSet().length;
    final topDepartments = getTopDepartments(limit: 3);

    return {
      'total': total,
      'recent': recent,
      'departments': departments,
      'topDepartments': topDepartments
          .map((e) => {'name': getDepartmentName(e.key), 'count': e.value})
          .toList(),
    };
  }
}
