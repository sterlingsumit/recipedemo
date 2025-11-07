import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Recipe> getPopularRecipe();
  Future<Recipe> getQuickRecipe();
  Future<Recipe> getVegetarianRecipe();
  Future<List<Recipe>> searchRecipes(String query, {int page = 1, int pageSize = 10});
  Future<Recipe> getRecipeDetails(int id);
}
