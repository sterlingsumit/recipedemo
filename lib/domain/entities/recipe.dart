import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int aggregateLikes;
  final String? description;
  final List<String>? ingredients;
  final List<String>? instructions;
  final int? servings;
  final double? rating;

  const Recipe({
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

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    readyInMinutes,
    aggregateLikes,
    description,
    ingredients,
    instructions,
    servings,
    rating,
  ];

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String? ?? 'https://placehold.co/600x400/grey/white?text=No+Image',
      readyInMinutes: json['readyInMinutes'] as int? ?? 0,
      aggregateLikes: json['aggregateLikes'] as int? ?? 0,
      description: json['summary'] as String?,
      ingredients: List<String>.from(
        json['extendedIngredients']?.map((e) => e['original'] as String) ?? [],
      ),
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
}
