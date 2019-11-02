enum TicTacToeErrors {
  engineConstructionError
}

class TicTacToeException implements Exception {
  final TicTacToeErrors cause;
  final String message;

  TicTacToeException(this.cause, this.message);
}