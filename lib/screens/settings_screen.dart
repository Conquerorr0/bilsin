import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                title: 'Bildirim Ayarları',
                icon: Icons.notifications,
                children: [
                  _buildNotificationPreferenceTile(userProvider),
                  _buildTestNotificationTile(context, userProvider),
                ],
              ),

              const SizedBox(height: 24),

              // Takip Edilen Bölümler
              _buildSection(
                title: 'Takip Edilen Bölümler',
                icon: Icons.school,
                children: [
                  _buildFollowedDepartmentsTile(context, userProvider),
                ],
              ),

              const SizedBox(height: 24),

              // Uygulama Bilgileri
              _buildSection(
                title: 'Uygulama Bilgileri',
                icon: Icons.info,
                children: [_buildAppInfoTile(), _buildVersionTile()],
              ),

              const SizedBox(height: 24),

              // Hakkında
              _buildSection(
                title: 'Hakkında',
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

  Widget _buildNotificationPreferenceTile(UserProvider userProvider) {
    return ListTile(
      leading: const Icon(Icons.notifications_active),
      title: const Text('Bildirim Tercihi'),
      subtitle: Text(
        userProvider.notificationPreference == 'tumu'
            ? 'Tüm duyurular için bildirim al'
            : 'Sadece yeni duyurular için bildirim al',
      ),
      trailing: DropdownButton<String>(
        value: userProvider.notificationPreference,
        onChanged: (String? newValue) {
          if (newValue != null) {
            userProvider.updateNotificationPreference(newValue);
          }
        },
        items: const [
          DropdownMenuItem(value: 'tumu', child: Text('Tüm Duyurular')),
          DropdownMenuItem(
            value: 'sadece_yeni',
            child: Text('Sadece Yeni Duyurular'),
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationTile(
    BuildContext context,
    UserProvider userProvider,
  ) {
    return ListTile(
      leading: const Icon(Icons.send),
      title: const Text('Test Bildirimi Gönder'),
      subtitle: const Text('Bildirimlerin çalıştığını test et'),
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
                    const SnackBar(
                      content: Text('Test bildirimi gönderildi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hata: $e'),
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
    return ListTile(
      leading: const Icon(Icons.school),
      title: const Text('Takip Edilen Bölümler'),
      subtitle: Text('${userProvider.selectedDepartmentCount} bölüm seçili'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        // Bölüm seçim ekranına git
      },
    );
  }

  Widget _buildAppInfoTile() {
    return const ListTile(
      leading: Icon(Icons.school),
      title: Text('Fırat Üniversitesi Duyuru Takip'),
      subtitle: Text(
        'Fırat Üniversitesi\'nin tüm bölümlerinden duyuruları takip edin',
      ),
    );
  }

  Widget _buildVersionTile() {
    return const ListTile(
      leading: Icon(Icons.info_outline),
      title: Text('Versiyon'),
      subtitle: Text('1.0.0'),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text('Hakkında'),
      subtitle: const Text('Uygulama hakkında bilgi al'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showAboutDialog(context);
      },
    );
  }

  Widget _buildPrivacyPolicyTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.privacy_tip_outlined),
      title: const Text('Gizlilik Politikası'),
      subtitle: const Text('Veri kullanımı ve gizlilik'),
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
    return ListTile(
      leading: const Icon(Icons.description_outlined),
      title: const Text('Kullanım Şartları'),
      subtitle: const Text('Hizmet şartları ve koşulları'),
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
    showAboutDialog(
      context: context,
      applicationName: 'Fırat Üni Duyuru Takip',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.school,
        size: 64,
        color: Color(0xFF79113E),
      ),
      children: [
        const Text(
          'Fırat Üniversitesi\'nin tüm bölümlerinden duyuruları takip etmenizi sağlayan mobil uygulama.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Özellikler:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('• 24 bölümden duyuru takibi'),
        const Text('• Anlık push bildirimleri'),
        const Text('• Arama ve filtreleme'),
        const Text('• Offline okuma'),
        const SizedBox(height: 16),
        const Text(
          'Geliştirici: Fırat Üniversitesi Dijital Dönüşüm ve Yazılım Ofisi',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
