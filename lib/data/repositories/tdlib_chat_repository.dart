import 'package:materialgramclient/data/tdlib_models.dart';
import 'package:tdlib/td_api.dart' as td;
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../core/network/tdlib_service.dart';
import 'chat_repository.dart';

class TdLibChatRepository implements ChatRepository {
  final TdLibService _tdLibService = TdLibService();

  @override
  Stream<List<ChatModel>> getChats() async* {
    // Первоначальная загрузка
    final chats = await _tdLibService.getChats();
    yield chats.map((chat) => chat.toChatModel()).toList();

    // Слушаем обновления
    yield* _tdLibService.updates.where((update) {
      return update is td.UpdateNewChat || 
             update is td.UpdateChatLastMessage ||
             update is td.UpdateChatReadInbox;
    }).asyncMap((_) async {
      final updatedChats = await _tdLibService.getChats();
      return updatedChats.map((chat) => chat.toChatModel()).toList();
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(int chatId) async* {
    // Загрузка истории сообщений
    final messages = await _tdLibService.getMessages(chatId);
    yield messages.map((msg) => msg.toMessageModel()).toList();

    // Слушаем новые сообщения
    yield* _tdLibService.updates
        .where((update) => update is td.UpdateNewMessage)
        .map((update) {
          final newMessageUpdate = update as td.UpdateNewMessage;
          if (newMessageUpdate.message.chatId == chatId) {
            return newMessageUpdate.message.toMessageModel();
          }
          return null;
        })
        .where((message) => message != null)
        .asyncMap((newMessage) async {
          final currentMessages = await _tdLibService.getMessages(chatId);
          return currentMessages.map((msg) => msg.toMessageModel()).toList();
        });
  }

  @override
  Future<void> sendMessage(int chatId, String text) async {
    await _tdLibService.sendMessage(chatId, text);
  }

  @override
  Future<void> sendMedia(int chatId, String filePath) async {
    // Определяем тип файла по расширению
    if (filePath.toLowerCase().endsWith('.jpg') || 
        filePath.toLowerCase().endsWith('.png') ||
        filePath.toLowerCase().endsWith('.jpeg')) {
      await _tdLibService.sendPhoto(chatId, filePath);
    } else {
      // Для других типов файлов
      await _sendDocument(chatId, filePath);
    }
  }

  Future<void> _sendDocument(int chatId, String filePath) async {
    await _tdLibService._sendCommand(td.SendMessage(
      chatId: chatId,
      inputMessageContent: td.InputMessageDocument(
        document: td.InputFileLocal(path: filePath),
      ),
    ));
  }

  @override
  Future<void> markAsRead(int chatId) async {
    await _tdLibService._sendCommand(td.ViewMessages(
      chatId: chatId,
      messageIds: [], // Пометить все сообщения как прочитанные
      forceRead: true,
    ));
  }

  Future<void> initialize() async {
    await _tdLibService.initialize();
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _tdLibService.setPhoneNumber(phoneNumber);
  }

  Future<void> checkCode(String code) async {
    await _tdLibService.checkAuthenticationCode(code);
  }

  void dispose() {
    _tdLibService.dispose();
  }
}