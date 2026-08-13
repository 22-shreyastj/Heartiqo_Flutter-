import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../features/chat/view/chat_list_page.dart';

class ProfileFooter extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onAlertsTap;
  final VoidCallback? onProfileTap;

  const ProfileFooter({
    super.key,
    this.selectedIndex = 0,
    this.onHomeTap,
    this.onDiscoverTap,
    this.onMessagesTap,
    this.onAlertsTap,
    this.onProfileTap,
  });

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
            active: selectedIndex == 0,
            onTap: () {
              onHomeTap?.call();
            },
          ),
          _FooterButton(
            icon: Icons.compass_calibration_rounded,
            label: 'Discover',
            active: selectedIndex == 1,
            onTap: () {
              onDiscoverTap?.call();
            },
          ),
          _FooterButton(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            active: selectedIndex == 2,
            onTap: () {
              onMessagesTap?.call();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatListPage(),
                ),
              );
            },
          ),
          _FooterButton(
            icon: Icons.notifications_none,
            label: 'Alerts',
            active: selectedIndex == 3,
            onTap: () {
              onAlertsTap?.call();
            },
          ),
          _FooterButton(
            icon: Icons.person_outline,
            label: 'Profile',
            active: selectedIndex == 4,
            onTap: () {
              onProfileTap?.call();
            },
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
