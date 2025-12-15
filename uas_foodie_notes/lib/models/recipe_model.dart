class Recipe {
  final String id;
  final String name;
  final String thumb;

  Recipe({required this.id, required this.name, required this.thumb});

  // Mengubah JSON dari API menjadi Objek Recipe
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      thumb: json['strMealThumb'],
    );
  }
}