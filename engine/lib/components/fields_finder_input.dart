import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

/// Finds specific sets of field coordinates
/// i.e. those that are valid
abstract class FieldsFinderInputs {
  /// Returns set of points that an item can be placed at
  /// [board] Board to examine
  Set<Point<int>> findValidFields(BoardInputs board);

  /// Returns set of points that an item can be placed at for player
  /// controlling [itemType] to instantely win
  /// [board] Board to examine
  /// [itemType] Type of items to check
  Set<Point<int>> findWinningFields(BoardInputs board, BoardItemType itemType);
}