class Recipe {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final String difficulty;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final double rating;
  final int reviewCount;
  final int servings;
  final int caloriesPerServing;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags;
  final List<String> mealType;

  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.cookTimeMinutes,
    required this.rating,
    required this.reviewCount,
    this.prepTimeMinutes = 0,
    this.servings = 0,
    this.caloriesPerServing = 0,
    this.ingredients = const [],
    this.instructions = const [],
    this.tags = const [],
    this.mealType = const [],
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  /// Recipes have no price in the source API. This app treats each recipe as
  /// an orderable meal kit, so we derive a stable mock price per recipe
  /// (deterministic on `id`, not random) purely so cart totals mean something.
  double get price => 8.99 + (id % 12);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? 'Unknown',
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      servings: json['servings'] as int? ?? 0,
      caloriesPerServing: json['caloriesPerServing'] as int? ?? 0,
      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      instructions: (json['instructions'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
      mealType: (json['mealType'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'difficulty': difficulty,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'rating': rating,
      'reviewCount': reviewCount,
      'servings': servings,
      'caloriesPerServing': caloriesPerServing,
      'ingredients': ingredients,
      'instructions': instructions,
      'tags': tags,
      'mealType': mealType,
    };
  }
}

class RecipeResponse {
  final List<Recipe> recipes;
  final int total;

  const RecipeResponse({required this.recipes, required this.total});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    final list = json['recipes'] as List? ?? [];
    return RecipeResponse(
      recipes: list
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
    );
  }
}
