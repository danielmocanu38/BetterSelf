// lib/models/ingredient.dart
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'calories': calories,
      'price': price,
    };
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      type: map['type'],
      calories: map['calories'],
      price: map['price'],
    );
  }
}
