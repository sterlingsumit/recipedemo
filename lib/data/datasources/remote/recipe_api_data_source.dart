import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

abstract class RecipeApiDataSource {
  Future<Map<String, dynamic>> fetchPopularRecipe();
  Future<Map<String, dynamic>> fetchQuickRecipe();
  Future<Map<String, dynamic>> fetchVegetarianRecipe();
  Future<List<dynamic>> searchRecipes(String query);
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
      throw Exception('Failed to load data (Status Code: ${response.statusCode})');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPopularRecipe() async {
    final response = await _get('/recipes/random', {'number': '1'});
    final recipes = response['recipes'] as List;
    if (recipes.isEmpty) throw Exception("No popular recipes found.");
    return recipes.first as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> fetchQuickRecipe() async {
    final response = await _get('/recipes/complexSearch', {'maxReadyTime': '30', 'number': '1'});
    final results = response['results'] as List;
    if (results.isEmpty) throw Exception("No quick recipes found.");
    return results.first as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> fetchVegetarianRecipe() async {
    final response = await _get('/recipes/complexSearch', {'diet': 'vegetarian', 'number': '1'});
    final results = response['results'] as List;
    if (results.isEmpty) throw Exception("No vegetarian recipes found.");
    return results.first as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await _get('/recipes/complexSearch', {'query': query, 'number': '10'});
    return response['results'] as List<dynamic>;
  }
}
