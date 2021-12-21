import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import './ingredient.dart';

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

  RecipeModel({
    this.id,
    this.name,
    this.description,
    this.category,
    this.ranking,
    this.cooking,
    this.ingredients,
    this.createdUid,
    this.pictureUrls,
  });

  RecipeModel copyWith({
    String id,
    List<String> pictureUrls,
    String createdUid,
  }) =>
      RecipeModel(
        id: id ?? this.id,
        name: this.name,
        description: this.description,
        category: this.category,
        ranking: this.ranking,
        cooking: this.cooking,
        ingredients: this.ingredients,
        createdUid: createdUid ?? this.createdUid,
        pictureUrls: pictureUrls ?? this.pictureUrls,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "category": category,
        "ranking": ranking,
        "cooking": cooking,
        "ingredients": ingredients.map((e) => e.toJson()).toList(),
        "createdUid": createdUid,
        "pictureUrls": pictureUrls
      };

  factory RecipeModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var pictures = snapshot.data()["pictureUrls"] as List;
    var ingredients = snapshot.data()["ingredients"] as List;
    return RecipeModel(
        id: snapshot.id,
        name: snapshot.data()["name"],
        description: snapshot.data()["description"],
        category: snapshot.data()["category"],
        ranking: snapshot.data()["ranking"],
        cooking: snapshot.data()["cooking"],
        ingredients: ingredients == null
            ? []
            : ingredients.map((e) => IngredientModel.fromMap(e)).toList(),
        createdUid: snapshot.data()["createdUid"],
        pictureUrls:
            pictures == null ? [] : pictures.map((e) => e.toString()).toList());
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        category,
        ranking,
        cooking,
        ingredients,
        createdUid,
        pictureUrls
      ];
}
