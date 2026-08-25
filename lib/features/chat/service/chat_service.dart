import '../model/message_model.dart';
import '../repository/chat_repository.dart';

class ChatService {
  final ChatRepository repository;

  ChatService(this.repository);

  Future<List<MessageModel>> getMessages(
    String chatId,
  ) {
    return repository.getMessages(chatId);
  }

  Future<void> sendMessage(
    String chatId,
    MessageModel message,
  ) async {
    await repository.sendMessage(chatId, message);
  }

  Future<void> deleteMessage(
    String chatId,
    String messageId,
  ) async {
    await repository.deleteMessage(chatId, messageId);
  }

  Future<void> removeMessagePermanently(
    String chatId,
    String messageId,
  ) async {
    await repository.removeMessagePermanently(chatId, messageId);
  }

  Future<void> clearChat(
    String chatId,
  ) async {
    await repository.clearChat(chatId);
  }

  Future<void> blockUser(
    String userId,
  ) async {
    // API call later
  }

  Future<void> unblockUser(
    String userId,
  ) async {
    // API call later
  }

  Future<void> reportUser(
    String userId,
    String reason,
  ) async {
    // API call later
  }
}