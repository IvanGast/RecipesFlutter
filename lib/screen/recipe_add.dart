import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_app/bloc/recipes/recipes_bloc.dart';
import 'package:recipes_app/bloc/recipes/recipes_events.dart';
import 'package:recipes_app/bloc/recipes/recipes_states.dart';
import 'package:recipes_app/constants/strings.dart';
import 'package:recipes_app/model/ingredient.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/utils/text_validator.dart';
import 'package:recipes_app/widget/snackbars.dart';
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

  RecipesBloc _recipesBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _recipesBloc = BlocProvider.of<RecipesBloc>(context);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _cookingController = TextEditingController();
    _ingredientController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Add New Recipe",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: _buildForm(),
            )
          ],
        )
      ]),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameInput(),
          _buildDescriptionInput(),
          Row(children: [
            Text("Select category: "),
            _buildSelect(),
          ]),
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text("Ingredients"),
          ),
          _buildIngredients(),
          Row(
            children: [
              Column(children: [
                _buildIngredientNameInput(),
                _buildIngredientAmountInput(),
              ]),
              _buildAddButton(),
            ],
          ),
          _buildCookingTipsInput(),
          _buildAddImagesButton(),
          if (_images.isNotEmpty) _buildImagesCarousel(),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      validator: (val) {
        String str = TextValidator.isBigger(val, 5);
        if (str == null) {
          str = TextValidator.containsOnlyLetters(val);
        }
        return str;
      },
      controller: _nameController,
      decoration: InputDecoration(
        hintText: "Enter Name",
        contentPadding: EdgeInsets.all(5),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      validator: (val) => TextValidator.isBigger(val, 10),
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: "Enter Description",
        contentPadding: EdgeInsets.all(5),
      ),
    );
  }

  Widget _buildSelect() {
    return DropdownButton<String>(
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
      items: Strings.CATEGORIES.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildIngredients() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        return Ingredient(_ingredients[index]);
      },
    );
  }

  Widget _buildIngredientNameInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 15, 5),
      width: 200,
      child: TextFormField(
        controller: _ingredientController,
        decoration: InputDecoration(
            hintText: "Enter Ingredient", contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  Widget _buildIngredientAmountInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 15, 5),
      width: 200,
      child: TextFormField(
        controller: _amountController,
        decoration: InputDecoration(
          hintText: "Enter Amount",
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: _addIngredient,
      child: Text("Add"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
      ),
    );
  }

  Widget _buildCookingTipsInput() {
    return TextFormField(
      validator: (val) => TextValidator.isBigger(val, 8),
      controller: _cookingController,
      decoration: InputDecoration(
          hintText: "Enter Cooking Tips", contentPadding: EdgeInsets.all(5)),
    );
  }

  Widget _buildAddImagesButton() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _addPhoto,
        child: Text("Add photos"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
        ),
      ),
    );
  }

  Widget _buildImagesCarousel() {
    return CarouselSlider(
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
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<RecipesBloc, RecipesState>(
      listener: (context, state) {
        if (state is RecipesFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBars.error("Error occurred"));
        } else if (state is RecipesAddSuccess) {
          _clearFields();
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is RecipesStateLoading) {
          return Center(
            child: CircularProgressIndicator(color: Colors.yellowAccent),
          );
        }
        return Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate() && fieldValidation()) {
                _submitRecipe();
              }
            },
            child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            ),
          ),
        );
      },
    );
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

  void _submitRecipe() {
    final recipe = RecipeModel(
      name: _nameController.value.text,
      description: _descriptionController.value.text,
      category: _dropdownValue,
      ranking: 0,
      cooking: _cookingController.value.text,
      ingredients: _ingredients,
    );
    _recipesBloc.add(RecipesEventAdd(model: recipe, files: _images));
  }

  void _addIngredient() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBars.error('Please enter materials name and amount'),
      );
    }
  }

  void _clearFields() {
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
