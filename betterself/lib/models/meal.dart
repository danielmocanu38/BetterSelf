// lib/models/meal.dart
class Ingredient {
  String name;
  String type;
  int calories;
  double price;

  Ingredient({
    required this.name,
    required this.type,
    required this.calories,
    required this.price,
  });
}

class Meal {
  String id;
  String name;
  String type; // e.g., breakfast, lunch, dinner
  int calories;
  double price;
  bool isPrepared;
  List<Ingredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.price,
    required this.isPrepared,
    this.ingredients = const [],
  });

  void calculateProperties() {
    if (ingredients.isNotEmpty) {
      calories = ingredients.fold(0, (sum, item) => sum + item.calories);
      price = ingredients.fold(0, (sum, item) => sum + item.price);
    }
  }
}
