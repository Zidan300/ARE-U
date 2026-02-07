import 'package:flutter/material.dart';
import 'dart:math';

class ScreenShakeWidget extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  const ScreenShakeWidget({super.key, required this.child, required this.controller});

  @override
  State<ScreenShakeWidget> createState() => _ScreenShakeWidgetState();
}

class _ScreenShakeWidgetState extends State<ScreenShakeWidget> {
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      child: widget.child,
      builder: (context, child) {
        // Uses a sine wave to create a shake effect
        final sineValue = sin(4 * pi * _shakeAnimation.value);
        return Transform.translate(
          // The offset controls the shake distance. 8 pixels here.
          offset: Offset(sineValue * 8, 0),
          child: child,
        );
      },
    );
  }
}
