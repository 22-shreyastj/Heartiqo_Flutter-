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
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.55),
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
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (index) {
      case 0:
        return Icons.flight_takeoff_rounded;
      case 1:
        return Icons.music_note_rounded;
      case 2:
        return Icons.camera_alt_outlined;
      default:
        return Icons.favorite_border_rounded;
    }
  }
}