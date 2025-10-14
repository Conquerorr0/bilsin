import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/announcement_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/skeleton_loading.dart';
import 'departments_screen.dart';
import 'settings_screen.dart';
import 'announcement_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kullanıcı tercihlerini yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });

    // UserProvider'daki değişiklikleri dinle
    final userProvider = context.read<UserProvider>();
    userProvider.addListener(_onUserProviderChanged);
  }

  void _onUserProviderChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userProvider = context.read<UserProvider>();
    final announcementProvider = context.read<AnnouncementProvider>();

    print('DEBUG: _loadUserData called');
    print('DEBUG: User authenticated: ${userProvider.isAuthenticated}');
    print('DEBUG: Selected departments: ${userProvider.selectedDepartments}');
    print(
      'DEBUG: All announcements count: ${announcementProvider.allAnnouncements.length}',
    );

    if (userProvider.isAuthenticated) {
      // Yeni kurulum kontrolü - eğer hiç duyuru yoksa ve bölüm seçiliyse son 5 duyuruyu çek
      final isNewInstall = announcementProvider.allAnnouncements.isEmpty;
      print('DEBUG: Is new install: $isNewInstall');

      announcementProvider.updateFollowedDepartments(
        userProvider.selectedDepartments,
        isNewInstall: isNewInstall,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Listener'ı kaldır
    final userProvider = context.read<UserProvider>();
    userProvider.removeListener(_onUserProviderChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bilsin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'FÜ Duyuru Takip',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Üst bilgi kartı
          _buildInfoCard(),

          // Arama ve filtreler
          _buildSearchAndFilters(),

          // Duyuru listesi
          Expanded(child: _buildAnnouncementList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToDepartments(),
        backgroundColor: const Color(0xFF79113E),
        icon: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset('assets/images/app_icon.png', fit: BoxFit.cover),
          ),
        ),
        label: const Text('Bölümler', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Consumer2<UserProvider, AnnouncementProvider>(
      builder: (context, userProvider, announcementProvider, child) {
        // UserProvider değiştiğinde AnnouncementProvider'ı güncelle
        if (userProvider.isAuthenticated &&
            userProvider.selectedDepartments.isNotEmpty &&
            announcementProvider.followedDepartments !=
                userProvider.selectedDepartments) {
          print('DEBUG: UserProvider changed, updating AnnouncementProvider');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final isNewInstall = announcementProvider.allAnnouncements.isEmpty;
            announcementProvider.updateFollowedDepartments(
              userProvider.selectedDepartments,
              isNewInstall: isNewInstall,
            );
          });
        }

        final stats = announcementProvider.getStatistics();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF79113E), Color(0xFF9A1B4A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bilsin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'FÜ Duyuru Platformu',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (userProvider.selectedDepartmentCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${userProvider.selectedDepartmentCount} bölüm takip ediliyor',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatItem('Toplam', '${stats['total']}'),
                  const SizedBox(width: 16),
                  _buildStatItem('Son 24 saat', '${stats['recent']}'),
                  const SizedBox(width: 16),
                  _buildStatItem('Bölümler', '${stats['departments']}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Arama çubuğu
          SearchBarWidget(
            controller: _searchController,
            onChanged: (query) {
              context.read<AnnouncementProvider>().updateSearchQuery(query);
            },
            hintText: 'Duyurularda ara...',
          ),

          const SizedBox(height: 12),

          // Filtre çipleri
          FilterChipWidget(
            onDepartmentFilterChanged: (departmentId) {
              context.read<AnnouncementProvider>().updateDepartmentFilter(
                departmentId,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementList() {
    return Consumer<AnnouncementProvider>(
      builder: (context, announcementProvider, child) {
        if (announcementProvider.isLoading) {
          return SkeletonList(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const SkeletonAnnouncementCard();
            },
          );
        }

        if (announcementProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Hata: ${announcementProvider.error}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => announcementProvider.refresh(),
                  child: const Text('Yeniden Dene'),
                ),
              ],
            ),
          );
        }

        final announcements = announcementProvider.announcements;

        if (announcements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.announcement_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Henüz duyuru bulunmuyor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Takip etmek istediğiniz bölümleri seçin',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _navigateToDepartments(),
                  icon: const Icon(Icons.school),
                  label: const Text('Bölümleri Seç'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF79113E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            announcementProvider.refresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return AnnouncementCard(
                announcement: announcement,
                onTap: () => _navigateToDetail(announcement.id),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDepartments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DepartmentsScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToDetail(String announcementId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AnnouncementDetailScreen(announcementId: announcementId),
      ),
    );
  }
}
