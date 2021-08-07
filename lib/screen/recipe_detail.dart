import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/constants/strings.dart';
import '../widget/ingredient.dart';
import '../model/recipe_model.dart';

class RecipeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = ModalRoute.of(context).settings.arguments as RecipeModel;
    return Scaffold(
        body: Stack(
      children: [
        _buildBackgroundImageContainer(context, _recipe.pictureUrls[0]),
        _buildBackgroundImageGradient(context),
        _buildContent(context, _recipe),
      ],
    ));
  }

  Widget _buildBackgroundImageContainer(
      BuildContext context, String pictureUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FirebaseImage(getPictureUrl(pictureUrl)),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
    );
  }

  Widget _buildBackgroundImageGradient(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1],
              colors: [Colors.transparent, Colors.white]),
        ),);
  }

  Widget _buildContent(BuildContext context, RecipeModel _recipe) {
    return ListView(children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildCloseButton(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Stack(children: [
              _buildRecipeInfoColumn(_recipe),
              _buildFavoriteButton(),
            ]),
            _buildStartCookingButton()
          ])
    ]);
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 20),
        height: 25,
        width: 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              padding: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Icon(
            Icons.close,
            color: Colors.black38,
            size: 15,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ));
  }

  Widget _buildFavoriteButton() {
    return Positioned(
        top: 0,
        right: 30,
        height: 35,
        width: 35,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.yellow.withOpacity(0.4),
              padding: EdgeInsets.only(left: 9, bottom: 9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(40)))),
          child: Icon(
            Icons.star,
            color: Colors.amber,
            size: 15,
          ),
          onPressed: () => {},
        ));
  }

  Widget _buildStartCookingButton() {
    return Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: Row(children: [
          Expanded(
              child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                backgroundColor: MaterialStateProperty.all(Colors.amber),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))))),
            onPressed: () => {},
            child: Text("Start Cooking",
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ))
        ]));
  }

  Widget _buildRecipeInfoColumn(RecipeModel _recipe) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 30, right: 30),
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_recipe.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 26)),
        SizedBox(
          height: 9,
        ),
        Text(_recipe.description,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
        SizedBox(
          height: 22,
        ),
        Text("Materials",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20),),
        _buildIngredientsColumn(_recipe)
      ]),
    );
  }

  Widget _buildIngredientsColumn(RecipeModel _recipe) {
    return Container(
      margin: EdgeInsets.only(top: 7),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
        color: Colors.grey.withOpacity(0.4),
      ),
      padding: EdgeInsets.all(10),
      child: Column(children: [
        ..._recipe.ingredients.map((element) {
          return Ingredient(element);
        }).toList()
      ]),
    );
  }

  String getPictureUrl(String pictureUrl) {
    return Strings.IMAGES_PATH + pictureUrl;
  }
}
