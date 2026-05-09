enum GameType { nineBall }

enum MatchStatus { inProgress, complete }

class Player {
  final String name;
  int score;
  int racksWon;
  bool broke;

  Player({
    required this.name,
    this.score = 0,
    this.racksWon = 0,
    this.broke = false,
  });
}

class Match {
  final String id;
  final Player playerOne;
  final Player playerTwo;
  final GameType gameType;
  final int raceLength;
  int innings;
  MatchStatus status;
  Player? winner;
  final DateTime startTime;

  Match({
    required this.id,
    required this.playerOne,
    required this.playerTwo,
    this.gameType = GameType.nineBall,
    required this.raceLength,
    this.innings = 0,
    this.status = MatchStatus.inProgress,
    this.winner,
    required this.startTime,
  });

  bool get isComplete => status == MatchStatus.complete;

  Player? get leader {
    if (playerOne.score > playerTwo.score) return playerOne;
    if (playerTwo.score > playerOne.score) return playerTwo;
    return null;
  }
}
