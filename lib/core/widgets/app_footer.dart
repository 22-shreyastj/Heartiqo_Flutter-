import 'package:flutter/material.dart';

import '../../app/app_colors.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _FooterButton(
            icon: Icons.home_rounded,
            label: 'Home',
            active: true,
            onTap: () {},
          ),
          _FooterButton(
            icon: Icons.compass_calibration_rounded,
            label: 'Discover',
            onTap: () {},
          ),
          _FooterButton(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            onTap: () {},
          ),
          _FooterButton(
            icon: Icons.notifications_none,
            label: 'Alerts',
            onTap: () {},
          ),
          _FooterButton(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: active ? AppColors.deepPink : Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? AppColors.deepPink : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
