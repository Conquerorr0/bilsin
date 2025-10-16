// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Fırat Üni Duyuru Takip';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get departments => 'Bölümler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get all => 'Tümü';

  @override
  String get search => 'Ara';

  @override
  String get searchHint => 'Duyuru ara...';

  @override
  String get selectDepartments => 'Bölüm Seç';

  @override
  String get selectAll => 'Tümünü Seç';

  @override
  String get removeAll => 'Tümünü Kaldır';

  @override
  String get save => 'Kaydet';

  @override
  String departmentsSelected(int count) {
    return '$count bölüm seçildi';
  }

  @override
  String get noAnnouncements => 'Henüz duyuru yok';

  @override
  String get noAnnouncementsMessage =>
      'Takip ettiğiniz bölümlerde henüz duyuru bulunmuyor.';

  @override
  String get selectDepartmentsFirst => 'Önce bölüm seçin';

  @override
  String get selectDepartmentsMessage =>
      'Duyuruları görmek için en az bir bölüm seçmeniz gerekiyor.';

  @override
  String get announcementDetails => 'Duyuru Detayları';

  @override
  String get openInWebsite => 'Web Sitesinde Aç';

  @override
  String get share => 'Paylaş';

  @override
  String get publishedOn => 'Yayınlanma Tarihi';

  @override
  String get addedOn => 'Eklenme Tarihi';

  @override
  String get department => 'Bölüm';

  @override
  String get content => 'İçerik';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get refresh => 'Yenile';

  @override
  String get testNotification => 'Test Bildirimi';

  @override
  String get testNotificationDescription =>
      'Bildirim sistemini test etmek için kullanın';

  @override
  String get sendTestNotification => 'Test Bildirimi Gönder';

  @override
  String get notificationSent => 'Test bildirimi gönderildi';

  @override
  String get notificationFailed => 'Test bildirimi gönderilemedi';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get developer =>
      'Geliştirici: Fırat Üniversitesi Dijital Dönüşüm ve Yazılım Ofisi';

  @override
  String get developerInfo => 'Fatih Altuntaş - Fırat Üniversitesi Öğrencisi';

  @override
  String get contact => 'İletişim';

  @override
  String get email => 'E-posta';

  @override
  String get emailAddress => 'altuntasfatih0@outlook.com';

  @override
  String get updateAvailable => 'Güncelleme Mevcut';

  @override
  String get updateRequired => 'Güncelleme Gerekli';

  @override
  String get updateOptional => 'Güncelleme Önerilir';

  @override
  String get updateNow => 'Şimdi Güncelle';

  @override
  String get updateLater => 'Daha Sonra';

  @override
  String get updateDownload => 'Güncellemeyi İndir';

  @override
  String get noUpdate => 'Uygulama güncel';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get tryAgain => 'Tekrar deneyin';

  @override
  String ago(String time) {
    return '$time önce';
  }

  @override
  String daysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String hoursAgo(int count) {
    return '$count saat önce';
  }

  @override
  String minutesAgo(int count) {
    return '$count dakika önce';
  }

  @override
  String get justNow => 'Az önce';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get unknownDepartment => 'Bilinmeyen Bölüm';

  @override
  String get followDepartments => 'Bölüm Takip Et';

  @override
  String get followDepartmentsDescription =>
      'Takip etmek istediğiniz bölümleri seçin';

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get allNotifications => 'Tüm Bildirimler';

  @override
  String get onlyNewAnnouncements => 'Sadece Yeni Duyurular';

  @override
  String get notificationPreferenceDescription => 'Bildirim tercihinizi seçin';

  @override
  String get departmentSearch => 'Bölüm ara...';

  @override
  String get noDepartmentsFound => 'Bölüm bulunamadı';

  @override
  String get selectAtLeastOne => 'En az bir bölüm seçin';

  @override
  String get urlCannotBeOpened => 'URL açılamadı';

  @override
  String get copyUrl => 'URL Kopyala';

  @override
  String get urlCopied => 'URL panoya kopyalandı';

  @override
  String get shareSubject => 'Fırat Üniversitesi Duyurusu';

  @override
  String shareText(String title, String content, String url, String date) {
    return '📢 $title\n\n$content\n\n🔗 $url\n\n📅 $date\n\n#FıratÜniversitesi #Duyuru';
  }

  @override
  String get appName => 'Bilsin';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistem';

  @override
  String get dark => 'Koyu';

  @override
  String get light => 'Açık';

  @override
  String get testNotifications => 'Bildirimleri Test Et';

  @override
  String get testNotificationsDescription =>
      'Bildirimlerin çalıştığını test et';

  @override
  String get aboutDescription => 'Uygulama hakkında bilgi al';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicyDescription => 'Veri kullanımı ve gizlilik';
  @override
  String get lastUpdated => 'Son Güncelleme';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get termsOfServiceDescription => 'Hizmet şartları ve koşulları';

  // Gizlilik Politikası TR
  @override
  String get ppCollectedInfoTitle => '1. Toplanan Bilgiler';
  @override
  String get ppCollectedInfoContent =>
      'Şunları toplarız:\n\n• FCM token (push bildirimleri için)\n• Takip edilen bölümler\n• Bildirim tercihleri\n• Firebase Authentication ile anonim kimlik';
  @override
  String get ppUsageTitle => '2. Kullanım Amaçları';
  @override
  String get ppUsageContent =>
      'Toplanan veriler şu amaçlarla kullanılır:\n\n• Duyuru bildirimleri gönderme\n• Tercihlerinizi kaydetme\n• Uygulama deneyimini iyileştirme';
  @override
  String get ppSharingTitle => '3. Bilgi Paylaşımı';
  @override
  String get ppSharingContent =>
      'Kişisel veriler üçüncü kişilerle paylaşılmaz. Yalnızca Firebase servisleri (Firestore, FCM) kullanılır.';
  @override
  String get ppSecurityTitle => '4. Güvenlik';
  @override
  String get ppSecurityContent =>
      'Tüm veriler Firebase güvenliği ile korunur ve güvenli şekilde saklanır.';
  @override
  String get ppDeletionTitle => '5. Veri Silme';
  @override
  String get ppDeletionContent =>
      'Uygulamayı kaldırarak verilerinizi silebilirsiniz. İsterseniz Firebase Console üzerinden de silme talep edebilirsiniz.';
  @override
  String get ppContactTitle => '6. İletişim';
  @override
  String get ppContactContent =>
      'Gizlilik politikası ile ilgili sorularınız için:\n\nE-posta: fatihaltuntas0@outlook.com';
  @override
  String get ppFooter =>
      'Bu gizlilik politikası, Fatih Altuntaş tarafından hazırlanmıştır.';

  // Kullanım Şartları TR
  @override
  String get tosServiceTitle => '1. Hizmet Tanımı';
  @override
  String get tosServiceContent =>
      'Bu uygulama, 24 bölümün duyurularını takip etmenizi ve anlık bildirimler almanızı sağlar.';
  @override
  String get tosTermsTitle => '2. Kullanım Koşulları';
  @override
  String get tosTermsContent =>
      'Uygulamayı kullanarak şunları kabul edersiniz:\n\n• Uygulamayı yasal amaçlarla kullanmak\n• Başkalarının haklarını ihlal etmemek\n• Zararlı faaliyetlerde bulunmamak';
  @override
  String get tosResponsibilitiesTitle => '3. Kullanıcı Sorumlulukları';
  @override
  String get tosResponsibilitiesContent =>
      'Kullanıcıların sorumlulukları:\n\n• Doğru bilgi sağlamak\n• Uygulama güvenliğini korumak\n• Telif haklarına saygı göstermek';
  @override
  String get tosDowntimeTitle => '4. Hizmet Kesintileri';
  @override
  String get tosDowntimeContent =>
      'Kesintisiz hizmet hedeflenir ancak teknik nedenlerle geçici kesintiler olabilir.';
  @override
  String get tosContentLiabilityTitle => '5. İçerik Sorumluluğu';
  @override
  String get tosContentLiabilityContent =>
      'Duyuru içerikleri Fırat Üniversitesi’ne aittir. Uygulama yalnızca bu içerikleri gösterir.';
  @override
  String get tosChangesTitle => '6. Değişiklikler';
  @override
  String get tosChangesContent =>
      'Bu şartlar önceden haber verilmeksizin değiştirilebilir. Güncel sürüm uygulamada yer alır.';
  @override
  String get tosDisclaimerTitle => '7. Sorumluluk Reddi';
  @override
  String get tosDisclaimerContent =>
      'Uygulama “olduğu gibi” sunulur. Kesintisiz çalışacağı garanti edilmez.';
  @override
  String get tosContactTitle => '8. İletişim';
  @override
  String get tosContactContent =>
      'Kullanım şartları ile ilgili sorular için:\n\nE-posta: fatihaltuntas0@outlook.com';
  @override
  String get tosFooter =>
      'Bu kullanım şartları, Fatih Altuntaş tarafından hazırlanmıştır.';

  @override
  String get selectDepartmentsDescription =>
      'Takip etmek istediğiniz bölümleri seçin';

  @override
  String get noDepartmentsFoundMessage =>
      'Arama kriterlerinize uygun bölüm bulunamadı';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get total => 'Toplam';

  @override
  String get last24Hours => 'Son 24 saat';

  @override
  String get noAnnouncementsFound => 'Henüz duyuru bulunmuyor';

  @override
  String get selectDepartmentsFirstMessage =>
      'Takip etmek istediğiniz bölümleri seçin';

  @override
  String get announcementNotFound => 'Duyuru bulunamadı';

  @override
  String get departmentLabel => 'Bölüm';

  @override
  String get contentLabel => 'İçerik';

  @override
  String get appDescription =>
      'Fırat Üniversitesi\'nin tüm bölümlerinden duyuruları takip etmenizi sağlayan mobil uygulama.';

  @override
  String get features => 'Özellikler:';

  @override
  String get feature1 => '• 24 bölümden duyuru takibi';

  @override
  String get feature2 => '• Anlık push bildirimleri';

  @override
  String get feature3 => '• Arama ve filtreleme';

  @override
  String get feature4 => '• Offline okuma';
}
