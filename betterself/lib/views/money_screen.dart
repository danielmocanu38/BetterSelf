import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/money_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';

class MoneyScreen extends StatelessWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Planning'),
      ),
      body: Consumer<MoneyViewModel>(
        builder: (context, viewModel, child) {
          var categorySummary = viewModel.getCategorySummary();
          var data = categorySummary.entries.map((entry) {
            return PieChartSectionData(
              title: entry.key,
              value: entry.value,
              color: Colors.blue, // Customize as needed
            );
          }).toList();

          return Column(
            children: [
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
                    String category = categorySummary.keys.elementAt(index);
                    double amount = categorySummary.values.elementAt(index);
                    return ListTile(
                      title: Text('$category: \$${amount.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to detailed view of expenses for this category
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add navigation to expense creation screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
