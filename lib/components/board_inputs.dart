import 'dart:math';

import 'package:tic_tac_toe/enums/board_item_type.dart';

/// Holds information about board dimensions and items placed,
/// and is responsible for placing new items
/// The coordinate space of a board starts with (0, 0) at top-left corner
/// and ends with (n-1, n-1) at bottom-right, where n is size of a board
abstract class BoardInputs {
  // Methods:

  /// Returns item at given coordinates.
  /// Doest NOT verify if [point] is within board's bounds
  /// [point] Coordinates of item to get
  BoardItemType getItemAt(Point point);

  /// Places item at coordinates.
  /// Does NOT verify, if [point] is within boards's bounds or if
  /// it is a valid move
  /// [itemType] Type of item to place.
  /// [point] Coordinates of object to place.
  void setItemAt(BoardItemType itemType, Point point);

  /// Checks if given field is in board's bounds
  bool containts(Point point);

  /// Iterates over all fields and performs passed function on each of them
  void forEach(void Function(Point, BoardItemType) op);

  // Computed Properties:

  /// Returns of all board's fields and items they contain
  List<List<BoardItemType>> get state;

  /// Returns size of the board
  int get size;

  /// Returns number of elements that must be placed in line in
  /// order to win the game 
  int get numberOfElementsToWin;
}