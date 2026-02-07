import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// A centralized service for playing all audio throughout the app.
class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _sirenPlayer = AudioPlayer();
  static final AudioPlayer _backgroundMusicPlayer = AudioPlayer();

  // Stores the current volume of the music, defaulting to 100%.
  static double _musicVolume = 1.0;
  static double get musicVolume => _musicVolume;

  static Future<void> playSfx(String assetPath) async {
    try {
      await _sfxPlayer.play(AssetSource(assetPath), volume: 0.7);
    } catch (e) {
      if (kDebugMode) print("Error playing SFX: $e");
    }
  }

  static Future<void> playSiren() async {
    try {
      await _sirenPlayer.setReleaseMode(ReleaseMode.loop);
      await _sirenPlayer.play(AssetSource('audio/siren.mp3'));
    } catch (e) {
      if (kDebugMode) print("Error playing siren: $e");
    }
  }

  static Future<void> stopSiren() async {
    await _sirenPlayer.stop();
  }

  /// Plays the looping background music at the currently stored volume.
  static Future<void> playBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(_musicVolume);
      await _backgroundMusicPlayer.play(AssetSource('audio/baby.mp3'));
    } catch (e) {
      if (kDebugMode) print("Error playing background music: $e");
    }
  }

  static Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
  }

  /// Sets the music volume and updates the static state.
  static Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    await _backgroundMusicPlayer.setVolume(_musicVolume);
  }

  static void dispose() {
    _sfxPlayer.dispose();
    _sirenPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}
