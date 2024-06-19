import 'meal.dart';

class Diet {
  final String id;
  final String name;
  String userId;
  final int dailyCalorieGoal;
  final List<Meal> meals;

  Diet({
    required this.id,
    required this.name,
    required this.userId,
    required this.dailyCalorieGoal,
    required this.meals,
  });

  int get totalCalories {
    return meals.fold(0, (sum, meal) => sum + meal.dish.calories);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'dailyCalorieGoal': dailyCalorieGoal,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }

  factory Diet.fromMap(Map<String, dynamic> map) {
    return Diet(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      dailyCalorieGoal: map['dailyCalorieGoal'],
      meals: List<Meal>.from(map['meals']?.map((x) => Meal.fromMap(x))),
    );
  }
}
