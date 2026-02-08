import 'package:appcomplication_app/screens/player_selection_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARE-U',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6A1B9A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDD835),
          brightness: Brightness.dark,
          primary: const Color(0xFFFDD835),
          secondary: const Color(0xFF81C784),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white, fontSize: 16)),
        useMaterial3: true,
      ),
      // Direct access to player selection screen, bypassing login
      home: const PlayerSelectionScreen(),
    );
  }
}
