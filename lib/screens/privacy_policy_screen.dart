import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gizlilik Politikası',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fırat Üniversitesi Duyuru Takip Uygulaması Gizlilik Politikası',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF79113E),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Son Güncelleme: 12 Ekim 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Toplanan Bilgiler',
              'Uygulamamız aşağıdaki bilgileri toplar:\n\n'
                  '• FCM Token: Push bildirimleri göndermek için\n'
                  '• Takip Edilen Bölümler: Kullanıcının seçtiği bölümler\n'
                  '• Bildirim Tercihleri: Kullanıcının bildirim ayarları\n'
                  '• Anonim Kimlik: Firebase Authentication ile',
            ),
            _buildSection(
              '2. Bilgilerin Kullanımı',
              'Toplanan bilgiler sadece aşağıdaki amaçlarla kullanılır:\n\n'
                  '• Duyuru bildirimleri gönderme\n'
                  '• Kullanıcı tercihlerini kaydetme\n'
                  '• Uygulama deneyimini iyileştirme',
            ),
            _buildSection(
              '3. Bilgi Paylaşımı',
              'Kişisel bilgileriniz üçüncü taraflarla paylaşılmaz. '
                  'Sadece Firebase hizmetleri (Firestore, FCM) kullanılır.',
            ),
            _buildSection(
              '4. Veri Güvenliği',
              'Tüm veriler Firebase güvenlik altyapısı ile korunur. '
                  'Veriler şifrelenmiş olarak saklanır.',
            ),
            _buildSection(
              '5. Veri Silme',
              'Uygulamayı silerek tüm verilerinizi kaldırabilirsiniz. '
                  'Firebase Console üzerinden de verilerinizi silebilirsiniz.',
            ),
            _buildSection(
              '6. İletişim',
              'Gizlilik politikası ile ilgili sorularınız için:\n\n'
                  'E-posta: bilgi@firat.edu.tr\n'
                  'Web: https://www.firat.edu.tr',
            ),
            const SizedBox(height: 32),
            const Text(
              'Bu gizlilik politikası, Fırat Üniversitesi tarafından hazırlanmıştır.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF79113E),
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.6)),
        const SizedBox(height: 24),
      ],
    );
  }
}
