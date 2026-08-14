import 'package:flutter/material.dart';
import '../model/discover_profile.dart';

class DiscoverProfileCard extends StatelessWidget {
  final DiscoverProfile profile;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const DiscoverProfileCard({
    super.key,
    required this.profile,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: _ProfileImage(imageUrl: profile.imageUrl),
            ),

            // Bottom Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.35, 0.65, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            // Top-Right Favorite Button
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onFavoriteTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      profile.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: const Color(0xFFC2185B),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Info Overlay
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name, Age & Verified Badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profile.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 4),
                        const _VerifiedBadge(),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Distance
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          profile.distance,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Interest Tags
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: profile.interests.map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.38),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Color(0xFF26A69A),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 11,
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String imageUrl;

  const _ProfileImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const _ImagePlaceholder();
      },
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8D5DC),
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          color: Color(0xFF8A0B3B),
          size: 40,
        ),
      ),
    );
  }
}
