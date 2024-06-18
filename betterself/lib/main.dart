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
        ChangeNotifierProvider(create: (_) => ActivityViewModel()),
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
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(), // Added this line
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while checking auth state
        }
        if (snapshot.hasData) {
          return const HomeScreen(); // User is logged in, navigate to HomeScreen
        }
        return const LoginScreen(); // User is not logged in, navigate to LoginScreen
      },
    );
  }
}
