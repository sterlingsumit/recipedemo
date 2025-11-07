import 'package:equatable/equatable.dart';

abstract class RecipePaginatedEvent extends Equatable {
  const RecipePaginatedEvent();
  @override
  List<Object> get props => [];
}

class FetchPaginatedRecipes extends RecipePaginatedEvent {
  final String query;
  final String type; // 'search', 'popular', 'quick', 'vegetarian'
  const FetchPaginatedRecipes({required this.query, required this.type});
  @override
  List<Object> get props => [query, type];
}

class LoadMoreRecipes extends RecipePaginatedEvent {
  final String query;
  final String type;
  const LoadMoreRecipes({required this.query, required this.type});
  @override
  List<Object> get props => [query, type];
}
