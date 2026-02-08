import 'package:flutter/material.dart';

class AlertOverlayWidget extends StatelessWidget {
  final AnimationController controller;

  const AlertOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            // The opacity is animated from 0.0 (fully transparent) to 0.3 (semi-transparent red)
            // and then back to 0.0, creating a pulsing effect.
            color: Colors.red.withValues(alpha: controller.value * 0.3),
          );
        },
      ),
    );
  }
}
