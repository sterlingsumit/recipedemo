import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_discovery_app/main.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/get_popular_recipes_usecase.dart';
import '../../domain/usecases/get_quick_recipes_usecase.dart';
import '../../domain/usecases/get_recipe_details_usecase.dart';
import '../../domain/usecases/get_vegetarian_recipes_usecase.dart';
import '../../domain/usecases/search_recipes_usecase.dart';
import '../blocs/recipe/get_recipe_bloc.dart';
import '../blocs/recipe/get_recipe_event.dart';
import '../blocs/recipe/get_recipe_state.dart';


class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          var repository = recipeRepository;
          // Reuse RecipeBloc for detail screen or create a specific one
          return RecipeBloc(
            getPopularRecipeUseCase:
            GetPopularRecipeUseCase(repo: repository),
            getQuickRecipeUseCase:
            GetQuickRecipeUseCase(repo: repository),
            getVegetarianRecipeUseCase:
            GetVegetarianRecipeUseCase(repo: repository),
            searchRecipesUseCase:
            SearchRecipesUseCase(repo: repository),
            getRecipeDetailsUseCase:
            GetRecipeDetailsUseCase(repo: repository),
            repository: repository,
          )..add(FetchInitialData())..add(FetchRecipeDetails(recipeId));
        },
        child: _RecipeDetailView(recipeId: recipeId),
      ),
    );
  }
}

class _RecipeDetailView extends StatelessWidget {
  final int recipeId;

  const _RecipeDetailView({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      bloc: context.read<RecipeBloc>(),
      builder: (context, state) {
        if (state.status == RecipeStatus.loading &&
            state.recipeDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == RecipeStatus.error &&
            state.recipeDetails == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Failed to load recipe'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        final recipe = state.recipeDetails;
        if (recipe == null) {
          return const Center(child: Text('Recipe not found'));
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(recipe.title),
                background: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoCard(
                          icon: Icons.timer,
                          label: 'Time',
                          value: '${recipe.readyInMinutes} min',
                        ),
                        _InfoCard(
                          icon: Icons.people,
                          label: 'Servings',
                          value: '${recipe.servings ?? 'N/A'}',
                        ),
                        _InfoCard(
                          icon: Icons.star,
                          label: 'Rating',
                          value: '${recipe.rating?.toStringAsFixed(1) ?? 'N/A'}',
                        ),
                        _InfoCard(
                          icon: Icons.thumb_up,
                          label: 'Likes',
                          value: recipe.aggregateLikes.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    if (recipe.description != null) ...[
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Ingredients
                    if (recipe.ingredients != null &&
                        recipe.ingredients!.isNotEmpty) ...[
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...recipe.ingredients!.map((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 18, color: Colors.green),
                              const SizedBox(width: 12),
                              Expanded(child: Text(ingredient)),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                    ],

                    // Instructions
                    if (recipe.instructions != null &&
                        recipe.instructions!.isNotEmpty) ...[
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        recipe.instructions!.length,
                            (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    recipe.instructions![index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
