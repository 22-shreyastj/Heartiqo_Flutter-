import 'package:flutter/material.dart';

import '../model/message_model.dart';
import '../service/chat_service.dart';

class ChatController extends ChangeNotifier {
  final ChatService service;

  ChatController(this.service);

  List<MessageModel> messages = [];

  bool isLoading = false;
  bool isTyping = false;
  bool isOnline = false;
  bool muteNotifications = false;
  String? muteDuration;
  bool isBlocked = false;

  Future<void> loadMessages(String chatId) async {
    isLoading = true;
    notifyListeners();

    messages = await service.getMessages(chatId);

    isLoading = false;
    notifyListeners();
  }

  void setTyping(bool value) {
    isTyping = value;
    notifyListeners();
  }

  void sendMessage(
    String chatId,
    String text,
  ) {
    if (isBlocked || text.trim().isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      senderId: 'me',
      time: DateTime.now(),
      isMine: true,
    );

    messages.add(message);

    notifyListeners();

    service.sendMessage(
      chatId,
      text,
    );
  }

  void deleteMessage(String messageId) {
    messages.removeWhere(
      (message) => message.id == messageId,
    );

    notifyListeners();

    service.deleteMessage(messageId);
  }

  void clearChat(String chatId) {
    messages.clear();
    notifyListeners();

    service.clearChat(chatId);
  }

  void toggleMute([String duration = '30 min']) {
    if (muteNotifications) {
      unmuteChat();
    } else {
      muteChat(duration);
    }
  }

  void muteChat(String duration) {
    muteNotifications = true;
    muteDuration = duration;
    notifyListeners();
  }

  void unmuteChat() {
    muteNotifications = false;
    muteDuration = null;
    notifyListeners();
  }

  void blockUser(String chatId) {
    isBlocked = true;
    notifyListeners();
    service.blockUser(chatId);
  }

  void unblockUser(String chatId) {
    isBlocked = false;
    notifyListeners();
    service.unblockUser(chatId);
  }

  void toggleBlockUser(String chatId) {
    if (isBlocked) {
      unblockUser(chatId);
    } else {
      blockUser(chatId);
    }
  }
}