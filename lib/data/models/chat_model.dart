import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final int id;
  final String title;
  final String? lastMessage;
  final DateTime? lastMessageDate;
  final String? avatarUrl;
  final int unreadCount;

  const ChatModel({
    required this.id,
    required this.title,
    this.lastMessage,
    this.lastMessageDate,
    this.avatarUrl,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        lastMessage,
        lastMessageDate,
        avatarUrl,
        unreadCount,
      ];
}