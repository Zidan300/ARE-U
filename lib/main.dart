import 'package:appcomplication_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Ensure Flutter framework is properly initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6A1B9A), // Deep Purple
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDD835), // Sunny Yellow
          brightness: Brightness.dark,
          primary: const Color(0xFFFDD835), // Sunny Yellow
          secondary: const Color(0xFF81C784), // Light Green
        ),
        scaffoldBackgroundColor: const Color(0xFF212121), // Dark Grey
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white)), // Removed custom font
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
