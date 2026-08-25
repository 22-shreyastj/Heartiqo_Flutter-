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

  String? currentChatId;

  Future<void> loadMessages(String chatId) async {
    currentChatId = chatId;
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
      message,
    );
  }

  void deleteMessage(String messageId, {bool forEveryone = false}) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index].isDeleted = true;
      messages[index].isDeletedForEveryone = forEveryone;
      messages[index].text = messages[index].isMine
          ? 'You deleted this message'
          : 'This message was deleted';
      notifyListeners();
    }
    if (currentChatId != null) {
      service.deleteMessage(currentChatId!, messageId);
    }
  }

  bool isSelectionMode = false;
  final Set<String> selectedMessageIds = {};

  void startSelectionMode([String? initialMessageId]) {
    isSelectionMode = true;
    selectedMessageIds.clear();
    if (initialMessageId != null) {
      selectedMessageIds.add(initialMessageId);
    }
    notifyListeners();
  }

  void toggleMessageSelection(String messageId) {
    if (selectedMessageIds.contains(messageId)) {
      selectedMessageIds.remove(messageId);
      if (selectedMessageIds.isEmpty) {
        isSelectionMode = false;
      }
    } else {
      selectedMessageIds.add(messageId);
    }
    notifyListeners();
  }

  void clearSelection() {
    isSelectionMode = false;
    selectedMessageIds.clear();
    notifyListeners();
  }

  void removeMessagePermanently(String messageId) {
    messages.removeWhere((m) => m.id == messageId);
    notifyListeners();
    if (currentChatId != null) {
      service.removeMessagePermanently(currentChatId!, messageId);
    }
  }

  void deleteSelectedMessages({bool forEveryone = false}) {
    final idsToDelete = List<String>.from(selectedMessageIds);
    for (final id in idsToDelete) {
      final msg = messages.firstWhere(
        (m) => m.id == id,
        orElse: () => MessageModel(id: '', text: '', senderId: '', time: DateTime.now(), isMine: false),
      );
      if (msg.isDeleted || msg.text.contains('deleted this message') || msg.text.contains('message was deleted')) {
        removeMessagePermanently(id);
      } else {
        deleteMessage(id, forEveryone: forEveryone);
      }
    }
    clearSelection();
  }

  void deleteMessageForMe(String messageId) {
    final msg = messages.firstWhere(
      (m) => m.id == messageId,
      orElse: () => MessageModel(id: '', text: '', senderId: '', time: DateTime.now(), isMine: false),
    );
    if (msg.isDeleted || msg.text.contains('deleted this message') || msg.text.contains('message was deleted')) {
      removeMessagePermanently(messageId);
    } else {
      deleteMessage(messageId, forEveryone: false);
    }
  }

  void deleteMessageForEveryone(String messageId) {
    deleteMessage(messageId, forEveryone: true);
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