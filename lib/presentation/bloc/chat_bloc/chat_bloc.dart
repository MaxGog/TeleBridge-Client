import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chatsStream = chatRepository.getChats();
        emit(ChatLoaded(chats: chatsStream));
      } catch (e) {
        emit(ChatError(message: e.toString()));
      }
    });
  }
}