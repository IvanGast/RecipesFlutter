import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/bloc/recipes/recipes_bloc.dart';
import 'package:recipes_app/bloc/recipes/recipes_events.dart';
import 'package:recipes_app/bloc/recipes/recipes_states.dart';
import 'package:recipes_app/utils/my_painter.dart';

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

  _RecipesListState();

  @override
  void initState() {
    super.initState();
    _userUid = FirebaseAuth.instance.currentUser.uid;
    _recipesBloc = BlocProvider.of(context);
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
          painter: MyPainter(),
        ));
  }

  Widget _buildScrollView() {
    return CustomScrollView(slivers: [_buildAppBar(), _buildBloc()]);
  }

  Widget _buildAppBar() {
    return SliverAppBar(
        floating: true,
        expandedHeight: 0,
        flexibleSpace: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(5),
          child: Row(children: [
            IconButton(
              icon: !_isMyRecipes
                  ? Icon(Icons.restaurant_menu, color: Colors.black)
                  : Icon(Icons.home, color: Colors.black),
              onPressed: _toggleRecipes,
            ),
            Expanded(
                child: Text(
              _isMyRecipes ? "My Recipes" : "Cook Book",
              style: TextStyle(
                  color: Colors.black,
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
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              child: InkWell(
                  onTap: () => _openProfile(context),
                  splashColor: Colors.black87,
                  // splash color
                  child: Text('Profile'))),
          PopupMenuItem(
              child: InkWell(
                  onTap: () => _logout(context),
                  splashColor: Colors.black87,
                  // splash color
                  child: Text('Logout'))),
        ];
      },
    );
  }

  Widget _buildBloc() {
    return BlocBuilder<RecipesBloc, RecipesState>(
      bloc: _recipesBloc,
      builder: (context, data) {
        if (data is RecipesStateRecipesLoaded) {
          if (data.recipes != null) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      RecipeListItem(data.recipes[index]),
                  childCount: data.recipes.length),
            );
          } else {
            return SliverToBoxAdapter(
                child: Center(child: Text("Nothing yet here")));
          }
        } else {
          return SliverToBoxAdapter(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => _addRecipe(context),
      tooltip: 'Add Recipe',
      child: Icon(Icons.add),
    );
  }

  void _addRecipe(BuildContext ctx) {
    Navigator.of(ctx).pushNamed("/add-recipe");
  }

  void _toggleRecipes() {
    setState(() {
      _isMyRecipes = !_isMyRecipes;
    });
    !_isMyRecipes
        ? _recipesBloc.add(RecipesEventRefresh(null))
        : _recipesBloc.add(RecipesEventRefresh(_userUid));
  }

  void _openProfile(BuildContext ctx) {
    Navigator.of(ctx).pushNamed("/profile");
  }

  void _logout(BuildContext ctx) {
    FirebaseAuth.instance.signOut();
    Navigator.of(ctx).popAndPushNamed("/login");
  }
}
