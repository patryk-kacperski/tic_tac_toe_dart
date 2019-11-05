import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/components/game_state_inspector_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/mappings.dart';

class _LineCount {
  /// Number of items of the same type next to each other
  int count;

  /// Set to true when winning conditions are met
  bool confirmed;

  /// Type of items counted
  BoardItemType type;

  _LineCount(this.count, this.confirmed, this.type);

  _LineCount.empty()
      : count = 0,
        confirmed = false,
        type = BoardItemType.none;
}

class GameStateInspector implements GameStateInspectorInputs {
  const GameStateInspector();
  
  @override
  GameState checkGameState(BoardInputs board) {
    // Preparing counters
    List<_LineCount> horizontalCounts = List.generate(
      board.size,
      (_) => _LineCount.empty(),
    );
    List<_LineCount> verticalCounts = List.generate(
      board.size,
      (_) => _LineCount.empty(),
    );
    List<_LineCount> mainDiagonalCounts = List.generate(
      _diagonalCountsSize(board),
      (_) => _LineCount.empty(),
    );
    List<_LineCount> minorDiagonalCounts = List.generate(
      _diagonalCountsSize(board),
      (_) => _LineCount.empty(),
    );
    int emptyFieldsCount = 0;

    // Checking if any player won
    for (int i = 0; i < board.size; ++i) {
      for (int j = 0; j < board.size; ++j) {
        final point = Point<int>(i, j);
        final itemType = board.getItemAt(point);

        int horizontalIndex = point.y;
        _updateCount(
          horizontalCounts[horizontalIndex],
          itemType,
          board.numberOfElementsToWin,
        );

        int verticalIndex = point.x;
        _updateCount(
          verticalCounts[verticalIndex],
          itemType,
          board.numberOfElementsToWin,
        );

        int mainDiagonalIndex =
            point.x - point.y + board.size - board.numberOfElementsToWin;
        if (mainDiagonalIndex >= 0 &&
            mainDiagonalIndex < mainDiagonalCounts.length) {
          _updateCount(
            mainDiagonalCounts[mainDiagonalIndex],
            itemType,
            board.numberOfElementsToWin,
          );
        }

        int minorDiagonalIndex = 2 * board.size -
            point.x -
            point.y -
            board.numberOfElementsToWin -
            1;
        if (minorDiagonalIndex >= 0 &&
            minorDiagonalIndex < minorDiagonalCounts.length) {
          _updateCount(
            minorDiagonalCounts[minorDiagonalIndex],
            itemType,
            board.numberOfElementsToWin,
          );
        }

        // Counting empty fields to see if there is a tie
        if (itemType == BoardItemType.none) {
          emptyFieldsCount++;
        }
      }
    }
    // Checking count results
    final horizontalResults = _checkCounts(
      horizontalCounts,
      board.numberOfElementsToWin,
    );
    final verticalResults = _checkCounts(
      verticalCounts,
      board.numberOfElementsToWin,
    );
    final mainDiagonalResults = _checkCounts(
      mainDiagonalCounts,
      board.numberOfElementsToWin,
    );
    final minorDiagonalResults = _checkCounts(
      minorDiagonalCounts,
      board.numberOfElementsToWin,
    );
    GameState result = _compareResults(
      horizontalResults,
      verticalResults,
      mainDiagonalResults,
      minorDiagonalResults,
    );

    // If game is ongoing and there are no more empty fields then it is a tie
    if (result == GameState.ongoing) {
      return emptyFieldsCount == 0 ? GameState.tie : GameState.ongoing;
    }

    return result;
  }

  int _diagonalCountsSize(BoardInputs board) {
    return 2 * (board.size - board.numberOfElementsToWin) + 1;
  }

  void _updateCount(
    _LineCount count,
    BoardItemType itemType,
    int numberOfElementsToWin,
  ) {
    if (count.count == numberOfElementsToWin && itemType != count.type) {
      count.confirmed = true;
    }
    if (count.confirmed) {
      return;
    }
    if (itemType == BoardItemType.none) {
      count.count = 0;
      return;
    }
    if (itemType == count.type) {
      count.count++;
    } else {
      count.type = itemType;
      count.count = 1;
    }
  }

  GameState _checkCounts(List<_LineCount> counts, int numberOfElementsToWin) {
    BoardItemType currentType = BoardItemType.none;
    GameState gameState = GameState.ongoing;
    for (final count in counts) {
      if (count.count == numberOfElementsToWin) {
        if (currentType == BoardItemType.none || currentType == count.type) {
          currentType = count.type;
          gameState = boardItemTypeToGameState(count.type);
        } else {
          return GameState.invalid;
        }
      }
    }
    return gameState;
  }

  GameState _compareResults(
    GameState r1,
    GameState r2,
    GameState r3,
    GameState r4,
  ) {
    final states = [r1, r2, r3, r4];

    // If any state is invalid return invalid
    if (states.contains(GameState.invalid)) {
      return GameState.invalid;
    }

    // Removing all ongoing states
    states.removeWhere((state) => state == GameState.ongoing);

    // If all removed, then game is ongoing
    if (states.isEmpty) {
      return GameState.ongoing;
    }

    // If all remaining are circles won, then circles won
    if (states.every((state) => state == GameState.circlesWon)) {
      return GameState.circlesWon;
    }

    // If all remaining are crosses won, then crosses won
    if (states.every((state) => state == GameState.crossesWon)) {
      return GameState.crossesWon;
    }

    // If 2 different sides won at the same time then that is an invalid state
    return GameState.invalid;
  }
}
