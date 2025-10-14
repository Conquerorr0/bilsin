import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String baslik;
  final String icerik;
  final DateTime tarih;
  final DateTime? yayinlanmaTarihi;
  final String bolumId;
  final String bolumAdi;
  final String url;
  final DateTime olusturmaZamani;

  Announcement({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.tarih,
    this.yayinlanmaTarihi,
    required this.bolumId,
    required this.bolumAdi,
    required this.url,
    required this.olusturmaZamani,
  });

  factory Announcement.fromFirestore(Map<String, dynamic> data) {
    return Announcement(
      id: data['id'] ?? '',
      baslik: data['baslik'] ?? '',
      icerik: data['icerik'] ?? '',
      tarih: (data['tarih'] as String).isNotEmpty
          ? DateTime.parse(data['tarih'])
          : DateTime.now(),
      yayinlanmaTarihi: data['yayinlanma_tarihi'] != null
          ? (data['yayinlanma_tarihi'] is Timestamp
                ? (data['yayinlanma_tarihi'] as Timestamp).toDate()
                : DateTime.parse(data['yayinlanma_tarihi'] as String))
          : null,
      bolumId: data['bolum_id'] ?? '',
      bolumAdi: data['bolum_adi'] ?? '',
      url: data['url'] ?? '',
      olusturmaZamani: data['olusturma_zamani'] is Timestamp
          ? (data['olusturma_zamani'] as Timestamp).toDate()
          : DateTime.parse(data['olusturma_zamani'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'baslik': baslik,
      'icerik': icerik,
      'tarih': tarih.toIso8601String(),
      'yayinlanma_tarihi': yayinlanmaTarihi != null
          ? Timestamp.fromDate(yayinlanmaTarihi!)
          : null,
      'bolum_id': bolumId,
      'bolum_adi': bolumAdi,
      'url': url,
      'olusturma_zamani': Timestamp.fromDate(olusturmaZamani),
    };
  }

  String get formattedDate {
    final displayDate = yayinlanmaTarihi ?? tarih;
    return '${displayDate.day.toString().padLeft(2, '0')}.${displayDate.month.toString().padLeft(2, '0')}.${displayDate.year}';
  }

  String get shortContent {
    if (icerik.length <= 100) return icerik;
    return '${icerik.substring(0, 100)}...';
  }
}
