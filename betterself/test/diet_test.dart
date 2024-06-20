// test/diet_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/diet.dart';
import 'package:betterself/models/meal.dart';
import 'package:betterself/models/dish.dart';

void main() {
  group('Diet Model Tests', () {
    test('Diet model should be instantiated correctly', () {
      final dish = Dish(
        id: '1',
        name: 'Salad',
        type: DishType.vegetarian,
        calories: 150,
        price: 5.0,
        isPrepared: false,
        ingredients: ['Lettuce', 'Tomato', 'Cucumber'],
        userId: 'test_user',
      );

      final meal = Meal(
        id: '1',
        dish: dish,
        servingTime: DateTime.now(),
      );

      final diet = Diet(
        id: '1',
        name: 'Healthy Diet',
        userId: 'test_user',
        dailyCalorieGoal: 2000,
        meals: [meal],
      );

      expect(diet.id, '1');
      expect(diet.name, 'Healthy Diet');
      expect(diet.userId, 'test_user');
      expect(diet.dailyCalorieGoal, 2000);
      expect(diet.meals.length, 1);
      expect(diet.totalCalories, 150);
    });

    test('Diet model should convert to map correctly', () {
      final dish = Dish(
        id: '1',
        name: 'Salad',
        type: DishType.vegetarian,
        calories: 150,
        price: 5.0,
        isPrepared: false,
        ingredients: ['Lettuce', 'Tomato', 'Cucumber'],
        userId: 'test_user',
      );

      final meal = Meal(
        id: '1',
        dish: dish,
        servingTime: DateTime.now(),
      );

      final diet = Diet(
        id: '1',
        name: 'Healthy Diet',
        userId: 'test_user',
        dailyCalorieGoal: 2000,
        meals: [meal],
      );

      final dietMap = diet.toMap();
      expect(dietMap['id'], '1');
      expect(dietMap['name'], 'Healthy Diet');
      expect(dietMap['userId'], 'test_user');
      expect(dietMap['dailyCalorieGoal'], 2000);
      expect(dietMap['meals'].length, 1);
      expect(dietMap['meals'][0]['id'], '1');
    });

    test('Diet model should be instantiated from map correctly', () {
      final dishMap = {
        'id': '1',
        'name': 'Salad',
        'type': 'vegetarian',
        'calories': 150,
        'price': 5.0,
        'isPrepared': false,
        'ingredients': ['Lettuce', 'Tomato', 'Cucumber'],
        'userId': 'test_user',
      };

      final mealMap = {
        'id': '1',
        'dish': dishMap,
        'servingTime': DateTime.now().toIso8601String(),
      };

      final dietMap = {
        'id': '1',
        'name': 'Healthy Diet',
        'userId': 'test_user',
        'dailyCalorieGoal': 2000,
        'meals': [mealMap],
      };

      final diet = Diet.fromMap(dietMap);

      expect(diet.id, '1');
      expect(diet.name, 'Healthy Diet');
      expect(diet.userId, 'test_user');
      expect(diet.dailyCalorieGoal, 2000);
      expect(diet.meals.length, 1);
      expect(diet.totalCalories, 150);
    });
  });
}
