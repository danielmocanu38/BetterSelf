import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/activity_viewmodel.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Planning'),
      ),
      body: Consumer<ActivityViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.activities.length,
            itemBuilder: (context, index) {
              final activity = viewModel.activities[index];
              return ListTile(
                title: Text(activity.title),
                subtitle: Text(
                    '${activity.description} - Repeats ${activity.repeatFrequency} for ${activity.repeatCount} times'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add navigation to activity creation screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
