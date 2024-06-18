import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isRoutine;
  String repeatFrequency; // e.g., 'Daily', 'Weekly', 'Monthly', 'Yearly'
  TimeOfDay startTime;
  TimeOfDay endTime;
  String userId; // Add userId field

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isRoutine,
    this.repeatFrequency = '',
    required this.startTime,
    required this.endTime,
    required this.userId, // Add userId parameter
  });

  factory Activity.fromMap(Map<String, dynamic> data) {
    return Activity(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      isRoutine: data['isRoutine'],
      repeatFrequency: data['repeatFrequency'],
      startTime: TimeOfDay(
          hour: data['startTime']['hour'], minute: data['startTime']['minute']),
      endTime: TimeOfDay(
          hour: data['endTime']['hour'], minute: data['endTime']['minute']),
      userId: data['userId'], // Add userId from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'isRoutine': isRoutine,
      'repeatFrequency': repeatFrequency,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'userId': userId, // Add userId to map
    };
  }
}
