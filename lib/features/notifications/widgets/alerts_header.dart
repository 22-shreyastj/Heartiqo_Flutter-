import 'package:flutter/material.dart';

class AlertsHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const AlertsHeader({super.key, this.onNotificationTap, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFEBF0),
                child: Icon(Icons.person, color: Color(0xFFFF3B70)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Heartiqo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF3B70),
                    ),
                  ),
                  Text(
                    'Hyderabad',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black87),
                onPressed: onSearchTap,
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF3B70)),
                    onPressed: onNotificationTap,
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}