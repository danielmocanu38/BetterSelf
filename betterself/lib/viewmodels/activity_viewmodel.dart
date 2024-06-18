import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';

class ActivityViewModel extends ChangeNotifier {
  final List<Activity> _weeklyActivities = [];
  final List<Activity> _calendarActivities = [];

  List<Activity> get weeklyActivities => _weeklyActivities;
  List<Activity> get calendarActivities => _calendarActivities;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addWeeklyActivity(Activity activity) async {
    _weeklyActivities.add(activity);
    _weeklyActivities.sort((a, b) {
      final aTime = a.startTime.hour * 60 + a.startTime.minute;
      final bTime = b.startTime.hour * 60 + b.startTime.minute;
      return aTime.compareTo(bTime);
    });
    notifyListeners();
    await _firestore
        .collection('weeklyActivities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  void addCalendarActivity(Activity activity) async {
    _calendarActivities.add(activity);
    notifyListeners();
    await _firestore
        .collection('calendarActivities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  void removeWeeklyActivity(String id) async {
    _weeklyActivities.removeWhere((activity) => activity.id == id);
    notifyListeners();
    await _firestore.collection('weeklyActivities').doc(id).delete();
  }

  void removeCalendarActivity(String id) async {
    _calendarActivities.removeWhere((activity) => activity.id == id);
    notifyListeners();
    await _firestore.collection('calendarActivities').doc(id).delete();
  }

  void updateWeeklyActivity(Activity activity) async {
    final index = _weeklyActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _weeklyActivities[index] = activity;
      _weeklyActivities.sort((a, b) {
        final aTime = a.startTime.hour * 60 + a.startTime.minute;
        final bTime = b.startTime.hour * 60 + b.startTime.minute;
        return aTime.compareTo(bTime);
      });
      notifyListeners();
      await _firestore
          .collection('weeklyActivities')
          .doc(activity.id)
          .set(activity.toMap());
    }
  }

  void updateCalendarActivity(Activity activity) async {
    final index = _calendarActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _calendarActivities[index] = activity;
      notifyListeners();
      await _firestore
          .collection('calendarActivities')
          .doc(activity.id)
          .set(activity.toMap());
    }
  }

  List<Activity> getWeeklyActivitiesForDay(int dayIndex) {
    return _weeklyActivities.where((activity) {
      return activity.dateTime.weekday == dayIndex + 1;
    }).toList();
  }

  List<Activity> getCalendarActivitiesForDay(DateTime day) {
    return _calendarActivities.where((activity) {
      return isSameDay(activity.dateTime, day) ||
          (activity.isRoutine &&
                  (activity.repeatFrequency == 'Only Once' &&
                      isSameDay(activity.dateTime, day)) ||
              (activity.repeatFrequency == 'Daily') ||
              (activity.repeatFrequency == 'Weekly' &&
                  activity.dateTime.weekday == day.weekday) ||
              (activity.repeatFrequency == 'Monthly' &&
                  activity.dateTime.day == day.day) ||
              (activity.repeatFrequency == 'Yearly' &&
                  activity.dateTime.month == day.month &&
                  activity.dateTime.day == day.day));
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> loadActivities(String userId) async {
    final weeklySnapshot = await _firestore
        .collection('weeklyActivities')
        .where('userId', isEqualTo: userId)
        .get();
    final calendarSnapshot = await _firestore
        .collection('calendarActivities')
        .where('userId', isEqualTo: userId)
        .get();

    _weeklyActivities.clear();
    _calendarActivities.clear();

    for (var doc in weeklySnapshot.docs) {
      _weeklyActivities.add(Activity.fromMap(doc.data()));
    }

    for (var doc in calendarSnapshot.docs) {
      _calendarActivities.add(Activity.fromMap(doc.data()));
    }

    notifyListeners();
  }

  void clearActivities() {
    _weeklyActivities.clear();
    _calendarActivities.clear();
    notifyListeners();
  }
}
