import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/tdlib_chat_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TdLibChatRepository chatRepository;

  AuthBloc({required this.chatRepository}) : super(AuthInitial()) {
    on<SendPhoneNumber>(_onSendPhoneNumber);
    on<SendAuthCode>(_onSendAuthCode);
    on<SendPassword>(_onSendPassword);
  }

  Future<void> _onSendPhoneNumber(
    SendPhoneNumber event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await chatRepository.setPhoneNumber(event.phoneNumber);
      emit(AuthCodeSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSendAuthCode(
    SendAuthCode event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await chatRepository.checkCode(event.code);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSendPassword(
    SendPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Реализация проверки пароля
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}