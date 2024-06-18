// lib/models/task.dart
class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  int priority; // 0: not urgent and not important, 1: not urgent and important, 2: urgent and not important, 3: urgent and important

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
  });
}
