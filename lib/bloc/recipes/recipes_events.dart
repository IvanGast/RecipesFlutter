import 'package:equatable/equatable.dart';
import 'package:recipes_app/model/recipe_model.dart';

abstract class RecipesEvent extends Equatable {}
class RecipesEventInit extends RecipesEvent {
  @override
  List<Object> get props => [runtimeType];
}
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