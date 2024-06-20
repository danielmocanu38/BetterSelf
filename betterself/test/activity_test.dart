import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Activity Model Tests', () {
    test('Activity model should be instantiated correctly', () {
      final activity = Activity(
        id: '1',
        title: 'Test Activity',
        description: 'Description',
        dateTime: DateTime.now(),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        userId: 'test_user',
      );

      expect(activity.id, '1');
      expect(activity.title, 'Test Activity');
      expect(activity.description, 'Description');
      expect(activity.dateTime, isNotNull);
      expect(activity.isRoutine, false);
      expect(activity.startTime.hour, 9);
      expect(activity.startTime.minute, 0);
      expect(activity.endTime.hour, 10);
      expect(activity.endTime.minute, 0);
      expect(activity.userId, 'test_user');
    });

    test('Activity model should convert to map correctly', () {
      final activity = Activity(
        id: '1',
        title: 'Test Activity',
        description: 'Description',
        dateTime: DateTime.now(),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        userId: 'test_user',
      );

      final activityMap = activity.toMap();
      expect(activityMap['id'], '1');
      expect(activityMap['title'], 'Test Activity');
      expect(activityMap['description'], 'Description');
      expect(activityMap['dateTime'], isNotNull);
      expect(activityMap['isRoutine'], false);
      expect(activityMap['startTime']['hour'], 9);
      expect(activityMap['startTime']['minute'], 0);
      expect(activityMap['endTime']['hour'], 10);
      expect(activityMap['endTime']['minute'], 0);
      expect(activityMap['userId'], 'test_user');
    });

    test('Activity model should be instantiated from map correctly', () {
      final activityMap = {
        'id': '1',
        'title': 'Test Activity',
        'description': 'Description',
        'dateTime': Timestamp.fromDate(DateTime.now()),
        'isRoutine': false,
        'repeatFrequency': '',
        'startTime': {'hour': 9, 'minute': 0},
        'endTime': {'hour': 10, 'minute': 0},
        'userId': 'test_user',
      };

      final activity = Activity.fromMap(activityMap);

      expect(activity.id, '1');
      expect(activity.title, 'Test Activity');
      expect(activity.description, 'Description');
      expect(activity.dateTime, isNotNull);
      expect(activity.isRoutine, false);
      expect(activity.startTime.hour, 9);
      expect(activity.startTime.minute, 0);
      expect(activity.endTime.hour, 10);
      expect(activity.endTime.minute, 0);
      expect(activity.userId, 'test_user');
    });
  });
}
