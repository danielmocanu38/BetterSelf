enum DishType { vegetarian, vegan, meat, seafood, dessert, other }

class Dish {
  String id;
  String name;
  DishType type;
  int calories;
  double price;
  bool isPrepared;
  List<String> ingredients;
  String userId;

  Dish({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.price,
    required this.isPrepared,
    this.ingredients = const [],
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'calories': calories,
      'price': price,
      'isPrepared': isPrepared,
      'ingredients': ingredients,
      'userId': userId,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id'],
      name: map['name'],
      type: DishType.values
          .firstWhere((e) => e.toString().split('.').last == map['type']),
      calories: map['calories'],
      price: map['price'],
      isPrepared: map['isPrepared'],
      ingredients: List<String>.from(map['ingredients']),
      userId: map['userId'],
    );
  }
}
