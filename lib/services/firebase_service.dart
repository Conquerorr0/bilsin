import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/announcement.dart';
import '../models/user_preferences.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı kimlik doğrulama
  static Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('Anonim giriş başarısız: $e');
    }
  }

  // Kullanıcı tercihlerini kaydet
  static Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        await signInAnonymously();
        return saveUserPreferences(preferences);
      }

      await _firestore
          .collection('kullanicilar')
          .doc(user.uid)
          .set(preferences.toFirestore());
    } catch (e) {
      throw Exception('Kullanıcı tercihleri kaydedilemedi: $e');
    }
  }

  // Kullanıcı tercihlerini getir
  static Future<UserPreferences?> getUserPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection('kullanicilar')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserPreferences.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Kullanıcı tercihleri alınamadı: $e');
    }
  }

  // Kullanıcı tercihlerini stream olarak dinle
  static Stream<UserPreferences?> getUserPreferencesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return _firestore.collection('kullanicilar').doc(user.uid).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return UserPreferences.fromFirestore(snapshot.data()!);
      }
      return null;
    });
  }

  // Takip edilen bölümlerin duyurularını getir
  static Stream<List<Announcement>> getAnnouncementsStream(
    List<String> departmentIds,
  ) {
    print(
      'DEBUG: getAnnouncementsStream called with departments: $departmentIds',
    );

    if (departmentIds.isEmpty) {
      print('DEBUG: No departments provided, returning empty stream');
      return Stream.value([]);
    }

    // Her bölüm için ayrı collection'dan duyuruları çek
    List<Stream<List<Announcement>>> streams = [];

    for (String departmentId in departmentIds) {
      final collectionName = 'bolum_${departmentId}_duyurular';
      print('DEBUG: Creating stream for collection: $collectionName');

      streams.add(
        _firestore
            .collection(collectionName)
            .orderBy('olusturma_zamani', descending: true)
            .snapshots()
            .map((snapshot) {
              final announcements = snapshot.docs.map((doc) {
                final announcement = Announcement.fromFirestore(doc.data());
                print(
                  'DEBUG: Stream parsed announcement: ${announcement.id} - ${announcement.baslik}',
                );
                return announcement;
              }).toList();
              print(
                'DEBUG: Collection $collectionName returned ${announcements.length} announcements',
              );
              return announcements;
            }),
      );
    }

    // Tüm stream'leri birleştir
    return StreamZip(streams).map((List<List<Announcement>> lists) {
      List<Announcement> allAnnouncements = [];
      for (int i = 0; i < lists.length; i++) {
        final list = lists[i];
        final departmentId = departmentIds[i];
        print(
          'DEBUG: Department $departmentId contributed ${list.length} announcements',
        );
        allAnnouncements.addAll(list);
      }
      // Yayınlanma tarihine göre sırala (yeniden eskiye)
      allAnnouncements.sort((a, b) {
        final dateA = a.yayinlanmaTarihi ?? a.tarih;
        final dateB = b.yayinlanmaTarihi ?? b.tarih;
        return dateB.compareTo(dateA);
      });
      print(
        'DEBUG: StreamZip returning ${allAnnouncements.length} total announcements',
      );
      return allAnnouncements;
    });
  }

  // FCM token'ı güncelle
  static Future<void> updateFCMToken(String token) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('kullanicilar').doc(user.uid).update({
        'fcm_token': token,
        'son_guncelleme': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('FCM token güncellenemedi: $e');
    }
  }

  // Takip edilen bölümleri güncelle
  static Future<void> updateFollowedDepartments(
    List<String> departmentIds,
  ) async {
    try {
      print('DEBUG: updateFollowedDepartments called with: $departmentIds');
      final user = _auth.currentUser;
      print('DEBUG: Current user: ${user?.uid}');

      if (user == null) {
        print('DEBUG: No user, signing in anonymously');
        await signInAnonymously();
        return updateFollowedDepartments(departmentIds);
      }

      print('DEBUG: Updating Firestore with departments: $departmentIds');

      // Önce belgenin var olup olmadığını kontrol et
      final docRef = _firestore.collection('kullanicilar').doc(user.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Belge varsa güncelle
        await docRef.update({
          'takipEdilenBolumler': departmentIds,
          'sonGuncelleme': FieldValue.serverTimestamp(),
        });
      } else {
        // Belge yoksa oluştur
        await docRef.set({
          'takipEdilenBolumler': departmentIds,
          'fcmToken': null,
          'bildirimTercihi': 'tumu',
          'olusturmaZamani': FieldValue.serverTimestamp(),
          'sonGuncelleme': FieldValue.serverTimestamp(),
        });
      }

      print('DEBUG: Firestore update completed');
    } catch (e) {
      print('DEBUG: Error in updateFollowedDepartments: $e');
      throw Exception('Takip edilen bölümler güncellenemedi: $e');
    }
  }

  // Bildirim tercihini güncelle
  static Future<void> updateNotificationPreference(String preference) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('kullanicilar').doc(user.uid).update({
        'bildirim_tercihi': preference,
        'son_guncelleme': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Bildirim tercihi güncellenemedi: $e');
    }
  }

  // Kullanıcı ID'sini al
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Kullanıcı giriş durumunu dinle
  static Stream<User?> getAuthStateChanges() {
    return _auth.authStateChanges();
  }

  // Test bildirimi gönder
  static Future<Map<String, dynamic>> sendTestNotification(
    String fcmToken,
  ) async {
    try {
      // Cloud Function URL'ini al
      final functionUrl =
          'https://us-central1-bilsin-882ce.cloudfunctions.net/sendTestNotification';

      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Test bildirimi gönderme hatası: $e');
    }
  }

  // Son duyuruları getir (yeni kurulum için)
  static Future<List<Announcement>> getRecentAnnouncements(
    List<String> departmentIds, {
    int limit = 5,
  }) async {
    print(
      'DEBUG: getRecentAnnouncements called with departments: $departmentIds, limit: $limit',
    );
    try {
      List<Announcement> allAnnouncements = [];

      for (String departmentId in departmentIds) {
        final collectionName = 'bolum_${departmentId}_duyurular';
        print(
          'DEBUG: Fetching from collection: $collectionName (all announcements)',
        );

        final query = await _firestore
            .collection(collectionName)
            .orderBy('olusturma_zamani', descending: true)
            .get();

        print(
          'DEBUG: Collection $collectionName has ${query.docs.length} documents',
        );

        final announcements = query.docs.map((doc) {
          final announcement = Announcement.fromFirestore(doc.data());
          print(
            'DEBUG: Parsed announcement: ${announcement.id} - ${announcement.baslik}',
          );
          return announcement;
        }).toList();

        allAnnouncements.addAll(announcements);
      }

      print(
        'DEBUG: Total announcements before sorting: ${allAnnouncements.length}',
      );

      // Yayınlanma tarihine göre sırala (yeniden eskiye) ve limit uygula
      allAnnouncements.sort((a, b) {
        final dateA = a.yayinlanmaTarihi ?? a.tarih;
        final dateB = b.yayinlanmaTarihi ?? b.tarih;
        return dateB.compareTo(dateA);
      });

      final result = allAnnouncements.take(limit).toList();
      print('DEBUG: Returning ${result.length} announcements');
      return result;
    } catch (e) {
      print('DEBUG: Error in getRecentAnnouncements: $e');
      throw Exception('Son duyurular getirilemedi: $e');
    }
  }
}
