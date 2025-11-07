import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class SearchRecipesUseCase {
  final RecipeRepository repo;
  SearchRecipesUseCase({required this.repo});

  Future<List<Recipe>> call(String query, {int page = 1, int pageSize = 10}) =>
      repo.searchRecipes(query, page: page, pageSize: pageSize);
}
