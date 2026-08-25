import 'package:flutter/material.dart';
import '../model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectedChanged;

  const ChatBubble({
    super.key,
    required this.message,
    this.onLongPress,
    this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectedChanged,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeleted = message.isDeleted ||
        message.text.contains('deleted this message') ||
        message.text.contains('message was deleted');
    final String displayText = isDeleted
        ? (message.isMine ? 'You deleted this message' : 'This message was deleted')
        : message.text;

    Widget bubbleWidget;

    if (isDeleted) {
      bubbleWidget = Align(
        alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isSelectionMode
              ? () => onSelectedChanged?.call(!isSelected)
              : (onTap ?? onLongPress),
          onLongPress: isSelectionMode ? null : onLongPress,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .75,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(message.isMine ? 16 : 4),
                bottomRight: Radius.circular(message.isMine ? 4 : 16),
              ),
              border: Border.all(color: Colors.grey.shade300, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.block_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        displayText,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      bubbleWidget = Align(
        alignment: message.isMine
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: GestureDetector(
          onTap: isSelectionMode ? () => onSelectedChanged?.call(!isSelected) : onTap,
          onLongPress: isSelectionMode ? null : onLongPress,
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width * .75,
            ),
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: message.isMine
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFD41470),
                        Color(0xFFB50068),
                      ],
                    )
                  : null,
              color: message.isMine
                  ? null
                  : const Color(0xFFFFDDEB),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(
                  message.isMine ? 16 : 4,
                ),
                bottomRight: Radius.circular(
                  message.isMine ? 4 : 16,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: message.isMine
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(message.time),
                      style: TextStyle(
                        color: message.isMine
                            ? Colors.white.withValues(alpha: 0.75)
                            : Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                    if (message.isMine) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.done_all_rounded,
                        size: 13,
                        color: message.isRead
                            ? Colors.cyanAccent
                            : Colors.white.withValues(alpha: 0.75),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isSelectionMode) {
      return InkWell(
        onTap: () => onSelectedChanged?.call(!isSelected),
        child: Container(
          color: isSelected
              ? const Color(0xFFD41470).withValues(alpha: 0.08)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                activeColor: const Color(0xFFD41470),
                shape: const CircleBorder(),
                onChanged: onSelectedChanged,
              ),
              Expanded(child: bubbleWidget),
            ],
          ),
        ),
      );
    }

    return bubbleWidget;
  }
}