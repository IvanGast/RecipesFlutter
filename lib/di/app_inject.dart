import 'package:get_it/get_it.dart';
import 'package:recipes_app/repository/api/recipe.dart';
import 'package:recipes_app/repository/api/user.dart';
import 'package:recipes_app/repository/repository.dart';

class AppInject {
  static GetIt getIt = GetIt.instance;

  static void injectAppComponents() {
    _injectApis();

    getIt.registerSingleton<Repository>(Repository(
      getIt<RecipesApi>(),
      getIt<UserApi>(),
    ));
  }

  static void _injectApis() {
    getIt.registerSingleton(RecipesApi());
    getIt.registerSingleton(UserApi());
  }
}
