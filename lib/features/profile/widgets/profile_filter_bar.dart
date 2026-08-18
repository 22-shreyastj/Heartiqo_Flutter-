import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';


class ProfileFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const ProfileFilterBar({
    super.key,
    this.selectedIndex = 0,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _filterItem(
            icon: Icons.tune_rounded,
            iconOnly: true,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          _filterItem(
            label: 'Near Me',
            selected: selectedIndex == 0,
            onTap: () => onSelected?.call(0),
          ),
          const SizedBox(width: 8),
          _filterItem(
            label: 'New Users',
            selected: selectedIndex == 1,
            onTap: () => onSelected?.call(1),
          ),
          const SizedBox(width: 8),
          _filterItem(
            label: 'Verified',
            icon: Icons.verified_rounded,
            selected: selectedIndex == 2,
            onTap: () => onSelected?.call(2),
          ),
        ],
      ),
    );
  }

  Widget _filterItem({
    String? label,
    IconData? icon,
    bool selected = false,
    bool iconOnly = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 14 : 18,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(


                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),


                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.dark.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : AppColors.primary,
              ),
            if (icon != null && label != null) const SizedBox(width: 6),
            if (label != null)
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF4B5563),
                ),
              ),
          ],
        ),
      ),
    );
  }
}