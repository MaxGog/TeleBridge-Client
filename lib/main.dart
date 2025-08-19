import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/chat_model.dart';
import 'data/models/message_model.dart';
import 'data/repositories/chat_repository.dart';
import 'presentation/bloc/chat_bloc/chat_bloc.dart';
import 'presentation/bloc/message_bloc/message_bloc.dart';
import 'presentation/pages/chats_page.dart';
import 'presentation/pages/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(ChatModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ChatRepository chatRepository = MockChatRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: chatRepository)
            ..add(LoadChats()),
        ),
      ],
      child: MaterialApp(
        title: 'Telegram Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ChatsPage(),
        routes: {
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return BlocProvider(
              create: (context) => MessageBloc(
                chatRepository: chatRepository,
                chatId: args['chatId'],
              ),
              child: ChatPage(
                chatId: args['chatId'],
                chatTitle: args['chatTitle'],
              ),
            );
          },
        },
      ),
    );
  }
}

// Адаптеры для Hive
class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 0;

  @override
  ChatModel read(BinaryReader reader) {
    return ChatModel(
      id: reader.readInt(),
      title: reader.readString(),
      lastMessage: reader.readString(),
      lastMessageDate: DateTime.parse(reader.readString()),
      avatarUrl: reader.readString(),
      unreadCount: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.lastMessage ?? '');
    writer.writeString(obj.lastMessageDate?.toIso8601String() ?? '');
    writer.writeString(obj.avatarUrl ?? '');
    writer.writeInt(obj.unreadCount);
  }
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 1;

  @override
  MessageType read(BinaryReader reader) {
    return MessageType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    writer.writeInt(obj.index);
  }
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 2;

  @override
  MessageModel read(BinaryReader reader) {
    return MessageModel(
      id: reader.readInt(),
      chatId: reader.readInt(),
      text: reader.readString(),
      type: MessageType.values[reader.readInt()],
      date: DateTime.parse(reader.readString()),
      isOutgoing: reader.readBool(),
      mediaUrl: reader.readString(),
      thumbnailUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.chatId);
    writer.writeString(obj.text);
    writer.writeInt(obj.type.index);
    writer.writeString(obj.date.toIso8601String());
    writer.writeBool(obj.isOutgoing);
    writer.writeString(obj.mediaUrl ?? '');
    writer.writeString(obj.thumbnailUrl ?? '');
  }
}

// Mock репозиторий с примерами данных
class MockChatRepository implements ChatRepository {
  @override
  Stream<List<ChatModel>> getChats() async* {
    yield [
      ChatModel(
        id: 1,
        title: 'Иван Иванов',
        lastMessage: 'Привет! Как дела?',
        lastMessageDate: DateTime.now(),
        unreadCount: 3,
      ),
      ChatModel(
        id: 2,
        title: 'Группа Flutter',
        lastMessage: 'Новый релиз Flutter 3.0',
        lastMessageDate: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
      ),
    ];
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Stream<List<MessageModel>> getMessages(int chatId) async* {
    yield [
      MessageModel(
        id: 1,
        chatId: chatId,
        text: 'Привет! Как дела?',
        type: MessageType.text,
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        isOutgoing: false,
      ),
      MessageModel(
        id: 2,
        chatId: chatId,
        text: 'Всё отлично!',
        type: MessageType.text,
        date: DateTime.now().subtract(const Duration(minutes: 3)),
        isOutgoing: true,
      ),
      MessageModel(
        id: 3,
        chatId: chatId,
        text: 'Посмотри это фото',
        type: MessageType.image,
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isOutgoing: false,
        mediaUrl: 'https://picsum.photos/200/300',
      ),
    ];
  }

  @override
  Future<void> markAsRead(int chatId) async {
    print('Чат $chatId прочитан');
  }

  @override
  Future<void> sendMedia(int chatId, String filePath) async {
    print('Отправка медиа в чат $chatId: $filePath');
  }

  @override
  Future<void> sendMessage(int chatId, String text) async {
    print('Отправка сообщения в чат $chatId: $text');
    await Future.delayed(const Duration(milliseconds: 500));
  }
}