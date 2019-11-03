import 'dart:math';

import 'package:tic_tac_toe/components/board.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

const _ = BoardItemType.none;
const o = BoardItemType.circle;
const x = BoardItemType.cross;

Point<int> p(int x, int y) => Point(x, y);

List<List<BoardItemType>> createFieldsEmpty() {
  return [
    [_, _, _],
    [_, _, _],
    [_, _, _],
  ];
}

List<List<BoardItemType>> createFieldsFilled() {
  return [
    [_, _, o],
    [_, _, o],
    [_, _, x],
  ];
}

List<List<BoardItemType>> createFieldsForFieldsFinder() {
  return [
    [_, _, _, _, _, _, _, _],
    [_, _, o, _, _, _, _, _],
    [_, o, o, o, o, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, o, _, x, _, x, _],
    [_, _, o, _, _, x, _, _],
    [_, _, _, _, x, _, x, _],
    [_, x, x, x, _, x, x, x],
  ];
}

List<List<BoardItemType>> createFieldsFull() {
  return [
    [o, x, o],
    [o, x, o],
    [x, o, x]
  ];
}

List<List<BoardItemType>> createFieldsMoreThanRequiredToWin() {
  return [
    [_, _, _, _, _, _, _, o],
    [_, x, x, x, x, x, x, o],
    [_, _, _, _, _, _, o, o],
    [_, _, _, _, _, _, _, o],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsMoreThanRequiredToWinOtherSideWinning() {
  return [
    [_, _, _, _, _, _, _, o],
    [_, x, x, x, x, x, x, o],
    [_, _, _, _, _, _, o, o],
    [_, _, _, _, _, _, _, o],
    [_, _, _, _, _, _, _, o],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsInvalidStateSameAxis() {
  return [
    [_, _, x, _, _, _, _, o],
    [_, _, x, _, _, _, _, o],
    [_, _, x, _, _, _, _, o],
    [o, _, x, _, _, _, _, o],
    [_, o, x, _, _, _, _, o],
    [_, _, o, _, _, _, _, _],
    [_, _, _, o, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsInvalidStateDifferentAxis() {
  return [
    [_, _, _, _, _, _, _, _],
    [_, x, x, x, x, x, _, _],
    [_, _, x, _, _, _, _, _],
    [_, _, _, x, o, _, _, _],
    [_, _, _, o, x, _, _, _],
    [_, _, o, _, _, x, _, _],
    [_, o, _, _, _, _, _, _],
    [o, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsFullLarge() {
  return [
    [o, x, o, x, o, x, o, x],
    [o, x, x, x, x, o, o, x],
    [o, x, x, o, x, x, o, x],
    [x, o, o, x, x, x, o, x],
    [x, x, x, o, x, o, o, o],
    [x, o, o, x, o, o, o, o],
    [o, o, o, x, x, x, x, o],
    [o, x, x, x, x, x, x, o]
  ];
}

List<List<BoardItemType>> createFieldsCirclesWonMainDiagonalUpperEdge() {
  return [
    [_, _, _, o, _, _, _, _],
    [_, _, _, _, o, _, _, _],
    [_, _, _, _, _, o, _, _],
    [_, _, _, _, _, _, o, _],
    [_, _, _, _, _, _, _, o],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCirclesWonMainDiagonalMiddle() {
  return [
    [x, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, o, _, _, _, _, _],
    [_, _, _, o, _, _, _, _],
    [_, _, _, _, o, _, _, _],
    [_, _, _, _, _, o, _, _],
    [_, _, _, _, _, _, o, _],
    [_, _, _, _, _, _, _, x]
  ];
}

List<List<BoardItemType>> createFieldsCirclesWonMainDiagonalLowerEdge() {
  return [
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [o, _, _, _, _, _, _, _],
    [_, o, _, _, _, _, _, _],
    [_, _, o, _, _, _, _, _],
    [_, _, _, o, _, _, _, _],
    [_, _, _, _, o, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCrossesWonMinorDiagonalUpperEdge() {
  return [
    [_, _, _, _, x, _, _, _],
    [_, _, _, x, _, _, _, _],
    [_, _, x, _, _, _, _, _],
    [_, x, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCrossesWonMinorDiagonalMiddle() {
  return [
    [_, _, _, _, _, _, _, o],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, x, _, _],
    [_, _, _, _, x, _, _, _],
    [_, _, _, x, _, _, _, _],
    [_, _, x, _, _, _, _, _],
    [_, x, _, _, _, _, _, _],
    [o, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCrossesWonMinorDiagonalLowerEdge() {
  return [
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, x],
    [_, _, _, _, _, _, x, _],
    [_, _, _, _, _, x, _, _],
    [_, _, _, _, x, _, _, _],
    [_, _, _, x, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCirclesWonHorizontal() {
  return [
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [o, x, o, o, o, o, o, x],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCrossesWonVertical() {
  return [
    [x, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [x, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

List<List<BoardItemType>> createFieldsCirclesMultiWin() {
  return [
    [o, _, o, _, _, _, o, _],
    [_, o, o, _, _, o, _, _],
    [_, _, o, _, o, _, _, _],
    [o, x, o, o, o, o, o, x],
    [_, _, o, _, o, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _]
  ];
}

Board createBoardEmpty() {
  return Board(createFieldsEmpty(), 3);
}

Board createBoardFilled() {
  return Board(createFieldsFilled(), 3);
}

Board createBoardForFieldsFinder() {
  return Board(createFieldsForFieldsFinder(), 5);
}

Board createBoardFull() {
  return Board(createFieldsFull(), 3);
}

Board createBoardMoreThanRequiredToWin() {
  return Board(createFieldsMoreThanRequiredToWin(), 5);
}

Board createBoardMoreThanRequiredToWinOtherSideWinning() {
  return Board(createFieldsMoreThanRequiredToWinOtherSideWinning(), 5);
}

Board createBoardInvalidStateSameAxis() {
  return Board(createFieldsInvalidStateSameAxis(), 5);
}

Board createBoardInvalidStateDifferentAxis() {
  return Board(createFieldsInvalidStateDifferentAxis(), 5);
}

Board createBoardFullLarge() {
  return Board(createFieldsFullLarge(), 5);
}

Board createBoardCirclesWonMainDiagonalUpperEdge() {
  return Board(createFieldsCirclesWonMainDiagonalUpperEdge(), 5);
}

Board createBoardCirclesWonMainDiagonalMiddle() {
  return Board(createFieldsCirclesWonMainDiagonalMiddle(), 5);
}

Board createBoardCirclesWonMainDiagonalLowerEdge() {
  return Board(createFieldsCirclesWonMainDiagonalLowerEdge(), 5);
}

Board createBoardCrossesWonMinorDiagonalUpperEdge() {
  return Board(createFieldsCrossesWonMinorDiagonalUpperEdge(), 5);
}

Board createBoardCrossesWonMinorDiagonalMiddle() {
  return Board(createFieldsCrossesWonMinorDiagonalMiddle(), 5);
}

Board createBoardCrossesWonMinorDiagonalLowerEdge() {
  return Board(createFieldsCrossesWonMinorDiagonalLowerEdge(), 5);
}

Board createBoardCirclesWonHorizontal() {
  return Board(createFieldsCirclesWonHorizontal(), 5);
}

Board createBoardCrossesWonVertical() {
  return Board(createFieldsCrossesWonVertical(), 5);
}

Board createBoardCirclesMultiWin() {
  return Board(createFieldsCirclesMultiWin(), 5);
}
