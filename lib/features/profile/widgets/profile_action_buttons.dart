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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Cancel / Reject Button (X) - Left
        _cancelButton(),

        const SizedBox(width: 24),

        // 2. Like Button (❤️) - Center / Right
        _likeButton(),
      ],
    );
  }

  /// White circular Cancel (X) button with subtle border & shadow (62px diameter)
  Widget _cancelButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onReject,
        customBorder: const CircleBorder(),
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.close_rounded,
              size: 32,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
    );
  }

  /// Pink/Coral circular Like (❤️) button (62px diameter)
  Widget _likeButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onLike,
        customBorder: const CircleBorder(),
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.emotionalAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.emotionalAccent.withValues(alpha: 0.38),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.favorite_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}