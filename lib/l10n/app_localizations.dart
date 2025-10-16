import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

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
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
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
    Locale('en'),
    Locale('tr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Fırat Uni Announcement Tracker'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search announcements...'**
  String get searchHint;

  /// No description provided for @selectDepartments.
  ///
  /// In en, this message translates to:
  /// **'Select Departments'**
  String get selectDepartments;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  String get removeAll;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Number of selected departments
  ///
  /// In en, this message translates to:
  /// **'{count} departments selected'**
  String departmentsSelected(int count);

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noAnnouncements;

  /// No description provided for @noAnnouncementsMessage.
  ///
  /// In en, this message translates to:
  /// **'No announcements found in the departments you follow.'**
  String get noAnnouncementsMessage;

  /// No description provided for @selectDepartmentsFirst.
  ///
  /// In en, this message translates to:
  /// **'Select departments first'**
  String get selectDepartmentsFirst;

  /// No description provided for @selectDepartmentsMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to select at least one department to see announcements.'**
  String get selectDepartmentsMessage;

  /// No description provided for @announcementDetails.
  ///
  /// In en, this message translates to:
  /// **'Announcement Details'**
  String get announcementDetails;

  /// No description provided for @openInWebsite.
  ///
  /// In en, this message translates to:
  /// **'Open in Website'**
  String get openInWebsite;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published On'**
  String get publishedOn;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added On'**
  String get addedOn;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @testNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Use to test the notification system'**
  String get testNotificationDescription;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get sendTestNotification;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get notificationSent;

  /// No description provided for @notificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Test notification failed'**
  String get notificationFailed;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer: Fırat University Digital Transformation and Software Office'**
  String get developer;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Fatih Altuntaş - Fırat University Student'**
  String get developerInfo;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'altuntasfatih0@outlook.com'**
  String get emailAddress;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateOptional.
  ///
  /// In en, this message translates to:
  /// **'Update Recommended'**
  String get updateOptional;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get updateDownload;

  /// No description provided for @noUpdate.
  ///
  /// In en, this message translates to:
  /// **'App is up to date'**
  String get noUpdate;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String ago(String time);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @unknownDepartment.
  ///
  /// In en, this message translates to:
  /// **'Unknown Department'**
  String get unknownDepartment;

  /// No description provided for @followDepartments.
  ///
  /// In en, this message translates to:
  /// **'Follow Departments'**
  String get followDepartments;

  /// No description provided for @followDepartmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the departments you want to follow'**
  String get followDepartmentsDescription;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  String get allNotifications;

  /// No description provided for @onlyNewAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Only New Announcements'**
  String get onlyNewAnnouncements;

  /// No description provided for @notificationPreferenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your notification preference'**
  String get notificationPreferenceDescription;

  /// No description provided for @departmentSearch.
  ///
  /// In en, this message translates to:
  /// **'Search departments...'**
  String get departmentSearch;

  /// No description provided for @noDepartmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No departments found'**
  String get noDepartmentsFound;

  /// No description provided for @selectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one department'**
  String get selectAtLeastOne;

  /// No description provided for @urlCannotBeOpened.
  ///
  /// In en, this message translates to:
  /// **'URL cannot be opened'**
  String get urlCannotBeOpened;

  /// No description provided for @copyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get urlCopied;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'Fırat University Announcement'**
  String get shareSubject;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'📢 {title}\n\n{content}\n\n🔗 {url}\n\n📅 {date}\n\n#FiratUniversity #Announcement'**
  String shareText(String title, String content, String url, String date);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Bilsin'**
  String get appName;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @testNotifications.
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get testNotifications;

  /// No description provided for @testNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Test if notifications are working'**
  String get testNotificationsDescription;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Get information about the app'**
  String get aboutDescription;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Data usage and privacy'**
  String get privacyPolicyDescription;

  /// Last updated label
  /// In en: 'Last Updated'
  String get lastUpdated;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions of service'**
  String get termsOfServiceDescription;

  // Privacy Policy sections
  String get ppCollectedInfoTitle;
  String get ppCollectedInfoContent;
  String get ppUsageTitle;
  String get ppUsageContent;
  String get ppSharingTitle;
  String get ppSharingContent;
  String get ppSecurityTitle;
  String get ppSecurityContent;
  String get ppDeletionTitle;
  String get ppDeletionContent;
  String get ppContactTitle;
  String get ppContactContent;
  String get ppFooter;

  // Terms of Service sections
  String get tosServiceTitle;
  String get tosServiceContent;
  String get tosTermsTitle;
  String get tosTermsContent;
  String get tosResponsibilitiesTitle;
  String get tosResponsibilitiesContent;
  String get tosDowntimeTitle;
  String get tosDowntimeContent;
  String get tosContentLiabilityTitle;
  String get tosContentLiabilityContent;
  String get tosChangesTitle;
  String get tosChangesContent;
  String get tosDisclaimerTitle;
  String get tosDisclaimerContent;
  String get tosContactTitle;
  String get tosContactContent;
  String get tosFooter;

  /// No description provided for @selectDepartmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the departments you want to follow'**
  String get selectDepartmentsDescription;

  /// No description provided for @noDepartmentsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No departments found matching your search criteria'**
  String get noDepartmentsFoundMessage;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @last24Hours.
  ///
  /// In en, this message translates to:
  /// **'Last 24 Hours'**
  String get last24Hours;

  /// No description provided for @noAnnouncementsFound.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noAnnouncementsFound;

  /// No description provided for @selectDepartmentsFirstMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the departments you want to follow'**
  String get selectDepartmentsFirstMessage;

  /// No description provided for @announcementNotFound.
  ///
  /// In en, this message translates to:
  /// **'Announcement not found'**
  String get announcementNotFound;

  /// No description provided for @departmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departmentLabel;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Mobile application that allows you to track announcements from all departments of Fırat University.'**
  String get appDescription;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// No description provided for @feature1.
  ///
  /// In en, this message translates to:
  /// **'• Announcement tracking from 24 departments'**
  String get feature1;

  /// No description provided for @feature2.
  ///
  /// In en, this message translates to:
  /// **'• Instant push notifications'**
  String get feature2;

  /// No description provided for @feature3.
  ///
  /// In en, this message translates to:
  /// **'• Search and filtering'**
  String get feature3;

  /// No description provided for @feature4.
  ///
  /// In en, this message translates to:
  /// **'• Offline reading'**
  String get feature4;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
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
