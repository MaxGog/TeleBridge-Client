part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {}

class SendNewMessage extends MessageEvent {
  final String text;

  const SendNewMessage({required this.text});

  @override
  List<Object> get props => [text];
}