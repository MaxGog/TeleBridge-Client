import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;
  final int chatId;

  MessageBloc({required this.chatRepository, required this.chatId})
      : super(MessageInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        final messagesStream = chatRepository.getMessages(chatId);
        emit(MessageLoaded(messages: messagesStream));
      } catch (e) {
        emit(MessageError(message: e.toString()));
      }
    });

    on<SendNewMessage>((event, emit) async {
      emit(MessageSending());
      try {
        await chatRepository.sendMessage(chatId, event.text);
        emit(MessageSent());
        add(LoadMessages());
      } catch (e) {
        emit(MessageError(message: e.toString()));
      }
    });
  }
}