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
              const Text(
                'Heartiqo',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepPink,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.darkPurple,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search_rounded, size: 26),
        ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onNotification,
              icon: const Icon(Icons.notifications_none_rounded, size: 26),
            ),
            Positioned(
              right: 7,
              top: 7,
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
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF3DDE4),
      ),
      child: ClipOval(
        child: avatarImage != null && avatarImage!.isNotEmpty
            ? Image.asset(
                avatarImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: AppColors.deepPink);
                },
              )
            : const Icon(Icons.person, color: AppColors.deepPink),
      ),
    );
  }
}
