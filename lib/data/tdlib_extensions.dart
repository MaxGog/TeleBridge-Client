import 'package:tdlib/td_api.dart' as td;
import '../data/models/chat_model.dart';
import '../data/models/message_model.dart';

extension TdChatExtensions on td.Chat {
  ChatModel toChatModel() {
    String? lastMessageText;
    DateTime? lastMessageDate;
    
    if (lastMessage != null) {
      lastMessageText = _extractMessageText(lastMessage!);
      lastMessageDate = DateTime.fromMillisecondsSinceEpoch(lastMessage!.date * 1000);
    }

    return ChatModel(
      id: id,
      title: title,
      lastMessage: lastMessageText,
      lastMessageDate: lastMessageDate,
      unreadCount: unreadCount,
      avatarUrl: null, // Будет загружено отдельно
    );
  }

  String _extractMessageText(td.Message message) {
    if (message.content is td.MessageText) {
      return (message.content as td.MessageText).text.text;
    } else if (message.content is td.MessagePhoto) {
      return '📷 Photo';
    } else if (message.content is td.MessageVideo) {
      return '🎬 Video';
    } else if (message.content is td.MessageDocument) {
      return '📄 Document';
    } else if (message.content is td.MessageSticker) {
      return '🖼️ Sticker';
    }
    return 'Unknown message type';
  }
}

extension TdMessageExtensions on td.Message {
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
      final photo = content as td.MessagePhoto;
      return photo.caption?.text ?? '📷 Photo';
    } else if (content is td.MessageVideo) {
      final video = content as td.MessageVideo;
      return video.caption?.text ?? '🎬 Video';
    } else if (content is td.MessageDocument) {
      return '📄 Document';
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
    if (content is td.MessagePhoto) {
      final photo = content as td.MessagePhoto;
      //return photo.photo.small.local?.path;
    } else if (content is td.MessageVideo) {
      final video = content as td.MessageVideo;
      return video.video.thumbnail?.file.local?.path;
    }
    return null;
  }
}

extension TdUserExtensions on td.User {
  String get fullName {
    return '$firstName $lastName'.trim();
  }

  String get displayName {
    if (usernames?.editableUsername.isNotEmpty == true) {
      return '@${usernames!.editableUsername!}';
    }
    return fullName;
  }
}