import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetQuickRecipeUseCase {
  final RecipeRepository repo;
  GetQuickRecipeUseCase({required this.repo});
  Future<Recipe> call() => repo.getQuickRecipe();
}
