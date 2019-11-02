import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

import '../testing_utils/board_utils.dart';

void main() {
  Point<int> p(int x, int y) => Point(x, y);
  group('Board', () {
    test('.state should return board passed in constructor', () {
      final expected = createFieldsEmpty();

      final sut = createBoardEmpty();
      final actual = sut.state;

      expect(actual, equals(expected));
    });

    test('.getItemAt() should return correct value when index is valid', () {
      final expected = BoardItemType.circle;

      final sut = createBoardFilled();
      final point = Point(2, 1);
      final actual = sut.getItemAt(point);

      expect(actual, equals(expected));
    });

    test('.getItemAt() should throw a range error when index is out of range',
        () {
      final sut = createBoardFilled();
      final point = Point(4, 1);
      final actual = () => sut.getItemAt(point);

      expect(actual, throwsRangeError);
    });

    test('.setItemAt() should should correctly set value at valid index', () {
      final expected = BoardItemType.cross;

      final sut = createBoardEmpty();
      final point = Point(1, 2);
      sut.setItemAt(BoardItemType.cross, point);
      final actual = sut.getItemAt(point);

      expect(actual, equals(expected));
    });

    test(
        '.setItemAt() should throw a range error when setting value at index out of range',
        () {
      final sut = createBoardEmpty();
      final point = Point(4, 1);
      final actual = () => sut.setItemAt(BoardItemType.cross, point);

      expect(actual, throwsRangeError);
    });

    test('.contains() should return false when point is out of range', () {
      final expected = true;

      final sut = createBoardEmpty();
      final points = [
        p(-1, -1),
        p(0, -1),
        p(1, -1),
        p(2, -1),
        p(3, -1),
        p(-1, 0),
        p(3, 0),
        p(-1, 1),
        p(3, 1),
        p(-1, 2),
        p(3, 2),
        p(-1, 3),
        p(0, 3),
        p(1, 3),
        p(2, 3),
        p(3, 3),
      ];
      final actual = points
          .map((point) => sut.containts(point))
          .every((isContained) => isContained == false);

      expect(actual, equals(expected));
    });

    test('.contains() should return true when point is in range', () {
      final expected = true;

      final sut = createBoardEmpty();
      final points = [
        p(0, 0),
        p(1, 0),
        p(2, 0),
        p(0, 1),
        p(1, 1),
        p(2, 1),
        p(0, 2),
        p(1, 2),
        p(2, 2),
      ];
      final actual = points
          .map((point) => sut.containts(point))
          .every((isContained) => isContained == true);

      expect(actual, equals(expected));
    });
  });
}
