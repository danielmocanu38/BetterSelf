import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish.dart';
import '../models/diet.dart';
import '../models/meal.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietViewModel extends ChangeNotifier {
  final List<Dish> _dishes = [];
  final List<Diet> _diets = [];

  List<Dish> get dishes => _dishes;
  List<Diet> get diets => _diets;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DietViewModel();

  void setFirestore(FirebaseFirestore firestore) {
    _firestore = firestore;
  }

  void setFirebaseAuth(FirebaseAuth firebaseAuth) {
    _firebaseAuth = firebaseAuth;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> addDish(Dish dish) async {
    final user = currentUser;
    if (user != null) {
      dish.userId = user.uid;
      _dishes.add(dish);
      notifyListeners();
      await _firestore.collection('dishes').doc(dish.id).set(dish.toMap());
    }
  }

  Future<void> removeDish(String id) async {
    final user = currentUser;
    if (user != null) {
      _dishes.removeWhere((dish) => dish.id == id);
      notifyListeners();
      await _firestore.collection('dishes').doc(id).delete();
    }
  }

  Future<void> updateDish(Dish dish) async {
    final user = currentUser;
    if (user != null) {
      final index = _dishes.indexWhere((d) => d.id == dish.id);
      if (index != -1) {
        _dishes[index] = dish;
        notifyListeners();
        await _firestore.collection('dishes').doc(dish.id).set(dish.toMap());
      }
    }
  }

  Future<void> addDiet(Diet diet) async {
    final user = currentUser;
    if (user != null) {
      diet.userId = user.uid;
      _diets.add(diet);
      notifyListeners();
      await _firestore.collection('diets').doc(diet.id).set(diet.toMap());
    }
  }

  Future<void> removeDiet(String id) async {
    final user = currentUser;
    if (user != null) {
      _diets.removeWhere((diet) => diet.id == id);
      notifyListeners();
      await _firestore.collection('diets').doc(id).delete();
    }
  }

  Future<void> updateDiet(Diet diet) async {
    final user = currentUser;
    if (user != null) {
      final index = _diets.indexWhere((d) => d.id == diet.id);
      if (index != -1) {
        _diets[index] = diet;
        notifyListeners();
        await _firestore.collection('diets').doc(diet.id).set(diet.toMap());
      }
    }
  }

  Future<void> addMealToDiet(String dietId, Meal meal) async {
    final user = currentUser;
    if (user != null) {
      final dietIndex = _diets.indexWhere((d) => d.id == dietId);
      if (dietIndex != -1) {
        _diets[dietIndex].meals.add(meal);
        notifyListeners();
        await _firestore
            .collection('diets')
            .doc(dietId)
            .set(_diets[dietIndex].toMap());
      }
    }
  }

  Future<void> removeMealFromDiet(String dietId, String mealId) async {
    final user = currentUser;
    if (user != null) {
      final dietIndex = _diets.indexWhere((d) => d.id == dietId);
      if (dietIndex != -1) {
        _diets[dietIndex].meals.removeWhere((meal) => meal.id == mealId);
        notifyListeners();
        await _firestore
            .collection('diets')
            .doc(dietId)
            .set(_diets[dietIndex].toMap());
      }
    }
  }

  Future<void> loadDishes(String userId) async {
    final dishSnapshot = await _firestore
        .collection('dishes')
        .where('userId', isEqualTo: userId)
        .get();

    _dishes.clear();

    for (var doc in dishSnapshot.docs) {
      _dishes.add(Dish.fromMap(doc.data()));
    }

    notifyListeners();
  }

  Future<void> loadDiets(String userId) async {
    final dietSnapshot = await _firestore
        .collection('diets')
        .where('userId', isEqualTo: userId)
        .get();

    _diets.clear();

    for (var doc in dietSnapshot.docs) {
      _diets.add(Diet.fromMap(doc.data()));
    }

    notifyListeners();
  }

  Future<void> loadData(String userId) async {
    await loadDishes(userId);
    await loadDiets(userId);
    notifyListeners();
  }

  void clearData() {
    _dishes.clear();
    _diets.clear();
    notifyListeners();
  }
}
