import 'package:flutter/material.dart';
import 'online_indicator.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String image;
  final bool isOnline;
  final bool isMuted;
  final String? muteDuration;
  final bool isBlocked;
  final VoidCallback? onCallTap;
  final VoidCallback? onVideoTap;
  final PopupMenuItemSelected<String>? onOptionSelected;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.image,
    required this.isOnline,
    this.isMuted = false,
    this.muteDuration,
    this.isBlocked = false,
    this.onCallTap,
    this.onVideoTap,
    this.onOptionSelected,
  });

  Widget _buildAvatar() {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFFFFDDEB),
        backgroundImage: NetworkImage(image),
        onBackgroundImageError: (exception, stackTrace) {},
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Color(0xFFD41470),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFFFFDDEB),
      child: ClipOval(
        child: Image.asset(
          image,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Color(0xFFD41470),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              _buildAvatar(),
              Positioned(
                right: 0,
                bottom: 0,
                child: OnlineIndicator(isOnline: isOnline),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isMuted) ...[
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.volume_off,
                        size: 15,
                        color: Colors.grey,
                      ),
                    ],
                  ],
                ),
                Text(
                  isBlocked
                      ? 'Blocked'
                      : isMuted
                          ? (muteDuration != null ? 'Muted ($muteDuration)' : 'Muted')
                          : (isOnline ? 'Active now' : 'Offline'),
                  style: TextStyle(
                    fontSize: 11,
                    color: isBlocked
                        ? Colors.redAccent
                        : (isOnline && !isMuted ? Colors.green : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call_outlined, color: Color(0xFFD41470)),
          onPressed: onCallTap,
        ),
        IconButton(
          icon: const Icon(Icons.videocam_outlined, color: Color(0xFFD41470)),
          onPressed: onVideoTap,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          onSelected: onOptionSelected,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: isMuted ? 'unmute' : 'mute',
              child: Row(
                children: [
                  Icon(
                    isMuted ? Icons.volume_up_outlined : Icons.notifications_off_outlined,
                    size: 20,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(isMuted ? 'Unmute notifications' : 'Mute notifications'),
                  ),
                  const Icon(Icons.arrow_right, size: 20, color: Colors.black54),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'send_call_link',
              child: Row(
                children: [
                  Icon(Icons.link, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('Send call link'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'schedule_call',
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('Schedule call'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'new_group_call',
              child: Row(
                children: [
                  Icon(Icons.person_add_alt_outlined, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('New group call'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.thumb_down_outlined, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('Report'),
                ],
              ),
            ),
            PopupMenuItem(
              value: isBlocked ? 'unblock' : 'block',
              child: Row(
                children: [
                  Icon(
                    isBlocked ? Icons.lock_open : Icons.block,
                    size: 20,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  Text(isBlocked ? 'Unblock' : 'Block'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.remove_circle_outline, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('Clear chat'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete_chat',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.black87),
                  SizedBox(width: 12),
                  Text('Delete chat'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
