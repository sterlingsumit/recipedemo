import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_recipes_usecase.dart';

import '../recipe/get_recipe_event.dart';
import '../recipe/get_recipe_state.dart';
import 'recipe_paginated_event.dart';
import 'recipe_paginated_state.dart';

class RecipePaginatedBloc
    extends Bloc<RecipePaginatedEvent, RecipePaginatedState> {
  final SearchRecipesUseCase searchRecipesUseCase;
  static const int pageSize = 10;

  RecipePaginatedBloc({required this.searchRecipesUseCase})
      : super(RecipePaginatedState.initial()) {
    on<FetchPaginatedRecipes>(_onFetchPaginatedRecipes);
    on<LoadMoreRecipes>(_onLoadMoreRecipes);
  }

  

  Future<void> _onFetchPaginatedRecipes(
      FetchPaginatedRecipes event,
      Emitter<RecipePaginatedState> emit,
      ) async {
    emit(state.copyWith(status: RecipePaginatedStatus.loading, recipeDetails: null));
    try {
      final recipes = await searchRecipesUseCase(
        event.query,
        page: 1,
        pageSize: pageSize,
      );

      emit(state.copyWith(
        status: RecipePaginatedStatus.loaded,
        recipes: recipes,
        currentPage: 1,
        hasMorePages: recipes.length >= pageSize, recipeDetails: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecipePaginatedStatus.error,
        errorMessage: e.toString(), recipeDetails: null,
      ));
    }
  }

  Future<void> _onLoadMoreRecipes(
      LoadMoreRecipes event,
      Emitter<RecipePaginatedState> emit,
      ) async {
    if (!state.hasMorePages || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, recipeDetails: null));
    try {
      final nextPage = state.currentPage + 1;
      final newRecipes = await searchRecipesUseCase(
        event.query,
        page: nextPage,
        pageSize: pageSize,
      );

      if (newRecipes.isEmpty || newRecipes.length < pageSize) {
        emit(state.copyWith(
          recipes: [...state.recipes, ...newRecipes],
          currentPage: nextPage,
          hasMorePages: false,
          isLoadingMore: false, recipeDetails: null,
        ));
      } else {
        emit(state.copyWith(
          recipes: [...state.recipes, ...newRecipes],
          currentPage: nextPage,
          hasMorePages: true,
          isLoadingMore: false, recipeDetails: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(), recipeDetails: null,
      ));
    }
  }
}
