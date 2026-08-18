import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class PhotoUploadGrid extends StatelessWidget {
  final List<String> photos;
  final Function(int index)? onAddPhoto;
  final Function(int index)? onRemovePhoto;

  const PhotoUploadGrid({
    super.key,
    required this.photos,
    this.onAddPhoto,
    this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        // Grid layout: Main photo + 5 auxiliary photo slots
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left main photo container
            Expanded(
              flex: 3,
              child: _buildMainPhotoSlot(context, 0),
            ),
            const SizedBox(width: 12),
            // Right column for 2 secondary photo slots
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildSubPhotoSlot(context, 1),
                  const SizedBox(height: 12),
                  _buildSubPhotoSlot(context, 2),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bottom row for remaining 3 photo slots
        Row(
          children: [
            Expanded(child: _buildSubPhotoSlot(context, 3)),
            const SizedBox(width: 12),
            Expanded(child: _buildSubPhotoSlot(context, 4)),
            const SizedBox(width: 12),
            Expanded(child: _buildSubPhotoSlot(context, 5)),
          ],
        ),

        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Add at least 3 photos to boost your profile visibility.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainPhotoSlot(BuildContext context, int index) {
    final bool hasPhoto = index < photos.length && photos[index].isNotEmpty;
    final String photoPath = hasPhoto ? photos[index] : '';

    return AspectRatio(
      aspectRatio: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.softPinkSlot,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.brandPink.withValues(alpha: 0.15),
            width: 1.5,
          ),
          image: hasPhoto
              ? DecorationImage(
                  image: AssetImage(photoPath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                )
              : null,
        ),
        child: Stack(
          children: [
            if (!hasPhoto)
              Center(
                child: IconButton(
                  onPressed: () => onAddPhoto?.call(index),
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 36,
                    color: AppColors.brandPink,
                  ),
                ),
              ),

            if (hasPhoto)
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Main Photo',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPink,
                    ),
                  ),
                ),
              ),

            if (hasPhoto)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => onRemovePhoto?.call(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.brandPink,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubPhotoSlot(BuildContext context, int index) {
    final bool hasPhoto = index < photos.length && photos[index].isNotEmpty;
    final String photoPath = hasPhoto ? photos[index] : '';

    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: () {
          if (hasPhoto) {
            onRemovePhoto?.call(index);
          } else {
            onAddPhoto?.call(index);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.softPinkSlot,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.brandPink.withValues(alpha: 0.12),
              width: 1,
            ),
            image: hasPhoto
                ? DecorationImage(
                    image: AssetImage(photoPath),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  )
                : null,
          ),
          child: Center(
            child: Icon(
              hasPhoto ? Icons.close_rounded : Icons.add_rounded,
              size: 26,
              color: AppColors.brandPink,
            ),
          ),
        ),
      ),
    );
  }
}
