// lib/viewmodels/money_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/budget.dart';

class MoneyViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final Budget _budget = Budget(totalAmount: 0, spentAmount: 0);

  List<Expense> get expenses => _expenses;
  Budget get budget => _budget;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _budget.spentAmount += expense.amount;
    notifyListeners();
  }

  void removeExpense(String id) {
    final expense = _expenses.firstWhere((e) => e.id == id);
    _expenses.removeWhere((expense) => expense.id == id);
    _budget.spentAmount -= expense.amount;
    notifyListeners();
  }

  void setBudget(double amount) {
    _budget.totalAmount = amount;
    notifyListeners();
  }

  Map<String, double> getCategorySummary() {
    Map<String, double> categorySummary = {};
    for (var expense in _expenses) {
      if (categorySummary.containsKey(expense.category)) {
        categorySummary[expense.category] =
            categorySummary[expense.category]! + expense.amount;
      } else {
        categorySummary[expense.category] = expense.amount;
      }
    }
    return categorySummary;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }
}
