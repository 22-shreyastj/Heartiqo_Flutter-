import 'package:flutter/material.dart';

import '../../../add_profile_page.dart';
import '../../../app/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_header.dart';
import '../../chat/view/chat_list_page.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';
import '../widgets/profile_settings_list.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_upgrade_banner.dart';
import '../../discover/view/discover_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onNotificationTap;

  const ProfileScreen({
    super.key,
    this.isEmbedded = false,
    this.onNotificationTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _controller;
  int _currentNavIndex = 4; // Profile tab index

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _controller.addListener(_onProfileUpdated);
  }

  void _onProfileUpdated() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onProfileUpdated);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _controller.profile;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Shared App Header
            AppHeader(
              avatarImage: profile.avatarUrl,
              location: 'Hyderabad',
              onSearch: _onSearch,
              onNotification:
                  widget.onNotificationTap ?? _onNotification,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Avatar & Info Section
                    _buildAvatarSection(context, profile),

                    const SizedBox(height: 24),

                    // Stats Row Card
                    ProfileStatsCard(
                      likes: '${profile.likesCount}',
                      matches: '${profile.matchesCount}',
                      profileViews: profile.viewsCount,
                      onLikesTap: () {},
                      onMatchesTap: () {},
                      onViewsTap: () {},
                    ),

                    const SizedBox(height: 20),

                    // Premium Upgrade Banner
                    ProfileUpgradeBanner(
                      onUpgradeTap: _onUpgrade,
                    ),

                    const SizedBox(height: 20),

                    // Settings Options List
                    ProfileSettingsList(
                      onAccountTap: _onAccountTap,
                      onDiscoverySettingsTap:
                          _onDiscoverySettingsTap,
                      onSafetyTap: _onSafetyTap,
                      onHelpTap: _onHelpTap,
                    ),

                    const SizedBox(height: 24),

                    // Logout Button
                    _buildLogoutButton(context),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Shared Bottom Navigation
            if (!widget.isEmbedded)
              AppBottomNav(
                currentIndex: _currentNavIndex,
                onItemSelected: _onNavigationChanged,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddProfile,
        backgroundColor: AppColors.deepPink,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    BuildContext context,
    ProfileModel profile,
  ) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softPinkSlot,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                image: profile.avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(profile.avatarUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      )
                    : null,
              ),
              child: profile.avatarUrl.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: AppColors.brandPink,
                    )
                  : null,
            ),

            // Edit Pencil
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: _navigateToEditProfile,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.brandPink,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandPink.withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Name & Age
        Text(
          '${profile.name}, ${profile.age}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 4),

        // Occupation
        Text(
          profile.occupation,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.brandPink.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onLogout,
          borderRadius: BorderRadius.circular(25),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20,
                color: AppColors.brandPink,
              ),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandPink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProfilePage(),
      ),
    );
  }

  void _onSearch() {
    // TODO: Navigate to search
  }

  void _onNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No new notifications'),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          controller: _controller,
        ),
      ),
    );
  }

  void _onUpgrade() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Premium Upgrade...'),
      ),
    );
  }

  void _onAccountTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account settings tapped'),
      ),
    );
  }

  void _onDiscoverySettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Discovery settings tapped'),
      ),
    );
  }

  void _onSafetyTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Safety center tapped'),
      ),
    );
  }

  void _onHelpTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & support tapped'),
      ),
    );
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to log out of Heartiqo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DiscoverScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatListPage(),
        ),
      );
    }
  }
}