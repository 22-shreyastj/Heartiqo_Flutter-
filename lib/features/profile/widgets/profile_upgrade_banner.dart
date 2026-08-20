import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class ProfileUpgradeBanner extends StatelessWidget {
  final VoidCallback? onUpgradeTap;
  final String currentPlan;
  final bool isPremium;

  const ProfileUpgradeBanner({
    super.key,
    this.onUpgradeTap,
    this.currentPlan = 'Free',
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = isPremium
        ? 'Active Plan: $currentPlan'
        : 'Upgrade to Premium';
    final subtitle = isPremium
        ? 'Enjoying unlimited likes, rewinds & extra perks!'
        : 'See who likes you & get unlimited rewinds!';
    final buttonText = isPremium ? 'Manage Subscription' : 'Upgrade Now';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFFFFF0F5) : AppColors.softPinkSlot,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.brandPink.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.brandPink.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPremium ? Icons.workspace_premium_rounded : Icons.star_rounded,
                  color: AppColors.brandPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onUpgradeTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: isPremium ? AppColors.brandPink : Colors.white,
                foregroundColor: isPremium ? Colors.white : AppColors.brandPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    color: AppColors.brandPink.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isPremium ? Colors.white : AppColors.brandPink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
