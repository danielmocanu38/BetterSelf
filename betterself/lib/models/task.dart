import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String userId;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  int priority;
  int quadrant;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
    required this.quadrant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority,
      'quadrant': quadrant,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] is Timestamp
          ? (map['dueDate'] as Timestamp).toDate()
          : DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'],
      priority: map['priority'],
      quadrant: map['quadrant'],
    );
  }
}
