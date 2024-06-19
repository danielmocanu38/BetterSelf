import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/income_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoneyViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [];
  late Budget _budget;
  String _selectedCurrency = '\$';

  List<Expense> get expenses => _expenses;
  Budget get budget => _budget;
  String get selectedCurrency => _selectedCurrency;

  final List<String> currencyOptions = ['\$', '€', 'LEI'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MoneyViewModel() {
    _budget = Budget(totalAmount: 0, spentAmount: 0, incomeSources: []);
  }

  void addExpense(Expense expense) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      expense.userId = user.uid;
      _expenses.add(expense);
      _budget.spentAmount +=
          convertCurrency(expense.amount, expense.currency, _selectedCurrency);
      notifyListeners();
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toMap());
    }
  }

  void removeExpense(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final expense = _expenses.firstWhere((e) => e.id == id);
      _expenses.removeWhere((expense) => expense.id == id);
      _budget.spentAmount -=
          convertCurrency(expense.amount, expense.currency, _selectedCurrency);
      notifyListeners();
      await _firestore.collection('expenses').doc(id).delete();
    }
  }

  void updateExpense(Expense expense) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        final oldExpense = _expenses[index];
        _budget.spentAmount -= convertCurrency(
            oldExpense.amount, oldExpense.currency, _selectedCurrency);
        _expenses[index] = expense;
        _budget.spentAmount += convertCurrency(
            expense.amount, expense.currency, _selectedCurrency);
        notifyListeners();
        await _firestore
            .collection('expenses')
            .doc(expense.id)
            .set(expense.toMap());
      }
    }
  }

  void setBudget(double amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _budget.totalAmount = amount;
      notifyListeners();
      await _firestore.collection('budgets').doc(user.uid).set(_budget.toMap());
    }
  }

  void addIncomeSource(IncomeSource source) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      source.userId = user.uid;
      _budget.incomeSources.add(source);
      _budget.totalAmount +=
          convertCurrency(source.amount, source.currency, _selectedCurrency);
      notifyListeners();
      await _firestore.collection('budgets').doc(user.uid).set(_budget.toMap());
    }
  }

  void removeIncomeSource(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final source = _budget.incomeSources.firstWhere((s) => s.id == id);
      _budget.incomeSources.removeWhere((source) => source.id == id);
      _budget.totalAmount -=
          convertCurrency(source.amount, source.currency, _selectedCurrency);
      notifyListeners();
      await _firestore.collection('budgets').doc(user.uid).set(_budget.toMap());
    }
  }

  Map<String, double> getCategorySummary() {
    Map<String, double> categorySummary = {};
    for (var expense in _expenses) {
      double amountInSelectedCurrency =
          convertCurrency(expense.amount, expense.currency, _selectedCurrency);
      if (categorySummary.containsKey(expense.category)) {
        categorySummary[expense.category] =
            categorySummary[expense.category]! + amountInSelectedCurrency;
      } else {
        categorySummary[expense.category] = amountInSelectedCurrency;
      }
    }
    return categorySummary;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  Future<void> loadExpensesAndBudget(String userId) async {
    final expenseSnapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();
    final budgetSnapshot =
        await _firestore.collection('budgets').doc(userId).get();

    _expenses.clear();
    _budget.incomeSources.clear();
    _budget.totalAmount = 0;
    _budget.spentAmount = 0;

    for (var doc in expenseSnapshot.docs) {
      _expenses.add(Expense.fromMap(doc.data()));
      _budget.spentAmount += convertCurrency(
        Expense.fromMap(doc.data()).amount,
        Expense.fromMap(doc.data()).currency,
        _selectedCurrency,
      );
    }

    if (budgetSnapshot.exists) {
      _budget = Budget.fromMap(budgetSnapshot.data()!);
    } else {
      _budget = Budget(totalAmount: 0, spentAmount: 0, incomeSources: []);
    }

    notifyListeners();
  }

  void updateSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  double convertCurrency(
      double amount, String fromCurrency, String toCurrency) {
    const rates = {
      '\$': {'€': 1 / 1.07, 'LEI': 4.63, '\$': 1.0},
      '€': {'\$': 1.07, 'LEI': 4.98, '€': 1.0},
      'LEI': {'\$': 1 / 4.63, '€': 1 / 4.98, 'LEI': 1.0},
    };

    if (fromCurrency == toCurrency) {
      return amount;
    }

    return amount * rates[fromCurrency]![toCurrency]!;
  }

  double getTotalBudget() {
    double totalBudget = 0;
    for (var source in _budget.incomeSources) {
      totalBudget +=
          convertCurrency(source.amount, source.currency, _selectedCurrency);
    }
    return totalBudget;
  }

  double getTotalExpenses() {
    double totalExpenses = 0;
    for (var expense in _expenses) {
      totalExpenses +=
          convertCurrency(expense.amount, expense.currency, _selectedCurrency);
    }
    return totalExpenses;
  }

  double getExpenseRatio() {
    if (_budget.totalAmount == 0) {
      return 0;
    }
    return getTotalExpenses() / getTotalBudget();
  }

  void clearData() {
    _expenses.clear();
    _budget = Budget(totalAmount: 0, spentAmount: 0, incomeSources: []);
    notifyListeners();
  }
}
