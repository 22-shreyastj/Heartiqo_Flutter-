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
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterItem(
            icon: Icons.tune_rounded,
            iconOnly: true,
            onTap: () {},
          ),

          const SizedBox(width: 10),

          _FilterItem(
            label: 'Near Me',
            selected: selectedIndex == 0,
            onTap: () => onSelected?.call(0),
          ),

          const SizedBox(width: 8),

          _FilterItem(
            label: 'New Users',
            selected: selectedIndex == 1,
            onTap: () => onSelected?.call(1),
          ),

          const SizedBox(width: 8),

          _FilterItem(
            label: 'Verified',
            icon: Icons.verified_rounded,
            selected: selectedIndex == 2,
            onTap: () => onSelected?.call(2),
          ),
        ],
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool selected;
  final bool iconOnly;
  final VoidCallback? onTap;

  const _FilterItem({
    this.label,
    this.icon,
    this.selected = false,
    this.iconOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 14 : 18,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.deepPink
              : const Color(0xFFF9E5E9),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: selected
                ? AppColors.deepPink
                : const Color(0xFFE7C9D1),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.deepPink.withValues(alpha: .15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.white
                    : AppColors.deepPink,
              ),

            if (icon != null && label != null)
              const SizedBox(width: 5),

            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : AppColors.darkPurple,
                ),
              ),
          ],
        ),
      ),
    );
  }
}