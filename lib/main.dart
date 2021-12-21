import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/repository/repository.dart';

import 'bloc/recipes/recipes_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'di/app_inject.dart';
import 'screen/home.dart';
import 'screen/recipe_add.dart';
import 'screen/recipe_detail.dart';
import 'screen/recipes_list.dart';
import 'package:path_provider/path_provider.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  AppInject.injectAppComponents();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => RecipesBloc(
            repository: getIt<Repository>(),
          ),
        ),
        BlocProvider(
          create: (_) => UserBloc(
            repository: getIt<Repository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber,
        ),
        initialRoute: '/login',
        routes: {
          '/recipe-detail': (ctx) => RecipeDetail(),
          '/recipes-list': (ctx) => RecipesList(),
          '/login': (ctx) => Login(),
          '/add-recipe': (ctx) => AddRecipe(),
        },
      ),
    );
  }
}
