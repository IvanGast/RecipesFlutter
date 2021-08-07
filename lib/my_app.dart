import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/repository/repository.dart';

import 'bloc/recipes/recipes_bloc.dart';
import 'bloc/recipes/recipes_events.dart';
import 'screen/login.dart';
import 'screen/profile.dart';
import 'screen/recipe_add.dart';
import 'screen/recipe_detail.dart';
import 'screen/recipes_list.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Colors.amber,
      ),
      home: Scaffold(
        body: Login(),
      ),
      routes: {
        '/recipe-detail': (ctx) => RecipeDetail(),
        '/recipes-list': (ctx) => RepositoryProvider<Repository>(
            lazy: false,
            create: (context) => Repository(),
            child: BlocProvider(
              lazy: false,
              create: (context) => RecipesBloc(RepositoryProvider.of(context))
                ..add(RecipesEventInit()),
              child: RecipesList(),
            )),
        '/profile': (ctx) => Profile(),
        '/login': (ctx) => Login(),
        '/add-recipe': (ctx) => RepositoryProvider<Repository>(
              child: AddRecipe(),
              create: (ctx) => Repository(),
            ),
      },
    );
  }
}
