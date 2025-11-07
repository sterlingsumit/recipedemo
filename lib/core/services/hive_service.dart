import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/recipe_hive_model.dart';

class HiveService {
  static const String recipeBoxName = 'recipes';
  static const String searchCacheBoxName = 'search_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeHiveModelAdapter());
    await Hive.openBox<RecipeHiveModel>(recipeBoxName);
    await Hive.openBox(searchCacheBoxName);
  }

  // Save single recipe
  static Future<void> saveRecipe(RecipeHiveModel recipe) async {
    final box = Hive.box<RecipeHiveModel>(recipeBoxName);
    await box.put(recipe.id, recipe);
  }

  // Save multiple recipes
  static Future<void> saveRecipes(List<RecipeHiveModel> recipes) async {
    final box = Hive.box<RecipeHiveModel>(recipeBoxName);
    for (var recipe in recipes) {
      await box.put(recipe.id, recipe);
    }
  }

  // Get recipe by ID
  static Future<RecipeHiveModel?> getRecipe(int id) async {
    final box = Hive.box<RecipeHiveModel>(recipeBoxName);
    return box.get(id);
  }

  // Get all recipes
  static Future<List<RecipeHiveModel>> getAllRecipes() async {
    final box = Hive.box<RecipeHiveModel>(recipeBoxName);
    return box.values.toList();
  }

  // Cache search results
  static Future<void> cacheSearchResults(String query, List<RecipeHiveModel> recipes) async {
    final box = Hive.box(searchCacheBoxName);
    await box.put('search_$query', recipes.map((r) => r.id).toList());
  }

  // Get cached search results
  static Future<List<RecipeHiveModel>?> getCachedSearchResults(String query) async {
    final box = Hive.box(searchCacheBoxName);
    final recipeIds = box.get('search_$query') as List<dynamic>?;

    if (recipeIds == null) return null;

    final recipeBox = Hive.box<RecipeHiveModel>(recipeBoxName);
    return recipeIds
        .map((id) => recipeBox.get(id as int))
        .whereType<RecipeHiveModel>()
        .toList();
  }

  // Clear cache
  static Future<void> clearCache() async {
    final box = Hive.box(searchCacheBoxName);
    await box.clear();
  }
}
