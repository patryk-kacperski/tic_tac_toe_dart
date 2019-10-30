import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';

/// Verifies if a given move is valid and places items on a board
abstract class ItemPlacerInputs {
  /// Checks if an item can be placed on a board
  /// [itemType] Type of an item to be placed
  /// [point] Coordinates where an item should be placed
  /// [board] Board on which an item should be placed
  PlacementResult canPlace(BoardItemType itemType, Point<int> point, BoardInputs board);

  /// Places an item on a board. Does NOT check if the placement is valid
  /// [itemType] Type of an item to be placed
  /// [point] Coordinates where an item should be placed
  /// [board] Board on which an item should be placed
  void place(BoardItemType itemType, Point<int> point, BoardInputs board);
}