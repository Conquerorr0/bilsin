import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Bildirim Ayarları
              _buildSection(
                title: l10n.notificationSettings,
                icon: Icons.notifications,
                children: [
                  _buildNotificationPreferenceTile(context, userProvider),
                  _buildTestNotificationTile(context, userProvider),
                ],
              ),

              const SizedBox(height: 24),

              // Takip Edilen Bölümler
              _buildSection(
                title: l10n.followDepartments,
                icon: Icons.school,
                children: [
                  _buildFollowedDepartmentsTile(context, userProvider),
                ],
              ),

              const SizedBox(height: 24),

              // Uygulama Bilgileri
              _buildSection(
                title: l10n.about,
                icon: Icons.info,
                children: [
                  _buildThemeTile(context),
                  _buildLanguageTile(context),
                  _buildAppInfoTile(context),
                  _buildVersionTile(context),
                ],
              ),

              const SizedBox(height: 24),

              // Hakkında
              _buildSection(
                title: l10n.about,
                icon: Icons.help,
                children: [
                  _buildAboutTile(context),
                  _buildPrivacyPolicyTile(context),
                  _buildTermsOfServiceTile(context),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.dark_mode),
      title: Text(l10n.theme),
      subtitle: Text(
        themeProvider.mode == ThemeMode.system
            ? l10n.system
            : themeProvider.mode == ThemeMode.dark
            ? l10n.dark
            : l10n.light,
      ),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.mode,
        onChanged: (ThemeMode? val) {
          if (val != null) themeProvider.setMode(val);
        },
        items: [
          DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.system)),
          DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.light)),
          DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(localeProvider.currentLanguageName),
      trailing: DropdownButton<Locale>(
        value: localeProvider.locale,
        onChanged: (Locale? val) {
          if (val != null) localeProvider.setLocale(val);
        },
        items: [
          DropdownMenuItem(
            value: const Locale('tr'),
            child: Text(l10n.turkish),
          ),
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(l10n.english),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF79113E), size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF79113E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNotificationPreferenceTile(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.notifications_active),
      title: Text(l10n.notificationSettings),
      subtitle: Text(
        userProvider.notificationPreference == 'tumu'
            ? l10n.allNotifications
            : l10n.onlyNewAnnouncements,
      ),
      trailing: DropdownButton<String>(
        value: userProvider.notificationPreference,
        onChanged: (String? newValue) {
          if (newValue != null) {
            userProvider.updateNotificationPreference(newValue);
          }
        },
        items: [
          DropdownMenuItem(value: 'tumu', child: Text(l10n.allNotifications)),
          DropdownMenuItem(
            value: 'sadece_yeni',
            child: Text(l10n.onlyNewAnnouncements),
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationTile(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.send),
      title: Text(l10n.testNotifications),
      subtitle: Text(l10n.testNotificationsDescription),
      trailing: userProvider.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: userProvider.isLoading
          ? null
          : () async {
              try {
                await userProvider.sendTestNotification();
                if (userProvider.error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.notificationSent),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.error}: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
    );
  }

  Widget _buildFollowedDepartmentsTile(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.school),
      title: Text(l10n.followDepartments),
      subtitle: Text(
        userProvider.selectedDepartmentCount > 0
            ? l10n.departmentsSelected(userProvider.selectedDepartmentCount)
            : l10n.selectDepartmentsDescription,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        // Bölüm seçim ekranına git
      },
    );
  }

  Widget _buildAppInfoTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.school),
      title: Text(l10n.appTitle),
      subtitle: Text(l10n.appDescription),
    );
  }

  Widget _buildVersionTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<String>(
      future: _getVersion(),
      builder: (context, snapshot) {
        final version = snapshot.data ?? '';
        return ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.version),
          subtitle: Text(version.isEmpty ? '-' : version),
        );
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: Text(l10n.about),
      subtitle: Text(l10n.aboutDescription),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showAboutDialog(context);
      },
    );
  }

  Widget _buildPrivacyPolicyTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.privacy_tip_outlined),
      title: Text(l10n.privacyPolicy),
      subtitle: Text(l10n.privacyPolicyDescription),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
        );
      },
    );
  }

  Widget _buildTermsOfServiceTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.description_outlined),
      title: Text(l10n.termsOfService),
      subtitle: Text(l10n.termsOfServiceDescription),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: l10n.appName,
      applicationVersion: '',
      applicationIcon: const Icon(
        Icons.school,
        size: 64,
        color: Color(0xFF79113E),
      ),
      children: [
        Text(l10n.appDescription),
        const SizedBox(height: 16),
        Text(
          l10n.features,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(l10n.feature1),
        Text(l10n.feature2),
        Text(l10n.feature3),
        Text(l10n.feature4),
        const SizedBox(height: 16),
        const Text(
          'Developer: Fatih Altuntaş',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Future<String> _getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '';
    }
  }
}
