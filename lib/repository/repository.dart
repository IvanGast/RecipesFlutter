import 'package:recipes_app/model/recipe_model.dart';

import 'api/recipe_api.dart';

class Repository {
  RecipesApi _recipesApi = RecipesApi();

  Repository();

  // Recipes methods
  Stream<List<RecipeModel>> getRecipes() {
    return _recipesApi.getRecipes();
  }

  Stream<List<RecipeModel>> getRecipesByUid(String uid) {
    return _recipesApi.getRecipesByUid(uid);
  }

  void addRecipe(RecipeModel recipe) {
    _recipesApi.addRecipe(recipe);
  }
}
