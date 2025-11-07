import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';

enum RecipePaginatedStatus { initial, loading, loaded, error }

class RecipePaginatedState extends Equatable {
  const RecipePaginatedState({
    this.status = RecipePaginatedStatus.initial,
    this.recipes = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
  });

  final RecipePaginatedStatus status;
  final List<Recipe> recipes;
  final String? errorMessage;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  factory RecipePaginatedState.initial() => const RecipePaginatedState();

  RecipePaginatedState copyWith({
    RecipePaginatedStatus? status,
    List<Recipe>? recipes,
    String? errorMessage,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore, required recipeDetails,
  }) {
    return RecipePaginatedState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    recipes,
    errorMessage,
    currentPage,
    hasMorePages,
    isLoadingMore,
  ];
}
