import 'dart:math';

import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';
import 'package:tic_tac_toe/model/placement.dart';

/// Takes in commands and performs actions upon it's state.
/// When sending commands with coordinates it should be assumed, that
/// point (0, 0) is in the top-left corner and point (n-1, n-1) is in
/// bottom-right corner, where n is size of the board
abstract class GameEngineInputs {
  // Methods:

  /// Tries to place an object on board. If placement is valid, it's performed,
  /// otherwise game state doesn't change and reason of failure is returned
  /// [x] X coordinate of field where an object should be placed
  /// [y] Y coordinate of field where an object should be placed
  /// [itemType] Type of object that should be placed
  PlacementResult attemptToPlaceWithRawCoords(
      int x, int y, BoardItemType itemType);

  /// Tries to place an item on board. If placement is valid, it's performed,
  /// otherwise game state doesn't change and reason of failure is returned
  /// [point] Coordinates of field where an item should be placed
  /// [itemType] Type of item that should be placed
  PlacementResult attemptToPlaceWithPoint(Point<int> point, BoardItemType itemType);

  /// Returns a set of fields where a new item can be placed
  Set<Point<int>> findValidFields();

  /// Returns a list of fields where current player can place an item to instantely win
  Set<Point<int>> findWinningFields();

  /// Undoes [count] number of previous placements. If [count] is ommited undoes last 
  /// placement.
  /// [count] must not be greater than size of [placementsLog] or else an exception is thrown
  void undoPlacement({int count});

  /// TODO
  String saveState();

  // Computed properties:

  /// Returns type of item that current player controlls
  BoardItemType get currentType;

  /// Returns state of a board
  List<List<BoardItemType>> get boardState;

  /// Returns size of a board
  int get boardSize;

  /// Returns number of elements that must be placed next to each other to win the game
  int get numberOfElementsToWin;

  /// Returns state of the game
  GameState get gameState;

  /// Returns a list of placements made this game
  List<Placement> get placementsLog;
}
