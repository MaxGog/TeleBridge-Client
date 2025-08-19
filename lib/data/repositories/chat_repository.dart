import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
  Stream<List<ChatModel>> getChats();
  Stream<List<MessageModel>> getMessages(int chatId);
  Future<void> sendMessage(int chatId, String text);
  Future<void> sendMedia(int chatId, String filePath);
  Future<void> markAsRead(int chatId);
}