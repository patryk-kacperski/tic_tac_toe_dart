import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/components/item_placer_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';
import 'package:tic_tac_toe/model/placement.dart';

class ItemPlacer implements ItemPlacerInputs {
  const ItemPlacer();
  @override
  PlacementResult canPlace(
    BoardItemType itemType,
    Point<int> point,
    BoardInputs board,
    BoardItemType currentItemType
  ) {
    if (!board.containts(point)) {
      return PlacementResult.outOfBoard;
    }
    if (board.getItemAt(point) != BoardItemType.none) {
      return PlacementResult.occupied;
    }
    if (itemType == BoardItemType.none) {
      return PlacementResult.nonePassed;
    }
    if (itemType != currentItemType) {
      return PlacementResult.wrongTypePassed;
    }
    return PlacementResult.valid;
  }

  @override
  void place(BoardItemType itemType, Point<int> point, BoardInputs board) {
    board.setItemAt(itemType, point);
  }

  @override
  void undo(int count, List<Placement> log, BoardInputs board) {
    final length = log.length;
    for (int i = 0; i < count; ++i) {
      final placement = log[length - 1 - i];
      board.setItemAt(BoardItemType.none, placement.point);
    }
    log.removeRange(length - count, length);
  }
}
