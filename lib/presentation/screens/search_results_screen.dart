import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/search_recipes_usecase.dart';

import '../blocs/pagination/recipe_paginated_bloc.dart';
import '../blocs/pagination/recipe_paginated_event.dart';
import '../blocs/pagination/recipe_paginated_state.dart';
import 'recipe_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipePaginatedBloc(
        searchRecipesUseCase: SearchRecipesUseCase(
          repo: context.read<RecipeRepository>(),
        ),
      )..add(FetchPaginatedRecipes(query: query, type: 'search')),
      child: _SearchResultsView(query: query),
    );
  }
}

class _SearchResultsView extends StatefulWidget {
  final String query;

  const _SearchResultsView({Key? key, required this.query}) : super(key: key);

  @override
  State<_SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<_SearchResultsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<RecipePaginatedBloc>().add(
        LoadMoreRecipes(query: widget.query, type: 'search'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
        elevation: 0,
      ),
      body: BlocBuilder<RecipePaginatedBloc, RecipePaginatedState>(
        builder: (context, state) {
          if (state.status == RecipePaginatedStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == RecipePaginatedStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load recipes',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.recipes.isEmpty) {
            return const Center(
              child: Text('No recipes found'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: state.recipes.length + (state.hasMorePages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.recipes.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final recipe = state.recipes[index];
              return _RecipeListTile(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}

class _RecipeListTile extends StatelessWidget {
  final dynamic recipe;

  const _RecipeListTile({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipeDetail',
          arguments: {'recipeId': recipe.id},
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                recipe.image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${recipe.readyInMinutes} min'),
                        const SizedBox(width: 16),
                        const Icon(Icons.thumb_up, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(recipe.aggregateLikes.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
