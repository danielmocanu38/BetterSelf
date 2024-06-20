import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../viewmodels/diet_viewmodel.dart';
import '../models/diet.dart';
import '../models/meal.dart';
import '../models/dish.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietCreationScreen extends StatefulWidget {
  final Diet? diet;

  const DietCreationScreen({super.key, this.diet});

  @override
  DietCreationScreenState createState() => DietCreationScreenState();
}

class DietCreationScreenState extends State<DietCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _calorieGoalController = TextEditingController();
  Dish? _selectedDish;
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.diet != null) {
      _nameController.text = widget.diet!.name;
      _calorieGoalController.text = widget.diet!.dailyCalorieGoal.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _calorieGoalController.dispose();
    super.dispose();
  }

  void _saveDiet() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newDiet = Diet(
      id: widget.diet?.id ?? const Uuid().v4(),
      name: _nameController.text,
      userId: user.uid,
      dailyCalorieGoal: int.tryParse(_calorieGoalController.text) ?? 0,
      meals: widget.diet?.meals ?? [],
    );

    if (widget.diet == null) {
      Provider.of<DietViewModel>(context, listen: false).addDiet(newDiet);
    } else {
      Provider.of<DietViewModel>(context, listen: false).updateDiet(newDiet);
    }
    Navigator.pop(context);
  }

  void _deleteDiet() {
    if (widget.diet != null) {
      Provider.of<DietViewModel>(context, listen: false)
          .removeDiet(widget.diet!.id);
      Navigator.pop(context);
    }
  }

  void _addMeal() {
    if (_selectedDish != null && _selectedTime != null) {
      setState(() {
        widget.diet!.meals.add(Meal(
          id: const Uuid().v4(),
          dish: _selectedDish!,
          servingTime: _selectedTime!,
        ));
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCalories = widget.diet?.meals.fold<int>(
          0,
          (sum, meal) => sum + meal.dish.calories,
        ) ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diet == null ? 'Create Diet' : 'Edit Diet'),
        actions: widget.diet != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteDiet,
                )
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Diet Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _calorieGoalController,
              decoration: const InputDecoration(labelText: 'Calorie Goal'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total Calories: $totalCalories/${_calorieGoalController.text}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            if (widget.diet != null) ...[
              DropdownButton<Dish>(
                value: _selectedDish,
                hint: const Text('Select Dish'),
                onChanged: (Dish? newValue) {
                  setState(() {
                    _selectedDish = newValue!;
                  });
                },
                items: Provider.of<DietViewModel>(context, listen: false)
                    .dishes
                    .map((Dish dish) {
                  return DropdownMenuItem<Dish>(
                    value: dish,
                    child: Text(dish.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('Select Serving Time'),
                  ),
                  const SizedBox(width: 16.0),
                  Text(_selectedTime != null
                      ? DateFormat('HH:mm').format(_selectedTime!)
                      : 'No time selected'),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addMeal,
                child: const Text('Add Meal'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.diet!.meals.length,
                  itemBuilder: (context, index) {
                    final meal = widget.diet!.meals[index];
                    return ListTile(
                      title: Text(meal.dish.name),
                      subtitle:
                          Text(DateFormat('HH:mm').format(meal.servingTime)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.diet!.meals.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveDiet,
              child: const Text('Save Diet'),
            ),
          ],
        ),
      ),
    );
  }
}
