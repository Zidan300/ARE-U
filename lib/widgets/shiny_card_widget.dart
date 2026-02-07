import 'package:flutter/material.dart';

/// A widget that displays a card with a shiny gradient, text, and subtitle.
class ShinyCardWidget extends StatefulWidget {
  final String cardType;

  const ShinyCardWidget({super.key, required this.cardType});

  @override
  State<ShinyCardWidget> createState() => _ShinyCardWidgetState();
}

class _ShinyCardWidgetState extends State<ShinyCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    // The shimmer animation runs in a slow, continuous loop.
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActCard = widget.cardType == 'ACT';

    // Define colors and subtitles based on the card type.
    final gradientColors = isActCard
        ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] // Yellow -> Amber
        : [const Color(0xFFFF4F9A), const Color(0xFFC837AB)]; // Pink -> Magenta

    final subtitleText = isActCard ? 'RolePlay' : 'Warning: Cannot Speak';
    final subtitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: isActCard ? FontWeight.w600 : FontWeight.normal,
      fontStyle: isActCard ? FontStyle.normal : FontStyle.italic,
      color: Colors.white.withOpacity(0.9),
    );

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.antiAlias, // Ensures the shimmer stays within the card bounds.
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // The subtle shine effect that sweeps across the card.
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(-150 + (_shimmerController.value * 400), 0),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.4, 0.5, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // The main card content (title and subtitle).
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  Text(
                    widget.cardType,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 12.0, color: Colors.black54)],
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(subtitleText, style: subtitleStyle),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
