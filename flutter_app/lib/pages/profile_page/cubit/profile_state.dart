import 'package:equatable/equatable.dart';
import 'package:login_system/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;

  ProfileSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileState {}

class ProfileDelete extends ProfileState{}