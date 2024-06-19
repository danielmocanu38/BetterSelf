import 'dish.dart';

class Meal {
  final String id;
  final Dish dish;
  final DateTime servingTime;

  Meal({
    required this.id,
    required this.dish,
    required this.servingTime,
  });

  Meal copyWith({
    String? id,
    Dish? dish,
    DateTime? servingTime,
  }) {
    return Meal(
      id: id ?? this.id,
      dish: dish ?? this.dish,
      servingTime: servingTime ?? this.servingTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dish': dish.toMap(),
      'servingTime': servingTime.toIso8601String(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      dish: Dish.fromMap(map['dish']),
      servingTime: DateTime.parse(map['servingTime']),
    );
  }
}
