import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/components/fields_finder_input.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

class FieldsFinder implements FieldsFinderInputs {
  @override
  Set<Point<int>> findValidFields(BoardInputs board) {
    Set<Point<int>> validFields;
    board.forEach((point, itemType) {
      if (itemType == BoardItemType.none) {
        validFields.add(point);
      }
    });
    return validFields;
  }

  @override
  Set<Point<int>> findWinningFields(BoardInputs board, BoardItemType itemType) {
    Set<Point<int>> winningFields;
    board.forEach((point, currentItemType) {
      if (currentItemType != BoardItemType.none) {
        return;
      }
      if (_checkHorizontally(board, point, itemType) ||
          _checkVertically(board, point, itemType) ||
          _checkOnMainDiagonal(board, point, itemType) ||
          _checkOnMinorDiagonal(board, point, itemType)) {
        winningFields.add(point);
      }
    });
    return winningFields;
  }

  bool _checkHorizontally(
    BoardInputs board,
    Point<int> point,
    BoardItemType itemType,
  ) {
    return _checkLine(
      board,
      point,
      itemType,
      increase: (p) => Point(p.x + 1, p.y),
      decrease: (p) => Point(p.x - 1, p.y),
    );
  }

  bool _checkVertically(
    BoardInputs board,
    Point<int> point,
    BoardItemType itemType,
  ) {
    return _checkLine(
      board,
      point,
      itemType,
      increase: (p) => Point(p.x, p.y + 1),
      decrease: (p) => Point(p.x, p.y - 1),
    );
  }

  bool _checkOnMainDiagonal(
    BoardInputs board,
    Point<int> point,
    BoardItemType itemType,
  ) {
    return _checkLine(
      board,
      point,
      itemType,
      increase: (p) => Point(p.x + 1, p.y + 1),
      decrease: (p) => Point(p.x - 1, p.y - 1),
    );
  }

  bool _checkOnMinorDiagonal(
    BoardInputs board,
    Point<int> point,
    BoardItemType itemType,
  ) {
    return _checkLine(
      board,
      point,
      itemType,
      increase: (p) => Point(p.x - 1, p.y + 1),
      decrease: (p) => Point(p.x + 1, p.y - 1),
    );
  }

  bool _checkLine(
    BoardInputs board,
    Point<int> point,
    BoardItemType itemType, {
    Point Function(Point) increase,
    Point Function(Point) decrease,
  }) {
    Point next = increase(point);
    Point previous = decrease(point);
    int count = 0;

    while (board.containts(next) && board.getItemAt(next) == itemType) {
      count++;
      next = increase(next);
    }
    while (board.containts(previous) && board.getItemAt(previous) == itemType) {
      count++;
      previous = decrease(previous);
    }

    return count == board.numberOfElementsToWin;
  }
}
