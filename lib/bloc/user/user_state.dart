part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);

  @override
  List<Object> get props => [error];
}
class UserLoggedIn extends UserState {}
