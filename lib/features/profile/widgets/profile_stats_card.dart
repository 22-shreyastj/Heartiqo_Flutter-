import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class ProfileStatsCard extends StatelessWidget {
  final String likes;
  final String matches;
  final String profileViews;
  final VoidCallback? onLikesTap;
  final VoidCallback? onMatchesTap;
  final VoidCallback? onViewsTap;

  const ProfileStatsCard({
    super.key,
    required this.likes,
    required this.matches,
    required this.profileViews,
    this.onLikesTap,
    this.onMatchesTap,
    this.onViewsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            value: likes,
            label: 'Likes',
            valueColor: AppColors.brandPink,
            onTap: onLikesTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            value: matches,
            label: 'Matches',
            valueColor: AppColors.brandPink,
            onTap: onMatchesTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            value: profileViews,
            label: 'Profile\nViews',
            valueColor: AppColors.accentGreen,
            onTap: onViewsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color valueColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
