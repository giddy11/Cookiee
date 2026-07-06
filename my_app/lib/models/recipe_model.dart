class Recipe {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final String difficulty;
  final int cookTimeMinutes;
  final double rating;
  final int reviewCount;

  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.cookTimeMinutes,
    required this.rating,
    required this.reviewCount,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? 'Unknown',
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'difficulty': difficulty,
      'cookTimeMinutes': cookTimeMinutes,
      'rating': rating,
      'reviewCount': reviewCount,
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
