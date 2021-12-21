import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/bloc/recipes/recipes_bloc.dart';
import 'package:recipes_app/bloc/recipes/recipes_events.dart';
import 'package:recipes_app/bloc/recipes/recipes_states.dart';
import 'package:recipes_app/utils/wave_painter.dart';

import '../widget/recipe_list_item.dart';

class RecipesList extends StatefulWidget {
  RecipesList();

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  bool _isMyRecipes = false;
  RecipesBloc _recipesBloc;
  String _userUid;

  @override
  void initState() {
    super.initState();
    _userUid = FirebaseAuth.instance.currentUser.uid;
    _recipesBloc = BlocProvider.of<RecipesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          _buildBackground(),
          _buildScrollView(),
        ]),
        floatingActionButton: _buildFAB());
  }

  @override
  void dispose() {
    super.dispose();
    _recipesBloc.close();
  }

  Widget _buildBackground() {
    return Container(
        width: double.infinity,
        height: 300.0,
        child: CustomPaint(
          painter: WavePainter(),
        ));
  }

  Widget _buildScrollView() {
    return CustomScrollView(slivers: [_buildAppBar(), _buildBloc()]);
  }

  Widget _buildAppBar() {
    return SliverAppBar(
        floating: true,
        expandedHeight: 0,
        backgroundColor: Colors.amber,
        flexibleSpace: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(5),
          child: Row(children: [
            IconButton(
              icon: !_isMyRecipes
                  ? Icon(Icons.restaurant_menu, color: Colors.white)
                  : Icon(Icons.home, color: Colors.white),
              onPressed: _toggleRecipes,
            ),
            Expanded(
                child: Text(
              _isMyRecipes ? "My Recipes" : "Cook Book",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
            _buildPopupMenuButton()
          ]),
        ));
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.adaptive.more,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              child: InkWell(
                  onTap:_logout,
                  splashColor: Colors.black87,
                  // splash color
                  child: Text('Logout'))),
        ];
      },
    );
  }

  Widget _buildBloc() {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, data) {
        if (data is RecipesStateRecipesLoaded) {
          if (data.recipes != null && data.recipes.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    RecipeListItem(data.recipes[index]),
                childCount: data.recipes.length,
              ),
            );
          } else {
            return SliverToBoxAdapter(
                child: Center(child: Text("No recepies were found")));
          }
        } else {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      backgroundColor: Colors.amber,
      onPressed: _addRecipe,
      tooltip: 'Add Recipe',
      child: Icon(Icons.add),
    );
  }

  void _addRecipe() {
    Navigator.of(context).pushNamed("/add-recipe");
  }

  void _toggleRecipes() {
    setState(() {
      _isMyRecipes = !_isMyRecipes;
    });
    !_isMyRecipes
        ? _recipesBloc.add(RecipesEventRefresh(null))
        : _recipesBloc.add(RecipesEventRefresh(_userUid));
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).popAndPushNamed("/login");
  }
}
