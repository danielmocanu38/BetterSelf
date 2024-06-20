import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/money_viewmodel.dart';
import 'expense_creation_screen.dart';
import 'budget_management_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class MoneyPlanningScreen extends StatefulWidget {
  const MoneyPlanningScreen({super.key});

  @override
  MoneyPlanningScreenState createState() => MoneyPlanningScreenState();
}

class MoneyPlanningScreenState extends State<MoneyPlanningScreen> {
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Provider.of<MoneyViewModel>(context, listen: false)
          .loadExpensesAndBudget(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Planning'),
      ),
      body: FutureBuilder<void>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          } else {
            return Consumer<MoneyViewModel>(
              builder: (context, viewModel, child) {
                var categorySummary = viewModel.getCategorySummary();
                var data = categorySummary.entries.map((entry) {
                  return PieChartSectionData(
                    title: entry.key,
                    value: entry.value,
                    color: _getColorForCategory(entry.key),
                  );
                }).toList();

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Always use a strategy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                '50-30-20 rule',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('50-30-20 rule'),
                                        content: const Text.rich(
                                          TextSpan(
                                            text: 'The ',
                                            children: [
                                              TextSpan(
                                                text: '50-30-20 rule',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' recommends putting ',
                                              ),
                                              TextSpan(
                                                text: '50%',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' of your money toward ',
                                              ),
                                              TextSpan(
                                                text: 'needs',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ', ',
                                              ),
                                              TextSpan(
                                                text: '30%',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' toward ',
                                              ),
                                              TextSpan(
                                                text: 'wants',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ', and ',
                                              ),
                                              TextSpan(
                                                text: '20%',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' toward ',
                                              ),
                                              TextSpan(
                                                text: 'savings',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: '.'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Pay Yourself First',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Pay Yourself First'),
                                        content: const Text.rich(
                                          TextSpan(
                                            text: 'In the ',
                                            children: [
                                              TextSpan(
                                                text: '“Pay Yourself First”',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' strategy, the ',
                                              ),
                                              TextSpan(
                                                text: 'first “bill”',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 150, 145, 40),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' you pay every month is to your ',
                                              ),
                                              TextSpan(
                                                text: 'savings',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: ' account.'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: viewModel.selectedCurrency,
                      items: viewModel.currencyOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        viewModel.updateSelectedCurrency(newValue!);
                      },
                    ),
                    Text(
                      'Budget: ${viewModel.getTotalBudget().toStringAsFixed(2)} ${viewModel.selectedCurrency}',
                    ),
                    Text(
                      'Expenses: ${viewModel.getTotalExpenses().toStringAsFixed(2)} ${viewModel.selectedCurrency}',
                    ),
                    Text(
                      'Expenses/Budget: ${(viewModel.getExpenseRatio() * 100).toStringAsFixed(2)}%',
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sections: data,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categorySummary.length,
                        itemBuilder: (context, index) {
                          String category =
                              categorySummary.keys.elementAt(index);
                          double amount =
                              categorySummary.values.elementAt(index);
                          return ExpansionTile(
                            title: Text(
                                '$category: ${amount.toStringAsFixed(2)} ${viewModel.selectedCurrency}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            children: viewModel
                                .getExpensesByCategory(category)
                                .map((expense) {
                              return ListTile(
                                title: Text(expense.description),
                                subtitle: Text(
                                    '${expense.amount} ${expense.currency} - ${expense.date.toLocal().toString().split(' ')[0]}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExpenseCreationScreen(
                                                    expense: expense),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        viewModel.removeExpense(expense.id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BudgetManagementScreen()),
                        );
                      },
                      child: const Text('Manage Budget'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExpenseCreationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Lifestyle':
        return Colors.blue;
      case 'Necessities':
        return Colors.red;
      case 'Economies':
        return Colors.green;
      case 'Investment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
