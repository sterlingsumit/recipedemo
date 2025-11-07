import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetVegetarianRecipeUseCase {
  final RecipeRepository repo;
  GetVegetarianRecipeUseCase({required this.repo});
  Future<Recipe> call() => repo.getVegetarianRecipe();
}
