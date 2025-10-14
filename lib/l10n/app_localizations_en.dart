import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fırat Uni Announcement Tracker';

  @override
  String get home => 'Home';

  @override
  String get departments => 'Departments';

  @override
  String get settings => 'Settings';

  @override
  String get all => 'All';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search announcements...';

  @override
  String get selectDepartments => 'Select Departments';

  @override
  String get selectAll => 'Select All';

  @override
  String get removeAll => 'Remove All';

  @override
  String get save => 'Save';

  @override
  String departmentsSelected(int count) {
    return '$count departments selected';
  }

  @override
  String get noAnnouncements => 'No announcements yet';

  @override
  String get noAnnouncementsMessage => 'No announcements found in the departments you follow.';

  @override
  String get selectDepartmentsFirst => 'Select departments first';

  @override
  String get selectDepartmentsMessage => 'You need to select at least one department to see announcements.';

  @override
  String get announcementDetails => 'Announcement Details';

  @override
  String get openInWebsite => 'Open in Website';

  @override
  String get share => 'Share';

  @override
  String get publishedOn => 'Published On';

  @override
  String get department => 'Department';

  @override
  String get content => 'Content';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get testNotificationDescription => 'Use to test the notification system';

  @override
  String get sendTestNotification => 'Send Test Notification';

  @override
  String get notificationSent => 'Test notification sent';

  @override
  String get notificationFailed => 'Test notification failed';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get developerInfo => 'Fatih Altuntaş - Fırat University Student';

  @override
  String get contact => 'Contact';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'altuntasfatih0@outlook.com';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get updateRequired => 'Update Required';

  @override
  String get updateOptional => 'Update Recommended';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateLater => 'Later';

  @override
  String get updateDownload => 'Download Update';

  @override
  String get noUpdate => 'App is up to date';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tryAgain => 'Try again';

  @override
  String ago(String time) => '$time ago';

  @override
  String daysAgo(int count) => '$count days ago';

  @override
  String hoursAgo(int count) => '$count hours ago';

  @override
  String minutesAgo(int count) => '$count minutes ago';

  @override
  String get justNow => 'Just now';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get unknownDepartment => 'Unknown Department';

  @override
  String get followDepartments => 'Follow Departments';

  @override
  String get followDepartmentsDescription => 'Select the departments you want to follow';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get allNotifications => 'All Notifications';

  @override
  String get onlyNewAnnouncements => 'Only New Announcements';

  @override
  String get notificationPreferenceDescription => 'Choose your notification preference';

  @override
  String get departmentSearch => 'Search departments...';

  @override
  String get noDepartmentsFound => 'No departments found';

  @override
  String get selectAtLeastOne => 'Select at least one department';

  @override
  String get urlCannotBeOpened => 'URL cannot be opened';

  @override
  String get shareSubject => 'Fırat University Announcement';

  @override
  String shareText(String title, String content, String url, String date) {
    return '📢 $title\n\n$content\n\n🔗 $url\n\n📅 $date\n\n#FiratUniversity #Announcement';
  }
}
