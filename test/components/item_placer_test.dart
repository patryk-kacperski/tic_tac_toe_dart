import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/item_placer.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';

import '../testing_utils/board_utils.dart';

void main() {
  group('ItemPlacer', () {
    test('.canPlace() should return [PlacementResult.outOfBoard] when coordinates out of board are passed', () {
      final expected = PlacementResult.outOfBoard;

      final itemType = BoardItemType.circle;
      final point = Point(3, 3);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final actual = sut.canPlace(itemType, point, board);

      expect(actual, equals(expected));
    });

    test('.canPlace() should return [PlacementResult.occupied] when trying to place a field on an occupied place', () {
      final expected = PlacementResult.occupied;

      final itemType = BoardItemType.circle;
      final point = Point(2, 0);
      final board = createBoardFilled();
      final sut = ItemPlacer();
      final actual = sut.canPlace(itemType, point, board);

      expect(actual, equals(expected));
    });

    test('.canPlace() should return [PlacementResult.nonePassed] when [BoardItemType.none] is passed as an item to place', () {
      final expected = PlacementResult.nonePassed;

      final itemType = BoardItemType.none;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final actual = sut.canPlace(itemType, point, board);

      expect(actual, equals(expected));
    });

    test('.canPlace() should return [PlacementResult.valid] when move is valid', () {
      final expected = PlacementResult.valid;

      final itemType = BoardItemType.circle;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      final actual = sut.canPlace(itemType, point, board);

      expect(actual, equals(expected));
    });

    test('.place should place when move is valid', () {
      final expected = BoardItemType.circle;

      final itemType = BoardItemType.circle;
      final point = Point(1, 0);
      final board = createBoardEmpty();
      final sut = ItemPlacer();
      sut.place(itemType, point, board);
      final actual = board.getItemAt(point);

      expect(actual, equals(expected));
    });
  });
}