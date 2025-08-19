import 'package:materialgramclient/data/models/chat_model.dart';
import 'package:materialgramclient/data/models/message_model.dart';
import 'package:tdlib/td_api.dart' as td;

extension TdChatConverter on td.Chat {
  ChatModel toChatModel() {
    return ChatModel(
      id: id,
      title: title,
      lastMessage: lastMessage?.toString(),
      lastMessageDate: lastMessage != null 
          ? DateTime.fromMillisecondsSinceEpoch(lastMessage!.date * 1000)
          : null,
      unreadCount: unreadCount,
      avatarUrl: null, // Будем получать отдельно
    );
  }
}

extension TdMessageConverter on td.Message {
  MessageModel toMessageModel() {
    return MessageModel(
      id: id,
      chatId: chatId,
      text: _extractMessageText(),
      type: _getMessageType(),
      date: DateTime.fromMillisecondsSinceEpoch(date * 1000),
      isOutgoing: isOutgoing,
      mediaUrl: _extractMediaUrl(),
    );
  }

  String _extractMessageText() {
    if (content is td.MessageText) {
      return (content as td.MessageText).text.text;
    } else if (content is td.MessagePhoto) {
      return (content as td.MessagePhoto).caption?.text ?? '📷 Photo';
    } else if (content is td.MessageVideo) {
      return (content as td.MessageVideo).caption?.text ?? '🎬 Video';
    }
    return 'Unsupported message type';
  }

  MessageType _getMessageType() {
    if (content is td.MessagePhoto) return MessageType.image;
    if (content is td.MessageVideo) return MessageType.video;
    if (content is td.MessageDocument) return MessageType.document;
    return MessageType.text;
  }

  String? _extractMediaUrl() {
    // URL будет получен через getFile
    return null;
  }
}