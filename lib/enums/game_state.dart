/// State of the current game
enum GameState {
  /// Game is in progress
  ongoing,

  /// Player with crosses won
  crossesWon,

  /// Player with circles won
  circlesWon,

  /// Tie between players
  tie,

  /// Game is not valid (for example both players are winning)
  invalid
}

GameState gameStateFromString(String str) =>
    GameState.values.firstWhere((e) => e.toString() == str);
