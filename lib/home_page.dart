import 'package:flutter/material.dart';

import 'app/app_colors.dart';
import 'core/widgets/app_bottom_nav.dart';
import 'core/widgets/app_header.dart';
import 'discover_page.dart';
import 'features/chat/view/chat_list_page.dart';
import 'features/notifications/view/alerts_page.dart';
import 'features/profile/model/profile_model.dart';
import 'features/profile/view/profile_screen.dart';
import 'features/profile/widgets/profile_action_buttons.dart';
import 'features/profile/widgets/profile_card.dart';
import 'features/profile/widgets/profile_filter_bar.dart';
import 'match_success_page.dart';
import 'profile_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFilter = 0;
  int _currentNavIndex = 0;
  int _currentProfileIndex = 0;

  final List<ProfileModel> _profiles = const [
    ProfileModel(
      name: 'Sophia',
      age: 26,
      occupation: 'Travel Creator',
      avatarUrl: 'assets/images/profiles/image1.jpg',
      photos: ['assets/images/profiles/image1.jpg'],
      distance: '4 km away',
      bio:
          'Love travel, music, coffee and discovering new places. Looking for someone to explore hidden cafes with!',
      selectedInterests: ['Travel', 'Music', 'Photography', 'Coffee'],
      verified: true,
    ),
    ProfileModel(
      name: 'Emma',
      age: 24,
      occupation: 'Fitness Coach',
      avatarUrl: 'assets/images/profiles/image2.avif',
      photos: ['assets/images/profiles/image2.avif'],
      distance: '2 km away',
      bio:
          'Fitness enthusiast, dog lover, and weekend baker. Let’s grab boba and talk about books!',
      selectedInterests: ['Fitness', 'Baking', 'Dogs', 'Reading'],
      verified: true,
    ),
    ProfileModel(
      name: 'Olivia',
      age: 25,
      occupation: 'Art Director',
      avatarUrl: 'assets/images/profiles/image3.avif',
      photos: ['assets/images/profiles/image3.avif'],
      distance: '5 km away',
      bio:
          'Art director by day, indie film buff by night. Always down for live concerts!',
      selectedInterests: ['Art', 'Indie Movies', 'Concerts', 'Wine'],
      verified: false,
    ),
    ProfileModel(
      name: 'Isabella',
      age: 27,
      occupation: 'Software Developer',
      avatarUrl: 'assets/images/profiles/image4.webp',
      photos: ['assets/images/profiles/image4.webp'],
      distance: '3 km away',
      bio:
          'Software developer who loves hiking, board games, and sunset photography.',
      selectedInterests: ['Tech', 'Hiking', 'Board Games', 'Sunset'],
      verified: true,
    ),
  ];

  ProfileModel get _currentProfile => _profiles[_currentProfileIndex];

  void _nextProfile() {
    setState(() {
      _currentProfileIndex = (_currentProfileIndex + 1) % _profiles.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing next profile: ${_currentProfile.name}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToProfileDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileDetailsPage(profile: _currentProfile),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.08);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  void _navigateToMatchSuccess() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            MatchSuccessPage(matchedProfile: _currentProfile),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _navigateToDiscover() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DiscoverPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // App Header
                    AppHeader(
                      avatarImage: _currentProfile.image,
                      location: 'Hyderabad',
                      onSearch: _navigateToDiscover,
                      onNotification: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No new notifications')),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // Greeting
                    _buildGreeting(),

                    const SizedBox(height: 16),

                    // Filter Bar
                    ProfileFilterBar(
                      selectedIndex: _selectedFilter,
                      onSelected: (index) {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    // Animated Profile Card (Tapping opens Profile Details)
                    GestureDetector(
                      onTap: _navigateToProfileDetails,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.95,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                        child: ProfileCard(
                          key: ValueKey<int>(_currentProfileIndex),
                          profile: _currentProfile,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Action Buttons (Reject/Close, Like/Heart, Discover)
                    ProfileActionButtons(
                      onReject: _nextProfile,
                      onLike: _navigateToMatchSuccess,
                      onDiscover: _navigateToDiscover,
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
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
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(text: '❤️', style: TextStyle(fontSize: 26)),
            ],
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Discover people who match your vibe.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
