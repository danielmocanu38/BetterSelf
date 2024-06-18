import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/activity.dart';
import '../viewmodels/activity_viewmodel.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  CalendarViewScreenState createState() => CalendarViewScreenState();
}

class CalendarViewScreenState extends State<CalendarViewScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> frequencyOptions = [
    'Only Once',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  void _addOrEditActivity({DateTime? selectedDate, Activity? activity}) {
    TextEditingController titleController =
        TextEditingController(text: activity?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: activity?.description ?? '');
    String selectedFrequency =
        activity?.repeatFrequency ?? frequencyOptions.first;
    TimeOfDay? startTime = activity?.startTime;
    TimeOfDay? endTime = activity?.endTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity == null ? 'Add Activity' : 'Edit Activity'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
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
              DropdownButtonFormField<String>(
                value: selectedFrequency,
                items: frequencyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedFrequency = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          startTime = selectedTime;
                        });
                      }
                    },
                    child: const Text('Select Start Time'),
                  ),
                  if (startTime != null) Text(startTime!.format(context)),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          endTime = selectedTime;
                        });
                      }
                    },
                    child: const Text('Select End Time'),
                  ),
                  if (endTime != null) Text(endTime!.format(context)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (startTime != null && endTime != null) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (activity == null) {
                    final newActivity = Activity(
                      id: DateTime.now().toString(),
                      userId: user.uid,
                      title: titleController.text,
                      description: descriptionController.text,
                      dateTime: selectedDate!,
                      isRoutine: selectedFrequency != 'Only Once',
                      repeatFrequency: selectedFrequency,
                      startTime: startTime!,
                      endTime: endTime!,
                    );
                    final viewModel =
                        Provider.of<ActivityViewModel>(context, listen: false);
                    viewModel.addCalendarActivity(newActivity);
                  } else {
                    final updatedActivity = Activity(
                      id: activity.id,
                      userId: activity.userId,
                      title: titleController.text,
                      description: descriptionController.text,
                      dateTime: activity.dateTime,
                      isRoutine: activity.isRoutine,
                      repeatFrequency: selectedFrequency,
                      startTime: startTime!,
                      endTime: endTime!,
                    );
                    final viewModel =
                        Provider.of<ActivityViewModel>(context, listen: false);
                    viewModel.updateCalendarActivity(updatedActivity);
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select start and end times.'),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          if (activity != null)
            TextButton(
              onPressed: () {
                final viewModel =
                    Provider.of<ActivityViewModel>(context, listen: false);
                viewModel.removeCalendarActivity(activity.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ActivityViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final activities = viewModel.getCalendarActivitiesForDay(date);
                if (activities.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDay == null
                  ? 0
                  : viewModel.getCalendarActivitiesForDay(_selectedDay!).length,
              itemBuilder: (context, index) {
                final activity =
                    viewModel.getCalendarActivitiesForDay(_selectedDay!)[index];
                return ListTile(
                  title: Text(activity.title),
                  subtitle: Text(activity.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _addOrEditActivity(activity: activity);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          final viewModel = Provider.of<ActivityViewModel>(
                              context,
                              listen: false);
                          viewModel.removeCalendarActivity(activity.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedDay != null
            ? () => _addOrEditActivity(selectedDate: _selectedDay!)
            : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
