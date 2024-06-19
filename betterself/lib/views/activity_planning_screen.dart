import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/activity_viewmodel.dart'; // Adjust this import based on your actual view model location
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
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Provider.of<ActivityViewModel>(context, listen: false)
          .loadActivities(user.uid);
    }
  }

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
        body: FutureBuilder<void>(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            } else {
              return TabBarView(
                children: _views,
              );
            }
          },
        ),
      ),
    );
  }
}
