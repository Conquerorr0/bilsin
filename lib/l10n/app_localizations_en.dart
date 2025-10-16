// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get noAnnouncementsMessage =>
      'No announcements found in the departments you follow.';

  @override
  String get selectDepartmentsFirst => 'Select departments first';

  @override
  String get selectDepartmentsMessage =>
      'You need to select at least one department to see announcements.';

  @override
  String get announcementDetails => 'Announcement Details';

  @override
  String get openInWebsite => 'Open in Website';

  @override
  String get share => 'Share';

  @override
  String get publishedOn => 'Published On';

  @override
  String get addedOn => 'Added On';

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
  String get testNotificationDescription =>
      'Use to test the notification system';

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
  String get developer =>
      'Developer: Fırat University Digital Transformation and Software Office';

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
  String ago(String time) {
    return '$time ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

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
  String get followDepartmentsDescription =>
      'Select the departments you want to follow';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get allNotifications => 'All Notifications';

  @override
  String get onlyNewAnnouncements => 'Only New Announcements';

  @override
  String get notificationPreferenceDescription =>
      'Choose your notification preference';

  @override
  String get departmentSearch => 'Search departments...';

  @override
  String get noDepartmentsFound => 'No departments found';

  @override
  String get selectAtLeastOne => 'Select at least one department';

  @override
  String get urlCannotBeOpened => 'URL cannot be opened';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied to clipboard';

  @override
  String get shareSubject => 'Fırat University Announcement';

  @override
  String shareText(String title, String content, String url, String date) {
    return '📢 $title\n\n$content\n\n🔗 $url\n\n📅 $date\n\n#FiratUniversity #Announcement';
  }

  @override
  String get appName => 'Bilsin';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get testNotifications => 'Test Notifications';

  @override
  String get testNotificationsDescription =>
      'Test if notifications are working';

  @override
  String get aboutDescription => 'Get information about the app';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'Data usage and privacy';
  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDescription => 'Terms and conditions of service';

  // Privacy Policy EN
  @override
  String get ppCollectedInfoTitle => '1. Information Collected';
  @override
  String get ppCollectedInfoContent =>
      'We collect the following:\n\n• FCM token (to send push notifications)\n• Followed departments\n• Notification preferences\n• Anonymous ID via Firebase Authentication';
  @override
  String get ppUsageTitle => '2. How We Use Information';
  @override
  String get ppUsageContent =>
      'Collected data is used to:\n\n• Deliver announcement notifications\n• Save your preferences\n• Improve the app experience';
  @override
  String get ppSharingTitle => '3. Sharing';
  @override
  String get ppSharingContent =>
      'We do not share personal data with third parties. Only Firebase services (Firestore, FCM) are used.';
  @override
  String get ppSecurityTitle => '4. Security';
  @override
  String get ppSecurityContent =>
      'All data is protected by Firebase security and stored securely.';
  @override
  String get ppDeletionTitle => '5. Data Deletion';
  @override
  String get ppDeletionContent =>
      'You can delete your data by uninstalling the app. You may also request deletion via Firebase Console.';
  @override
  String get ppContactTitle => '6. Contact';
  @override
  String get ppContactContent =>
      'For privacy questions:\n\nEmail: fatihaltuntas0@outlook.com';
  @override
  String get ppFooter => 'This privacy policy was prepared by Fatih Altuntaş.';

  // Terms EN
  @override
  String get tosServiceTitle => '1. Service Description';
  @override
  String get tosServiceContent =>
      'This app lets you follow announcements from 24 departments and receive instant notifications.';
  @override
  String get tosTermsTitle => '2. Terms of Use';
  @override
  String get tosTermsContent =>
      'By using the app, you agree to:\n\n• Use the app for lawful purposes\n• Not infringe others’ rights\n• Not use the app for harmful activities';
  @override
  String get tosResponsibilitiesTitle => '3. User Responsibilities';
  @override
  String get tosResponsibilitiesContent =>
      'Users are responsible for:\n\n• Providing accurate information\n• Protecting app security\n• Respecting copyrights';
  @override
  String get tosDowntimeTitle => '4. Service Downtime';
  @override
  String get tosDowntimeContent =>
      'We aim for uninterrupted service but temporary outages may occur due to technical reasons.';
  @override
  String get tosContentLiabilityTitle => '5. Content Liability';
  @override
  String get tosContentLiabilityContent =>
      'Announcement content belongs to Fırat University. The app only displays this content.';
  @override
  String get tosChangesTitle => '6. Changes';
  @override
  String get tosChangesContent =>
      'These terms may change without notice. The latest version is available in the app.';
  @override
  String get tosDisclaimerTitle => '7. Disclaimer';
  @override
  String get tosDisclaimerContent =>
      'The app is provided “as is”. We do not guarantee uninterrupted operation.';
  @override
  String get tosContactTitle => '8. Contact';
  @override
  String get tosContactContent =>
      'For questions about the terms:\n\nEmail: fatihaltuntas0@outlook.com';
  @override
  String get tosFooter =>
      'These terms of service were prepared by Fatih Altuntaş.';

  @override
  String get selectDepartmentsDescription =>
      'Select the departments you want to follow';

  @override
  String get noDepartmentsFoundMessage =>
      'No departments found matching your search criteria';

  @override
  String get saveButton => 'Save';

  @override
  String get total => 'Total';

  @override
  String get last24Hours => 'Last 24 Hours';

  @override
  String get noAnnouncementsFound => 'No announcements yet';

  @override
  String get selectDepartmentsFirstMessage =>
      'Select the departments you want to follow';

  @override
  String get announcementNotFound => 'Announcement not found';

  @override
  String get departmentLabel => 'Department';

  @override
  String get contentLabel => 'Content';

  @override
  String get appDescription =>
      'Mobile application that allows you to track announcements from all departments of Fırat University.';

  @override
  String get features => 'Features:';

  @override
  String get feature1 => '• Announcement tracking from 24 departments';

  @override
  String get feature2 => '• Instant push notifications';

  @override
  String get feature3 => '• Search and filtering';

  @override
  String get feature4 => '• Offline reading';
}
