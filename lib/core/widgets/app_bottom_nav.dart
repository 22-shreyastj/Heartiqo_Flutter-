import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onItemSelected;

  const AppBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            index: 0,
            icon: Icons.home_outlined,
            label: 'Home',
            selected: currentIndex == 0,
          ),
          _navItem(
            index: 1,
            icon: Icons.explore_outlined,
            label: 'Discover',
            selected: currentIndex == 1,
          ),
          _navItem(
            index: 2,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            selected: currentIndex == 2,
            notification: true,
          ),
          _navItem(
            index: 3,
            icon: Icons.notifications_none_rounded,
            label: 'Alerts',
            selected: currentIndex == 3,
          ),
          _navItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            selected: currentIndex == 4,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
    required bool selected,
    bool notification = false,
  }) {
    return GestureDetector(
      onTap: () => onItemSelected?.call(index),
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 48 : 38,
                  height: selected ? 38 : 30,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF6B7280),
                  ),
                ),
                if (notification)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.emotionalAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}