import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_preferences.dart';
import '../models/department.dart';
import '../services/firebase_service.dart';
import '../services/fcm_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  UserPreferences? _preferences;
  List<String> _selectedDepartments = [];
  String _notificationPreference = 'tumu';
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  UserPreferences? get preferences => _preferences;
  List<String> get selectedDepartments => _selectedDepartments;
  String get notificationPreference => _notificationPreference;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Constructor
  UserProvider() {
    _initialize();
  }

  // Initialize
  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Auth state değişikliklerini dinle
      FirebaseAuth.instance.authStateChanges().listen((user) {
        _user = user;
        if (user != null) {
          _loadUserPreferences();
        } else {
          _preferences = null;
          _selectedDepartments = [];
          _notificationPreference = 'tumu';
        }
        notifyListeners();
      });

      // FCM başlat
      await FCMService.initialize();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı tercihlerini yükle
  Future<void> _loadUserPreferences() async {
    try {
      final preferences = await FirebaseService.getUserPreferences();
      if (preferences != null) {
        print(
          'DEBUG: User preferences loaded: ${preferences.takipEdilenBolumler}',
        );
        _preferences = preferences;
        _selectedDepartments = preferences.takipEdilenBolumler;
        _notificationPreference = preferences.bildirimTercihi;

        // AnnouncementProvider'a bildirim gönder
        _notifyAnnouncementProvider();
      } else {
        print('DEBUG: No user preferences found, creating default');
        // İlk kez giriş yapan kullanıcı için varsayılan değerler
        await _createDefaultPreferences();
      }
    } catch (e) {
      print('DEBUG: Error loading user preferences: $e');
      _error = e.toString();
    }
    notifyListeners();
  }

  // AnnouncementProvider'a bildirim gönder
  void _notifyAnnouncementProvider() {
    // Bu fonksiyon HomeScreen'den çağrılacak
    // Şimdilik sadece log ekleyelim
    print(
      'DEBUG: _notifyAnnouncementProvider called with departments: $_selectedDepartments',
    );
  }

  // Varsayılan tercihleri oluştur
  Future<void> _createDefaultPreferences() async {
    try {
      final token = FCMService.fcmToken ?? '';
      final defaultPreferences = UserPreferences(
        fcmToken: token,
        takipEdilenBolumler: [],
        bildirimTercihi: 'tumu',
        kayitTarihi: DateTime.now(),
      );

      await FirebaseService.saveUserPreferences(defaultPreferences);
      _preferences = defaultPreferences;
    } catch (e) {
      _error = e.toString();
    }
  }

  // Anonim giriş yap
  Future<void> signInAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await FirebaseService.signInAnonymously();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Takip edilen bölümleri güncelle
  Future<void> updateSelectedDepartments(List<String> departmentIds) async {
    print('DEBUG: updateSelectedDepartments called with: $departmentIds');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedDepartments = departmentIds;
      print('DEBUG: Updating Firebase with departments: $departmentIds');
      await FirebaseService.updateFollowedDepartments(departmentIds);
      print('DEBUG: Firebase update completed successfully');

      // Local preferences'ı da güncelle
      if (_preferences != null) {
        _preferences = _preferences!.copyWith(
          takipEdilenBolumler: departmentIds,
        );
        print('DEBUG: Local preferences updated');
      }
    } catch (e) {
      print('DEBUG: Error updating departments: $e');
      _error = e.toString();
      // Hata durumunda eski değerlere geri dön
      _selectedDepartments = _preferences?.takipEdilenBolumler ?? [];
    } finally {
      _isLoading = false;
      notifyListeners();
      print('DEBUG: updateSelectedDepartments completed');
    }
  }

  // Bildirim tercihini güncelle
  Future<void> updateNotificationPreference(String preference) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notificationPreference = preference;
      await FirebaseService.updateNotificationPreference(preference);

      // Local preferences'ı da güncelle
      if (_preferences != null) {
        _preferences = _preferences!.copyWith(bildirimTercihi: preference);
      }
    } catch (e) {
      _error = e.toString();
      // Hata durumunda eski değere geri dön
      _notificationPreference = _preferences?.bildirimTercihi ?? 'tumu';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Bölüm seçimi toggle
  Future<void> toggleDepartmentSelection(String departmentId) async {
    if (_selectedDepartments.contains(departmentId)) {
      _selectedDepartments.remove(departmentId);
    } else {
      _selectedDepartments.add(departmentId);
    }

    // Firebase'e kaydet
    try {
      await FirebaseService.updateFollowedDepartments(_selectedDepartments);

      // Local preferences'ı da güncelle
      if (_preferences != null) {
        _preferences = _preferences!.copyWith(
          takipEdilenBolumler: _selectedDepartments,
        );
      }
    } catch (e) {
      print('DEBUG: Error toggling department: $e');
      // Hata durumunda eski değerlere geri dön
      _selectedDepartments = _preferences?.takipEdilenBolumler ?? [];
    }

    notifyListeners();
  }

  // Bölüm seçili mi kontrol et
  bool isDepartmentSelected(String departmentId) {
    return _selectedDepartments.contains(departmentId);
  }

  // Seçili bölüm sayısı
  int get selectedDepartmentCount => _selectedDepartments.length;

  // Tüm bölümleri seç/seçimi kaldır
  Future<void> toggleAllDepartments() async {
    if (_selectedDepartments.length == Department.allDepartments.length) {
      _selectedDepartments.clear();
    } else {
      _selectedDepartments = Department.allDepartments
          .map((d) => d.id)
          .toList();
    }

    // Firebase'e kaydet
    try {
      await FirebaseService.updateFollowedDepartments(_selectedDepartments);

      // Local preferences'ı da güncelle
      if (_preferences != null) {
        _preferences = _preferences!.copyWith(
          takipEdilenBolumler: _selectedDepartments,
        );
      }
    } catch (e) {
      print('DEBUG: Error toggling all departments: $e');
      // Hata durumunda eski değerlere geri dön
      _selectedDepartments = _preferences?.takipEdilenBolumler ?? [];
    }

    notifyListeners();
  }

  // Test bildirimi gönder
  Future<void> sendTestNotification() async {
    try {
      await FCMService.sendTestNotification();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Hata temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Yenile
  Future<void> refresh() async {
    if (_user != null) {
      await _loadUserPreferences();
    }
  }
}
