import 'package:flutter/material.dart';

class AlertModel {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  AlertModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.isUnread,
  });
}