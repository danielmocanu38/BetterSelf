// test/diet_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betterself/viewmodels/diet_viewmodel.dart';
import 'package:betterself/models/dish.dart';
import 'package:betterself/models/diet.dart';
import 'package:betterself/models/meal.dart';
import 'mock.dart';
import 'diet_viewmodel_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  FirebaseAuth,
  User
])
void main() {
  setupFirebaseMocks();

  group('DietViewModel Tests', () {
    late DietViewModel viewModel;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUpAll(() async {
      await Firebase.initializeApp();
    });

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async => {});
      when(mockDocumentReference.delete()).thenAnswer((_) async => {});
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_user');

      viewModel = DietViewModel();
      viewModel.setFirestore(mockFirestore);
      viewModel.setFirebaseAuth(mockFirebaseAuth);
    });

    test('Add and remove dish', () async {
      final dish = Dish(
        id: '1',
        name: 'Test Dish',
        type: DishType.vegetarian,
        calories: 200,
        price: 10.0,
        isPrepared: false,
        userId: 'test_user',
      );

      await viewModel.addDish(dish);
      expect(viewModel.dishes.length, 1);
      expect(viewModel.dishes[0].id, dish.id);

      await viewModel.removeDish(dish.id);
      expect(viewModel.dishes.length, 0);
    });

    test('Add and remove diet', () async {
      final diet = Diet(
        id: '1',
        name: 'Test Diet',
        userId: 'test_user',
        dailyCalorieGoal: 2000,
        meals: [],
      );

      await viewModel.addDiet(diet);
      expect(viewModel.diets.length, 1);
      expect(viewModel.diets[0].id, diet.id);

      await viewModel.removeDiet(diet.id);
      expect(viewModel.diets.length, 0);
    });

    test('Update dish', () async {
      final dish = Dish(
        id: '2',
        name: 'Test Dish 2',
        type: DishType.vegan,
        calories: 250,
        price: 12.0,
        isPrepared: false,
        userId: 'test_user',
      );

      await viewModel.addDish(dish);
      final updatedDish = Dish(
        id: '2',
        name: 'Updated Dish 2',
        type: DishType.vegan,
        calories: 300,
        price: 15.0,
        isPrepared: true,
        userId: 'test_user',
      );

      await viewModel.updateDish(updatedDish);
      expect(viewModel.dishes.length, 1);
      expect(viewModel.dishes[0].name, 'Updated Dish 2');
    });

    test('Update diet', () async {
      final diet = Diet(
        id: '3',
        name: 'Test Diet 3',
        userId: 'test_user',
        dailyCalorieGoal: 1800,
        meals: [],
      );

      await viewModel.addDiet(diet);
      final updatedDiet = Diet(
        id: '3',
        name: 'Updated Diet 3',
        userId: 'test_user',
        dailyCalorieGoal: 1500,
        meals: [],
      );

      await viewModel.updateDiet(updatedDiet);
      expect(viewModel.diets.length, 1);
      expect(viewModel.diets[0].name, 'Updated Diet 3');
    });

    test('Add and remove meal from diet', () async {
      final dish = Dish(
        id: '1',
        name: 'Test Dish',
        type: DishType.vegetarian,
        calories: 200,
        price: 10.0,
        isPrepared: false,
        userId: 'test_user',
      );
      final meal = Meal(
        id: '1',
        dish: dish,
        servingTime: DateTime(2022, 10, 10),
      );

      final diet = Diet(
        id: '4',
        name: 'Test Diet 4',
        userId: 'test_user',
        dailyCalorieGoal: 2000,
        meals: [],
      );

      await viewModel.addDiet(diet);
      await viewModel.addMealToDiet(diet.id, meal);
      expect(viewModel.diets.length, 1);
      expect(viewModel.diets[0].meals.length, 1);

      await viewModel.removeMealFromDiet(diet.id, meal.id);
      expect(viewModel.diets[0].meals.length, 0);
    });
  });
}
