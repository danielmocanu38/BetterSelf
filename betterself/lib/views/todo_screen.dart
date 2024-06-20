import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../models/task.dart';
import 'task_history_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  int _selectedQuadrant = 0;
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Provider.of<TodoViewModel>(context, listen: false)
          .loadTasks(user.uid);
    }
  }

  void _toggleQuadrant(int index) {
    setState(() {
      _selectedQuadrant = index;
    });
  }

  void _showTaskCreationDialog(BuildContext context, {Task? task}) {
    final TextEditingController titleController =
        TextEditingController(text: task?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: task?.description ?? '');
    DateTime dueDate = task?.dueDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(task == null ? 'Create Task' : 'Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text('${dueDate.toLocal()}'.split(' ')[0]),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != dueDate) {
                        setState(() {
                          dueDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    final newTask = Task(
                      id: task?.id ?? const Uuid().v4(),
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: dueDate,
                      isCompleted: task?.isCompleted ?? false,
                      quadrant: _selectedQuadrant,
                      priority: task?.priority ??
                          Provider.of<TodoViewModel>(context, listen: false)
                              .getTasksByQuadrant(_selectedQuadrant)
                              .length,
                      userId: user.uid,
                    );
                    if (task == null) {
                      Provider.of<TodoViewModel>(context, listen: false)
                          .addTask(newTask, user.uid);
                    } else {
                      Provider.of<TodoViewModel>(context, listen: false)
                          .updateTask(newTask);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(task == null ? 'Create' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          } else {
            return Consumer<TodoViewModel>(
              builder: (context, viewModel, child) {
                var tasks = viewModel
                    .getTasksByQuadrant(_selectedQuadrant)
                    .where((task) => !task.isCompleted)
                    .toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuadrantButton(
                                  context, 'Urgent & Important', 0),
                              _buildQuadrantButton(
                                  context, 'Not Urgent & Important', 1),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuadrantButton(
                                  context, 'Urgent & Not Important', 2),
                              _buildQuadrantButton(
                                  context, 'Not Urgent & Not Important', 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final task = tasks.removeAt(oldIndex);
                          tasks.insert(newIndex, task);
                          // Update priority based on new order
                          for (int i = 0; i < tasks.length; i++) {
                            tasks[i].priority = i;
                          }
                          viewModel.updateTaskPriorities(tasks);
                        },
                        children: [
                          for (int index = 0; index < tasks.length; index++)
                            ListTile(
                              key: ValueKey(tasks[index].id),
                              title: Text(tasks[index].title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tasks[index].description),
                                  Text(
                                      'DUE TO: ${tasks[index].dueDate.toLocal().toString().split(' ')[0]}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showTaskCreationDialog(context,
                                          task: tasks[index]);
                                    },
                                  ),
                                  Checkbox(
                                    value: tasks[index].isCompleted,
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        Provider.of<TodoViewModel>(context,
                                                listen: false)
                                            .completeTask(tasks[index].id);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      Provider.of<TodoViewModel>(context,
                                              listen: false)
                                          .removeTask(tasks[index].id);
                                    },
                                  ),
                                ],
                              ),
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskCreationDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  ElevatedButton _buildQuadrantButton(
      BuildContext context, String title, int index) {
    return ElevatedButton(
      onPressed: () => _toggleQuadrant(index),
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        textStyle: const TextStyle(fontSize: 10),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
