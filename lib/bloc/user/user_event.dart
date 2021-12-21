part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}
class UserEventSignIn extends UserEvent {
  final String email;
  final String password;

  UserEventSignIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
class UserEventSignUp extends UserEvent {
  final String email;
  final String name;
  final String password;

  UserEventSignUp(this.email, this.name, this.password);

  @override
  List<Object> get props => [email, password, name];
}