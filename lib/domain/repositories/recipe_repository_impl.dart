import '../../data/datasources/recipe_api_data_source.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApiDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Recipe> getPopularRecipe() async {
    try {
      final recipe = await remoteDataSource.fetchPopularRecipe();
      await localDataSource.cacheRecipes([recipe]);
      return recipe;
    } catch (e) {
      final cachedRecipes = await localDataSource.getAllCachedRecipes();
      if (cachedRecipes.isNotEmpty) {
        return cachedRecipes.first;
      }
      rethrow;
    }
  }

  @override
  Future<Recipe> getQuickRecipe() async {
    try {
      final recipe = await remoteDataSource.fetchQuickRecipe();
      await localDataSource.cacheRecipes([recipe]);
      return recipe;
    } catch (e) {
      final cachedRecipes = await localDataSource.getAllCachedRecipes();
      if (cachedRecipes.length > 1) {
        return cachedRecipes[1];
      }
      rethrow;
    }
  }

  @override
  Future<Recipe> getVegetarianRecipe() async {
    try {
      final recipe = await remoteDataSource.fetchVegetarianRecipe();
      await localDataSource.cacheRecipes([recipe]);
      return recipe;
    } catch (e) {
      final cachedRecipes = await localDataSource.getAllCachedRecipes();
      if (cachedRecipes.length > 2) {
        return cachedRecipes[2];
      }
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query, {int page = 1, int pageSize = 10}) async {
    try {
      final recipes = await remoteDataSource.searchRecipes(query, page: page, pageSize: pageSize);
      await localDataSource.cacheRecipes(recipes);
      await localDataSource.cacheSearchResults(query, recipes);
      return recipes;
    } catch (e) {
      // Try to get cached results
      final cachedResults = await localDataSource.getCachedSearchResults(query);
      if (cachedResults != null && cachedResults.isNotEmpty) {
        return cachedResults;
      }
      rethrow;
    }
  }

  @override
  Future<Recipe> getRecipeDetails(int id) async {
    try {
      final recipe = await remoteDataSource.fetchRecipeDetails(id);
      await localDataSource.cacheRecipes([recipe]);
      return recipe;
    } catch (e) {
      final cachedRecipe = await localDataSource.getRecipeById(id);
      if (cachedRecipe != null) {
        return cachedRecipe;
      }
      rethrow;
    }
  }
}
