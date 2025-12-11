import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;

  ResetPasswordFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
