import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/model/ingredient_model.dart';

class Ingredient extends StatelessWidget{
  final IngredientModel _ingredient;

  const Ingredient(this._ingredient);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_ingredient.name),
        SizedBox(width: 7,),
        Expanded(child: DottedLine(
          dashLength: 1.0,
        )),
        SizedBox(width: 7,),
        Text(_ingredient.name)
    ],);

  }

}