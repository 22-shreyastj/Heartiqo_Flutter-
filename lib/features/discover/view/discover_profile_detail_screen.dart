import 'package:flutter/material.dart';
import '../controller/discover_controller.dart';
import '../model/discover_profile.dart';
import '../widgets/discover_basic_info_card.dart';

class DiscoverProfileDetailScreen extends StatelessWidget {
  final DiscoverProfile profile;
  final DiscoverController? controller;

  const DiscoverProfileDetailScreen({
    super.key,
    required this.profile,
    this.controller,
  });

  static const _backgroundColor = Color(0xFFFFF8F8);
  static const _primaryColor = Color(0xFF8A0B3B);
  static const _accentPink = Color(0xFF9E1068);
  static const _borderColor = Color(0xFFF3D2DC);
  static const _chipBackground = Color(0xFFFDF0F3);
  static const _textColor = Color(0xFF1D1B1E);
  static const _subtextColor = Color(0xFF7A5A66);

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ListenableBuilder(
        listenable: controller!,
        builder: (context, _) {
          final currentProfile = controller!.profiles.firstWhere(
            (p) => p.id == profile.id,
            orElse: () => profile,
          );
          return _buildScaffold(context, currentProfile);
        },
      );
    }

    return _buildScaffold(context, profile);
  }

  Widget _buildScaffold(BuildContext context, DiscoverProfile currentProfile) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final imageHeight = (mediaQuery.size.height * 0.38).clamp(280.0, 340.0);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Image Header with Floating Actions
            Stack(
              children: [
                // Image
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: _DetailProfileImage(imageUrl: currentProfile.imageUrl),
                ),

                // Bottom Gradient Overlay for Name & Identity
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.35, 0.65, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // Floating Circular Back Button
                Positioned(
                  top: topPadding + 8,
                  left: 16,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating Circular Favorite Button
                Positioned(
                  top: topPadding + 8,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        controller?.toggleFavorite(currentProfile.id);
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.14),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          currentProfile.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: const Color(0xFFC2185B),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Identity (Name, Age, Verified, Distance)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              currentProfile.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (currentProfile.isVerified) ...[
                            const SizedBox(width: 6),
                            const _VerifiedBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white70,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            currentProfile.distance,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (currentProfile.relationshipGoal != null) ...[
                            Text(
                              '  •  ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 13,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                currentProfile.relationshipGoal!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 2. Profile Details Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Compatibility Card
                  _CompatibilityCard(
                    matchScore: currentProfile.matchScore ?? 92,
                    interests: currentProfile.interests,
                  ),

                  const SizedBox(height: 24),

                  // About Me Section
                  const _SectionTitle(title: 'About Me'),
                  const SizedBox(height: 10),
                  Text(
                    currentProfile.bio ??
                        'Fitness enthusiast, dog lover, and weekend baker. Let’s grab boba and talk about books!',
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.55,
                      color: Color(0xFF4A3E44),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Interests Section
                  const _SectionTitle(title: 'Interests'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: currentProfile.interests.map((interest) {
                      return _InterestChip(label: interest);
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // Basics Section
                  const _SectionTitle(title: 'Basics'),
                  const SizedBox(height: 14),
                  _BasicsGrid(profile: currentProfile),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Section Title
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: DiscoverProfileDetailScreen._textColor,
        letterSpacing: -0.2,
      ),
    );
  }
}

// Match Compatibility Card
class _CompatibilityCard extends StatelessWidget {
  final int matchScore;
  final List<String> interests;

  const _CompatibilityCard({required this.matchScore, required this.interests});

  @override
  Widget build(BuildContext context) {
    final sharedTopics = interests.length >= 2
        ? '${interests[0]} & ${interests[1]}'
        : (interests.isNotEmpty ? interests.first : 'Music & Food');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDEEF2), Color(0xFFFFF5F7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DiscoverProfileDetailScreen._borderColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: DiscoverProfileDetailScreen._accentPink.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9E1068), Color(0xFFC41C70)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9E1068).withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '✨ $matchScore% Match Compatibility',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: DiscoverProfileDetailScreen._primaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'You both love $sharedTopics!',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: DiscoverProfileDetailScreen._subtextColor,
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

// Interest Chip
class _InterestChip extends StatelessWidget {
  final String label;

  const _InterestChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
      decoration: BoxDecoration(
        color: DiscoverProfileDetailScreen._chipBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: DiscoverProfileDetailScreen._borderColor,
          width: 1.2,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: DiscoverProfileDetailScreen._primaryColor,
        ),
      ),
    );
  }
}

// Basics 2-Column Responsive Layout
class _BasicsGrid extends StatelessWidget {
  final DiscoverProfile profile;

  const _BasicsGrid({required this.profile});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.work_outline_rounded,
        label: 'Profession',
        value: profile.profession ?? 'UI/UX Designer',
      ),
      (
        icon: Icons.straighten_rounded,
        label: 'Height',
        value: profile.height ?? '5\'6" (168 cm)',
      ),
      (
        icon: Icons.stars_rounded,
        label: 'Zodiac',
        value: profile.zodiac ?? 'Scorpio ♏',
      ),
      (
        icon: Icons.school_outlined,
        label: 'Education',
        value: profile.education ?? 'Master Degree',
      ),
      (
        icon: Icons.local_bar_outlined,
        label: 'Drinking',
        value: profile.drinking ?? 'Socially',
      ),
      (
        icon: Icons.smoke_free_outlined,
        label: 'Smoking',
        value: profile.smoking ?? 'Non-smoker',
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DiscoverBasicInfoCard(
                  icon: items[i].icon,
                  label: items[i].label,
                  value: items[i].value,
                ),
              ),
              if (i + 1 < items.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: DiscoverBasicInfoCard(
                    icon: items[i + 1].icon,
                    label: items[i + 1].label,
                    value: items[i + 1].value,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

// Verified Badge
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Color(0xFF26A69A),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
    );
  }
}

// Profile Image loader with placeholder/error handling
class _DetailProfileImage extends StatelessWidget {
  final String imageUrl;

  const _DetailProfileImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const _DetailPlaceholder(),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const _DetailPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) => const _DetailPlaceholder(),
    );
  }
}

class _DetailPlaceholder extends StatelessWidget {
  const _DetailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8D5DC),
      child: const Center(
        child: Icon(Icons.person_rounded, color: Color(0xFF8A0B3B), size: 64),
      ),
    );
  }
}
