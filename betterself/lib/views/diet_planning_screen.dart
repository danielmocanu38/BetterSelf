import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/diet_viewmodel.dart';
import 'dish_creation_screen.dart';
import 'diet_creation_screen.dart';

class DietPlanningScreen extends StatelessWidget {
  const DietPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planning'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<DietViewModel>(
              builder: (context, viewModel, child) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'All Diets',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Create New Diet'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DietCreationScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    ...viewModel.diets.map((diet) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(diet.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Goal: ${diet.dailyCalorieGoal} kcal, Total: ${diet.totalCalories} kcal'),
                              Text(
                                  'Meals: ${diet.meals.length}'), // Display the number of meals
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DietCreationScreen(diet: diet),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'All Dishes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Create New Dish'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DishCreationScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    ...viewModel.dishes.map((dish) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(dish.name),
                          subtitle: Text(
                              'Type: ${dish.type.toString().split('.').last}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DishCreationScreen(dish: dish),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
