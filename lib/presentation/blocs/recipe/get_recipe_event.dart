import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
 const RecipeEvent();
 @override
 List<Object> get props => [];
}
class FetchRecipeDetails extends RecipeEvent {
 final int recipeId;
 const FetchRecipeDetails(this.recipeId);
 @override
 List<Object> get props => [recipeId];
}

class FetchInitialData extends RecipeEvent {}

class RecipesSearched extends RecipeEvent {
 final String query;
 const RecipesSearched(this.query);
 @override
 List<Object> get props => [query];
}
