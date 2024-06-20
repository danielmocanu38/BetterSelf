import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/expense.dart';

void main() {
  group('Expense Model Tests', () {
    test('Expense model should be instantiated correctly', () {
      final expense = Expense(
        id: '1',
        userId: 'test_user',
        amount: 100.0,
        category: 'Test Category',
        currency: '\$',
        date: DateTime.now(),
        description: 'Test Expense',
      );

      expect(expense.id, '1');
      expect(expense.userId, 'test_user');
      expect(expense.amount, 100.0);
      expect(expense.category, 'Test Category');
      expect(expense.currency, '\$');
      expect(expense.description, 'Test Expense');
    });

    test('Expense model should convert to map correctly', () {
      final date = DateTime.now();
      final expense = Expense(
        id: '1',
        userId: 'test_user',
        amount: 100.0,
        category: 'Test Category',
        currency: '\$',
        date: date,
        description: 'Test Expense',
      );

      final expenseMap = expense.toMap();
      expect(expenseMap['id'], '1');
      expect(expenseMap['userId'], 'test_user');
      expect(expenseMap['amount'], 100.0);
      expect(expenseMap['category'], 'Test Category');
      expect(expenseMap['currency'], '\$');
      expect(expenseMap['date'], date.toIso8601String());
      expect(expenseMap['description'], 'Test Expense');
    });

    test('Expense model should be instantiated from map correctly', () {
      final date = DateTime.now();
      final expenseMap = {
        'id': '1',
        'userId': 'test_user',
        'amount': 100.0,
        'category': 'Test Category',
        'currency': '\$',
        'date': date.toIso8601String(),
        'description': 'Test Expense',
      };

      final expense = Expense.fromMap(expenseMap);

      expect(expense.id, '1');
      expect(expense.userId, 'test_user');
      expect(expense.amount, 100.0);
      expect(expense.category, 'Test Category');
      expect(expense.currency, '\$');
      expect(expense.date, date);
      expect(expense.description, 'Test Expense');
    });
  });
}
