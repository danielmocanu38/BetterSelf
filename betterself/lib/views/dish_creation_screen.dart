import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../viewmodels/diet_viewmodel.dart';
import '../models/dish.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DishCreationScreen extends StatefulWidget {
  final Dish? dish;

  const DishCreationScreen({super.key, this.dish});

  @override
  DishCreationScreenState createState() => DishCreationScreenState();
}

class DishCreationScreenState extends State<DishCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  bool _isPrepared = false;
  DishType _selectedType = DishType.other;

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      _nameController.text = widget.dish!.name;
      _caloriesController.text = widget.dish!.calories.toString();
      _priceController.text = widget.dish!.price.toString();
      _ingredientsController.text = widget.dish!.ingredients.join(', ');
      _isPrepared = widget.dish!.isPrepared;
      _selectedType = widget.dish!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _priceController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _saveDish() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newDish = Dish(
      id: widget.dish?.id ?? const Uuid().v4(),
      name: _nameController.text,
      type: _selectedType,
      calories: int.tryParse(_caloriesController.text) ?? 0,
      price: double.tryParse(_priceController.text) ?? 0.0,
      isPrepared: _isPrepared,
      ingredients:
          _ingredientsController.text.split(', ').map((e) => e.trim()).toList(),
      userId: user.uid,
    );

    if (widget.dish == null) {
      Provider.of<DietViewModel>(context, listen: false).addDish(newDish);
    } else {
      Provider.of<DietViewModel>(context, listen: false).updateDish(newDish);
    }
    Navigator.pop(context);
  }

  void _deleteDish() {
    if (widget.dish != null) {
      Provider.of<DietViewModel>(context, listen: false)
          .removeDish(widget.dish!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish == null ? 'Create Dish' : 'Edit Dish'),
        actions: widget.dish != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteDish,
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
              decoration: const InputDecoration(labelText: 'Dish Name'),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<DishType>(
              value: _selectedType,
              onChanged: (DishType? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: DishType.values.map((DishType type) {
                return DropdownMenuItem<DishType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                  labelText: 'Ingredients (comma separated)'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Prepared:'),
                Checkbox(
                  value: _isPrepared,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPrepared = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveDish,
              child: const Text('Save Dish'),
            ),
          ],
        ),
      ),
    );
  }
}
