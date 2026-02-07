import 'package:appcomplication_app/utils/sound_service.dart';
import 'package:flutter/material.dart';

class SettingsOverlay extends StatefulWidget {
  final Function() onClose;

  const SettingsOverlay({super.key, required this.onClose});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  // The state is now managed by the SoundService, this is just for the UI.
  late double _currentVolume;
  late bool _isMusicEnabled;

  @override
  void initState() {
    super.initState();
    _currentVolume = SoundService.musicVolume;
    _isMusicEnabled = _currentVolume > 0;
  }

  void _onVolumeChanged(double newVolume) {
    setState(() {
      _currentVolume = newVolume;
      _isMusicEnabled = newVolume > 0;
    });
    SoundService.setMusicVolume(_currentVolume);
  }

  void _toggleMusic() {
    // When toggling, set volume between 0 and a default of 50%.
    final newVolume = _isMusicEnabled ? 0.0 : 0.5;
    _onVolumeChanged(newVolume);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Music Volume', style: TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_isMusicEnabled ? Icons.volume_up : Icons.volume_off, color: Colors.white),
                        onPressed: _toggleMusic,
                      ),
                      SizedBox(
                        width: 200, // Give the slider a fixed width
                        child: Slider(
                          value: _currentVolume,
                          onChanged: _onVolumeChanged,
                          min: 0.0,
                          max: 1.0,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
