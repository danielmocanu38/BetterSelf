// lib/models/expense.dart
class Expense {
  String id;
  String userId;
  double amount;
  String category;
  String currency; // Added currency field
  DateTime date;
  String description;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.currency,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'currency': currency,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['userId'],
      amount: map['amount'],
      category: map['category'],
      currency: map['currency'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }
}
