import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../viewmodels/money_viewmodel.dart';
import '../models/income_source.dart';
import 'package:uuid/uuid.dart';

class BudgetManagementScreen extends StatelessWidget {
  BudgetManagementScreen({super.key});

  final TextEditingController _incomeAmountController = TextEditingController();
  final TextEditingController _incomeSourceController = TextEditingController();

  final List<String> currencyOptions = ['\$', '€', 'LEI'];

  @override
  Widget build(BuildContext context) {
    String selectedCurrency = currencyOptions[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _incomeSourceController,
              decoration: const InputDecoration(labelText: 'Income Source'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _incomeAmountController,
              decoration: const InputDecoration(labelText: 'Income Amount'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              items: currencyOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedCurrency = newValue!;
              },
              decoration: const InputDecoration(labelText: 'Currency'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  const uuid = Uuid();
                  final incomeSource = IncomeSource(
                    id: uuid.v4(),
                    userId: user.uid,
                    source: _incomeSourceController.text,
                    amount: double.parse(_incomeAmountController.text),
                    currency: selectedCurrency,
                  );
                  final viewModel =
                      Provider.of<MoneyViewModel>(context, listen: false);
                  viewModel.addIncomeSource(incomeSource);
                  _incomeSourceController.clear();
                  _incomeAmountController.clear();
                }
              },
              child: const Text('Add Income Source'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<MoneyViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    itemCount: viewModel.budget.incomeSources.length,
                    itemBuilder: (context, index) {
                      final incomeSource =
                          viewModel.budget.incomeSources[index];
                      return ListTile(
                        title: Text(incomeSource.source),
                        subtitle: Text(
                            '${incomeSource.amount} ${incomeSource.currency}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditIncomeSourceDialog(
                                    context, incomeSource);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                viewModel.removeIncomeSource(incomeSource.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditIncomeSourceDialog(
      BuildContext context, IncomeSource incomeSource) {
    final TextEditingController editSourceController =
        TextEditingController(text: incomeSource.source);
    final TextEditingController editAmountController =
        TextEditingController(text: incomeSource.amount.toString());
    String editSelectedCurrency = incomeSource.currency;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Income Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editSourceController,
                decoration: const InputDecoration(labelText: 'Income Source'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: editAmountController,
                decoration: const InputDecoration(labelText: 'Income Amount'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: editSelectedCurrency,
                items: currencyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  editSelectedCurrency = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Currency'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final updatedIncomeSource = IncomeSource(
                    id: incomeSource.id,
                    userId: user.uid,
                    source: editSourceController.text,
                    amount: double.parse(editAmountController.text),
                    currency: editSelectedCurrency,
                  );
                  final viewModel =
                      Provider.of<MoneyViewModel>(context, listen: false);
                  viewModel.updateIncomeSource(updatedIncomeSource);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
}
