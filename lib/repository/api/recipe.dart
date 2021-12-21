import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/model/recipe.dart';

class RecipesApi {
  final _recipesRef = FirebaseFirestore.instance.collection("Recipes");

  Future<RecipeModel> addRecipe(RecipeModel recipe) => _recipesRef
      .add(recipe.toJson())
      .then((value) => recipe.copyWith(id: value.id));

  Future<void> updateRecipe(RecipeModel recipe) => _recipesRef
      .doc(recipe.id)
      .update(recipe.toJson());

  Stream<List<RecipeModel>> getRecipes() =>
      _recipesRef.snapshots().map((event) =>
          event.docs.map((doc) => RecipeModel.fromDocument(doc)).toList());

  Stream<List<RecipeModel>> getRecipesByUid(String uid) =>
      _recipesRef.snapshots().map((event) => event.docs
          .where((doc) => RecipeModel.fromDocument(doc).createdUid == uid)
          .map((doc) => RecipeModel.fromDocument(doc))
          .toList());
}
