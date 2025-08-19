import 'package:equatable/equatable.dart';

enum MessageType { text, image, video, document }

class MessageModel extends Equatable {
  final int id;
  final int chatId;
  final String text;
  final MessageType type;
  final DateTime date;
  final bool isOutgoing;
  final String? mediaUrl;
  final String? thumbnailUrl;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.type,
    required this.date,
    required this.isOutgoing,
    this.mediaUrl,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        text,
        type,
        date,
        isOutgoing,
        mediaUrl,
        thumbnailUrl,
      ];
}