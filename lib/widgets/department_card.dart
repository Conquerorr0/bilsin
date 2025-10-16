import 'package:flutter/material.dart';
import '../models/department.dart';
import '../l10n/app_localizations.dart';

class DepartmentCard extends StatelessWidget {
  final Department department;
  final bool isSelected;
  final VoidCallback onTap;

  const DepartmentCard({
    super.key,
    required this.department,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF79113E)
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF79113E)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF79113E) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),

              const SizedBox(width: 16),

              // Bölüm bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _localizedDepartmentName(context, department.name),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF79113E)
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDepartmentType(context, department.name),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? const Color(0xFF79113E).withOpacity(0.7)
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Seçim ikonu
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? const Color(0xFF79113E) : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDepartmentType(BuildContext context, String departmentName) {
    final l10n = AppLocalizations.of(context)!;
    if (departmentName.contains('Mühendislik Fakültesi') ||
        departmentName.contains('Faculty')) {
      return l10n
          .departments; // generic label; no specific key for type in l10n
    } else if (departmentName.contains('Teknoloji Fakültesi') ||
        departmentName.contains('Technology')) {
      return l10n.departments;
    } else if (departmentName.contains('Uluslararası') ||
        departmentName.toLowerCase().contains('international')) {
      return l10n.departments;
    } else {
      return l10n.departmentLabel;
    }
  }

  String _localizedDepartmentName(BuildContext context, String trName) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != 'en') return trName;
    // Basit eşleme; gerekli görülenler eklenebilir
    const Map<String, String> trToEn = {
      'Mühendislik Fakültesi': 'Faculty of Engineering',
      'Bilgisayar Mühendisliği': 'Computer Engineering',
      'Biyomühendislik': 'Bioengineering',
      'Çevre Mühendisliği': 'Environmental Engineering',
      'Elektrik Elektronik Mühendisliği (Mühendislik Fakültesi)':
          'Electrical and Electronics Engineering (Engineering Faculty)',
      'İnşaat Mühendisliği': 'Civil Engineering',
      'Jeoloji Mühendisliği': 'Geological Engineering',
      'Kimya Mühendisliği': 'Chemical Engineering',
      'Makine Mühendisliği': 'Mechanical Engineering',
      'Mekatronik Mühendisliği': 'Mechatronics Engineering',
      'Metalurji ve Malzeme Mühendisliği':
          'Metallurgical and Materials Engineering',
      'Yapay Zeka ve Veri Mühendisliği':
          'Artificial Intelligence and Data Engineering',
      'Yazılım Mühendisliği': 'Software Engineering',
      'Teknoloji Fakültesi': 'Faculty of Technology',
      'Adli Bilişim Mühendisliği': 'Forensic Informatics Engineering',
      'Elektrik Elektronik Mühendisliği (Teknoloji Mühendislik)':
          'Electrical and Electronics Engineering (Technology Faculty)',
      'Enerji Sistemleri Mühendisliği': 'Energy Systems Engineering',
      'İnşaat Mühendisliği (Teknoloji Fakültesi)':
          'Civil Engineering (Technology Faculty)',
      'Makine Mühendisliği (Teknoloji Fakültesi)':
          'Mechanical Engineering (Technology Faculty)',
      'Mekatronik Mühendisliği (Teknoloji Fakültesi)':
          'Mechatronics Engineering (Technology Faculty)',
      'Metalurji ve Malzeme Mühendisliği (Teknoloji Fakültesi)':
          'Metallurgical and Materials Engineering (Technology Faculty)',
      'Otomotiv Mühendisliği Bölümü': 'Automotive Engineering',
      'Yazılım Mühendisliği (Teknoloji Fakültesi)':
          'Software Engineering (Technology Faculty)',
      'Yazılım Mühendisliği Uluslararası Ortak Lisans Programı':
          'Software Engineering International Joint Undergraduate Program',
    };
    return trToEn[trName] ?? trName;
  }
}
