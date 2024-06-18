import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  void _addActivity(DateTime selectedDate) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String selectedFrequency = frequencyOptions.first;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
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
                final activity = Activity(
                  id: DateTime.now().toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  dateTime: selectedDate,
                  isRoutine: true,
                  repeatFrequency: selectedFrequency,
                  startTime: startTime!,
                  endTime: endTime!,
                );
                final viewModel =
                    Provider.of<ActivityViewModel>(context, listen: false);
                viewModel.addCalendarActivity(activity);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select start and end times.'),
                  ),
                );
              }
            },
            child: const Text('Add'),
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _selectedDay != null ? () => _addActivity(_selectedDay!) : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
