// lib/models/expense.dart
class Expense {
  String id;
  double amount;
  String category;
  String subCategory;
  DateTime date;
  String description;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.description,
  });
}
