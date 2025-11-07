import 'package:equatable/equatable.dart';
import 'package:recipe_discovery_app/domain/entities/recipe.dart';

enum RecipeStatus { initial, loading, loaded, error }

class RecipeState extends Equatable {
  const RecipeState({
    this.status = RecipeStatus.initial,
    this.popularRecipe,
    this.quickRecipe,
    this.vegetarianRecipe,
    this.recipeDetails,
    this.searchResults = const [],
    this.errorMessage,
  });

  final Recipe? recipeDetails;
  final RecipeStatus status;
  final Recipe? popularRecipe;
  final Recipe? quickRecipe;
  final Recipe? vegetarianRecipe;
  final List<Recipe> searchResults;
  final String? errorMessage;

  factory RecipeState.initial() => const RecipeState();

  RecipeState copyWith({
    RecipeStatus? status,
    Recipe? popularRecipe,
    Recipe? quickRecipe,
    Recipe? vegetarianRecipe,
    List<Recipe>? searchResults,
    String? errorMessage,  Recipe? recipeDetails,
  }) {
    return RecipeState(
      status: status ?? this.status,
      popularRecipe: popularRecipe ?? this.popularRecipe,
      quickRecipe: quickRecipe ?? this.quickRecipe,
      vegetarianRecipe: vegetarianRecipe ?? this.vegetarianRecipe,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
      recipeDetails:  recipeDetails ?? this.recipeDetails,
    );
  }

  @override
  List<Object?> get props => [
    status,
    popularRecipe,
    quickRecipe,
    vegetarianRecipe,
    searchResults,
    errorMessage
  ];
}
