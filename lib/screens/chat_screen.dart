import 'package:flutter/material.dart';
import 'package:materialgramclient/models/attachment.dart';
import 'package:materialgramclient/models/message.dart';
import 'package:materialgramclient/widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final List<Attachment> _attachments = [];

  @override
  void initState() {
    super.initState();
    // Заглушка сообщений
    _messages.addAll([
      Message(
        text: 'Привет! Как дела?',
        isMe: false,
        time: '12:30',
        attachments: [],
      ),
      Message(
        text: 'Всё отлично!',
        isMe: true,
        time: '12:31',
        attachments: [],
      ),
    ]);
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty || _attachments.isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: _textController.text,
          isMe: true,
          time: '${DateTime.now().hour}:${DateTime.now().minute}',
          attachments: List.from(_attachments),
        ));
        _textController.clear();
        _attachments.clear();
      });
    }
  }

  void _addAttachment() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Фото'),
              onTap: () {
                /*setState(() {
                  _attachments.add(Attachment(type: 'image', content: 'assets/avatars/defalut.png'));
                });*/
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Документ'),
              onTap: () {
                setState(() {
                  _attachments.add(Attachment(type: 'document', content: 'document.pdf'));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatarts/default.png'),
            ),
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  text: message.text,
                  isMe: message.isMe,
                  time: message.time,
                  attachments: message.attachments,
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(offset: Offset(0, 4), blurRadius: 32, color: Colors.grey)],
      ),
      child: Column(
        children: [
          if (_attachments.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachments.length,
                itemBuilder: (context, index) {
                  final attachment = _attachments[index];
                  if (attachment.type == 'image') {
                    return Stack(
                      children: [
                        Image.network(attachment.content, width: 80, height: 80, fit: BoxFit.cover),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              setState(() {
                                _attachments.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.insert_drive_file),
                          Text(attachment.content.split('/').last),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              setState(() {
                                _attachments.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.emoji_emotions), onPressed: () {}),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Введите сообщение',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _addAttachment,
              ),
              IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}