import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/activity_viewmodel.dart';
import '../models/activity.dart';

class WeeklyViewScreen extends StatefulWidget {
  const WeeklyViewScreen({super.key});

  @override
  WeeklyViewScreenState createState() => WeeklyViewScreenState();
}

class WeeklyViewScreenState extends State<WeeklyViewScreen> {
  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<ScrollController> _scrollControllers =
      List.generate(7, (index) => ScrollController());

  void _addOrEditActivity({int? dayIndex, Activity? activity}) {
    TextEditingController titleController =
        TextEditingController(text: activity?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: activity?.description ?? '');
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
                  final viewModel =
                      Provider.of<ActivityViewModel>(context, listen: false);
                  if (activity == null) {
                    final newActivity = Activity(
                      id: DateTime.now().toString(),
                      userId: user.uid,
                      title: titleController.text,
                      description: descriptionController.text,
                      dateTime: DateTime.now().add(Duration(
                          days: dayIndex! - DateTime.now().weekday + 1)),
                      isRoutine: false,
                      repeatFrequency: '',
                      startTime: startTime!,
                      endTime: endTime!,
                    );
                    viewModel.addWeeklyActivity(newActivity);
                  } else {
                    final updatedActivity = Activity(
                      id: activity.id,
                      userId: activity.userId,
                      title: titleController.text,
                      description: descriptionController.text,
                      dateTime: activity.dateTime,
                      isRoutine: activity.isRoutine,
                      repeatFrequency: activity.repeatFrequency,
                      startTime: startTime!,
                      endTime: endTime!,
                    );
                    viewModel.updateWeeklyActivity(updatedActivity);
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
                viewModel.removeWeeklyActivity(activity.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ActivityViewModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(daysOfWeek.length, (index) {
            return SizedBox(
              width: 300.0,
              child: Card(
                color: index >= 5
                    ? Colors.grey[100]
                    : Colors.white, // Highlight weekend days
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        daysOfWeek[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollControllers[index],
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollControllers[index],
                          itemCount:
                              viewModel.getWeeklyActivitiesForDay(index).length,
                          itemBuilder: (context, activityIndex) {
                            final activity =
                                viewModel.getWeeklyActivitiesForDay(
                                    index)[activityIndex];
                            return ExpansionTile(
                              title: Text(activity.title),
                              subtitle: Text(
                                '${activity.startTime.format(context)} - ${activity.endTime.format(context)}',
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(activity.description),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _addOrEditActivity(
                                          dayIndex: index,
                                          activity: activity,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        final viewModel =
                                            Provider.of<ActivityViewModel>(
                                                context,
                                                listen: false);
                                        viewModel
                                            .removeWeeklyActivity(activity.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addOrEditActivity(dayIndex: index);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
