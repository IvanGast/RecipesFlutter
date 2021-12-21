import 'dart:io';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/repository/api/storage.dart';

import 'api/recipe.dart';
import 'api/user.dart';

class Repository {
  final RecipesApi _recipesApi;
  final UserApi _userApi;
  final Storage _storage = Storage();

  Repository(this._recipesApi, this._userApi);

  // Storage
  Future<List<String>> addImages(List<File> images, String id) =>
      _storage.addImages(images, id);

  // Recipes methods
  Stream<List<RecipeModel>> getRecipes() => _recipesApi.getRecipes();

  Stream<List<RecipeModel>> getRecipesByUid(String uid) =>
      _recipesApi.getRecipesByUid(uid);

  Future<RecipeModel> addRecipe(RecipeModel recipe) =>
      _recipesApi.addRecipe(recipe);

  Future<void> updateRecipe(RecipeModel recipe) =>
      _recipesApi.updateRecipe(recipe);

  // User
  Future<void> authenticate(String email, String password) =>
      _userApi.authenticate(email, password);

  Future<void> register(String email, String name, String password) =>
      _userApi.register(email, name, password);

  Future<String> getUid() => _userApi.getUid();
}
