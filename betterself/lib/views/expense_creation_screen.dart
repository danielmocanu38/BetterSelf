import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Import FilteringTextInputFormatter
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';
import '../viewmodels/money_viewmodel.dart';
import 'package:uuid/uuid.dart'; // Import Uuid

class ExpenseCreationScreen extends StatefulWidget {
  final Expense? expense;
  const ExpenseCreationScreen({super.key, this.expense}); // Add key parameter

  @override
  ExpenseCreationScreenState createState() => ExpenseCreationScreenState();
}

class ExpenseCreationScreenState extends State<ExpenseCreationScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DateTime _date = DateTime.now();

  String _selectedCurrency = '\$'; // Default currency
  String _selectedCategory = 'Lifestyle'; // Default category

  final List<String> currencyOptions = ['\$', '€', 'LEI'];
  final List<String> categoryOptions = [
    'Lifestyle',
    'Necessities',
    'Economies',
    'Investment',
    'Custom'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _categoryController.text = widget.expense!.category;
      _descriptionController.text = widget.expense!.description;
      _selectedCurrency = widget.expense!.currency;
      _selectedCategory = widget.expense!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              items: currencyOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Currency'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categoryOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                  if (_selectedCategory != 'Custom') {
                    _categoryController.clear();
                  }
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            if (_selectedCategory == 'Custom')
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Custom Category'),
              ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  const uuid = Uuid();
                  final expense = Expense(
                    id: widget.expense?.id ?? uuid.v4(),
                    userId: user.uid,
                    amount: double.parse(_amountController.text),
                    currency: _selectedCurrency,
                    category: _selectedCategory == 'Custom'
                        ? _categoryController.text
                        : _selectedCategory,
                    date: _date,
                    description: _descriptionController.text,
                  );
                  final viewModel =
                      Provider.of<MoneyViewModel>(context, listen: false);
                  if (widget.expense == null) {
                    viewModel.addExpense(expense);
                  } else {
                    viewModel.updateExpense(expense);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
