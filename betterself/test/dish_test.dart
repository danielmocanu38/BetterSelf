import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/dish.dart';

void main() {
  group('Dish Model Tests', () {
    test('Dish model should be instantiated correctly', () {
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

      expect(dish.id, '1');
      expect(dish.name, 'Salad');
      expect(dish.type, DishType.vegetarian);
      expect(dish.calories, 150);
      expect(dish.price, 5.0);
      expect(dish.isPrepared, false);
      expect(dish.ingredients, ['Lettuce', 'Tomato', 'Cucumber']);
      expect(dish.userId, 'test_user');
    });

    test('Dish model should convert to map correctly', () {
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

      final dishMap = dish.toMap();
      expect(dishMap['id'], '1');
      expect(dishMap['name'], 'Salad');
      expect(dishMap['type'], 'vegetarian');
      expect(dishMap['calories'], 150);
      expect(dishMap['price'], 5.0);
      expect(dishMap['isPrepared'], false);
      expect(dishMap['ingredients'], ['Lettuce', 'Tomato', 'Cucumber']);
      expect(dishMap['userId'], 'test_user');
    });

    test('Dish model should be instantiated from map correctly', () {
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

      final dish = Dish.fromMap(dishMap);

      expect(dish.id, '1');
      expect(dish.name, 'Salad');
      expect(dish.type, DishType.vegetarian);
      expect(dish.calories, 150);
      expect(dish.price, 5.0);
      expect(dish.isPrepared, false);
      expect(dish.ingredients, ['Lettuce', 'Tomato', 'Cucumber']);
      expect(dish.userId, 'test_user');
    });
  });
}
