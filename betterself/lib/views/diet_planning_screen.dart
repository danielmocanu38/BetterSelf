// lib/views/diet_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/diet_viewmodel.dart';

class DietPlanningScreen extends StatelessWidget {
  const DietPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planning'),
      ),
      body: Consumer<DietViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.meals.length,
            itemBuilder: (context, index) {
              final meal = viewModel.meals[index];
              meal.calculateProperties();
              return ListTile(
                title: Text(meal.name),
                subtitle: Text(
                    '${meal.calories} calories - \$${meal.price.toStringAsFixed(2)} - ${meal.isPrepared ? "Prepared" : "Bought"}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add navigation to meal creation screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
