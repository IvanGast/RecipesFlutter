import 'package:equatable/equatable.dart';
import 'package:recipes_app/model/recipe.dart';

abstract class RecipesState extends Equatable {
  @override
  List<Object> get props => [runtimeType];
}
class RecipesStateLoading extends RecipesState  {}
class RecipesFailure extends RecipesState  {}
class RecipesAddSuccess extends RecipesState  {}
class RecipesStateRecipesLoaded extends RecipesState  {
  final List<RecipeModel> recipes;

  RecipesStateRecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}