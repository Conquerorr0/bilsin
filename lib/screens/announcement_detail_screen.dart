import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/announcement_provider.dart';
import '../models/announcement.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String announcementId;

  const AnnouncementDetailScreen({super.key, required this.announcementId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Duyuru Detayı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAnnouncement(context),
          ),
        ],
      ),
      body: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          final announcement = announcementProvider.getAnnouncementById(
            announcementId,
          );

          if (announcement == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Duyuru bulunamadı', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return _buildDetailContent(context, announcement);
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, Announcement announcement) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık kartı
          _buildTitleCard(announcement),

          const SizedBox(height: 16),

          // Bölüm bilgisi
          _buildDepartmentCard(announcement),

          const SizedBox(height: 16),

          // İçerik kartı
          _buildContentCard(announcement),

          const SizedBox(height: 16),

          // Tarih bilgisi
          _buildDateCard(announcement),

          const SizedBox(height: 16),

          // Alt butonlar
          _buildActionButtons(context, announcement),
        ],
      ),
    );
  }

  Widget _buildTitleCard(Announcement announcement) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.announcement,
                  color: Color(0xFF79113E),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    announcement.baslik,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF79113E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentCard(Announcement announcement) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.school, color: Color(0xFF79113E)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bölüm',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    announcement.bolumAdi,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Announcement announcement) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description, color: Color(0xFF79113E)),
                SizedBox(width: 12),
                Text(
                  'İçerik',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF79113E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              announcement.icerik,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(Announcement announcement) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF79113E)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yayın Tarihi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    announcement.formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eklenme Tarihi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatDateTime(announcement.olusturmaZamani),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Announcement announcement) {
    return Row(
      children: [
        // URL'yi aç
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openUrl(context, announcement.url),
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Web Sitesinde Aç'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF79113E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // URL'yi kopyala
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _copyUrl(context, announcement.url),
            icon: const Icon(Icons.copy),
            label: const Text('URL Kopyala'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF79113E),
              side: const BorderSide(color: Color(0xFF79113E)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      print('DEBUG: Attempting to open URL: $url');
      final uri = Uri.parse(url);

      // URL formatını kontrol et
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        print('DEBUG: URL does not start with http/https, adding https://');
        url = 'https://$url';
        final newUri = Uri.parse(url);
        await launchUrl(newUri, mode: LaunchMode.externalApplication);
      } else {
        final canLaunch = await canLaunchUrl(uri);
        print('DEBUG: Can launch URL: $canLaunch');

        if (canLaunch) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          print('DEBUG: URL launched successfully');
        } else {
          // Alternatif olarak platformDefault mode dene
          print('DEBUG: Trying with platformDefault mode');
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (e) {
      print('URL açma hatası: $e');
      // Kullanıcıya hata mesajı göster
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL açılamadı: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyUrl(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL panoya kopyalandı'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareAnnouncement(BuildContext context) {
    final announcement = context
        .read<AnnouncementProvider>()
        .getAnnouncementById(announcementId);

    if (announcement != null) {
      final shareText =
          '''
📢 ${announcement.baslik}

${announcement.icerik.length > 200 ? '${announcement.icerik.substring(0, 200)}...' : announcement.icerik}

🔗 ${announcement.url}

📅 ${announcement.formattedDate}

#FıratÜniversitesi #Duyuru
''';

      Share.share(shareText, subject: announcement.baslik);
    }
  }
}
