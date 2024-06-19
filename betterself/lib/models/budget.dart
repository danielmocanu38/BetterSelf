// lib/models/budget.dart
import 'income_source.dart';

class Budget {
  double totalAmount;
  double spentAmount;
  List<IncomeSource> incomeSources;

  Budget({
    required this.totalAmount,
    required this.spentAmount,
    this.incomeSources = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'totalAmount': totalAmount,
      'spentAmount': spentAmount,
      'incomeSources': incomeSources.map((e) => e.toMap()).toList(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      totalAmount: map['totalAmount'],
      spentAmount: map['spentAmount'],
      incomeSources: List<IncomeSource>.from(
          map['incomeSources']?.map((x) => IncomeSource.fromMap(x))),
    );
  }
}
