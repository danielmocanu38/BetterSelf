import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/diet_viewmodel.dart';
import 'dish_creation_screen.dart';
import 'diet_creation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietPlanningScreen extends StatelessWidget {
  const DietPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planning'),
      ),
      body: FutureBuilder(
        future: Provider.of<DietViewModel>(context, listen: false)
            .loadData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<DietViewModel>(
              builder: (context, viewModel, child) {
                return ListView(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 238, 238, 238),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Padding(
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
                        children: [
                          ListTile(
                            title: const Text('Create New Diet'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DietCreationScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (viewModel.diets.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No diets available.'),
                              ),
                            )
                          else
                            ...viewModel.diets.map((diet) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: ListTile(
                                  title: Text(diet.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Goal: ${diet.dailyCalorieGoal} kcal, Total: ${diet.totalCalories} kcal'),
                                      Text('Meals: ${diet.meals.length}'),
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
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Padding(
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
                        children: [
                          ListTile(
                            title: const Text('Create New Dish'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DishCreationScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (viewModel.dishes.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No dishes available.'),
                              ),
                            )
                          else
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
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
