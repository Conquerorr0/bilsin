import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kullanım Şartları',
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
              'Fırat Üniversitesi Duyuru Takip Uygulaması Kullanım Şartları',
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
              '1. Hizmet Tanımı',
              'Bu uygulama, Fırat Üniversitesi\'nin 24 farklı bölümünden '
                  'duyuruları takip etmenizi ve anlık bildirimler almanızı sağlar.',
            ),
            _buildSection(
              '2. Kullanım Koşulları',
              'Uygulamayı kullanarak aşağıdaki koşulları kabul etmiş sayılırsınız:\n\n'
                  '• Uygulamayı yasal amaçlarla kullanacaksınız\n'
                  '• Başkalarının haklarını ihlal etmeyeceksiniz\n'
                  '• Uygulamayı zararlı amaçlarla kullanmayacaksınız',
            ),
            _buildSection(
              '3. Kullanıcı Sorumlulukları',
              'Kullanıcılar şunlardan sorumludur:\n\n'
                  '• Doğru bilgi sağlamak\n'
                  '• Uygulama güvenliğini korumak\n'
                  '• Telif haklarına saygı göstermek',
            ),
            _buildSection(
              '4. Hizmet Kesintileri',
              'Uygulama kesintisiz hizmet vermeyi hedefler ancak '
                  'teknik nedenlerle geçici kesintiler olabilir.',
            ),
            _buildSection(
              '5. İçerik Sorumluluğu',
              'Duyuru içerikleri Fırat Üniversitesi\'ne aittir. '
                  'Uygulama sadece bu içerikleri gösterir.',
            ),
            _buildSection(
              '6. Değişiklikler',
              'Bu kullanım şartları önceden haber verilmeksizin '
                  'değiştirilebilir. Güncel versiyonu uygulamada bulabilirsiniz.',
            ),
            _buildSection(
              '7. Sorumluluk Reddi',
              'Uygulama "olduğu gibi" sağlanır. Fırat Üniversitesi, '
                  'uygulamanın kesintisiz çalışmasını garanti etmez.',
            ),
            _buildSection(
              '8. İletişim',
              'Kullanım şartları ile ilgili sorularınız için:\n\n'
                  'E-posta: bilgi@firat.edu.tr\n'
                  'Web: https://www.firat.edu.tr',
            ),
            const SizedBox(height: 32),
            const Text(
              'Bu kullanım şartları, Fırat Üniversitesi tarafından hazırlanmıştır.',
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
