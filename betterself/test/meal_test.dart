// test/meal_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/meal.dart';
import 'package:betterself/models/dish.dart';

void main() {
  group('Meal Model Tests', () {
    test('Meal model should be instantiated correctly', () {
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

      expect(meal.id, '1');
      expect(meal.dish, dish);
      expect(meal.servingTime, isNotNull);
    });

    test('Meal model should convert to map correctly', () {
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

      final mealMap = meal.toMap();
      expect(mealMap['id'], '1');
      expect(mealMap['dish']['id'], '1');
      expect(mealMap['servingTime'], isNotNull);
    });

    test('Meal model should be instantiated from map correctly', () {
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

      final meal = Meal.fromMap(mealMap);

      expect(meal.id, '1');
      expect(meal.dish.id, '1');
      expect(meal.servingTime, isNotNull);
    });
  });
}
