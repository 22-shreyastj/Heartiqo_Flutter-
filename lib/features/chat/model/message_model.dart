class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final DateTime time;
  final bool isMine;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.time,
    required this.isMine,
    this.isRead = false,
  });
}