import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:betterself/viewmodels/activity_viewmodel.dart';
import 'package:betterself/models/activity.dart';
import 'mock.dart'; // Import the mock file
import 'activity_viewmodel_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference])
void main() {
  setupFirebaseMocks(); // Set up the Firebase mocks

  group('ActivityViewModel Tests', () {
    late ActivityViewModel viewModel;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
    });

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();

      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async => {});
      when(mockDocumentReference.delete()).thenAnswer((_) async => {});

      viewModel = ActivityViewModel();
      viewModel.setFirestore(mockFirestore); // Set the mock Firestore instance
    });

    test('Add and remove calendar activity', () async {
      final activity = Activity(
        id: '1',
        title: 'Test Activity',
        description: 'Description',
        dateTime: DateTime(2022, 10, 10),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        userId: 'test_user',
      );

      await viewModel.addCalendarActivity(activity);
      expect(viewModel.calendarActivities.length, 1);
      expect(viewModel.calendarActivities[0].id, activity.id);

      await viewModel.removeCalendarActivity(activity.id);
      expect(viewModel.calendarActivities.length, 0);
    });

    test('Add and remove weekly activity', () async {
      final activity = Activity(
        id: '2',
        title: 'Test Activity 2',
        description: 'Description 2',
        dateTime: DateTime(2022, 10, 11),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        userId: 'test_user',
      );

      await viewModel.addWeeklyActivity(activity);
      expect(viewModel.weeklyActivities.length, 1);
      expect(viewModel.weeklyActivities[0].id, activity.id);

      await viewModel.removeWeeklyActivity(activity.id);
      expect(viewModel.weeklyActivities.length, 0);
    });

    test('Update calendar activity', () async {
      final activity = Activity(
        id: '3',
        title: 'Test Activity 3',
        description: 'Description 3',
        dateTime: DateTime(2022, 10, 12),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        userId: 'test_user',
      );

      await viewModel.addCalendarActivity(activity);
      final updatedActivity = Activity(
        id: '3',
        title: 'Updated Activity 3',
        description: 'Updated Description 3',
        dateTime: DateTime(2022, 10, 12),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        userId: 'test_user',
      );

      await viewModel.updateCalendarActivity(updatedActivity);
      expect(viewModel.calendarActivities.length, 1);
      expect(viewModel.calendarActivities[0].title, 'Updated Activity 3');
    });

    test('Update weekly activity', () async {
      final activity = Activity(
        id: '4',
        title: 'Test Activity 4',
        description: 'Description 4',
        dateTime: DateTime(2022, 10, 13),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 6, minute: 0),
        endTime: const TimeOfDay(hour: 7, minute: 0),
        userId: 'test_user',
      );

      await viewModel.addWeeklyActivity(activity);
      final updatedActivity = Activity(
        id: '4',
        title: 'Updated Activity 4',
        description: 'Updated Description 4',
        dateTime: DateTime(2022, 10, 13),
        isRoutine: false,
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 8, minute: 0),
        userId: 'test_user',
      );

      await viewModel.updateWeeklyActivity(updatedActivity);
      expect(viewModel.weeklyActivities.length, 1);
      expect(viewModel.weeklyActivities[0].title, 'Updated Activity 4');
    });
  });
}
