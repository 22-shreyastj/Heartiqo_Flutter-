class ChatModel {
  final String id;
  final String name;
  String image;
  String lastMessage;
  String lastMessageTime;
  final bool isOnline;
  final bool isTyping;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isOnline,
    this.isTyping = false,
    this.unreadCount = 0,
  });
}