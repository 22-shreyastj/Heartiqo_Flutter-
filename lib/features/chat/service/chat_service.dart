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
    String text,
  ) async {
    // Later:
    // API call
    // POST /messages
  }

  Future<void> deleteMessage(
    String messageId,
  ) async {
    // API call later
  }

  Future<void> clearChat(
    String chatId,
  ) async {
    // API call later
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