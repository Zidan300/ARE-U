import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// A centralized service for playing sound effects throughout the app.
class SoundService {
  // A player for short, one-off sound effects like clicks and swooshes.
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  // A separate player for longer or looping sounds like the siren.
  static final AudioPlayer _musicPlayer = AudioPlayer();

  /// Plays a short sound effect from the given asset path.
  static Future<void> playSfx(String assetPath) async {
    try {
      await _sfxPlayer.play(AssetSource(assetPath), volume: 0.7);
    } catch (e) {
      if (kDebugMode) {
        print("Error playing SFX: $e");
      }
    }
  }

  /// Plays the siren sound.
  static Future<void> playSiren() async {
    try {
      // Set release mode to loop to make the siren continuous.
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('audio/siren.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print("Error playing siren: $e");
      }
    }
  }

  /// Stops the siren sound.
  static Future<void> stopSiren() async {
    await _musicPlayer.stop();
  }

  /// Call this on app exit if needed, though AudioPlayer is good at self-managing.
  static void dispose() {
    _sfxPlayer.dispose();
    _musicPlayer.dispose();
  }
}
