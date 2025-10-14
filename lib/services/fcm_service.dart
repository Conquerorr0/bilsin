import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  // FCM servisini başlat
  static Future<void> initialize() async {
    try {
      // İzin iste
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('FCM izin verildi');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('FCM geçici izin verildi');
      } else {
        print('FCM izni reddedildi');
        return;
      }

      // FCM token'ı al
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        await FirebaseService.updateFCMToken(_fcmToken!);
        print('FCM Token alındı: ${_fcmToken!.substring(0, 20)}...');
      }

      // Token yenilendiğinde güncelle
      _messaging.onTokenRefresh.listen((newToken) async {
        _fcmToken = newToken;
        await FirebaseService.updateFCMToken(newToken);
        print('FCM Token yenilendi: ${newToken.substring(0, 20)}...');
      });

      // Local notifications başlat
      await _initializeLocalNotifications();

      // Foreground mesajları dinle
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Background mesajları dinle
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Uygulama kapalıyken gelen mesajları dinle
      _handleInitialMessage();
    } catch (e) {
      print('FCM başlatma hatası: $e');
    }
  }

  // Local notifications başlat
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android notification channel oluştur
    if (defaultTargetPlatform == TargetPlatform.android) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'duyuru_kanal',
        'Duyuru Bildirimleri',
        description: 'Fırat Üniversitesi duyuru bildirimleri',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  // Foreground mesajları işle
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground mesaj alındı: ${message.messageId}');

    _showLocalNotification(message);
  }

  // Background mesajları işle
  static void _handleBackgroundMessage(RemoteMessage message) {
    print('Background mesaj alındı: ${message.messageId}');

    // Deep linking ile duyuru sayfasına yönlendir
    if (message.data['duyuru_id'] != null) {
      _navigateToAnnouncement(message.data['duyuru_id']);
    }
  }

  // Uygulama kapalıyken gelen mesajları işle
  static Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      print('Initial mesaj alındı: ${initialMessage.messageId}');
      _handleBackgroundMessage(initialMessage);
    }
  }

  // Local notification göster
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'duyuru_kanal',
          'Duyuru Bildirimleri',
          channelDescription: 'Fırat Üniversitesi duyuru bildirimleri',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Yeni Duyuru',
      message.notification?.body ??
          'Fırat Üniversitesi\'nden yeni bir duyuru var',
      platformChannelSpecifics,
      payload: message.data['duyuru_id'],
    );
  }

  // Notification'a tıklandığında
  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      _navigateToAnnouncement(response.payload!);
    }
  }

  // Duyuru sayfasına yönlendir
  static void _navigateToAnnouncement(String announcementId) {
    // Bu fonksiyon main.dart'ta global navigator key ile implement edilecek
    print('Duyuru sayfasına yönlendiriliyor: $announcementId');
  }

  // Test bildirimi gönder
  static Future<void> sendTestNotification() async {
    try {
      if (_fcmToken == null) {
        print('FCM token bulunamadı');
        return;
      }

      print('Test bildirimi gönderiliyor...');

      // Cloud Function'ı çağır
      final response = await FirebaseService.sendTestNotification(_fcmToken!);

      if (response['success'] == true) {
        print('Test bildirimi başarıyla gönderildi');
      } else {
        print('Test bildirimi gönderilemedi: ${response['error']}');
      }
    } catch (e) {
      print('Test bildirimi gönderme hatası: $e');
    }
  }

  // Bildirim izinlerini kontrol et
  static Future<bool> hasPermission() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // Bildirim izinlerini tekrar iste
  static Future<NotificationSettings> requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }
}

// Background message handler (global scope'ta olmalı)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background mesaj işleniyor: ${message.messageId}');

  // Firebase'i başlat
  // Firebase.initializeApp(); // main.dart'ta zaten başlatılacak

  // Background'da yapılacak işlemler
  // Örneğin: veritabanına kaydetme, analytics, vb.
}

// Global FCM service instance
final FCMService fcmService = FCMService();
