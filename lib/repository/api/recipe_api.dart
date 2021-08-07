import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/model/recipe_model.dart';

class RecipesApi {
  final _recipesRef = FirebaseFirestore.instance.collection("Recipes");

  void addRecipe(RecipeModel recipe) {
    _recipesRef.add(recipe.toJson());
  }

  Stream<List<RecipeModel>> getRecipes() {
    return _recipesRef.snapshots().map((event) =>
        event.docs.map((doc) => RecipeModel.fromDocument(doc)).toList());
  }

  Stream<List<RecipeModel>> getRecipesByUid(String uid) {
    return _recipesRef.snapshots().map((event) =>
        event.docs.where((doc) => RecipeModel.fromDocument(doc).createdUid == uid)
            .map((doc) => RecipeModel.fromDocument(doc)).toList());
  }
}
