import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'viewmodels/activity_viewmodel.dart';
import 'viewmodels/money_viewmodel.dart';
import 'viewmodels/diet_viewmodel.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/weekly_view_screen.dart';
import 'views/calendar_view_screen.dart';
import 'views/money_planning_screen.dart';
import 'views/budget_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => MoneyViewModel()),
        ChangeNotifierProvider(create: (_) => DietViewModel()),
        ChangeNotifierProvider(create: (_) => TodoViewModel()),
      ],
      child: MaterialApp(
        title: 'BetterSelf',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyLarge: const TextStyle(),
                bodyMedium: const TextStyle(),
              ),
        ),
        home: const AuthGate(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/weekly-view': (context) => const WeeklyViewScreen(),
          '/calendar-view': (context) => const CalendarViewScreen(),
          '/money-planning': (context) => const MoneyPlanningScreen(),
          '/budget-management': (context) => BudgetManagementScreen(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            // Clear data on logout
            Provider.of<ActivityViewModel>(context, listen: false)
                .clearActivities();
            Provider.of<MoneyViewModel>(context, listen: false).clearData();
            return const LoginScreen();
          } else {
            // Load user-specific data on login
            Provider.of<ActivityViewModel>(context, listen: false)
                .loadActivities(user.uid);
            Provider.of<MoneyViewModel>(context, listen: false)
                .loadExpensesAndBudget(user.uid);
            return const HomeScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
