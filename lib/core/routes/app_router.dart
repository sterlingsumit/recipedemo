import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_discovery_app/domain/repositories/recipe_repository.dart';
import 'package:recipe_discovery_app/domain/usecases/get_popular_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_quick_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_vegetarian_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/search_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_recipe_details_usecase.dart';
import 'package:recipe_discovery_app/main.dart';
import 'package:recipe_discovery_app/presentation/blocs/location/location_bloc.dart';
import 'package:recipe_discovery_app/presentation/blocs/recipe/get_recipe_bloc.dart';
import 'package:recipe_discovery_app/presentation/blocs/recipe/get_recipe_event.dart';
import 'package:recipe_discovery_app/presentation/screens/recipe_home_screen.dart';
import 'package:recipe_discovery_app/presentation/screens/recipe_detail_screen.dart';
import 'package:recipe_discovery_app/presentation/screens/search_results_screen.dart';
import 'package:recipe_discovery_app/presentation/screens/splash.dart';

class AppRouter {
  // Route names
  static const String splashScreen = '/splashScreen';
  static const String homeScreen = '/homeScreen';
  static const String searchResults = '/searchResults';
  static const String recipeDetail = '/recipeDetail';

  // Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LocationBloc(),
            child: const SplashScreen(),
          ),
        );

      case homeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final address = settings.arguments; // ✅ Get arguments if needed

            return BlocProvider(
              create: (context) => RecipeBloc(
                getPopularRecipeUseCase:
                GetPopularRecipeUseCase(repo: recipeRepository),
                getQuickRecipeUseCase:
                GetQuickRecipeUseCase(repo: recipeRepository),
                getVegetarianRecipeUseCase:
                GetVegetarianRecipeUseCase(repo: recipeRepository),
                searchRecipesUseCase:
                SearchRecipesUseCase(repo: recipeRepository),
                getRecipeDetailsUseCase:
                GetRecipeDetailsUseCase(repo: recipeRepository),
                repository: recipeRepository, // ✅ Add repository
              )..add(FetchInitialData()),
              child: RecipeHomeScreen(address: address),
            );
          },
        );

      case searchResults:
        final query = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => SearchResultsScreen(query: query),
        );

      case recipeDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final recipeId = args['recipeId'] as int;
        return MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipeId: recipeId),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
