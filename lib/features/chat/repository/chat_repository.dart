import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatRepository {
  static final List<ChatModel> _chats = [
    ChatModel(
      id: '1',
      name: 'Alex',
      image: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400',
      lastMessage: 'I would love to grab coffee this week...',
      lastMessageTime: '12:34 PM',
      isOnline: true,
    ),
    ChatModel(
      id: '2',
      name: 'Jordan',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      lastMessage: 'Typing...',
      lastMessageTime: 'Yesterday',
      isOnline: true,
      isTyping: true,
    ),
    ChatModel(
      id: '3',
      name: 'Marcus',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      lastMessage: 'That sounds perfect, see you then.',
      lastMessageTime: 'Tuesday',
      isOnline: false,
    ),
    ChatModel(
      id: '4',
      name: 'Elena',
      image: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
      lastMessage: 'Haha, I totally agree! 😂',
      lastMessageTime: 'Monday',
      isOnline: true,
    ),
    ChatModel(
      id: '5',
      name: 'Sophia',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      lastMessage: 'Hey! Are we still meeting tomorrow evening?',
      lastMessageTime: 'Sunday',
      isOnline: true,
      unreadCount: 2,
    ),
    ChatModel(
      id: '6',
      name: 'Lucas',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      lastMessage: 'Check out this cool new playlist! 🎵',
      lastMessageTime: 'Oct 12',
      isOnline: false,
    ),
    ChatModel(
      id: '7',
      name: 'Maya',
      image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
      lastMessage: 'Did you finish watching that documentary?',
      lastMessageTime: '10:15 AM',
      isOnline: true,
      unreadCount: 1,
    ),
    ChatModel(
      id: '8',
      name: 'Liam',
      image: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
      lastMessage: 'Let me know when you get there!',
      lastMessageTime: 'Yesterday',
      isOnline: false,
    ),
    ChatModel(
      id: '9',
      name: 'Chloe',
      image: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      lastMessage: 'That restaurant was amazing! Thanks for the recommendation 🍕',
      lastMessageTime: '2 days ago',
      isOnline: true,
      unreadCount: 3,
    ),
    ChatModel(
      id: '10',
      name: 'Daniel',
      image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
      lastMessage: 'Good morning! Hope you have a great day ahead ☀️',
      lastMessageTime: '3 days ago',
      isOnline: false,
    ),
  ];

  static final Map<String, List<MessageModel>> _messagesStore = {};

  static final Map<String, String> _defaultAvatarUrls = {
    '1': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400',
    '2': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    '3': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    '4': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
    '5': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    '6': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    '7': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    '8': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
    '9': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
    '10': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
  };

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _syncLastMessage(String chatId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex == -1) return;

    final chat = _chats[chatIndex];
    if (chat.image.startsWith('assets/') && _defaultAvatarUrls.containsKey(chat.id)) {
      chat.image = _defaultAvatarUrls[chat.id]!;
    }

    if (_messagesStore.containsKey(chatId) && _messagesStore[chatId]!.isNotEmpty) {
      final lastMsg = _messagesStore[chatId]!.last;
      if (lastMsg.isDeleted ||
          lastMsg.text.contains('deleted this message') ||
          lastMsg.text.contains('message was deleted')) {
        chat.lastMessage =
            lastMsg.isMine ? 'You deleted this message' : 'This message was deleted';
      } else {
        chat.lastMessage = lastMsg.text;
      }
      chat.lastMessageTime = _formatTime(lastMsg.time);
    } else if (_messagesStore.containsKey(chatId)) {
      chat.lastMessage = 'No messages';
    }

    // Move active chat to the top of the chat list for live top ordering!
    if (chatIndex > 0) {
      _chats.removeAt(chatIndex);
      _chats.insert(0, chat);
    }
  }

  Future<List<ChatModel>> getChats() async {
    for (final chat in _chats) {
      if (chat.image.startsWith('assets/') && _defaultAvatarUrls.containsKey(chat.id)) {
        chat.image = _defaultAvatarUrls[chat.id]!;
      }
      if (_messagesStore.containsKey(chat.id)) {
        if (_messagesStore[chat.id]!.isEmpty) {
          chat.lastMessage = 'No messages';
        } else {
          final lastMsg = _messagesStore[chat.id]!.last;
          if (lastMsg.isDeleted ||
              lastMsg.text.contains('deleted this message') ||
              lastMsg.text.contains('message was deleted')) {
            chat.lastMessage =
                lastMsg.isMine ? 'You deleted this message' : 'This message was deleted';
          } else {
            chat.lastMessage = lastMsg.text;
          }
          chat.lastMessageTime = _formatTime(lastMsg.time);
        }
      }
    }
    return _chats;
  }

  Future<List<MessageModel>> getMessages(String chatId) async {
    if (!_messagesStore.containsKey(chatId)) {
      _messagesStore[chatId] = [
        MessageModel(
          id: '1',
          text:
              'Hey! It was really great matching with you. I loved that hiking photo on your profile.',
          senderId: 'alex',
          time: DateTime.now().subtract(const Duration(minutes: 10)),
          isMine: false,
        ),
        MessageModel(
          id: '2',
          text:
              'Hi Alex! Thanks 😊 That was from my trip to Zion last fall. It was incredible!',
          senderId: 'me',
          time: DateTime.now().subtract(const Duration(minutes: 8)),
          isMine: true,
          isRead: true,
        ),
        MessageModel(
          id: '3',
          text:
              "I've always wanted to go there! I'd love to grab coffee this week.",
          senderId: 'alex',
          time: DateTime.now().subtract(const Duration(minutes: 5)),
          isMine: false,
        ),
        MessageModel(
          id: '4',
          text: 'Are you free Thursday afternoon?',
          senderId: 'alex',
          time: DateTime.now().subtract(const Duration(minutes: 2)),
          isMine: false,
        ),
      ];
    }
    _syncLastMessage(chatId);
    return _messagesStore[chatId]!;
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    if (!_messagesStore.containsKey(chatId)) {
      await getMessages(chatId);
    }
    final exists = _messagesStore[chatId]!.any((m) => m.id == message.id);
    if (!exists) {
      _messagesStore[chatId]!.add(message);
    }

    _syncLastMessage(chatId);
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    if (_messagesStore.containsKey(chatId)) {
      final msgList = _messagesStore[chatId]!;
      final msgIndex = msgList.indexWhere((m) => m.id == messageId);
      if (msgIndex != -1) {
        msgList[msgIndex].isDeleted = true;
        msgList[msgIndex].text = msgList[msgIndex].isMine
            ? 'You deleted this message'
            : 'This message was deleted';
      }
    }
    _syncLastMessage(chatId);
  }

  Future<void> removeMessagePermanently(String chatId, String messageId) async {
    if (_messagesStore.containsKey(chatId)) {
      _messagesStore[chatId]!.removeWhere((m) => m.id == messageId);
    }
    _syncLastMessage(chatId);
  }

  Future<void> clearChat(String chatId) async {
    if (_messagesStore.containsKey(chatId)) {
      _messagesStore[chatId]!.clear();
    }
    _syncLastMessage(chatId);
  }
}