import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialgramclient/data/repositories/tdlib_chat_repository.dart';
import 'package:materialgramclient/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:materialgramclient/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:materialgramclient/presentation/pages/auth_page.dart';
import 'package:materialgramclient/presentation/pages/chats_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final chatRepository = TdLibChatRepository();
    await chatRepository.initialize();
    
    runApp(MyApp(chatRepository: chatRepository));
  } catch (e) {
    print('Failed to initialize app: $e');
    runApp(const ErrorApp());
  }
}


class MyApp extends StatelessWidget {
  final TdLibChatRepository chatRepository;

  const MyApp({super.key, required this.chatRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(chatRepository: chatRepository)
            ..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: chatRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Telegram Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/chats': (context) => const ChatsPage(),
          '/auth': (context) => const AuthPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return const ChatsPage();
        } else if (state is AuthCodeSent || state is AuthPasswordNeeded) {
          return const AuthPage();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const AuthPage();
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ошибка инициализации',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text('Проверьте настройки TDLib и интернет соединение'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}