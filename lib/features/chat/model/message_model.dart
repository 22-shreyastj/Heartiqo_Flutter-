class MessageModel {
  final String id;
  String text;
  final String senderId;
  final DateTime time;
  final bool isMine;
  final bool isRead;
  bool isDeleted;
  bool isDeletedForEveryone;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.time,
    required this.isMine,
    this.isRead = false,
    this.isDeleted = false,
    this.isDeletedForEveryone = false,
  });
}