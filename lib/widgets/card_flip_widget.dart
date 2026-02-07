import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that performs a 3D flip animation on a card.
/// This implementation correctly handles the back content to prevent mirrored text.
class CardFlipWidget extends StatelessWidget {
  final AnimationController controller;
  final Widget front;
  final Widget back;

  const CardFlipWidget({
    super.key,
    required this.controller,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // The animation controller's value goes from 0.0 to 1.0.
        // We map this to a rotation from 0 to 180 degrees (0 to pi radians).
        final angle = controller.value * pi;

        // Determine if the card is past the 90-degree flip point.
        final isFlipped = angle >= (pi / 2);

        // This Transform applies the main 3D rotation to the entire widget.
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Adds perspective for a 3D effect.
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFlipped
              // If we are past 90 degrees, show the back of the card.
              ? Transform(
                  // This corrective transform rotates the back content by 180 degrees,
                  // effectively "un-mirroring" it so the text is always readable.
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: back, // The back widget with the readable text.
                )
              // If we are not yet at 90 degrees, show the front of the card.
              : front,
        );
      },
    );
  }
}
