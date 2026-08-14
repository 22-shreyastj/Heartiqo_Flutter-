import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatRepository {
  Future<List<ChatModel>> getChats() async {
    return [
      ChatModel(
        id: '1',
        name: 'Alex',
        image: 'assets/images/alex.jpg',
        lastMessage: 'I would love to grab coffee this week...',
        lastMessageTime: '12:34 PM',
        isOnline: true,
      ),
      ChatModel(
        id: '2',
        name: 'Jordan',
        image: 'assets/images/jordan.jpg',
        lastMessage: 'Typing...',
        lastMessageTime: 'Yesterday',
        isOnline: true,
        isTyping: true,
      ),
      ChatModel(
        id: '3',
        name: 'Marcus',
        image: 'assets/images/marcus.jpg',
        lastMessage: 'That sounds perfect, see you then.',
        lastMessageTime: 'Tuesday',
        isOnline: false,
      ),
      ChatModel(
        id: '4',
        name: 'Elena',
        image: 'assets/images/elena.jpg',
        lastMessage: 'Haha, I totally agree! 😂',
        lastMessageTime: 'Monday',
        isOnline: true,
      ),
    ];
  }

  Future<List<MessageModel>> getMessages(
    String chatId,
  ) async {
    return [
      MessageModel(
        id: '1',
        text:
            'Hey! It was really great matching with you. I loved that hiking photo on your profile.',
        senderId: 'alex',
        time: DateTime.now(),
        isMine: false,
      ),

      MessageModel(
        id: '2',
        text:
            'Hi Alex! Thanks 😊 That was from my trip to Zion last fall. It was incredible!',
        senderId: 'me',
        time: DateTime.now(),
        isMine: true,
        isRead: true,
      ),

      MessageModel(
        id: '3',
        text:
            "I've always wanted to go there! I'd love to grab coffee this week.",
        senderId: 'alex',
        time: DateTime.now(),
        isMine: false,
      ),

      MessageModel(
        id: '4',
        text: 'Are you free Thursday afternoon?',
        senderId: 'alex',
        time: DateTime.now(),
        isMine: false,
      ),
    ];
  }
}