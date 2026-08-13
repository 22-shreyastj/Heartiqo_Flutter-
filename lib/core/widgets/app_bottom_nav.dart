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
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            label: 'Home',
            selected: currentIndex == 0,
          ),

          _buildNavItem(
            index: 1,
            icon: Icons.explore_outlined,
            label: 'Discover',
            selected: currentIndex == 1,
          ),

          _buildNavItem(
            index: 2,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            selected: currentIndex == 2,
            notification: true,
          ),

          _buildNavItem(
            index: 3,
            icon: Icons.notifications_none_rounded,
            label: 'Alerts',
            selected: currentIndex == 3,
          ),

          _buildNavItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            selected: currentIndex == 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
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
                        ? AppColors.deepPink
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                    color: selected
                        ? Colors.white
                        : AppColors.darkPurple,
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
                        color: AppColors.deepPink,
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
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? AppColors.deepPink
                    : AppColors.darkPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}