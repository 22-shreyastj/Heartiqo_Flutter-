import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback? onReject;
  final VoidCallback? onLike;
  final VoidCallback? onDiscover;

  const ProfileActionButtons({
    super.key,
    this.onReject,
    this.onLike,
    this.onDiscover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleButton(
          icon: Icons.close_rounded,
          onTap: onReject,
        ),

        const SizedBox(width: 14),

        _circleButton(
          icon: Icons.favorite_rounded,
          backgroundColor: AppColors.emotionalAccent,
          iconColor: Colors.white,
          onTap: onLike,
        ),

        const SizedBox(width: 14),

        _discoverButton(),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color backgroundColor = Colors.white,
    Color iconColor = const Color(0xFF6B7280),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(

              color: AppColors.dark.withValues(alpha: 0.08),
              blurRadius: 12,

              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 28,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _discoverButton() {
    return GestureDetector(
      onTap: onDiscover,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 22,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'DISCOVER',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: .5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}