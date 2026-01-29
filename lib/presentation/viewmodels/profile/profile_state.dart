import '../../models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}
