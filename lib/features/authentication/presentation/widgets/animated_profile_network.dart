import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import 'profile_orbit_item.dart';

class AnimatedProfileNetwork extends StatefulWidget {
  final double maxSize;
  final String? centerImageAsset;

  const AnimatedProfileNetwork({
    super.key,
    required this.maxSize,
    this.centerImageAsset,
  });

  @override
  State<AnimatedProfileNetwork> createState() => _AnimatedProfileNetworkState();
}

class _AnimatedProfileNetworkState extends State<AnimatedProfileNetwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // ============================================================
  // PROFILE CONFIGURATION
  // ============================================================

  static const List<_OrbitProfile> _profiles = [
    _OrbitProfile(
      angle: -2.55,
      size: 0.19,
      movement: 0.024,
      verticalMovement: 4.5,
      phase: 0.0,
      imageAsset: 'assets/images/profiles/image1.jpg',
    ),

    _OrbitProfile(
      angle: -1.72,
      size: 0.14,
      movement: 0.032,
      verticalMovement: 4.0,
      phase: 1.2,
      imageAsset: 'assets/images/profiles/image2.avif',
    ),

    _OrbitProfile(
      angle: -0.42,
      size: 0.17,
      movement: 0.026,
      verticalMovement: 4.5,
      phase: 2.1,
      imageAsset: 'assets/images/profiles/image3.avif',
    ),

    _OrbitProfile(
      angle: 0.45,
      size: 0.115,
      movement: 0.032,
      verticalMovement: 3.5,
      phase: 3.0,
      imageAsset: 'assets/images/profiles/image4.webp',
    ),

    _OrbitProfile(
      angle: 1.35,
      size: 0.135,
      movement: 0.028,
      verticalMovement: 4.0,
      phase: 4.0,
      imageAsset: 'assets/images/profiles/image1.jpg',
    ),

    _OrbitProfile(
      angle: 2.55,
      size: 0.16,
      movement: 0.024,
      verticalMovement: 4.5,
      phase: 5.0,
      imageAsset: 'assets/images/profiles/image1.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // Faster continuous animation.
    //
    // Previously: 7 seconds
    // Now: 4 seconds
    //
    // Profiles still move only slightly around their positions.
    // ------------------------------------------------------------

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.maxSize;

    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Main orbit
                _buildMainOrbit(size),

                // Subtle inner orbit
                _buildInnerOrbit(size),

                // Small floating icons
                ..._buildFloatingIcons(size),

                // Profile nodes
                ..._buildProfiles(size),

                // Center profile
                _buildCenterProfile(size),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // MAIN ORBIT
  // ============================================================

  Widget _buildMainOrbit(double size) {
    return Container(
      width: size * 0.86,
      height: size * 0.86,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.magenta.withValues(alpha: 0.17),
          width: 4,
        ),
      ),
    );
  }

  // ============================================================
  // INNER ORBIT
  // ============================================================

  Widget _buildInnerOrbit(double size) {
    return Container(
      width: size * 0.60,
      height: size * 0.60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.magenta.withValues(alpha: 0.055),
          width: 2,
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE ANIMATION
  // ============================================================

  List<Widget> _buildProfiles(double size) {
    final orbitRadius = size * 0.425;

    return _profiles.map((profile) {
      // Continuous animation.
      final t = (_controller.value * math.pi * 2) + profile.phase;

      // ==========================================================
      // ENTRANCE ANIMATION
      // ==========================================================

      //
      // First ~25% of the controller:
      //
      // profile starts closer to center
      //        ↓
      // moves toward orbit
      //        ↓
      // settles
      //
      final entranceProgress = Curves.easeOutBack.transform(
        (_controller.value / 0.25).clamp(0.0, 1.0),
      );

      // Start closer to center and move outward.
      final startRadius = orbitRadius * 0.55;

      final currentRadius =
          startRadius + ((orbitRadius - startRadius) * entranceProgress);

      // ==========================================================
      // SMALL CONTINUOUS MOVEMENT
      // ==========================================================

      final angle = profile.angle + math.sin(t) * profile.movement;

      final radialMovement = math.sin(t * 0.9) * 1.8;

      final radius = currentRadius + radialMovement;

      final x = math.cos(angle) * radius;

      final y = math.sin(angle) * radius;

      final profileSize = size * profile.size;

      // ==========================================================
      // FLOATING MOVEMENT
      // ==========================================================

      final floatingY = math.sin(t * 1.2) * profile.verticalMovement;

      final left = (size / 2) + x - (profileSize / 2);

      final top = (size / 2) + y - (profileSize / 2) + floatingY;

      // ==========================================================
      // ENTRANCE SCALE
      // ==========================================================

      final entranceScale = Tween<double>(begin: 0.55, end: 1.0).transform(
        Curves.easeOutBack.transform(
          (_controller.value / 0.25).clamp(0.0, 1.0),
        ),
      );

      // Small continuous breathing.
      final breathingScale = 1.0 + math.sin(t * 1.15) * 0.018;

      final finalScale = entranceScale * breathingScale;

      // ==========================================================
      // ENTRANCE FADE
      // ==========================================================

      final opacity = Curves.easeOut.transform(
        (_controller.value / 0.18).clamp(0.0, 1.0),
      );

      return Positioned(
        left: left,
        top: top,
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: finalScale,
            child: ProfileOrbitItem(
              size: profileSize,
              imageAsset: profile.imageAsset,
            ),
          ),
        ),
      );
    }).toList();
  }

  // ============================================================
  // FLOATING ICONS
  // ============================================================

  List<Widget> _buildFloatingIcons(double size) {
    final icons = [
      _FloatingIcon(
        angle: -2.05,
        radius: 0.435,
        phase: 0.0,
        icon: Icons.more_horiz,
      ),
      _FloatingIcon(
        angle: -0.95,
        radius: 0.435,
        phase: 1.5,
        icon: Icons.location_on_outlined,
      ),
      _FloatingIcon(
        angle: 0.75,
        radius: 0.435,
        phase: 2.5,
        icon: Icons.favorite_outline,
      ),
      _FloatingIcon(
        angle: 2.05,
        radius: 0.435,
        phase: 3.5,
        icon: Icons.more_horiz,
      ),
    ];

    return icons.map((item) {
      final t = (_controller.value * math.pi * 2) + item.phase;

      final angle = item.angle + math.sin(t) * 0.025;

      final radius = size * item.radius;

      final x = math.cos(angle) * radius;

      final y = math.sin(angle) * radius;

      final iconSize = size * 0.065;

      return Positioned(
        left: (size / 2) + x - iconSize / 2,
        top: (size / 2) + y - iconSize / 2,
        child: Transform.translate(
          offset: Offset(0, math.sin(t * 1.3) * 3),
          child: _SmallOrbitIcon(size: iconSize, icon: item.icon),
        ),
      );
    }).toList();
  }

  // ============================================================
  // CENTER PROFILE
  // ============================================================

  Widget _buildCenterProfile(double size) {
    final outerSize = size * 0.32;

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3B3940),
        border: Border.all(color: Colors.white.withValues(alpha: 0.70), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.018),
      child: ClipOval(
        child: widget.centerImageAsset != null
            ? Image.asset(
                widget.centerImageAsset!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _centerPlaceholder(size);
                },
              )
            : _centerPlaceholder(size),
      ),
    );
  }

  Widget _centerPlaceholder(double size) {
    return Container(
      color: const Color(0xFF777777),
      child: Icon(Icons.person, size: size * 0.10, color: Colors.white),
    );
  }
}

// ================================================================
// PROFILE CONFIGURATION
// ================================================================

class _OrbitProfile {
  final double angle;
  final double size;
  final double movement;
  final double verticalMovement;
  final double phase;
  final String imageAsset;

  const _OrbitProfile({
    required this.angle,
    required this.size,
    required this.movement,
    required this.verticalMovement,
    required this.phase,
    required this.imageAsset,
  });
}

// ================================================================
// FLOATING ICON CONFIGURATION
// ================================================================

class _FloatingIcon {
  final double angle;
  final double radius;
  final double phase;
  final IconData icon;

  const _FloatingIcon({
    required this.angle,
    required this.radius,
    required this.phase,
    required this.icon,
  });
}

// ================================================================
// FLOATING ICON
// ================================================================

class _SmallOrbitIcon extends StatelessWidget {
  final double size;
  final IconData icon;

  const _SmallOrbitIcon({required this.size, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.30),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size * 0.55,
        color: AppColors.magenta.withValues(alpha: 0.70),
      ),
    );
  }
}
