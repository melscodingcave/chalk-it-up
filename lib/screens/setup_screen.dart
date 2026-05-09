import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/match.dart';
import 'match_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _playerOneController = TextEditingController();
  final _playerTwoController = TextEditingController();
  final _raceLengthController = TextEditingController(text: '7');

  void _startMatch() {
    final p1Name = _playerOneController.text.trim();
    final p2Name = _playerTwoController.text.trim();
    final raceLength = int.tryParse(_raceLengthController.text) ?? 7;

    if (p1Name.isEmpty || p2Name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both player names')),
      );
      return;
    }

    if (raceLength < 1 || raceLength > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Race length must be between 1 and 20')),
      );
      return;
    }

    final match = Match(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playerOne: Player(name: p1Name),
      playerTwo: Player(name: p2Name),
      raceLength: raceLength,
      startTime: DateTime.now(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MatchScreen(match: match)),
    );
  }

  @override
  void dispose() {
    _playerOneController.dispose();
    _playerTwoController.dispose();
    _raceLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          '🎱 Chalk It Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              'New Match',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '9-Ball',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _playerOneController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Player One Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _playerTwoController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Player Two Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _raceLengthController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration('Race Length (default: 7)'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF16213E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}
