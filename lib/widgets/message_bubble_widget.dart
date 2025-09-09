import 'package:flutter/material.dart';
import 'package:materialgramclient/core/models/attachment.dart';

/// Виджет пузыря сообщения
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final List<Attachment> attachments;

  const MessageBubble({super.key, 
    required this.text,
    required this.isMe,
    required this.time,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (attachments.isNotEmpty)
              Column(
                children: attachments.map((attachment) {
                  if (attachment.type == 'image') {
                    return Image.network(attachment.content, width: 200, height: 200, fit: BoxFit.cover);
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file),
                          const SizedBox(width: 4),
                          Text(attachment.content.split('/').last),
                        ],
                      ),
                    );
                  }
                }).toList(),
              ),
            if (text.isNotEmpty) Text(text),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}