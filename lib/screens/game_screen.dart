import 'dart:async';
import 'dart:math';

import 'package:appcomplication_app/utils/sound_service.dart';
import 'package:appcomplication_app/widgets/card_flip_widget.dart';
import 'package:appcomplication_app/widgets/settings_overlay.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;

  const GameScreen({super.key, required this.playerNames});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game Config
  static const List<String> _cardTypes = ["ACT", "GESTURE"];
  static const int _initialTime = 30;

  // UI State
  bool _isSettingsVisible = false;

  // Game State
  String? _performer, _guesser, _suggester, _cardType;

  // Timer State
  Timer? _timer;
  int _countdown = _initialTime;
  bool _isTimerRunning = false;
  bool _timeUp = false;

  // Animation Controllers
  late AnimationController _cardFlipController, _timeUpPulseController, _panicShakeController;

  @override
  void initState() {
    super.initState();
    _cardFlipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _timeUpPulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600), reverseDuration: const Duration(milliseconds: 600));
    _panicShakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    
    _startNewRound(isFirstRound: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardFlipController.dispose();
    _timeUpPulseController.dispose();
    _panicShakeController.dispose();
    _resetAudio(); 
    super.dispose();
  }

  Future<void> _startNewRound({bool isFirstRound = false}) async {
    await _resetAudio();
    if (!isFirstRound) {
      SoundService.playSfx('audio/swoosh.mp3');
    }
    SoundService.playBackgroundMusic();

    final random = Random();
    if (mounted) {
      setState(() {
        final players = List<String>.from(widget.playerNames)..shuffle(random);
        _performer = players[0];
        _guesser = players[1];
        _suggester = players[2];
        _cardType = _cardTypes[random.nextInt(_cardTypes.length)];
        
        _resetVisuals();
        _cardFlipController.forward(from: 0.0);
      });
    }
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    setState(() { _isTimerRunning = true; });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          if (_countdown == 10 && !_panicShakeController.isAnimating) {
            _panicShakeController.repeat(reverse: true);
          }
        } else {
          timer.cancel();
          _isTimerRunning = false;
          if (!_timeUp) {
            _timeUp = true;
            SoundService.stopBackgroundMusic();
            SoundService.playSiren();
            _timeUpPulseController.repeat(reverse: true);
          }
        }
      });
    });
  }

  Future<void> _resetAudio() async {
    await SoundService.stopSiren();
    await SoundService.stopBackgroundMusic();
  }

  void _resetVisuals() {
    _timer?.cancel();
    if (_timeUpPulseController.isAnimating) _timeUpPulseController.stop();
    if (_panicShakeController.isAnimating) _panicShakeController.stop();
    _timeUpPulseController.reset();
    _panicShakeController.reset();
    _isTimerRunning = false;
    _timeUp = false;
    _countdown = _initialTime;
    _cardFlipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => setState(() { _isSettingsVisible = true; }),
              tooltip: 'Settings',
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                child: Column(
                  children: [
                    _buildPlayerRoles(),
                    Expanded(
                      child: Center(
                        child: _timeUp ? _buildTimeUpAlert() : _buildCard(),
                      ),
                    ),
                    _buildTimerWidget(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
            if (_isSettingsVisible)
              SettingsOverlay(onClose: () => setState(() { _isSettingsVisible = false; })),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlayerRoles() {
    return Column(
      children: [
        _buildPlayerChip('Performer', _performer ?? '', Colors.amber, Icons.star),
        _buildPlayerChip('Guesser', _guesser ?? '', Colors.lightBlueAccent, Icons.lightbulb_outline),
        _buildPlayerChip('Suggester', _suggester ?? '', Colors.lightGreenAccent, Icons.record_voice_over),
      ],
    );
  }

  Widget _buildPlayerChip(String r, String n, Color c, IconData i) => Chip(avatar: Icon(i, color: c), label: Text('$r: $n'));

  Widget _buildCard() {
    return CardFlipWidget(
      controller: _cardFlipController,
      front: const Card(color: Colors.blueGrey, child: SizedBox(width: 200, height: 250)),
      back: Card(
        color: const Color(0xFFFDD835),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8.0,
        child: SizedBox(
          width: 200, height: 250,
          child: Stack(
            children: [
              Center(child: Text(_cardType == 'ACT' ? 'ACT' : 'GESTURE', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black))),
              Positioned(bottom: 12.0, left: 0, right: 0, child: Text(_cardType == 'ACT' ? 'RolePlay' : 'Warning: Cannot Speak', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: _cardType == 'ACT' ? FontWeight.w600 : FontWeight.normal, fontStyle: _cardType == 'GESTURE' ? FontStyle.italic : FontStyle.normal, color: Colors.black.withOpacity(0.8)))),
            ],
          )
        ),
      ),
    );
  }
  
  Widget _buildTimeUpAlert() {
    return ScaleTransition(
      scale: _timeUpPulseController,
      child: Icon(Icons.front_hand, color: Colors.red.shade400, size: 120),
    );
  }

  // This widget has been updated for cross-platform compatibility.
  Widget _buildTimerWidget() {
    bool isPanic = _countdown <= 10 && _isTimerRunning;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: isPanic ? Colors.redAccent : Colors.white,
        // Add a red "glow" effect using shadows during panic mode.
        shadows: isPanic
            ? [
                const Shadow(blurRadius: 10.0, color: Colors.redAccent),
                const Shadow(blurRadius: 20.0, color: Colors.redAccent),
              ]
            : [],
      ),
      child: AnimatedBuilder(
        animation: _panicShakeController,
        builder: (context, child) {
          // Only apply the shake/scale if in panic mode.
          if (!isPanic) {
            return child!;
          }
          final shakeValue = sin(_panicShakeController.value * 2 * pi) * 5.0; // Horizontal shake
          final scaleValue = 1.0 + sin(_panicShakeController.value * pi) * 0.05; // Gentle pulse
          return Transform.translate(
            offset: Offset(shakeValue, 0),
            child: Transform.scale(
              scale: scaleValue,
              child: child,
            ),
          );
        },
        child: Text('0:${_countdown.toString().padLeft(2, '0')}'),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: _isTimerRunning ? null : _startTimer, style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18), textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), child: const Text('Start')),
        ElevatedButton(onPressed: () => _startNewRound(), style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), child: const Text('Restart')),
      ],
    );
  }
}
