import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityViewModel extends ChangeNotifier {
  final List<Activity> _weeklyActivities = [];
  final List<Activity> _calendarActivities = [];

  List<Activity> get weeklyActivities => _weeklyActivities;
  List<Activity> get calendarActivities => _calendarActivities;

  void addWeeklyActivity(Activity activity) {
    _weeklyActivities.add(activity);
    _weeklyActivities.sort((a, b) {
      final aTime = a.startTime.hour * 60 + a.startTime.minute;
      final bTime = b.startTime.hour * 60 + b.startTime.minute;
      return aTime.compareTo(bTime);
    });
    notifyListeners();
  }

  void addCalendarActivity(Activity activity) {
    _calendarActivities.add(activity);
    notifyListeners();
  }

  void removeWeeklyActivity(String id) {
    _weeklyActivities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  void removeCalendarActivity(String id) {
    _calendarActivities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  void updateWeeklyActivity(Activity activity) {
    final index = _weeklyActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _weeklyActivities[index] = activity;
      _weeklyActivities.sort((a, b) {
        final aTime = a.startTime.hour * 60 + a.startTime.minute;
        final bTime = b.startTime.hour * 60 + b.startTime.minute;
        return aTime.compareTo(bTime);
      });
      notifyListeners();
    }
  }

  void updateCalendarActivity(Activity activity) {
    final index = _calendarActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _calendarActivities[index] = activity;
      notifyListeners();
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
              (activity.repeatFrequency == 'Daily' ||
                  (activity.repeatFrequency == 'Weekly' &&
                      activity.dateTime.weekday == day.weekday) ||
                  (activity.repeatFrequency == 'Monthly' &&
                      activity.dateTime.day == day.day) ||
                  (activity.repeatFrequency == 'Yearly' &&
                      activity.dateTime.month == day.month &&
                      activity.dateTime.day == day.day)));
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
