import 'dart:async';
import 'dart:math';

import 'package:appcomplication_app/utils/sound_service.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;

  const GameScreen({super.key, required this.playerNames});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game Config
  static const List<String> _cardTypes = ["ACT", "GESTURE", "SONG", "DANCE"];
  static const int _initialTime = 30;

  // Game State
  String? _performer, _guesser, _suggester;
  String? _cardType;

  // Timer State
  Timer? _timer;
  int _countdown = _initialTime;
  bool _isTimerRunning = false;
  bool _timeUp = false;

  late AnimationController _timerPulseController;

  @override
  void initState() {
    super.initState();
    _timerPulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 500));
    _timerPulseController.repeat(reverse: true);
    _startNewRound();
  }

  void _startNewRound() {
    SoundService.playSfx('audio/swoosh.mp3');

    final random = Random();
    final players = List<String>.from(widget.playerNames)..shuffle(random);

    if (mounted) {
      setState(() {
        _performer = players[0];
        _guesser = players[1];
        _suggester = players[2];
        _cardType = _cardTypes[random.nextInt(_cardTypes.length)];
        _resetTimer();
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
        } else {
          timer.cancel();
          _isTimerRunning = false;
          if (!_timeUp) {
            _timeUp = true;
            SoundService.playSiren();
          }
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    SoundService.stopSiren();
    _isTimerRunning = false;
    _timeUp = false;
    _countdown = _initialTime;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerPulseController.dispose();
    SoundService.stopSiren();
    super.dispose();
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
          title: const Text('Game Round'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
            child: Column(
              children: [
                _buildPlayerRoles(),
                Expanded(
                  child: Center(
                    child: _timeUp ? _buildSirenAlert() : _buildCard(),
                  ),
                ),
                _buildTimerDisplay(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
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

  Widget _buildPlayerChip(String role, String name, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Chip(
        avatar: Icon(icon, color: color, size: 24),
        label: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 18),
            children: [
              TextSpan(text: '$role: ', style: TextStyle(color: Colors.white.withOpacity(0.8))),
              TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      elevation: 12,
      color: const Color(0xFFFDD835),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: 200, height: 250, alignment: Alignment.center,
        child: Text(_cardType ?? '', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }

  Widget _buildSirenAlert() {
    return ScaleTransition(
      scale: _timerPulseController,
      child: Icon(Icons.front_hand, color: Colors.red.shade400, size: 120),
    );
  }

  Widget _buildTimerDisplay() {
    final double progress = _countdown / _initialTime;
    final bool isPulsing = _isTimerRunning && _countdown <= 10;
    
    return Column(
      children: [
        ScaleTransition(
          scale: isPulsing ? _timerPulseController : const AlwaysStoppedAnimation(1.0),
          child: Text('0:${_countdown.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(progress > 0.33 ? Colors.greenAccent : Colors.redAccent),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _isTimerRunning ? null : _startTimer,
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18)),
          child: const Text('Start', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          onPressed: _startNewRound,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18)),
          child: const Text('Restart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
