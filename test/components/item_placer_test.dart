import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/item_placer.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';
import 'package:tic_tac_toe/model/placement.dart';

import '../testing_utils/board_utils.dart';

void main() {
  group('ItemPlacer', () {
    test(
        '.canPlace() should return [PlacementResult.outOfBoard] when coordinates out of board are passed',
        () {
      final expected = PlacementResult.outOfBoard;

      final itemType = BoardItemType.circle;
      final point = Point(3, 3);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final currentType = BoardItemType.circle;
      final actual = sut.canPlace(itemType, point, board, currentType);

      expect(actual, equals(expected));
    });

    test(
        '.canPlace() should return [PlacementResult.occupied] when trying to place a field on an occupied place',
        () {
      final expected = PlacementResult.occupied;

      final itemType = BoardItemType.circle;
      final point = Point(2, 0);
      final board = createBoardFilled();
      final sut = ItemPlacer();
      final currentType = BoardItemType.circle;
      final actual = sut.canPlace(itemType, point, board, currentType);

      expect(actual, equals(expected));
    });

    test(
        '.canPlace() should return [PlacementResult.nonePassed] when [BoardItemType.none] is passed as an item to place',
        () {
      final expected = PlacementResult.nonePassed;

      final itemType = BoardItemType.none;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final currentType = BoardItemType.circle;
      final actual = sut.canPlace(itemType, point, board, currentType);

      expect(actual, equals(expected));
    });

    test(
        '.canPlace() should return [PlacementResult.wrongTypePassed] when item passed is not the same as current item type',
        () {
      final expected = PlacementResult.wrongTypePassed;

      final itemType = BoardItemType.cross;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final currentType = BoardItemType.circle;
      final actual = sut.canPlace(itemType, point, board, currentType);

      expect(actual, equals(expected));
    });

    test('.canPlace() should return [PlacementResult.valid] when move is valid',
        () {
      final expected = PlacementResult.valid;

      final itemType = BoardItemType.circle;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final currentType = BoardItemType.circle;
      final actual = sut.canPlace(itemType, point, board, currentType);

      expect(actual, equals(expected));
    });

    test('.place() should place when move is valid', () {
      final expected = BoardItemType.circle;

      final itemType = BoardItemType.circle;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      sut.place(itemType, point, board);
      final actual = board.getItemAt(point);

      expect(actual, equals(expected));
    });

    test(
        '.undo() should undo [count] last moves when called with big enough [log]',
        () {
      final expected = createFieldsFilledAfterUndo();

      final count = 2;
      final log = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];
      final board = createBoardFilled();
      final sut = ItemPlacer();
      sut.undo(count, log, board);
      final actual = board.state;

      expect(actual, equals(expected));
    });

    test(
        '.undo() should remove [count] last elements from [log] when called with big enough [log]',
        () {
      final expectedLength = 1;
      final expectedElement = Placement(
        itemType: BoardItemType.circle,
        point: Point(2, 0),
      );

      final count = 2;
      final log = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];
      final board = createBoardFilled();
      final sut = ItemPlacer();
      sut.undo(count, log, board);
      final actualLength = log.length;
      final actualElement = log[0];

      expect(actualLength, equals(expectedLength));
      expect(actualElement, equals(expectedElement));
    });

    test(
        '.undo() should throw RangeError when [count] is greater than the size of [log]',
        () {
      final count = 4;
      final log = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];
      final board = createBoardFilled();
      final sut = ItemPlacer();
      final actual = () => sut.undo(count, log, board);

      expect(actual, throwsRangeError);
    });

    test(
        '.undo() should throw RangeError when [count] is less than zero',
        () {
      final count = -1;
      final log = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];
      final board = createBoardFilled();
      final sut = ItemPlacer();
      final actual = () => sut.undo(count, log, board);

      expect(actual, throwsRangeError);
    });

    test(
        '.undo() should not modify board or log when [count] is equal to zero',
        () {
      final expectedBoard = createFieldsFilled();
      final expectedLog = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];

      final count = 0;
      final log = [
        Placement(itemType: BoardItemType.circle, point: Point(2, 0)),
        Placement(itemType: BoardItemType.cross, point: Point(2, 2)),
        Placement(itemType: BoardItemType.circle, point: Point(2, 1)),
      ];
      final board = createBoardFilled();
      final sut = ItemPlacer();
      sut.undo(count, log, board);
      final actualBoard = board.state;
      final actualLog = log;

      expect(actualBoard, equals(expectedBoard));
      expect(actualLog, equals(expectedLog));
    });
  });
}
