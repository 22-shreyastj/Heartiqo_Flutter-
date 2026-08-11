import 'package:flutter/material.dart';

class ProfileOrbitItemData {
  final String? imageAsset;
  final double radius; // relative radius (0.0 - 1.0)
  final double initialAngle; // radians
  final double size; // relative to network size
  final double speed; // rotations per full controller cycle
  final IconData? icon;

  const ProfileOrbitItemData({
    this.imageAsset,
    required this.radius,
    required this.initialAngle,
    required this.size,
    required this.speed,
    this.icon,
  });
}
