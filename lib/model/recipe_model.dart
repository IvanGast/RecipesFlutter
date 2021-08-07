import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import './ingredient_model.dart';

class RecipeModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final int ranking;
  final String cooking;
  final List<IngredientModel> ingredients;
  final String createdUid;
  final List<String> pictureUrls;

  RecipeModel(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.ranking,
      this.cooking,
      this.ingredients,
      this.createdUid,
      this.pictureUrls});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "ranking": ranking,
        "cooking": cooking,
        "ingredients": ingredients.map((e) => e.toJson()).toList(),
        "createdUid": createdUid,
        "pictureUrls": pictureUrls
      };

  factory RecipeModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) => RecipeModel(
      id: snapshot.id,
      name: snapshot.data()["name"],
      description: snapshot.data()["description"],
      category: snapshot.data()["category"],
      ranking: snapshot.data()["ranking"],
      cooking: snapshot.data()["cooking"],
      ingredients: (snapshot.data()["ingredients"] as List)
          .map((e) => IngredientModel.fromMap(e))
          .toList(),
      createdUid: snapshot.data()["createdUid"],
      pictureUrls:
          (snapshot.data()["pictureUrls"] as List).map((e) => e.toString()).toList());

  @override
  List<Object> get props => [id, name, description, category, ranking, cooking, ingredients, createdUid, pictureUrls];
}
