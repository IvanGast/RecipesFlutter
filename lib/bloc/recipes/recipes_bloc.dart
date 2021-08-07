import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/repository.dart';
import 'recipes_events.dart';
import 'recipes_states.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final Repository repository;
  StreamSubscription _subscription;

  RecipesBloc(this.repository) : super(RecipesStateLoading());

  @override
  Stream<RecipesState> mapEventToState(RecipesEvent event) async* {
    switch (event.runtimeType) {
      case RecipesEventInit:
        yield* mapInitEventToState();
        break;
      case RecipesEventRecipesLoaded:
        yield RecipesStateRecipesLoaded(
            (event as RecipesEventRecipesLoaded).recipes);
        break;
      case RecipesEventRefresh:
        yield* mapRecipesRefreshEventToState(
            (event as RecipesEventRefresh).userUid);
        break;
      default:
        yield RecipesStateLoading();
    }
  }

  Stream<RecipesState> mapInitEventToState() async* {
    if (_subscription != null) {
      await _subscription.cancel();
    }
    yield RecipesStateLoading();
    _subscription = repository.getRecipes().listen((recipes) {
      add(RecipesEventRecipesLoaded(recipes));
    });
  }

  Stream<RecipesState> mapRecipesRefreshEventToState(
      String userUid) async* {
    if (_subscription != null) {
      await _subscription.cancel();
    }
    yield RecipesStateLoading();
    _subscription = userUid == null
        ? repository.getRecipes().listen((recipes) {
            add(RecipesEventRecipesLoaded(recipes));
          })
        : repository.getRecipesByUid(userUid).listen((recipes) {
            add(RecipesEventRecipesLoaded(recipes));
          });
  }

  @override
  Future<Function> close() {
    _subscription.cancel();
    return super.close();
  }
}
