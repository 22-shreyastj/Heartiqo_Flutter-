import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../features/profile/model/profile_model.dart';
import '../../features/profile/service/liked_profiles_service.dart';

class AppHeader extends StatelessWidget {
  final String? avatarImage;
  final String location;
  final VoidCallback? onSearch;
  final VoidCallback? onNotification;
  final VoidCallback? onLikes;

  const AppHeader({
    super.key,
    this.avatarImage,
    this.location = 'Hyderabad',
    this.onSearch,
    this.onNotification,
    this.onLikes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                    child: const Text(
                      'Heartiqo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.secondaryAccent,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search_rounded, size: 25, color: AppColors.dark),
        ),

        ValueListenableBuilder<List<ProfileModel>>(
          valueListenable: LikedProfilesService.instance,
          builder: (context, likedList, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: onLikes ?? onNotification,
                  icon: const Icon(
                    Icons.favorite_rounded,
                    size: 23,
                    color: AppColors.emotionalAccent,
                  ),
                ),
                if (likedList.isNotEmpty)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${likedList.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatarImage != null && avatarImage!.isNotEmpty
            ? Image.asset(
                avatarImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: AppColors.primary);
                },
              )
            : const Icon(Icons.person, color: AppColors.primary),
      ),
    );
  }
}
