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
    [_, _, _, _, o, _, _, _]
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

Board createBoardInvalidStateSameAxis() {
    return Board(createFieldsInvalidStateSameAxis(), 5);
}

Board createBoardInvalidStateDifferentAxis() {
    return Board(createFieldsInvalidStateDifferentAxis(), 5);
}

Board createBoardFullLarge() {
    return Board(createFieldsFilled(), 5);
}