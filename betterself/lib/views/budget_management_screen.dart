import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Import FilteringTextInputFormatter
import '../viewmodels/money_viewmodel.dart';
import '../models/income_source.dart';
import 'package:uuid/uuid.dart'; // Import Uuid

class BudgetManagementScreen extends StatelessWidget {
  BudgetManagementScreen({super.key}); // Add key parameter

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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            viewModel.removeIncomeSource(incomeSource.id);
                          },
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
}
