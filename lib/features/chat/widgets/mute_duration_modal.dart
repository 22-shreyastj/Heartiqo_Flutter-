import 'package:flutter/material.dart';

class MuteDurationModal extends StatelessWidget {
  final ValueChanged<String> onDurationSelected;

  const MuteDurationModal({
    super.key,
    required this.onDurationSelected,
  });

  static void show(
    BuildContext context, {
    required ValueChanged<String> onDurationSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MuteDurationModal(
        onDurationSelected: onDurationSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      {'label': '30 Minutes', 'value': '30 min', 'icon': Icons.timer_outlined},
      {'label': '1 Hour', 'value': '1 hour', 'icon': Icons.access_time},
      {'label': '1 Week', 'value': '1 week', 'icon': Icons.date_range_outlined},
      {'label': 'Always (Never notify)', 'value': 'Never', 'icon': Icons.notifications_off_outlined},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Mute Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Choose how long you want to mute notifications for this chat',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              return ListTile(
                leading: Icon(
                  opt['icon'] as IconData,
                  color: const Color(0xFFD41470),
                ),
                title: Text(
                  opt['label'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDurationSelected(opt['value'] as String);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
