import 'package:flutter/material.dart';
import '../models/department.dart';

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
                      department.name,
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
                      _getDepartmentType(department.name),
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

  String _getDepartmentType(String departmentName) {
    if (departmentName.contains('Mühendislik Fakültesi')) {
      return 'Fakülte';
    } else if (departmentName.contains('Teknoloji Fakültesi')) {
      return 'Teknoloji Fakültesi';
    } else if (departmentName.contains('Uluslararası')) {
      return 'Uluslararası Program';
    } else {
      return 'Bölüm';
    }
  }
}
