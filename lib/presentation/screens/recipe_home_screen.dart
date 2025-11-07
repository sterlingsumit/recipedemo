import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_discovery_app/core/routes/app_router.dart';
import 'package:recipe_discovery_app/presentation/blocs/recipe/get_recipe_bloc.dart';
import 'package:recipe_discovery_app/presentation/blocs/recipe/get_recipe_event.dart';
import 'package:recipe_discovery_app/presentation/blocs/recipe/get_recipe_state.dart';
import '../../domain/entities/recipe.dart';


class RecipeHomeScreen extends StatelessWidget {
  final address;
  const RecipeHomeScreen({super.key,required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hi User"),
            Text(
              address,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],

              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      toolbarHeight: 70,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: _buildSearchBar(context),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search recipes by name...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.read<RecipeBloc>().add(RecipesSearched(query));
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state.status == RecipeStatus.loading && state.popularRecipe == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == RecipeStatus.error && state.popularRecipe == null) {
          return Center(
            child: Text(
              state.errorMessage ?? "Failed to load recipes.",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.status == RecipeStatus.loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Center(child: CircularProgressIndicator()),
              ),

            if (state.searchResults.isNotEmpty)
              _buildSearchResults(context, state.searchResults),

            if (state.searchResults.isEmpty) ...[
              state.status == RecipeStatus.loading ? SizedBox() : const Text("No Recipies found for search text",textAlign: TextAlign.center,),
              _buildSection(
                context: context,
                title: "Popular Recipe",
                recipe: state.popularRecipe,
                isLoading: state.status == RecipeStatus.loading,
                onViewAll: () {},
              ),
              const SizedBox(height: 24),
              _buildSection(
                context: context,
                title: "Quick Recipe",
                recipe: state.quickRecipe,
                isLoading: state.status == RecipeStatus.loading,
                onViewAll: () {},
              ),
              const SizedBox(height: 24),
              _buildSection(
                context: context,
                title: "Vegetarian Recipe",
                recipe: state.vegetarianRecipe,
                isLoading: state.status == RecipeStatus.loading,
                onViewAll: () {},
              ),
            ]
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Recipe> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Results",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...results
            .map((recipe) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRecipeTile(recipe,context),
        ))
            .toList(),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Recipe? recipe,
    required bool isLoading,
    required VoidCallback onViewAll,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: onViewAll,
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recipe != null)
          _buildRecipeTile(recipe,context)
        else if (isLoading)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text("Loading...")),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text("No recipe found.")),
          ),
      ],
    );
  }

  Widget _buildRecipeTile(Recipe recipe,BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRouter.recipeDetail,arguments: {"recipeId":recipe.id});
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${recipe.readyInMinutes} min"),
                      const SizedBox(width: 16),
                      const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(recipe.aggregateLikes.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
