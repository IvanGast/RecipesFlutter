import 'package:equatable/equatable.dart';
import 'package:recipes_app/model/recipe_model.dart';

abstract class RecipesState extends Equatable {}
class RecipesStateLoading extends RecipesState  {
  @override
  List<Object> get props => [runtimeType];
}
class RecipesStateRecipesLoaded extends RecipesState  {
  final List<RecipeModel> recipes;

  RecipesStateRecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}