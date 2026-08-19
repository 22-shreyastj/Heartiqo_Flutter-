import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'app/app_colors.dart';
import 'features/profile/data/sample_profiles.dart';
import 'features/profile/model/profile_model.dart';
import 'features/profile/service/liked_profiles_service.dart';
import 'match_success_page.dart';

class SwipeProfilePage extends StatefulWidget {
  final List<ProfileModel>? profiles;
  final int initialIndex;

  const SwipeProfilePage({
    super.key,
    this.profiles,
    this.initialIndex = 0,
  });

  @override
  State<SwipeProfilePage> createState() => _SwipeProfilePageState();
}

class _SwipeProfilePageState extends State<SwipeProfilePage>
    with SingleTickerProviderStateMixin {
  late List<ProfileModel> _profiles;
  late int _currentIndex;
  final Map<int, bool> _likedStatus = {};

  // High performance gesture & animation state
  final ValueNotifier<Offset> _dragNotifier = ValueNotifier<Offset>(Offset.zero);
  late AnimationController _animController;
  Animation<Offset>? _slideAnimation;
  bool _isPrecached = false;

  @override
  void initState() {
    super.initState();
    _profiles = widget.profiles ?? sampleProfiles;
    _currentIndex = widget.initialIndex % _profiles.length;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() {
        if (_slideAnimation != null) {
          _dragNotifier.value = _slideAnimation!.value;
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPrecached) {
      _isPrecached = true;
      // Precache profile images in background so swiping never stutters
      for (final profile in _profiles) {
        precacheImage(AssetImage(profile.image), context);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  ProfileModel get _currentProfile => _profiles[_currentIndex];
  ProfileModel get _nextProfile =>
      _profiles[(_currentIndex + 1) % _profiles.length];

  bool get _isCurrentLiked => _likedStatus[_currentIndex] ?? false;

  void _toggleFavoriteCurrent() {
    setState(() {
      _likedStatus[_currentIndex] = !_isCurrentLiked;
    });
    if (!_isCurrentLiked) {
      LikedProfilesService.instance.addLikedProfile(_currentProfile);
    } else {
      LikedProfilesService.instance.removeLikedProfile(_currentProfile);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_animController.isAnimating) return;
    _dragNotifier.value += details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_animController.isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final currentDx = _dragNotifier.value.dx;

    if (currentDx > 100 || velocity > 500) {
      LikedProfilesService.instance.addLikedProfile(_currentProfile);
      _animateCardOut(targetDx: screenWidth * 1.5, isLike: true);
    } else if (currentDx < -100 || velocity < -500) {
      _animateCardOut(targetDx: -screenWidth * 1.5, isLike: false);
    } else {
      _resetCardPosition();
    }
  }

  void _resetCardPosition() {
    _slideAnimation = Tween<Offset>(
      begin: _dragNotifier.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0.0).then((_) {
      _dragNotifier.value = Offset.zero;
    });
  }

  void _animateCardOut({required double targetDx, required bool isLike}) {
    final startOffset = _dragNotifier.value;
    final endOffset = Offset(targetDx, startOffset.dy);

    _slideAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0.0).then((_) {
      _onSwipeCompleted(isLike: isLike);
    });
  }

  void _swipeLeft() {
    if (_animController.isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    _animateCardOut(targetDx: -screenWidth * 1.5, isLike: false);
  }

  void _swipeRight() {
    if (_animController.isAnimating) return;
    LikedProfilesService.instance.addLikedProfile(_currentProfile);
    final screenWidth = MediaQuery.of(context).size.width;
    _animateCardOut(targetDx: screenWidth * 1.5, isLike: true);
  }

  void _onSwipeCompleted({required bool isLike}) {
    final matchedProfile = _currentProfile;
    _dragNotifier.value = Offset.zero;

    setState(() {
      _currentIndex = (_currentIndex + 1) % _profiles.length;
    });

    if (isLike) {
      _navigateToMatchSuccess(matchedProfile);
    }
  }

  void _navigateToMatchSuccess(ProfileModel profile) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            MatchSuccessPage(matchedProfile: profile),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: const {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Underneath Preview Card (Next Profile) - Efficiently updated via ValueListenableBuilder
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: ValueListenableBuilder<Offset>(
                    valueListenable: _dragNotifier,
                    child: RepaintBoundary(
                      child: ProfileCardContent(
                        key: ValueKey<int>((_currentIndex + 1) % _profiles.length),
                        profile: _nextProfile,
                        isLiked: _likedStatus[(_currentIndex + 1) % _profiles.length] ?? false,
                        onBack: () => Navigator.pop(context),
                        onFavoriteToggle: () {},
                        isUnderneathCard: true,
                      ),
                    ),
                    builder: (context, dragOffset, child) {
                      final dragFraction = (dragOffset.dx / screenWidth).clamp(-1.0, 1.0).abs();
                      final scale = 0.94 + (dragFraction * 0.06);
                      final opacity = 0.7 + (dragFraction * 0.3);

                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: child,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Active Top Card - Efficiently transformed without rebuilding inner widget tree during drag
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    behavior: HitTestBehavior.translucent,
                    child: ValueListenableBuilder<Offset>(
                      valueListenable: _dragNotifier,
                      child: RepaintBoundary(
                        child: ProfileCardContent(
                          key: ValueKey<int>(_currentIndex),
                          profile: _currentProfile,
                          isLiked: _isCurrentLiked,
                          onBack: () => Navigator.pop(context),
                          onFavoriteToggle: _toggleFavoriteCurrent,
                          isUnderneathCard: false,
                        ),
                      ),
                      builder: (context, dragOffset, child) {
                        final dragFraction = (dragOffset.dx / screenWidth).clamp(-1.0, 1.0);
                        final rotationAngle = dragFraction * 0.25;

                        return Transform.translate(
                          offset: dragOffset,
                          child: Transform.rotate(
                            angle: rotationAngle,
                            alignment: Alignment.bottomCenter,
                            child: child,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Fixed Action Buttons overlay at bottom
              Positioned(
                left: 24,
                right: 24,
                bottom: 16,
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Reject / Pass Button
                      FloatingActionButton.large(
                        heroTag: 'swipe_pass_btn',
                        onPressed: _swipeLeft,
                        backgroundColor: Colors.white,
                        elevation: 6,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF6B7280),
                          size: 36,
                        ),
                      ),

                      // Like / Heart Button
                      FloatingActionButton.large(
                        heroTag: 'swipe_like_btn',
                        onPressed: _swipeRight,
                        backgroundColor: AppColors.emotionalAccent,
                        elevation: 8,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
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

class ProfileCardContent extends StatelessWidget {
  final ProfileModel profile;
  final bool isLiked;
  final VoidCallback onBack;
  final VoidCallback onFavoriteToggle;
  final bool isUnderneathCard;

  const ProfileCardContent({
    super.key,
    required this.profile,
    required this.isLiked,
    required this.onBack,
    required this.onFavoriteToggle,
    this.isUnderneathCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final imageCacheWidth = (size.width * devicePixelRatio).round();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Large Hero Profile Image Header
            SliverAppBar(
              expandedHeight: size.height * 0.50,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: isUnderneathCard
                  ? null
                  : Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0x59000000),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: onBack,
                      ),
                    ),
              actions: [
                if (!isUnderneathCard)
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0x59000000),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color:
                            isLiked ? AppColors.emotionalAccent : Colors.white,
                        size: 22,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      profile.image,
                      cacheWidth: imageCacheWidth > 0 ? imageCacheWidth : 800,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFEEDFE1),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x4D000000),
                            Colors.transparent,
                            Color(0xC7000000),
                          ],
                          stops: [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profile.name,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (profile.verified) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF4B8CF5),
                                  size: 24,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                profile.distance,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Details Body
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match Percentage Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEDE9FE), Color(0xFFFFE4E6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${profile.matchPercentage} Match Compatibility',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.dark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  profile.matchReason,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // About Me Section
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Interests Section
                    const Text(
                      'Interests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: profile.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Basics Section
                    const Text(
                      'Basics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: const [
                        _InfoTile(
                          icon: Icons.work_outline_rounded,
                          title: 'Profession',
                          value: 'UI/UX Designer',
                        ),
                        _InfoTile(
                          icon: Icons.height_rounded,
                          title: 'Height',
                          value: "5'6\" (168 cm)",
                        ),
                        _InfoTile(
                          icon: Icons.star_outline_rounded,
                          title: 'Zodiac',
                          value: 'Scorpio ♏',
                        ),
                        _InfoTile(
                          icon: Icons.school_outlined,
                          title: 'Education',
                          value: 'Master Degree',
                        ),
                        _InfoTile(
                          icon: Icons.local_drink_outlined,
                          title: 'Drinking',
                          value: 'Socially',
                        ),
                        _InfoTile(
                          icon: Icons.smoke_free_rounded,
                          title: 'Smoking',
                          value: 'Non-smoker',
                        ),
                      ],
                    ),

                    const SizedBox(height: 100), // Space for floating action buttons
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
