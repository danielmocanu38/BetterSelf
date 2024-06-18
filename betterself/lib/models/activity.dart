import 'package:flutter/material.dart';

class Activity {
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isRoutine;
  String repeatFrequency; // e.g., 'Daily', 'Weekly', 'Monthly', 'Yearly'
  TimeOfDay startTime;
  TimeOfDay endTime;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isRoutine,
    this.repeatFrequency = '',
    required this.startTime,
    required this.endTime,
  });
}
