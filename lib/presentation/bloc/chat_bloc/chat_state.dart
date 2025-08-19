part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Stream<List<ChatModel>> chats;

  const ChatLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {}

class MediaSending extends ChatState {}

class MediaSent extends ChatState {}