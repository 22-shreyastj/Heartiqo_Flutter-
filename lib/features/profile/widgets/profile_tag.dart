import 'package:flutter/material.dart';

class ProfileTag extends StatelessWidget {
  final String label;
  final int index;

  const ProfileTag({
    super.key,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (index % 4) {
      case 0:
        return Icons.flight_takeoff_rounded;
      case 1:
        return Icons.music_note_rounded;
      case 2:
        return Icons.camera_alt_outlined;
      case 3:
        return Icons.coffee_rounded;
      default:
        return Icons.favorite_border_rounded;
    }
  }
}