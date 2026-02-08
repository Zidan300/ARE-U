import 'package:appcomplication_app/screens/game_screen.dart';
import 'package:appcomplication_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

// NOTE: All Firebase and authentication-related imports and logic have been removed.

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  int _playerCount = 3;
  late List<TextEditingController> _nameControllers;

  @override
  void initState() {
    super.initState();
    _nameControllers = List.generate(_playerCount, (_) => TextEditingController());
  }

  // BUG FIX: Simplified and robust logic for handling player count changes.
  void _setPlayerCount(int count) {
    if (count == _playerCount) return;

    setState(() {
      // If we are removing players, dispose and remove the extra controllers.
      if (count < _playerCount) {
        for (int i = _playerCount - 1; i >= count; i--) {
          _nameControllers[i].dispose();
          _nameControllers.removeAt(i);
        }
      } 
      // If we are adding players, simply add new controllers.
      else {
        for (int i = _playerCount; i < count; i++) {
          _nameControllers.add(TextEditingController());
        }
      }
      _playerCount = count;
    });
  }

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final playerNames = _nameControllers.map((c) => c.text.trim()).where((name) => name.isNotEmpty).toList();
    if (playerNames.length != _playerCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for every player.')),
      );
      return;
    }
    final uniqueNames = playerNames.toSet();
    if (uniqueNames.length < playerNames.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player names must be unique.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(playerNames: playerNames)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARE-U - Set Up Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents a back button from appearing.
        // BUG FIX: Removed the actions button that relied on Firebase auth.
        actions: const [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('Who\'s Playing?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),
                _buildPlayerCountSelector(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _playerCount,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _nameControllers[index],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(labelText: 'Player ${index + 1}', labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)), filled: true, fillColor: Colors.white.withValues(alpha: 0.1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2))),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomButton(text: 'Let\'s Go!', onPressed: _startGame),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCountSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        int count = index + 3;
        bool isSelected = _playerCount == count;
        return GestureDetector(
          onTap: () => _setPlayerCount(count),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50, height: 50,
            decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle, border: isSelected ? Border.all(color: Colors.white, width: 2) : null),
            child: Center(child: Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.white))),
          ),
        );
      }),
    );
  }
}
