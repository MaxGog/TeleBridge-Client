part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent {}

class SendMessage extends ChatEvent {
  final int chatId;
  final String text;

  const SendMessage({required this.chatId, required this.text});

  @override
  List<Object> get props => [chatId, text];
}

class SendMedia extends ChatEvent {
  final int chatId;
  final String filePath;

  const SendMedia({required this.chatId, required this.filePath});

  @override
  List<Object> get props => [chatId, filePath];
}