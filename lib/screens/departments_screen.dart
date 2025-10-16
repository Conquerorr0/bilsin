import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../models/department.dart';
import '../widgets/department_card.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Department> _filteredDepartments = Department.allDepartments;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDepartments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDepartments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDepartments = Department.allDepartments;
      } else {
        _filteredDepartments = Department.allDepartments
            .where((dept) => dept.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectDepartments,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Arama çubuğu
          _buildSearchBar(),

          // Seçim bilgisi
          _buildSelectionInfo(),

          // Bölüm listesi
          Expanded(child: _buildDepartmentList()),

          // Alt butonlar
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF79113E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.departmentSearch,
            prefixIcon: const Icon(Icons.search, color: Color(0xFF79113E)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionInfo() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final selectedCount = userProvider.selectedDepartments.length;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedCount == 0
                      ? l10n.selectDepartmentsDescription
                      : l10n.departmentsSelected(selectedCount),
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (selectedCount > 0)
                TextButton(
                  onPressed: () {
                    userProvider.updateSelectedDepartments([]);
                  },
                  child: Text(l10n.removeAll),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDepartmentList() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF79113E)),
            ),
          );
        }

        if (_filteredDepartments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  l10n.noDepartmentsFoundMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredDepartments.length,
          itemBuilder: (context, index) {
            final department = _filteredDepartments[index];
            final isSelected = userProvider.isDepartmentSelected(department.id);

            return DepartmentCard(
              department: department,
              isSelected: isSelected,
              onTap: () async {
                await userProvider.toggleDepartmentSelection(department.id);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Tümünü seç/kaldır
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await userProvider.toggleAllDepartments();
                  },
                  icon: const Icon(Icons.select_all),
                  label: Text(
                    userProvider.selectedDepartments.length ==
                            Department.allDepartments.length
                        ? AppLocalizations.of(context)!.removeAll
                        : AppLocalizations.of(context)!.selectAll,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF79113E),
                    side: const BorderSide(color: Color(0xFF79113E)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Kaydet
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: userProvider.selectedDepartments.isEmpty
                      ? null
                      : () async {
                          try {
                            await userProvider.updateSelectedDepartments(
                              userProvider.selectedDepartments,
                            );

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.departmentsSelected(
                                      userProvider.selectedDepartments.length,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF79113E),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${AppLocalizations.of(context)!.error}: $e',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context)!.saveButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF79113E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
