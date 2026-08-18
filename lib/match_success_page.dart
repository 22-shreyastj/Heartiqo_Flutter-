import 'package:flutter/material.dart';
import 'app/app_colors.dart';
import 'features/profile/model/profile_model.dart';

class MatchSuccessPage extends StatefulWidget {
  final ProfileModel? matchedProfile;

  const MatchSuccessPage({super.key, this.matchedProfile});

  @override
  State<MatchSuccessPage> createState() => _MatchSuccessPageState();
}

class _MatchSuccessPageState extends State<MatchSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        widget.matchedProfile ??
        const ProfileModel(
          name: 'Sophia',
          age: 26,
          occupation: 'Travel Creator',
          avatarUrl: 'assets/images/profiles/image1.jpg',
          photos: ['assets/images/profiles/image1.jpg'],
          distance: '4 km away',
          bio: 'Love travel, music, coffee and discovering new places.',
          selectedInterests: ['Travel', 'Music', 'Photography'],
        );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.matchGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // Top Close Button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Match Title & Sparkles
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.emotionalAccent,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "It's a Match!",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "You and ${profile.name.split(',')[0]} liked each other!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Overlapping Avatar Circles
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          height: 150,
                          width: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Left Avatar (User - Alex)
                              Positioned(
                                left: 20,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const ClipOval(
                                    child: Icon(
                                      Icons.person,
                                      size: 70,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),

                              // Right Avatar (Sophia)
                              Positioned(
                                right: 20,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      profile.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: const Color(0xFFF3DDE4),
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 70,
                                                  color:
                                                      AppColors.emotionalAccent,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),

                              // Heart Badge Center
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.emotionalAccent,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 54),

                      // Actions
                      Column(
                        children: [
                          // Send Message Button
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Started chat with ${profile.name.split(',')[0]}!",
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.chat_bubble_rounded,
                              color: AppColors.primary,
                            ),
                            label: const Text(
                              'SEND A MESSAGE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.primary,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Keep Swiping Button
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'KEEP SWIPING',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
