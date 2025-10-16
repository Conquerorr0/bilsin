import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // Pagination state
  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Map<String, DateTime?> _deptCursors = {};
  static const String _prefsKeyFilter = 'selected_department_filter';

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
    _loadPersistedFilter();
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
      // Pagination tabanlı ilk yükleme
      print('DEBUG: Loading initial paged announcements');
      loadInitialAnnouncements(departmentIds);
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
    // Artık stream yerine sayfalı yükleme kullanıyoruz
    print(
      'DEBUG: loadFollowedAnnouncements -> redirect to loadInitialAnnouncements',
    );
    loadInitialAnnouncements(departmentIds);
  }

  // Paged loading - initial
  Future<void> loadInitialAnnouncements(List<String> departmentIds) async {
    _isLoading = true;
    _error = null;
    _deptCursors = {for (final id in departmentIds) id: null};
    _hasMore = true;
    _announcements = [];
    notifyListeners();

    try {
      final page = await FirebaseService.getAnnouncementsPage(
        departmentIds,
        limit: _pageSize,
        cursors: _deptCursors,
      );
      _deptCursors = page['cursors'] as Map<String, DateTime?>;
      final items = page['announcements'] as List<Announcement>;
      _hasMore = page['hasMore'] as bool;
      _announcements = items;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Paged loading - load more
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _followedDepartments.isEmpty) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await FirebaseService.getAnnouncementsPage(
        _followedDepartments,
        limit: _pageSize,
        cursors: _deptCursors,
      );
      _deptCursors = page['cursors'] as Map<String, DateTime?>;
      final items = page['announcements'] as List<Announcement>;
      _hasMore = page['hasMore'] as bool;
      // Append with dedupe
      final map = {for (final a in _announcements) a.id: a};
      for (final a in items) {
        map[a.id] = a;
      }
      _announcements = map.values.toList();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
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
    _persistSelectedFilter();
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

  Future<void> _loadPersistedFilter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKeyFilter);
      if (saved != null && saved.isNotEmpty) {
        _selectedDepartmentFilter = saved;
      }
    } catch (_) {}
  }

  Future<void> _persistSelectedFilter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_selectedDepartmentFilter == null) {
        await prefs.remove(_prefsKeyFilter);
      } else {
        await prefs.setString(_prefsKeyFilter, _selectedDepartmentFilter!);
      }
    } catch (_) {}
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
    final departments = _followedDepartments.toSet().length;
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
