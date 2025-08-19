import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/chat_model.dart';

class ChatItem extends StatelessWidget {
  final ChatModel chat;

  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: chat.avatarUrl != null
            ? CachedNetworkImageProvider(chat.avatarUrl!)
            : null,
        child: chat.avatarUrl == null
            ? Text(chat.title[0].toUpperCase())
            : null,
      ),
      title: Text(
        chat.title,
        style: TextStyle(
          fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        chat.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(chat.lastMessageDate),
            style: const TextStyle(fontSize: 12),
          ),
          if (chat.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/chat',
          arguments: {
            'chatId': chat.id,
            'chatTitle': chat.title,
          },
        );
      },
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}