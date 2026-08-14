import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String? avatarImage;
  final String location;
  final VoidCallback? onSearch;
  final VoidCallback? onNotification;

  const AppHeader({
    super.key,
    this.avatarImage,
    this.location = 'Hyderabad',
    this.onSearch,
    this.onNotification,
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

        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onNotification,
              icon: const Icon(Icons.notifications_none_rounded, size: 25, color: AppColors.dark),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.emotionalAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
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
