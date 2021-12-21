import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/repository/repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Repository repository;
  UserBloc({this.repository}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    switch (event.runtimeType) {
      case UserEventSignIn:
        yield* _mapUserEventSignInToState(event);
        break;
      case UserEventSignUp:
        yield* _mapUserEventSignUpToState(event);
        break;
    }
  }

  Stream<UserState> _mapUserEventSignInToState(UserEventSignIn event) async* {
    yield UserLoading();
    try {
      await repository.authenticate(event.email, event.password);
      yield UserLoggedIn();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        yield UserFailure('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        yield UserFailure('Wrong password provided for that user.');
      } else {
        yield UserFailure("Error occurred");
      }
    } catch (e) {
      yield UserFailure("Error occurred");
    }
  }

  Stream<UserState> _mapUserEventSignUpToState(UserEventSignUp event) async* {
    yield UserLoading();
    try {
      await repository.register(event.email, event.name, event.password);
      yield UserLoggedIn();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        yield UserFailure('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        yield UserFailure('The account already exists for that email.');
      } else {
        yield UserFailure("Error occurred");
      }
    } catch (e) {
      yield UserFailure("Error occurred");
    }
  }
}
