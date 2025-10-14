import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/announcement.dart';
import '../models/department.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;

  const AnnouncementCard({super.key, required this.announcement, this.onTap});

  @override
  Widget build(BuildContext context) {
    final departmentColor = _getDepartmentColor(announcement.bolumId);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve tarih
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      announcement.baslik,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? theme.colorScheme.onSurface
                            : const Color(0xFF79113E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surfaceVariant.withOpacity(0.35)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      announcement.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? theme.colorScheme.onSurfaceVariant
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Bölüm adı
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDepartmentColor(
                    announcement.bolumId,
                  ).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  announcement.bolumAdi,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getDepartmentColor(announcement.bolumId),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // İçerik önizlemesi
              Text(
                announcement.shortContent,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Alt bilgi
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDark
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatRelativeTime(announcement.olusturmaZamani),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  // Bölüm rengini getir
  Color _getDepartmentColor(String departmentId) {
    final department = Department.allDepartments.firstWhere(
      (dept) => dept.id == departmentId,
      orElse: () => Department(
        id: departmentId,
        name: 'Bilinmeyen Bölüm',
        url: '',
        color: Colors.grey,
      ),
    );
    return department.color;
  }
}
