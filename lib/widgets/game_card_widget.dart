import 'package:flutter/material.dart';

/// A simple, flat, sunny yellow card widget.
class GameCardWidget extends StatelessWidget {
  final String cardType;

  const GameCardWidget({super.key, required this.cardType});

  @override
  Widget build(BuildContext context) {
    final isActCard = cardType == 'ACT';
    final subtitleText = isActCard ? 'RolePlay' : 'Warning: Cannot Speak';
    
    // Sunny Yellow background
    const backgroundColor = Color(0xFFFFD700);

    return Card(
      elevation: 0.0, // Flat design
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 200,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Use FittedBox to ensure the text fits within the card width without overflowing.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cardType,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Dark text for readability on yellow
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Text(
                subtitleText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87, // Slightly softer black for subtitle
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
