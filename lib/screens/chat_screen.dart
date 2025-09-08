import 'package:flutter/material.dart';
import 'package:materialgramclient/widgets/chat_input_field_widget.dart';
import 'package:materialgramclient/widgets/message_bubble_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 10),
            Text('Имя чата'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return {'Настройки', 'Информация'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0;
                return MessageBubble(
                  text: 'Сообщение ${index + 1}',
                  isMe: isMe,
                  time: '12:${index % 60}',
                );
              },
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}