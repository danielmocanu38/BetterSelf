import 'package:flutter/material.dart';
import 'weekly_view_screen.dart';
import 'calendar_view_screen.dart';

class ActivityPlanningScreen extends StatefulWidget {
  const ActivityPlanningScreen({super.key});

  @override
  ActivityPlanningScreenState createState() => ActivityPlanningScreenState();
}

class ActivityPlanningScreenState extends State<ActivityPlanningScreen> {
  // ignore: unused_field
  int _selectedViewIndex = 0;

  final List<Widget> _views = const [
    WeeklyViewScreen(),
    CalendarViewScreen(),
  ];

  void _onViewChanged(int index) {
    setState(() {
      _selectedViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Planning'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Weekly View'),
              Tab(text: 'Calendar View'),
            ],
            onTap: _onViewChanged,
          ),
        ),
        body: TabBarView(
          children: _views,
        ),
      ),
    );
  }
}
