import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/user_provider.dart';
import '../models/department.dart';

class FilterChipWidget extends StatelessWidget {
  final ValueChanged<String?> onDepartmentFilterChanged;

  const FilterChipWidget({super.key, required this.onDepartmentFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AnnouncementProvider, UserProvider>(
      builder: (context, announcementProvider, userProvider, child) {
        // Sadece seçili bölümlerin chip'lerini göster
        final selectedDepartments = Department.allDepartments
            .where((dept) => userProvider.selectedDepartments.contains(dept.id))
            .toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Tümü filtresi
              FilterChip(
                label: const Text('Tümü'),
                selected: announcementProvider.selectedDepartmentFilter == null,
                onSelected: (selected) {
                  onDepartmentFilterChanged(null);
                },
                backgroundColor: Colors.grey[200],
                selectedColor: const Color(0xFF79113E).withOpacity(0.2),
                checkmarkColor: const Color(0xFF79113E),
                labelStyle: TextStyle(
                  color: announcementProvider.selectedDepartmentFilter == null
                      ? const Color(0xFF79113E)
                      : Colors.black87,
                  fontWeight:
                      announcementProvider.selectedDepartmentFilter == null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),

              const SizedBox(width: 8),

              // Seçili bölüm filtreleri
              ...selectedDepartments.map((department) {
                final isSelected =
                    announcementProvider.selectedDepartmentFilter ==
                    department.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      department.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      onDepartmentFilterChanged(
                        selected ? department.id : null,
                      );
                    },
                    backgroundColor: department.color.withOpacity(0.1),
                    selectedColor: department.color.withOpacity(0.3),
                    checkmarkColor: department.color,
                    labelStyle: TextStyle(
                      color: isSelected ? department.color : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
