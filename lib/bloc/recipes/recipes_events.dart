import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:recipes_app/model/recipe.dart';

abstract class RecipesEvent extends Equatable {
  @override
  List<Object> get props => [runtimeType];
}
class RecipesEventInit extends RecipesEvent {}
class RecipesEventRefresh extends RecipesEvent {
  final String userUid;

  RecipesEventRefresh(this.userUid);

  @override
  List<Object> get props => [userUid];
}
class RecipesEventRecipesLoaded extends RecipesEvent {
  final List<RecipeModel> recipes;

  RecipesEventRecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}
class RecipesEventAdd extends RecipesEvent {
  final RecipeModel model;
  final List<File> files;

  RecipesEventAdd({this.model, this.files});

  @override
  List<Object> get props => [model, files];
}