import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/budget.dart';
import 'package:betterself/models/income_source.dart';

void main() {
  group('Budget Model Tests', () {
    test('Budget model should be instantiated correctly', () {
      final incomeSource = IncomeSource(
        id: '1',
        userId: 'test_user',
        source: 'Salary',
        amount: 5000.0,
        currency: '\$',
      );

      final budget = Budget(
        totalAmount: 10000.0,
        spentAmount: 2000.0,
        incomeSources: [incomeSource],
      );

      expect(budget.totalAmount, 10000.0);
      expect(budget.spentAmount, 2000.0);
      expect(budget.incomeSources.length, 1);
      expect(budget.incomeSources.first.id, '1');
    });

    test('Budget model should convert to map correctly', () {
      final incomeSource = IncomeSource(
        id: '1',
        userId: 'test_user',
        source: 'Salary',
        amount: 5000.0,
        currency: '\$',
      );

      final budget = Budget(
        totalAmount: 10000.0,
        spentAmount: 2000.0,
        incomeSources: [incomeSource],
      );

      final budgetMap = budget.toMap();
      expect(budgetMap['totalAmount'], 10000.0);
      expect(budgetMap['spentAmount'], 2000.0);
      expect(budgetMap['incomeSources'].length, 1);
      expect(budgetMap['incomeSources'][0]['id'], '1');
    });

    test('Budget model should be instantiated from map correctly', () {
      final budgetMap = {
        'totalAmount': 10000.0,
        'spentAmount': 2000.0,
        'incomeSources': [
          {
            'id': '1',
            'userId': 'test_user',
            'source': 'Salary',
            'amount': 5000.0,
            'currency': '\$',
          }
        ],
      };

      final budget = Budget.fromMap(budgetMap);

      expect(budget.totalAmount, 10000.0);
      expect(budget.spentAmount, 2000.0);
      expect(budget.incomeSources.length, 1);
      expect(budget.incomeSources.first.id, '1');
    });
  });
}
