enum TicTacToeErrors {
  engineConstructionError,
  undoArgumentError,
  parsingError
}

class TicTacToeException implements Exception {
  final TicTacToeErrors cause;
  final String message;

  TicTacToeException(this.cause, this.message);
}