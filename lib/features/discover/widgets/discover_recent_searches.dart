import 'package:flutter/material.dart';
import '../model/discover_search_models.dart';

class DiscoverRecentSearches extends StatelessWidget {
  final List<RecentSearchItem> items;
  final VoidCallback? onClear;
  final ValueChanged<RecentSearchItem>? onItemTap;

  const DiscoverRecentSearches({
    super.key,
    required this.items,
    this.onClear,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1B1E),
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9E1068),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Avatars List
        SizedBox(
          height: 98,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _RecentSearchTile(
                item: item,
                onTap: () => onItemTap?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  final RecentSearchItem item;
  final VoidCallback? onTap;

  const _RecentSearchTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle Avatar Container
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3DDE4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _AvatarFallbackIcon(),
                    )
                  : const _AvatarFallbackIcon(isInterest: true),
            ),
          ),
          const SizedBox(height: 8),

          // Name and Age Label
          SizedBox(
            width: 72,
            child: Text(
              item.displayName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E0F1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallbackIcon extends StatelessWidget {
  final bool isInterest;

  const _AvatarFallbackIcon({this.isInterest = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDEEF2),
      child: Icon(
        isInterest ? Icons.tag_rounded : Icons.person_rounded,
        color: const Color(0xFF8A0B3B),
        size: 28,
      ),
    );
  }
}
