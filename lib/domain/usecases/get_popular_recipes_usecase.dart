import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetPopularRecipeUseCase {
  final RecipeRepository repo;
  GetPopularRecipeUseCase({required this.repo});
  Future<Recipe> call() => repo.getPopularRecipe();
}
