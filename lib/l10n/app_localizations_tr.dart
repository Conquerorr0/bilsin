import 'app_localizations.dart';

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
  String get noAnnouncementsMessage => 'Takip ettiğiniz bölümlerde henüz duyuru bulunmuyor.';

  @override
  String get selectDepartmentsFirst => 'Önce bölüm seçin';

  @override
  String get selectDepartmentsMessage => 'Duyuruları görmek için en az bir bölüm seçmeniz gerekiyor.';

  @override
  String get announcementDetails => 'Duyuru Detayları';

  @override
  String get openInWebsite => 'Web Sitesinde Aç';

  @override
  String get share => 'Paylaş';

  @override
  String get publishedOn => 'Yayınlanma Tarihi';

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
  String get testNotificationDescription => 'Bildirim sistemini test etmek için kullanın';

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
  String get developer => 'Geliştirici';

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
  String ago(String time) => '$time önce';

  @override
  String daysAgo(int count) => '$count gün önce';

  @override
  String hoursAgo(int count) => '$count saat önce';

  @override
  String minutesAgo(int count) => '$count dakika önce';

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
  String get followDepartmentsDescription => 'Takip etmek istediğiniz bölümleri seçin';

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
  String get shareSubject => 'Fırat Üniversitesi Duyurusu';

  @override
  String shareText(String title, String content, String url, String date) {
    return '📢 $title\n\n$content\n\n🔗 $url\n\n📅 $date\n\n#FıratÜniversitesi #Duyuru';
  }
}
