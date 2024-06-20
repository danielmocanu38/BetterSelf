import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

  Future<void> _register() async {
    setState(() {
      _errorMessage = '';
      _emailError = false;
      _passwordError = false;
      _confirmPasswordError = false;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = true;
        _errorMessage = 'Email is required';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = true;
        _errorMessage = 'Password is required';
      });
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = true;
        _errorMessage = 'Confirm Password is required';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordError = true;
        _confirmPasswordError = true;
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (!mounted) return;

      if (user != null) {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to register';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _emailError = true;
            _errorMessage =
                'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            _emailError = true;
            _errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            _passwordError = true;
            _errorMessage =
                'The password is too weak. It must be at least 6 characters long.';
            break;
          default:
            _errorMessage = 'An unknown error occurred. Please try again.';
            break;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'BetterSelf',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: _emailError ? Colors.red : Colors.grey),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: _passwordError ? Colors.red : Colors.grey),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: _confirmPasswordError
                                ? Colors.red
                                : Colors.grey),
                      ),
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login"),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
