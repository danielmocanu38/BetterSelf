import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _addActivity(int dayIndex) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
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
              if (startTime != null && endTime != null) {
                final viewModel =
                    Provider.of<ActivityViewModel>(context, listen: false);
                viewModel.addWeeklyActivity(Activity(
                  id: DateTime.now().toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  dateTime: DateTime.now().add(
                      Duration(days: dayIndex - DateTime.now().weekday + 1)),
                  isRoutine: false,
                  repeatFrequency: '',
                  startTime: startTime!,
                  endTime: endTime!,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
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
      appBar: AppBar(
        title: const Text('Weekly View'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(daysOfWeek.length, (index) {
            return SizedBox(
              width: 240.0,
              child: Card(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(activity.description),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addActivity(index);
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
