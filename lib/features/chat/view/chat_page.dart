import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import '../repository/chat_repository.dart';
import '../service/chat_service.dart';
import '../widgets/chat_app_bar.dart';
import 'call_screen.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_options.dart';
import '../widgets/mute_duration_modal.dart';
import '../widgets/typing_indicator.dart';

import '../widgets/user_profile_modal.dart';

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

  void _showMultiDeleteConfirmationDialog() {
    final count = controller.selectedMessageIds.length;
    if (count == 0) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                Text(
                  'Delete $count ${count == 1 ? "message" : "messages"}?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete the selected messages?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 20),
                    label: Text(
                      'Delete $count ${count == 1 ? "message" : "messages"}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD41470),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      controller.deleteSelectedMessages(forEveryone: false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$count ${count == 1 ? "message" : "messages"} deleted'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleOptionSelected(String value) {
    switch (value) {
      case 'select_messages':
        controller.startSelectionMode();
        break;
      case 'mute':
        _showMuteDurationPicker();
        break;
      case 'unmute':
        controller.unmuteChat();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications unmuted')),
        );
        break;
      case 'disappearing_messages':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disappearing messages: Off')),
        );
        break;
      case 'add_to_favourites':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} added to favourites')),
        );
        break;
      case 'close_chat':
        Navigator.of(context).pop();
        break;
      case 'report':
        controller.service.reportUser(widget.chatId, 'Reported by user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} reported')),
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
      case 'clear':
        controller.clearChat(widget.chatId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat history cleared')),
        );
        break;
      case 'delete_chat':
        controller.clearChat(widget.chatId);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat with ${widget.name} deleted')),
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
            isSelectionMode: controller.isSelectionMode,
            selectedCount: controller.selectedMessageIds.length,
            onClearSelection: controller.clearSelection,
            onDeleteSelected: _showMultiDeleteConfirmationDialog,
            onTitleTap: () {
              UserProfileModal.show(
                context,
                name: widget.name,
                image: widget.image,
                isOnline: controller.isOnline,
                isBlocked: controller.isBlocked,
                onCallTap: () {
                  controller.sendMessage(widget.chatId, '📞 Voice Call');
                  CallScreen.startCall(
                    context,
                    name: widget.name,
                    image: widget.image,
                    isVideo: false,
                  );
                },
                onVideoTap: () {
                  controller.sendMessage(widget.chatId, '📹 Video Call');
                  CallScreen.startCall(
                    context,
                    name: widget.name,
                    image: widget.image,
                    isVideo: true,
                  );
                },
                onToggleBlock: () {
                  controller.toggleBlockUser(widget.chatId);
                },
              );
            },
            onCallTap: () {
              controller.sendMessage(widget.chatId, '📞 Voice Call');
              CallScreen.startCall(
                context,
                name: widget.name,
                image: widget.image,
                isVideo: false,
              );
            },
            onVideoTap: () {
              controller.sendMessage(widget.chatId, '📹 Video Call');
              CallScreen.startCall(
                context,
                name: widget.name,
                image: widget.image,
                isVideo: true,
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
                          final isSelected = controller.selectedMessageIds.contains(message.id);

                          return ChatBubble(
                            message: message,
                            isSelectionMode: controller.isSelectionMode,
                            isSelected: isSelected,
                            onSelectedChanged: (_) {
                              controller.toggleMessageSelection(message.id);
                            },
                            onTap: () {
                              final isAlreadyDeleted = message.isDeleted ||
                                  message.text.contains('deleted this message') ||
                                  message.text.contains('message was deleted');

                              if (isAlreadyDeleted) {
                                MessageOptionsModal.show(
                                  context,
                                  messageText: message.text,
                                  onSelect: () {
                                    controller.startSelectionMode(message.id);
                                  },
                                  onRemovePermanently: () {
                                    controller.removeMessagePermanently(message.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Message permanently removed'),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            onLongPress: () {
                              final isAlreadyDeleted = message.isDeleted ||
                                  message.text.contains('deleted this message') ||
                                  message.text.contains('message was deleted');

                              MessageOptionsModal.show(
                                context,
                                messageText: message.text,
                                onSelect: () {
                                  controller.startSelectionMode(message.id);
                                },
                                onRemovePermanently: isAlreadyDeleted
                                    ? () {
                                        controller.removeMessagePermanently(message.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Message permanently removed'),
                                          ),
                                        );
                                      }
                                    : null,
                                onDeleteForMe: () {
                                  controller.deleteMessageForMe(message.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('You deleted this message'),
                                    ),
                                  );
                                },
                                onDeleteForEveryone: () {
                                  controller.deleteMessageForEveryone(message.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('You deleted this message for everyone'),
                                    ),
                                  );
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