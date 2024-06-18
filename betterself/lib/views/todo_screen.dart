// lib/views/todo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/todo_viewmodel.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              String quadrantTitle;
              switch (index) {
                case 0:
                  quadrantTitle = 'Urgent & Important';
                  break;
                case 1:
                  quadrantTitle = 'Not Urgent & Important';
                  break;
                case 2:
                  quadrantTitle = 'Urgent & Not Important';
                  break;
                case 3:
                  quadrantTitle = 'Not Urgent & Not Important';
                  break;
                default:
                  quadrantTitle = '';
              }
              var tasks = viewModel.getTasksByPriority(index);
              return Card(
                child: Column(
                  children: [
                    Text(quadrantTitle),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, taskIndex) {
                          final task = tasks[taskIndex];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (bool? value) {
                                // Update task completion status
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add navigation to task creation screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
