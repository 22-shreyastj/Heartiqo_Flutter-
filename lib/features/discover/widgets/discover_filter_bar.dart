import 'package:flutter/material.dart';

class DiscoverFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String>? onFilterSelected;

  const DiscoverFilterBar({
    super.key,
    this.selectedFilter = 'Filters',
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Primary Filters button
          _PrimaryFilterButton(
            label: 'Filters',
            icon: Icons.tune_rounded,
            isSelected: selectedFilter == 'Filters',
            onTap: () => onFilterSelected?.call('Filters'),
          ),
          const SizedBox(width: 10),

          // Distance filter button
          _SecondaryFilterButton(
            label: 'Distance',
            hasDropdown: true,
            isSelected: selectedFilter == 'Distance',
            onTap: () => onFilterSelected?.call('Distance'),
          ),
          const SizedBox(width: 10),

          // Interests filter button
          _SecondaryFilterButton(
            label: 'Interests',
            hasDropdown: false,
            isSelected: selectedFilter == 'Interests',
            onTap: () => onFilterSelected?.call('Interests'),
          ),
        ],
      ),
    );
  }
}

class _PrimaryFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrimaryFilterButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF9E1068),
              Color(0xFFC41C70),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9E1068).withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryFilterButton extends StatelessWidget {
  final String label;
  final bool hasDropdown;
  final bool isSelected;
  final VoidCallback onTap;

  const _SecondaryFilterButton({
    required this.label,
    required this.hasDropdown,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFF3D2DC),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8A0B3B),
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF8A0B3B),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
