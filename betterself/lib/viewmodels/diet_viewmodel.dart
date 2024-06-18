// lib/viewmodels/diet_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/diet.dart';

class DietViewModel extends ChangeNotifier {
  final List<Meal> _meals = [];
  final Diet _diet = Diet(dailyCalorieGoal: 2000, meals: []);

  List<Meal> get meals => _meals;
  Diet get diet => _diet;

  void addMeal(Meal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void removeMeal(String id) {
    _meals.removeWhere((meal) => meal.id == id);
    notifyListeners();
  }

  void updateMeal(Meal meal) {
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
      notifyListeners();
    }
  }

  void setDailyCalorieGoal(int goal) {
    _diet.dailyCalorieGoal = goal;
    notifyListeners();
  }
}
