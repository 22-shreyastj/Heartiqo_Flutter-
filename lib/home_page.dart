import 'package:flutter/material.dart';
import 'app/app_colors.dart';
import 'core/widgets/app_bottom_nav.dart';
import 'core/widgets/app_header.dart';
import 'discover_page.dart';
import 'features/profile/data/sample_profiles.dart';
import 'features/profile/model/profile_model.dart';
import 'features/profile/widgets/profile_action_buttons.dart';
import 'features/profile/widgets/profile_filter_bar.dart';
import 'features/profile/widgets/swipeable_profile_card_stack.dart';
import 'like_list_page.dart';
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

  final GlobalKey<SwipeableProfileCardStackState> _cardStackKey =
      GlobalKey<SwipeableProfileCardStackState>();

  final List<ProfileModel> _profiles = sampleProfiles;

  ProfileModel get _currentProfile => _profiles[_currentProfileIndex];

  void _navigateToProfileDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileDetailsPage(
          profiles: _profiles,
          initialIndex: _currentProfileIndex,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.08);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
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
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToLikes() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LikeListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
                      onLikes: _navigateToLikes,
                      onNotification: _navigateToLikes,
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

                    // Swipeable Tinder-Style Profile Card Stack
                    SwipeableProfileCardStack(
                      key: _cardStackKey,
                      profiles: _profiles,
                      currentIndex: _currentProfileIndex,
                      onProfileChanged: (newIndex) {
                        setState(() {
                          _currentProfileIndex = newIndex;
                        });
                      },
                      onTapCard: _navigateToProfileDetails,
                      onLike: () {},
                    ),

                    const SizedBox(height: 14),

                    // Action Buttons (Pass/Reject, Like/Heart, Discover)
                    ProfileActionButtons(
                      onReject: () => _cardStackKey.currentState?.swipeLeft(),
                      onLike: () => _cardStackKey.currentState?.swipeRight(),
                      onDiscover: _navigateToDiscover,
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            AppBottomNav(
              currentIndex: _currentNavIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
                if (index == 1) {
                  _navigateToDiscover();
                } else if (index == 3) {
                  _navigateToLikes();
                } else if (index == 2 || index == 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navigated to section $index'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
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
              TextSpan(
                text: '❤️',
                style: TextStyle(
                  fontSize: 26,
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
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
