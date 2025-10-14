import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final String fcmToken;
  final List<String> takipEdilenBolumler;
  final String bildirimTercihi; // "tumu" | "sadece_yeni"
  final DateTime kayitTarihi;

  UserPreferences({
    required this.fcmToken,
    required this.takipEdilenBolumler,
    required this.bildirimTercihi,
    required this.kayitTarihi,
  });

  factory UserPreferences.fromFirestore(Map<String, dynamic> data) {
    return UserPreferences(
      fcmToken: data['fcmToken'] ?? '',
      takipEdilenBolumler: List<String>.from(data['takipEdilenBolumler'] ?? []),
      bildirimTercihi: data['bildirimTercihi'] ?? 'tumu',
      kayitTarihi:
          (data['olusturmaZamani'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fcmToken': fcmToken,
      'takipEdilenBolumler': takipEdilenBolumler,
      'bildirimTercihi': bildirimTercihi,
      'olusturmaZamani': Timestamp.fromDate(kayitTarihi),
    };
  }

  UserPreferences copyWith({
    String? fcmToken,
    List<String>? takipEdilenBolumler,
    String? bildirimTercihi,
    DateTime? kayitTarihi,
  }) {
    return UserPreferences(
      fcmToken: fcmToken ?? this.fcmToken,
      takipEdilenBolumler: takipEdilenBolumler ?? this.takipEdilenBolumler,
      bildirimTercihi: bildirimTercihi ?? this.bildirimTercihi,
      kayitTarihi: kayitTarihi ?? this.kayitTarihi,
    );
  }

  bool get isAllNotifications => bildirimTercihi == 'tumu';
  bool get isOnlyNewNotifications => bildirimTercihi == 'sadece_yeni';
}
