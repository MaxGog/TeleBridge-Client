import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialgramclient/data/models/chat_model.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../widgets/chat_item.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is ChatLoaded) {
            return StreamBuilder<List<ChatModel>>(
              stream: state.chats,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chats = snapshot.data!;
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return ChatItem(chat: chats[index]);
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
    );
  }
}