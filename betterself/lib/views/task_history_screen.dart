import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/todo_viewmodel.dart';

class TaskHistoryScreen extends StatelessWidget {
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.completedTasks.length,
            itemBuilder: (context, index) {
              final task = viewModel.completedTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.removeTask(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
