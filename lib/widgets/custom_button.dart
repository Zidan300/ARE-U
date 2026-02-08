import 'package:appcomplication_app/utils/sound_service.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Play the click sound and then execute the original function
        SoundService.playSfx('audio/swoosh.mp3');
        onPressed();
      },
      icon: icon != null ? Icon(icon, size: 24.0) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
