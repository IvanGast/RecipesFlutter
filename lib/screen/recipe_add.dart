import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_app/constants/strings.dart';
import 'package:recipes_app/model/ingredient_model.dart';
import 'package:recipes_app/model/recipe_model.dart';
import 'package:recipes_app/repository/repository.dart';
import 'package:recipes_app/utils/text_validator.dart';
import '../widget/ingredient.dart';

class AddRecipe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  TextEditingController _nameController,
      _descriptionController,
      _cookingController,
      _ingredientController,
      _amountController;
  final List<IngredientModel> _ingredients = [];
  final List<File> _images = [];
  String _dropdownValue = "Veg";
  Repository _repository;

  final _formKey = GlobalKey<FormState>();
  String _recipeId = "";
  final _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Text("Add New Recipe",
                    style: TextStyle(color: Colors.black, fontSize: 30))),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: _buildForm(),
            )
          ],
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of(context);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _cookingController = TextEditingController();
    _ingredientController = TextEditingController();
    _amountController = TextEditingController();
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (val) {
              String str = TextValidator.isBigger(val, 5);
              if (str == null) {
                str = TextValidator.containsOnlyLetters(val);
              }
              return str;
            },
            controller: _nameController,
            decoration: InputDecoration(
                hintText: "Enter Name", contentPadding: EdgeInsets.all(5)),
          ),
          TextFormField(
            validator: (val) => TextValidator.isBigger(val, 10),
            controller: _descriptionController,
            decoration: InputDecoration(
                hintText: "Enter Description",
                contentPadding: EdgeInsets.all(5)),
          ),
          Row(children: [
            Text("Select category: "),
            DropdownButton<String>(
              value: _dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.black12,
              ),
              onChanged: (String data) {
                setState(() {
                  _dropdownValue = data;
                });
              },
              items: Strings.CATEGORIES
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text("Ingredients"),
          ),
          ..._ingredients.map(
            (element) {
              return Ingredient(element);
            },
          ),
          Row(
            children: [
              Column(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 15, 5),
                  width: 200,
                  child: TextFormField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                        hintText: "Enter Ingredient",
                        contentPadding: EdgeInsets.all(10)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 15, 5),
                  width: 200,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ]),
              ElevatedButton(
                onPressed: _addIngredient,
                child: Text("Add"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
                ),
              ),
            ],
          ),
          TextFormField(
            validator: (val) => TextValidator.isBigger(val, 8),
            controller: _cookingController,
            decoration: InputDecoration(
                hintText: "Enter Cooking Tips",
                contentPadding: EdgeInsets.all(5)),
          ),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: _addPhoto,
              child: Text("Add photos"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
              ),
            ),
          ),
          _images.length == 0
              ? SizedBox(
                  height: 0,
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                  ),
                  items: _images.map((item) {
                    return GridTile(
                      child: Image.file(item, fit: BoxFit.cover),
                      footer: Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.black54,
                        child: Text(
                          "Image " + (_images.indexOf(item) + 1).toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  }).toList(),
                ),
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate() && fieldValidation()) {
                  _submitRecipe(context);
                }
              },
              child: Text("Submit"),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addIngredient() {
    if (_ingredientController.value.text.isNotEmpty &&
        _amountController.value.text.isNotEmpty) {
      setState(() {
        _ingredients.add(IngredientModel(
            name: _ingredientController.value.text,
            amount: _amountController.value.text));
        _ingredientController.clear();
        _amountController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter materials name and amount'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _addPhoto() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  String _getUserUid() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  String _generateRecipeId() {
    String id = "";
    Random rnd = new Random();
    for (int i = 0; i < 15; i++) {
      id += rnd.nextInt(9).toString();
    }
    _recipeId = id;
    return id;
  }

  _submit(BuildContext ctx, List<String> urls) {
    final recipe = RecipeModel(
        id: _generateRecipeId(),
        name: _nameController.value.text,
        description: _descriptionController.value.text,
        category: _dropdownValue,
        ranking: 0,
        cooking: _cookingController.value.text,
        ingredients: _ingredients,
        createdUid: _getUserUid(),
        pictureUrls: urls);
    _repository.addRecipe(recipe);
    _clearFields();
    Navigator.of(ctx).pop();
  }

  _submitRecipe(BuildContext ctx) {
    final List<String> links = [];
    _images.forEach((img) async {
      String imageName = img.path
          .substring(img.path.lastIndexOf("/"), img.path.lastIndexOf("."))
          .replaceAll("/", "");
      final byteData = img.readAsBytesSync();
      await img.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      await _storage.ref('/images/$_recipeId/$imageName').putFile(img);
      final String name = img.path
          .substring(img.path.lastIndexOf("/"), img.path.lastIndexOf("."));
      links.add(name);
      if (_images.length == links.length) {
        _submit(ctx, links);
      }
    });
  }

  _clearFields() {
    setState(() {
      _ingredients.clear();
      _nameController.clear();
      _descriptionController.clear();
      _cookingController.clear();
      _ingredientController.clear();
      _amountController.clear();
    });
  }

  bool fieldValidation() {
    if (_ingredients.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please add an ingredient'),
        backgroundColor: Colors.red,
      ));
      return false;
    } else if (_images.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please add at least 1 picture'),
        backgroundColor: Colors.red,
      ));
      return false;
    } else {
      return true;
    }
  }
}
