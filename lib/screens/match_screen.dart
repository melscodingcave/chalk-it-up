import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/match.dart';

class MatchScreen extends StatefulWidget {
  final Match match;

  const MatchScreen({super.key, required this.match});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  String _trashTalk = '';
  bool _loadingTrashTalk = false;
  late Match _match;

  @override
  void initState() {
    super.initState();
    _match = widget.match;
  }

  void _addPoint(Player player) {
    if (_match.isComplete) return;

    setState(() {
      player.score++;
      player.racksWon++;

      if (player.score >= _match.raceLength) {
        _match.status = MatchStatus.complete;
        _match.winner = player;
      }
    });
  }

  void _incrementInnings() {
    if (_match.isComplete) return;
    setState(() => _match.innings++);
  }

  void _setBrake(Player player) {
    setState(() {
      _match.playerOne.broke = false;
      _match.playerTwo.broke = false;
      player.broke = true;
    });
  }

  Future<void> _generateTrashTalk() async {
    setState(() => _loadingTrashTalk = true);

    final winner = _match.winner!;
    final loser = winner == _match.playerOne
        ? _match.playerTwo
        : _match.playerOne;

    final prompt =
        '''You are a billiards trash talk generator. 
Generate ONE short, funny, billiards-themed trash talk line 
(max 20 words) from the winner to the loser. 
Winner: ${winner.name} (score: ${winner.score})
Loser: ${loser.name} (score: ${loser.score})
Race to: ${_match.raceLength}
Innings: ${_match.innings}
Keep it light, fun, and billiards-specific. No profanity.''';

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key':
              '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',
          'anthropic-version': '2023-06-01',
          'anthropic-dangerous-direct-browser-access': 'true',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-5',
          'max_tokens': 100,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        _trashTalk = data['content'][0]['text'];
        _loadingTrashTalk = false;
      });
    } catch (e) {
      setState(() {
        _trashTalk = 'Even the AI is speechless at that performance! 🎱';
        _loadingTrashTalk = false;
      });
    }
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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Innings: ${_match.innings}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Match info bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF16213E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '9-Ball • Race to ${_match.raceLength}',
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: _incrementInnings,
                  icon: const Icon(Icons.add, color: Colors.grey, size: 16),
                  label: const Text(
                    'Inning',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Score area
          Expanded(
            child: Row(
              children: [
                _buildPlayerPanel(_match.playerOne),
                Container(width: 1, color: Colors.blue.shade900),
                _buildPlayerPanel(_match.playerTwo),
              ],
            ),
          ),

          // Break indicator
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF16213E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Break: ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 8),
                _breakButton(_match.playerOne),
                const SizedBox(width: 8),
                _breakButton(_match.playerTwo),
              ],
            ),
          ),

          // Winner banner
          if (_match.isComplete)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade900,
              child: Column(
                children: [
                  Text(
                    '🏆 ${_match.winner?.name} wins!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_trashTalk.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '"$_trashTalk"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _loadingTrashTalk ? null : _generateTrashTalk,
                    icon: const Text('🤖', style: TextStyle(fontSize: 16)),
                    label: Text(
                      _loadingTrashTalk
                          ? 'Generating...'
                          : 'Generate Trash Talk',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerPanel(Player player) {
    final isWinner = _match.winner == player;
    final isLeading = _match.leader == player && !_match.isComplete;

    return Expanded(
      child: GestureDetector(
        onTap: () => _addPoint(player),
        child: Container(
          color: isWinner
              ? Colors.blue.shade900.withValues(alpha: 0.3)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  color: isLeading ? Colors.blue : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${player.score}',
                style: TextStyle(
                  color: isWinner ? Colors.blue : Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'of ${_match.raceLength}',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (!_match.isComplete)
                const Text(
                  'Tap to score',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _breakButton(Player player) {
    return GestureDetector(
      onTap: () => _setBrake(player),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: player.broke ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          player.name,
          style: TextStyle(
            color: player.broke ? Colors.white : Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
