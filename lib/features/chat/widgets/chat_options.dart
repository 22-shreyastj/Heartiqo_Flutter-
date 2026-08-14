import 'package:flutter/material.dart';

class ChatOptionsModal extends StatelessWidget {
  final bool isMuted;
  final String? muteDuration;
  final bool isBlocked;
  final VoidCallback? onClearChat;
  final VoidCallback? onToggleMute;
  final VoidCallback? onUnmute;
  final VoidCallback? onBlock;
  final VoidCallback? onUnblock;
  final VoidCallback? onReport;

  const ChatOptionsModal({
    super.key,
    this.isMuted = false,
    this.muteDuration,
    this.isBlocked = false,
    this.onClearChat,
    this.onToggleMute,
    this.onUnmute,
    this.onBlock,
    this.onUnblock,
    this.onReport,
  });

  static void show(
    BuildContext context, {
    bool isMuted = false,
    String? muteDuration,
    bool isBlocked = false,
    VoidCallback? onClearChat,
    VoidCallback? onToggleMute,
    VoidCallback? onUnmute,
    VoidCallback? onBlock,
    VoidCallback? onUnblock,
    VoidCallback? onReport,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChatOptionsModal(
        isMuted: isMuted,
        muteDuration: muteDuration,
        isBlocked: isBlocked,
        onClearChat: onClearChat,
        onToggleMute: onToggleMute,
        onUnmute: onUnmute,
        onBlock: onBlock,
        onUnblock: onUnblock,
        onReport: onReport,
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
            if (isMuted)
              ListTile(
                leading: const Icon(Icons.volume_up_outlined, color: Colors.black87),
                title: const Text('Unmute notifications'),
                subtitle: muteDuration != null
                    ? Text('Muted for $muteDuration', style: TextStyle(color: Colors.grey.shade600, fontSize: 12))
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onUnmute?.call();
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.volume_off_outlined, color: Colors.black87),
                title: const Text('Mute notifications'),
                onTap: () {
                  Navigator.pop(context);
                  onToggleMute?.call();
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.black87),
              title: const Text('Clear chat history'),
              onTap: () {
                Navigator.pop(context);
                onClearChat?.call();
              },
            ),
            if (isBlocked)
              ListTile(
                leading: const Icon(Icons.lock_open, color: Color(0xFFD41470)),
                title: const Text('Unblock user', style: TextStyle(color: Color(0xFFD41470), fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  onUnblock?.call();
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.block, color: Colors.redAccent),
                title: const Text('Block user', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  onBlock?.call();
                },
              ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
              title: const Text('Report user', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                onReport?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
