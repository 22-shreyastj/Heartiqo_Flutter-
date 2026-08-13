import 'package:flutter/material.dart';
import '../model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * .75,
          ),
          margin: const EdgeInsets.only(
            bottom: 8,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 11,
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
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isMine
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}