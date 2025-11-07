import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_discovery_app/domain/entities/recipe.dart';
import 'package:recipe_discovery_app/domain/repositories/recipe_repository.dart';
import 'package:recipe_discovery_app/domain/usecases/get_popular_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_quick_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_vegetarian_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/search_recipes_usecase.dart';
import 'package:recipe_discovery_app/domain/usecases/get_recipe_details_usecase.dart';

import 'get_recipe_event.dart';
import 'get_recipe_state.dart';


class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetPopularRecipeUseCase _getPopularRecipeUseCase;
  final GetQuickRecipeUseCase _getQuickRecipeUseCase;
  final GetVegetarianRecipeUseCase _getVegetarianRecipeUseCase;
  final SearchRecipesUseCase _searchRecipesUseCase;
  final GetRecipeDetailsUseCase _getRecipeDetailsUseCase;
  final RecipeRepository _repository; // ✅ Add this

  RecipeBloc({
    required GetPopularRecipeUseCase getPopularRecipeUseCase,
    required GetQuickRecipeUseCase getQuickRecipeUseCase,
    required GetVegetarianRecipeUseCase getVegetarianRecipeUseCase,
    required SearchRecipesUseCase searchRecipesUseCase,
    required GetRecipeDetailsUseCase getRecipeDetailsUseCase,
    required RecipeRepository repository, // ✅ Add this parameter
  })  : _getPopularRecipeUseCase = getPopularRecipeUseCase,
        _getQuickRecipeUseCase = getQuickRecipeUseCase,
        _getVegetarianRecipeUseCase = getVegetarianRecipeUseCase,
        _searchRecipesUseCase = searchRecipesUseCase,
        _getRecipeDetailsUseCase = getRecipeDetailsUseCase,
        _repository = repository, // ✅ Assign it here
        super(RecipeState.initial()) {
    on<FetchInitialData>(_onFetchInitialData);
    on<RecipesSearched>(_onRecipesSearched);
    on<FetchRecipeDetails>(_onFetchRecipeDetails);
  }

  Future<void> _onFetchRecipeDetails(
      FetchRecipeDetails event,
      Emitter<RecipeState> emit,
      ) async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      // Use the use case instead
      final recipe = await _getRecipeDetailsUseCase(event.recipeId);
      emit(state.copyWith(
        status: RecipeStatus.loaded,
        recipeDetails: recipe,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecipeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchInitialData(
      FetchInitialData event,
      Emitter<RecipeState> emit,
      ) async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      final results = await Future.wait([
        _getPopularRecipeUseCase(),
        _getQuickRecipeUseCase(),
        _getVegetarianRecipeUseCase(),
      ]);

      emit(state.copyWith(
        status: RecipeStatus.loaded,
        popularRecipe: results[0] as Recipe,
        quickRecipe: results[1] as Recipe,
        vegetarianRecipe: results[2] as Recipe,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecipeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRecipesSearched(
      RecipesSearched event,
      Emitter<RecipeState> emit,
      ) async {
    emit(state.copyWith(status: RecipeStatus.loading, searchResults: []));
    try {
      final results = await _searchRecipesUseCase(event.query);
      emit(state.copyWith(
        status: RecipeStatus.loaded,
        searchResults: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecipeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
