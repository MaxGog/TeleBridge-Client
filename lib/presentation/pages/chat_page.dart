import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialgramclient/data/models/message_model.dart';
import '../bloc/message_bloc/message_bloc.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final int chatId;
  final String chatTitle;

  const ChatPage({super.key, required this.chatId, required this.chatTitle});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _messageBloc = context.read<MessageBloc>();
    _messageBloc.add(LoadMessages());
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      _messageBloc.add(SendNewMessage(text: _controller.text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageError) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                } else if (state is MessageLoaded) {
                  return StreamBuilder<List<MessageModel>>(
                    stream: state.messages,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data!;
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(message: messages[index]);
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}