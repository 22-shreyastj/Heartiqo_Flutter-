import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import '../repository/chat_repository.dart';
import '../service/chat_service.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_options.dart';
import '../widgets/mute_duration_modal.dart';
import '../widgets/typing_indicator.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String name;
  final String image;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.name,
    required this.image,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController controller;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final repository = ChatRepository();
    final service = ChatService(repository);
    controller = ChatController(service);
    controller.loadMessages(widget.chatId);
  }

  @override
  void dispose() {
    messageController.dispose();
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    controller.sendMessage(
      widget.chatId,
      messageController.text,
    );
    messageController.clear();
  }

  void _showMuteDurationPicker() {
    MuteDurationModal.show(
      context,
      onDurationSelected: (duration) {
        controller.muteChat(duration);
        final label = duration == 'Never' ? 'until unmuted' : 'for $duration';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifications muted $label'),
          ),
        );
      },
    );
  }

  void _handleOptionSelected(String value) {
    switch (value) {
      case 'mute':
        _showMuteDurationPicker();
        break;
      case 'unmute':
        controller.unmuteChat();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications unmuted')),
        );
        break;
      case 'clear':
        controller.clearChat(widget.chatId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat history cleared')),
        );
        break;
      case 'block':
        controller.blockUser(widget.chatId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} blocked')),
        );
        break;
      case 'unblock':
        controller.unblockUser(widget.chatId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} unblocked')),
        );
        break;
      case 'report':
        controller.service.reportUser(widget.chatId, 'Reported by user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} reported')),
        );
        break;
    }
  }

  Widget _buildBlockedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You have blocked ${widget.name}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.lock_open, size: 18, color: Color(0xFFD41470)),
            label: const Text(
              'Unblock User',
              style: TextStyle(
                color: Color(0xFFD41470),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD41470)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              controller.unblockUser(widget.chatId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.name} unblocked')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8FB),
          appBar: ChatAppBar(
            name: widget.name,
            image: widget.image,
            isOnline: controller.isOnline,
            isMuted: controller.muteNotifications,
            muteDuration: controller.muteDuration,
            isBlocked: controller.isBlocked,
            onCallTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.name}...')),
              );
            },
            onVideoTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting video call with ${widget.name}...')),
              );
            },
            onOptionSelected: _handleOptionSelected,
          ),
          body: Column(
            children: [
              if (controller.isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: Color(0xFFD41470),
                ),
              Expanded(
                child: controller.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Say hi to ${widget.name}!',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.messages[index];
                          return ChatBubble(
                            message: message,
                            onLongPress: () {
                              MessageOptionsModal.show(
                                context,
                                messageText: message.text,
                                onDelete: () {
                                  controller.deleteMessage(message.id);
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
              if (controller.isTyping && !controller.isBlocked)
                TypingIndicator(
                  name: widget.name,
                ),
              controller.isBlocked
                  ? _buildBlockedBanner()
                  : ChatInput(
                      controller: messageController,
                      onChanged: (text) {
                        controller.setTyping(text.isNotEmpty);
                      },
                      onSend: sendMessage,
                    ),
            ],
          ),
        );
      },
    );
  }
}