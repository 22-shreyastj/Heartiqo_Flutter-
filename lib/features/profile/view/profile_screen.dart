import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_header.dart';
import '../../chat/view/chat_list_page.dart';

import '../model/profile_model.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_filter_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedFilter = 0;
  int _currentNavIndex = 0;

  final ProfileModel _profile = const ProfileModel(
    name: 'Sophia, 26',
    image: 'assets/images/sophia.jpg',
    distance: '4 km away',
    bio:
        'Love travel, music, coffee and discovering new places. Looking for someone to...',
    tags: [
      'Travel',
      'Music',
      'Photography',
    ],
    verified: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // SHARED APP HEADER
                    AppHeader(
                      avatarImage: _profile.image,
                      location: 'Hyderabad',
                      onSearch: _onSearch,
                      onNotification: _onNotification,
                    ),

                    const SizedBox(height: 22),

                    // GREETING
                    _buildGreeting(),

                    const SizedBox(height: 18),

                    // FILTER BAR
                    ProfileFilterBar(
                      selectedIndex: _selectedFilter,
                      onSelected: (index) {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    // PROFILE CARD
                    ProfileCard(
                      profile: _profile,
                    ),

                    const SizedBox(height: 12),

                    // ACTION BUTTONS
                    ProfileActionButtons(
                      onReject: _onReject,
                      onLike: _onLike,
                      onDiscover: _onDiscover,
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // SHARED BOTTOM NAVIGATION
            AppBottomNav(
              currentIndex: _currentNavIndex,
              onItemSelected: _onNavigationChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hello, Alex ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF21181D),
                ),
              ),
              TextSpan(
                text: '❤️',
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Discover people who match your vibe.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF55484D),
          ),
        ),
      ],
    );
  }

  void _onSearch() {
    // TODO: Navigate to search
  }

  void _onNotification() {
    // TODO: Navigate to notifications
  }

  void _onReject() {
    // TODO: Reject profile
  }

  void _onLike() {
    // TODO: Like profile
  }

  void _onDiscover() {
    // TODO: Open discover
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatListPage(),
        ),
      );
    }
  }
}