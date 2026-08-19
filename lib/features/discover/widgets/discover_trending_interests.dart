import 'package:flutter/material.dart';
import '../model/discover_search_models.dart';

class DiscoverTrendingInterests extends StatelessWidget {
  final List<TrendingInterestItem> items;
  final ValueChanged<TrendingInterestItem>? onItemTap;

  const DiscoverTrendingInterests({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Trending Interests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1B1E),
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Wrap layout for chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            children: items.map((item) {
              return _InterestChip(
                item: item,
                onTap: () => onItemTap?.call(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  final TrendingInterestItem item;
  final VoidCallback? onTap;

  const _InterestChip({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFFDEEF2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 18, color: const Color(0xFF2E0F1A)),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E0F1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
