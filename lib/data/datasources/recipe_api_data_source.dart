import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/recipe.dart';
import '../../../../core/constants/api_constants.dart';

abstract class RecipeApiDataSource {
  Future<Recipe> fetchPopularRecipe();
  Future<Recipe> fetchQuickRecipe();
  Future<Recipe> fetchVegetarianRecipe();
  Future<List<Recipe>> searchRecipes(String query, {int page = 1, int pageSize = 10});
  Future<Recipe> fetchRecipeDetails(int id);
}

class RecipeApiDataSourceImpl implements RecipeApiDataSource {
  final http.Client client;

  RecipeApiDataSourceImpl({required this.client});

  Future<Map<String, dynamic>> _get(String endpoint,
      [Map<String, String>? params]) async {
    final queryParams = {'apiKey': ApiConstants.apiKey, ...?params};
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: queryParams,
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 402) {
      throw Exception('API limit reached. Please check your Spoonacular plan.');
    } else {
      throw Exception(
          'Failed to load data (Status Code: ${response.statusCode})');
    }
  }

  @override
  Future<Recipe> fetchPopularRecipe() async {
    final response = await _get('/recipes/random', {'number': '1'});
    final recipes = response['recipes'] as List;
    if (recipes.isEmpty) throw Exception("No popular recipes found.");
    return Recipe.fromJson(recipes.first as Map<String, dynamic>);
  }

  @override
  Future<Recipe> fetchQuickRecipe() async {
    final response = await _get(
        '/recipes/complexSearch', {'maxReadyTime': '30', 'number': '1'});
    final results = response['results'] as List;
    if (results.isEmpty) throw Exception("No quick recipes found.");
    return Recipe.fromJson(results.first as Map<String, dynamic>);
  }

  @override
  Future<Recipe> fetchVegetarianRecipe() async {
    final response = await _get('/recipes/complexSearch',
        {'diet': 'vegetarian', 'number': '1'});
    final results = response['results'] as List;
    if (results.isEmpty) throw Exception("No vegetarian recipes found.");
    return Recipe.fromJson(results.first as Map<String, dynamic>);
  }

  @override
  Future<List<Recipe>> searchRecipes(String query, {int page = 1, int pageSize = 10}) async {
    final offset = (page - 1) * pageSize;
    final response = await _get('/recipes/complexSearch', {
      'query': query,
      'number': pageSize.toString(),
      'offset': offset.toString(),
      'addRecipeInformation': 'true',
      'fillIngredients': 'true',
    });
    final results = response['results'] as List<dynamic>? ?? [];
    return results
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Recipe> fetchRecipeDetails(int id) async {
    final response = await _get('/recipes/$id/information', {
      'includeNutrition': 'false',
      'addWinePairing': 'false',
    });
    return Recipe.fromJson(response);
  }
}
