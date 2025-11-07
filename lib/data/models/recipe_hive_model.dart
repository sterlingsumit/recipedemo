import 'package:hive/hive.dart';
import '../../domain/entities/recipe.dart';

part 'recipe_hive_model.g.dart';

@HiveType(typeId: 0)
class RecipeHiveModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final int readyInMinutes;

  @HiveField(4)
  final int aggregateLikes;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final List<String>? ingredients;

  @HiveField(7)
  final List<String>? instructions;

  @HiveField(8)
  final int? servings;

  @HiveField(9)
  final double? rating;

  RecipeHiveModel({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.aggregateLikes,
    this.description,
    this.ingredients,
    this.instructions,
    this.servings,
    this.rating,
  });

  factory RecipeHiveModel.fromJson(Map<String, dynamic> json) {
    return RecipeHiveModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String? ?? 'https://placehold.co/600x400/grey/white?text=No+Image',
      readyInMinutes: json['readyInMinutes'] as int? ?? 0,
      aggregateLikes: json['aggregateLikes'] as int? ?? 0,
      description: json['summary'] as String?,
      ingredients: List<String>.from(json['extendedIngredients']?.map((e) => e['original'] as String) ?? []),
      instructions: _parseInstructions(json['analyzedInstructions']),
      servings: json['servings'] as int?,
      rating: (json['healthScore'] as num?)?.toDouble(),
    );
  }

  static List<String>? _parseInstructions(dynamic analyzed) {
    if (analyzed == null || (analyzed as List).isEmpty) return null;
    return List<String>.from(
      analyzed[0]['steps']?.map((step) => step['step'] as String) ?? [],
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id,
      title: title,
      image: image,
      readyInMinutes: readyInMinutes,
      aggregateLikes: aggregateLikes,
      description: description,
      ingredients: ingredients,
      instructions: instructions,
      servings: servings,
      rating: rating,
    );
  }
}
