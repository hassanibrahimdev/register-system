import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class VerifyCodeLoading extends RegisterState {}

class VerifyCodeSuccess extends RegisterState {
  final String message;

  VerifyCodeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class VerifyCodeFailure extends RegisterState {
  final String message;

  VerifyCodeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
