import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'planning_screen.dart';
import 'money_screen.dart';
import 'diet_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const PlanningScreen(),
    const MoneyScreen(),
    const DietScreen(),
    const TodoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return; // Check if the widget is still mounted
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetterSelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Money',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'To-Do',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
