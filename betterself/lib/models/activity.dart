// lib/models/activity.dart
class Activity {
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isRoutine;
  String repeatFrequency; // e.g., daily, weekly, monthly
  int repeatCount; // number of times the activity will repeat

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isRoutine,
    this.repeatFrequency = '',
    this.repeatCount = 0,
  });
}
