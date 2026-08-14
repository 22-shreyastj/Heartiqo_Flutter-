import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageOptionsModal extends StatelessWidget {
  final String messageText;
  final VoidCallback? onDelete;

  const MessageOptionsModal({
    super.key,
    required this.messageText,
    this.onDelete,
  });

  static void show(
    BuildContext context, {
    required String messageText,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MessageOptionsModal(
        messageText: messageText,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.black87),
              title: const Text('Copy message'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: messageText));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text('Delete message', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
