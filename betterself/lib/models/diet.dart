// lib/models/diet.dart
import 'meal.dart';

class Diet {
  int dailyCalorieGoal;
  List<Meal> meals;

  Diet({
    required this.dailyCalorieGoal,
    required this.meals,
  });
}
