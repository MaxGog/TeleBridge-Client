part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendPhoneNumber extends AuthEvent {
  final String phoneNumber;

  const SendPhoneNumber({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class SendAuthCode extends AuthEvent {
  final String code;

  const SendAuthCode({required this.code});

  @override
  List<Object> get props => [code];
}

class SendPassword extends AuthEvent {
  final String password;

  const SendPassword({required this.password});

  @override
  List<Object> get props => [password];
}

class CheckAuthStatus extends AuthEvent {}