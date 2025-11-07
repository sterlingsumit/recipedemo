import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipeDetailsUseCase {
  final RecipeRepository repo;
  GetRecipeDetailsUseCase({required this.repo});
  Future<Recipe> call(int id) => repo.getRecipeDetails(id);
}
