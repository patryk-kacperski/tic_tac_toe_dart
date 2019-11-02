import 'dart:math';

import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

class Board implements BoardInputs {
  List<List<BoardItemType>> _board;
  final int _numberOfElementsToWin;

  Board(this._board, this._numberOfElementsToWin);

  @override
  BoardItemType getItemAt(Point<int> point) => _board[point.y][point.x];

  @override
  void setItemAt(BoardItemType itemType, Point<int> point) {
    _board[point.y][point.x] = itemType;
  }

  @override
  bool containts(Point<int> point) {
    return point.x >= 0 && point.x < size && point.y >= 0 && point.y < size;
  }

  @override
  void forEach(void Function(Point<int>, BoardItemType) op) {
    for (int x = 0; x < size; ++x) {
      for (int y = 0; y < size; ++y) {
        final point = Point(x, y);
        final itemType = getItemAt(point);
        op(point, itemType);
      }
    }
  }

  @override
  int get numberOfElementsToWin => _numberOfElementsToWin;

  @override
  int get size => _board.length;

  @override
  List<List<BoardItemType>> get state => _board;
}
