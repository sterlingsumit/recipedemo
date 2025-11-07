import '../../domain/entities/recipe.dart';
import '../models/recipe_hive_model.dart';
import 'package:recipe_discovery_app/core/services/hive_service.dart';

abstract class RecipeLocalDataSource {
  Future<void> cacheRecipes(List<Recipe> recipes);
  Future<Recipe?> getRecipeById(int id);
  Future<List<Recipe>> getAllCachedRecipes();
  Future<void> cacheSearchResults(String query, List<Recipe> recipes);
  Future<List<Recipe>?> getCachedSearchResults(String query);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  @override
  Future<void> cacheRecipes(List<Recipe> recipes) async {
    final hiveModels = recipes
        .map((r) => RecipeHiveModel(
      id: r.id,
      title: r.title,
      image: r.image,
      readyInMinutes: r.readyInMinutes,
      aggregateLikes: r.aggregateLikes,
      description: r.description,
      ingredients: r.ingredients,
      instructions: r.instructions,
      servings: r.servings,
      rating: r.rating,
    ))
        .toList();
    await HiveService.saveRecipes(hiveModels);
  }

  @override
  Future<Recipe?> getRecipeById(int id) async {
    final hiveModel = await HiveService.getRecipe(id);
    return hiveModel?.toEntity();
  }

  @override
  Future<List<Recipe>> getAllCachedRecipes() async {
    final hiveModels = await HiveService.getAllRecipes();
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> cacheSearchResults(String query, List<Recipe> recipes) async {
    final hiveModels = recipes
        .map((r) => RecipeHiveModel(
      id: r.id,
      title: r.title,
      image: r.image,
      readyInMinutes: r.readyInMinutes,
      aggregateLikes: r.aggregateLikes,
      description: r.description,
      ingredients: r.ingredients,
      instructions: r.instructions,
      servings: r.servings,
      rating: r.rating,
    ))
        .toList();
    await HiveService.cacheSearchResults(query, hiveModels);
  }

  @override
  Future<List<Recipe>?> getCachedSearchResults(String query) async {
    final cachedModels = await HiveService.getCachedSearchResults(query);
    return cachedModels?.map((m) => m.toEntity()).toList();
  }
}
