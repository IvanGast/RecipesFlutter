import 'dart:ui';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/constants/strings.dart';

import '../model/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeModel _recipe;

  RecipeListItem(this._recipe);

  @override
  Widget build(BuildContext context) {
    return _buildCardWithBackground(context);
  }

  Widget _buildCardWithBackground(BuildContext context) {
    return InkWell(
        onTap: () => selectRecipe(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
        child: Container(
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                image: DecorationImage(
                    image: FirebaseImage(_getPictureUrl()), fit: BoxFit.cover)),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: _buildInfoColumn()));
  }

  Widget _buildInfoColumn() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Row(children: [
              Icon(Icons.star_border, color: Colors.white),
              Text(
                _recipe.ranking.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ]),
          ),
          _buildBlur(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  child: Text(_recipe.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          decorationStyle: TextDecorationStyle.solid))))
        ]);
  }

  Widget _buildBlur({
    @required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
  }) =>
      ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: child,
          ));

  String _getPictureUrl() {
    return Strings.IMAGES_PATH + "/" + _recipe.id + _recipe.pictureUrls[0];
  }

  void selectRecipe(BuildContext ctx) {
    Navigator.of(ctx).pushNamed("/recipe-detail", arguments: _recipe);
  }
}
