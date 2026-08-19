import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class ProfileSettingsList extends StatelessWidget {
  final VoidCallback? onAccountTap;
  final VoidCallback? onDiscoverySettingsTap;
  final VoidCallback? onSafetyTap;
  final VoidCallback? onHelpTap;

  const ProfileSettingsList({
    super.key,
    this.onAccountTap,
    this.onDiscoverySettingsTap,
    this.onSafetyTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildItem(
            icon: Icons.person_outline_rounded,
            title: 'Account',
            onTap: onAccountTap,
            isFirst: true,
          ),
          const Divider(height: 1, indent: 64, endIndent: 16, color: AppColors.borderLight),
          _buildItem(
            icon: Icons.tune_rounded,
            title: 'Discovery Settings',
            onTap: onDiscoverySettingsTap,
          ),
          const Divider(height: 1, indent: 64, endIndent: 16, color: AppColors.borderLight),
          _buildItem(
            icon: Icons.shield_outlined,
            title: 'Safety',
            onTap: onSafetyTap,
          ),
          const Divider(height: 1, indent: 64, endIndent: 16, color: AppColors.borderLight),
          _buildItem(
            icon: Icons.help_outline_rounded,
            title: 'Help',
            onTap: onHelpTap,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.softPinkSlot,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.brandPink,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
