import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback? onReject;
  final VoidCallback? onLike;
  final VoidCallback? onDiscover;

  const ProfileActionButtons({
    super.key,
    this.onReject,
    this.onLike,
    this.onDiscover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleButton(
          icon: Icons.close_rounded,
          onTap: onReject,
        ),

        const SizedBox(width: 12),

        _circleButton(
          icon: Icons.favorite_border_rounded,
          backgroundColor: AppColors.deepPink,
          iconColor: Colors.white,
          onTap: onLike,
        ),

        const SizedBox(width: 0),

        _discoverButton(),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color backgroundColor = Colors.white,
    Color iconColor = const Color(0xFF75666C),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE7D5DA),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 29,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _discoverButton() {
    return GestureDetector(
      onTap: onDiscover,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE50063),
              Color(0xFF9C0FC8),
            ],
          ),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(30),
            left: Radius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 22,
              color: Colors.white,
            ),

            SizedBox(width: 7),

            Text(
              'DISCOVER',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: .3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}