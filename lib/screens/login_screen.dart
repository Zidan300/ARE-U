import 'package:appcomplication_app/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // A single method to handle all sign-in logic.
  // It shows a loading indicator and displays errors.
  Future<void> _signIn(Future<void> Function() signInMethod) async {
    if (_isLoading) return; // Prevent multiple taps
    setState(() { _isLoading = true; });

    try {
      await signInMethod();
      // On success, the AuthWrapper will handle navigation.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icon/app_logo.png', height: 150),
                      const SizedBox(height: 60),
                      CustomButton(
                        text: 'Sign in with Google',
                        icon: FontAwesomeIcons.google,
                        onPressed: () => _signIn(AuthService.signInWithGoogle),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => _signIn(AuthService.signInAnonymously),
                        child: const Text(
                          'Play as a Guest',
                          style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
