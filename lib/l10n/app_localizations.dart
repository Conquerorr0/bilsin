import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   flutter_localizations:
///     sdk: flutter
///   intl: any
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you'll need to edit this
/// file.
///
/// First, open your project's ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project's Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Fırat Uni Announcement Tracker'**
  ///
  /// In tr, this message translates to:
  /// **'Fırat Üni Duyuru Takip'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  ///
  /// In tr, this message translates to:
  /// **'Bölümler'**
  String get departments;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get all;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search announcements...'**
  ///
  /// In tr, this message translates to:
  /// **'Duyuru ara...'**
  String get searchHint;

  /// No description provided for @selectDepartments.
  ///
  /// In en, this message translates to:
  /// **'Select Departments'**
  ///
  /// In tr, this message translates to:
  /// **'Bölüm Seç'**
  String get selectDepartments;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Seç'**
  String get selectAll;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Kaldır'**
  String get removeAll;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// Number of selected departments
  ///
  /// In en, this message translates to:
  /// **'{count} departments selected'**
  ///
  /// In tr, this message translates to:
  /// **'{count} bölüm seçildi'**
  String departmentsSelected(int count);

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  ///
  /// In tr, this message translates to:
  /// **'Henüz duyuru yok'**
  String get noAnnouncements;

  /// No description provided for @noAnnouncementsMessage.
  ///
  /// In en, this message translates to:
  /// **'No announcements found in the departments you follow.'**
  ///
  /// In tr, this message translates to:
  /// **'Takip ettiğiniz bölümlerde henüz duyuru bulunmuyor.'**
  String get noAnnouncementsMessage;

  /// No description provided for @selectDepartmentsFirst.
  ///
  /// In en, this message translates to:
  /// **'Select departments first'**
  ///
  /// In tr, this message translates to:
  /// **'Önce bölüm seçin'**
  String get selectDepartmentsFirst;

  /// No description provided for @selectDepartmentsMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to select at least one department to see announcements.'**
  ///
  /// In tr, this message translates to:
  /// **'Duyuruları görmek için en az bir bölüm seçmeniz gerekiyor.'**
  String get selectDepartmentsMessage;

  /// No description provided for @announcementDetails.
  ///
  /// In en, this message translates to:
  /// **'Announcement Details'**
  ///
  /// In tr, this message translates to:
  /// **'Duyuru Detayları'**
  String get announcementDetails;

  /// No description provided for @openInWebsite.
  ///
  /// In en, this message translates to:
  /// **'Open in Website'**
  ///
  /// In tr, this message translates to:
  /// **'Web Sitesinde Aç'**
  String get openInWebsite;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get share;

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published On'**
  ///
  /// In tr, this message translates to:
  /// **'Yayınlanma Tarihi'**
  String get publishedOn;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  ///
  /// In tr, this message translates to:
  /// **'Bölüm'**
  String get department;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  ///
  /// In tr, this message translates to:
  /// **'İçerik'**
  String get content;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get refresh;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  ///
  /// In tr, this message translates to:
  /// **'Test Bildirimi'**
  String get testNotification;

  /// No description provided for @testNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Use to test the notification system'**
  ///
  /// In tr, this message translates to:
  /// **'Bildirim sistemini test etmek için kullanın'**
  String get testNotificationDescription;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  ///
  /// In tr, this message translates to:
  /// **'Test Bildirimi Gönder'**
  String get sendTestNotification;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  ///
  /// In tr, this message translates to:
  /// **'Test bildirimi gönderildi'**
  String get notificationSent;

  /// No description provided for @notificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Test notification failed'**
  ///
  /// In tr, this message translates to:
  /// **'Test bildirimi gönderilemedi'**
  String get notificationFailed;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Mod'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici'**
  String get developer;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Fatih Altuntaş - Fırat University Student'**
  ///
  /// In tr, this message translates to:
  /// **'Fatih Altuntaş - Fırat Üniversitesi Öğrencisi'**
  String get developerInfo;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get contact;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'altuntasfatih0@outlook.com'**
  ///
  /// In tr, this message translates to:
  /// **'altuntasfatih0@outlook.com'**
  String get emailAddress;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme Mevcut'**
  String get updateAvailable;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme Gerekli'**
  String get updateRequired;

  /// No description provided for @updateOptional.
  ///
  /// In en, this message translates to:
  /// **'Update Recommended'**
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme Önerilir'**
  String get updateOptional;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  ///
  /// In tr, this message translates to:
  /// **'Şimdi Güncelle'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  ///
  /// In tr, this message translates to:
  /// **'Daha Sonra'**
  String get updateLater;

  /// No description provided for @updateDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  ///
  /// In tr, this message translates to:
  /// **'Güncellemeyi İndir'**
  String get updateDownload;

  /// No description provided for @noUpdate.
  ///
  /// In en, this message translates to:
  /// **'App is up to date'**
  ///
  /// In tr, this message translates to:
  /// **'Uygulama güncel'**
  String get noUpdate;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  ///
  /// In tr, this message translates to:
  /// **'Tekrar deneyin'**
  String get tryAgain;

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  ///
  /// In tr, this message translates to:
  /// **'{time} önce'**
  String ago(String time);

  String daysAgo(int count);

  String hoursAgo(int count);

  String minutesAgo(int count);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  ///
  /// In tr, this message translates to:
  /// **'Az önce'**
  String get justNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get yesterday;

  /// No description provided for @unknownDepartment.
  ///
  /// In en, this message translates to:
  /// **'Unknown Department'**
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen Bölüm'**
  String get unknownDepartment;

  /// No description provided for @followDepartments.
  ///
  /// In en, this message translates to:
  /// **'Follow Departments'**
  ///
  /// In tr, this message translates to:
  /// **'Bölüm Takip Et'**
  String get followDepartments;

  /// No description provided for @followDepartmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the departments you want to follow'**
  ///
  /// In tr, this message translates to:
  /// **'Takip etmek istediğiniz bölümleri seçin'**
  String get followDepartmentsDescription;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettings;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  ///
  /// In tr, this message translates to:
  /// **'Tüm Bildirimler'**
  String get allNotifications;

  /// No description provided for @onlyNewAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Only New Announcements'**
  ///
  /// In tr, this message translates to:
  /// **'Sadece Yeni Duyurular'**
  String get onlyNewAnnouncements;

  /// No description provided for @notificationPreferenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your notification preference'**
  ///
  /// In tr, this message translates to:
  /// **'Bildirim tercihinizi seçin'**
  String get notificationPreferenceDescription;

  /// No description provided for @departmentSearch.
  ///
  /// In en, this message translates to:
  /// **'Search departments...'**
  ///
  /// In tr, this message translates to:
  /// **'Bölüm ara...'**
  String get departmentSearch;

  /// No description provided for @noDepartmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No departments found'**
  ///
  /// In tr, this message translates to:
  /// **'Bölüm bulunamadı'**
  String get noDepartmentsFound;

  /// No description provided for @selectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one department'**
  ///
  /// In tr, this message translates to:
  /// **'En az bir bölüm seçin'**
  String get selectAtLeastOne;

  /// No description provided for @urlCannotBeOpened.
  ///
  /// In en, this message translates to:
  /// **'URL cannot be opened'**
  ///
  /// In tr, this message translates to:
  /// **'URL açılamadı'**
  String get urlCannotBeOpened;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'Fırat University Announcement'**
  ///
  /// In tr, this message translates to:
  /// **'Fırat Üniversitesi Duyurusu'**
  String get shareSubject;

  String shareText(String title, String content, String url, String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
