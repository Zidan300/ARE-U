import 'package:appcomplication_app/screens/player_selection_screen.dart';
import 'package:appcomplication_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _navigateToPlayerSelection(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PlayerSelectionScreen()),
    );
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150), // Add space at the top
                const Text(
                  'Party Game!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 80),
                CustomButton(
                  text: 'Sign in with Google',
                  icon: FontAwesomeIcons.google,
                  onPressed: () => _navigateToPlayerSelection(context),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sign in with Facebook',
                  icon: FontAwesomeIcons.facebook,
                  onPressed: () => _navigateToPlayerSelection(context),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sign in with GitHub',
                  icon: FontAwesomeIcons.github,
                  onPressed: () => _navigateToPlayerSelection(context),
                ),
                const SizedBox(height: 100), // Add space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
