import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/income_source.dart';

void main() {
  group('IncomeSource Model Tests', () {
    test('IncomeSource model should be instantiated correctly', () {
      final incomeSource = IncomeSource(
        id: '1',
        userId: 'test_user',
        source: 'Salary',
        amount: 5000.0,
        currency: '\$',
      );

      expect(incomeSource.id, '1');
      expect(incomeSource.userId, 'test_user');
      expect(incomeSource.source, 'Salary');
      expect(incomeSource.amount, 5000.0);
      expect(incomeSource.currency, '\$');
    });

    test('IncomeSource model should convert to map correctly', () {
      final incomeSource = IncomeSource(
        id: '1',
        userId: 'test_user',
        source: 'Salary',
        amount: 5000.0,
        currency: '\$',
      );

      final incomeSourceMap = incomeSource.toMap();
      expect(incomeSourceMap['id'], '1');
      expect(incomeSourceMap['userId'], 'test_user');
      expect(incomeSourceMap['source'], 'Salary');
      expect(incomeSourceMap['amount'], 5000.0);
      expect(incomeSourceMap['currency'], '\$');
    });

    test('IncomeSource model should be instantiated from map correctly', () {
      final incomeSourceMap = {
        'id': '1',
        'userId': 'test_user',
        'source': 'Salary',
        'amount': 5000.0,
        'currency': '\$',
      };

      final incomeSource = IncomeSource.fromMap(incomeSourceMap);

      expect(incomeSource.id, '1');
      expect(incomeSource.userId, 'test_user');
      expect(incomeSource.source, 'Salary');
      expect(incomeSource.amount, 5000.0);
      expect(incomeSource.currency, '\$');
    });
  });
}
