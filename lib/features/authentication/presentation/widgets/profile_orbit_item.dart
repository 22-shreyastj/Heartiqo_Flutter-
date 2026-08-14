import 'package:flutter/material.dart';

class ProfileOrbitItem extends StatelessWidget {
  final double size;
  final String? imageAsset;
  final IconData? icon;

  const ProfileOrbitItem({
    super.key,
    required this.size,
    this.imageAsset,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: imageAsset != null
              ? Image.asset(
                  imageAsset!,
                  width: size,
                  height: size,

                  fit: BoxFit.cover,

                  alignment: Alignment.center,

                  filterQuality: FilterQuality.high,

                  errorBuilder: (context, error, stackTrace) {
                    return _placeholder();
                  },
                )
              : _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9ACB), Color(0xFF9C5BC5)],
        ),
      ),
      child: Icon(icon ?? Icons.person, color: Colors.white, size: size * 0.42),
    );
  }
}
