import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/fields_finder.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

import '../testing_utils/board_utils.dart';

void main() {
  group('FieldsFinder', () {
    test('.findValidFields() should return entire board when it\'s empty', () {
      final expected = Set.from([
        p(0, 0),
        p(1, 0),
        p(2, 0),
        p(0, 1),
        p(1, 1),
        p(2, 1),
        p(0, 2),
        p(1, 2),
        p(2, 2),
      ]);

      final board = createBoardEmpty();
      final sut = FieldsFinder();
      final actual = sut.findValidFields(board);

      expect(actual, equals(expected));
    });

    test(
        '.findValidFields() should return correct fields for partially filled board',
        () {
      final expected = Set.from([
        p(0, 0),
        p(1, 0),
        p(0, 1),
        p(1, 1),
        p(0, 2),
        p(1, 2),
      ]);

      final board = createBoardFilled();
      final sut = FieldsFinder();
      final actual = sut.findValidFields(board);

      expect(actual, equals(expected));
    });

    test(
        '.findValidFields should return correct fields for partailly filled large board',
        () {
      final expected = Set.from([
        p(0, 0),
        p(1, 0),
        p(2, 0),
        p(3, 0),
        p(4, 0),
        p(5, 0),
        p(6, 0),
        p(7, 0),
        p(0, 1),
        p(1, 1),
        p(3, 1),
        p(4, 1),
        p(5, 1),
        p(6, 1),
        p(7, 1),
        p(0, 2),
        p(5, 2),
        p(6, 2),
        p(7, 2),
        p(0, 3),
        p(1, 3),
        p(2, 3),
        p(3, 3),
        p(4, 3),
        p(5, 3),
        p(6, 3),
        p(7, 3),
        p(0, 4),
        p(1, 4),
        p(3, 4),
        p(5, 4),
        p(7, 4),
        p(0, 5),
        p(1, 5),
        p(3, 5),
        p(4, 5),
        p(6, 5),
        p(7, 5),
        p(0, 6),
        p(1, 6),
        p(2, 6),
        p(3, 6),
        p(5, 6),
        p(7, 6),
        p(0, 7),
        p(4, 7),
      ]);

      final board = createBoardForFieldsFinder();
      final sut = FieldsFinder();
      final actual = sut.findValidFields(board);

      expect(actual, equals(expected));
    });

    test('.findValidFields() should return empty set when Board is full', () {
      final expected = Set();

      final board = createBoardFull();
      final sut = FieldsFinder();
      final actual = sut.findValidFields(board);

      expect(actual, equals(expected));
    });

    test(
        '.findWinningFields() should return empty set with board with no winning fields',
        () {
      final expected = Set();

      final board = createBoardFilled();
      final itemType = BoardItemType.circle;
      final sut = FieldsFinder();
      final actual = sut.findWinningFields(board, itemType);

      expect(actual, equals(expected));
    });

    test('.findWinningFields() should return empty set when board is empty',
        () {
      final expected = Set();

      final board = createBoardEmpty();
      final itemType = BoardItemType.circle;
      final sut = FieldsFinder();
      final actual = sut.findWinningFields(board, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.findWinningFields() should return correct set for large filled board when it\' circle\'s turn',
        () {
      final expected = Set.from([p(0, 2), p(5, 2), p(2, 3)]);

      final board = createBoardForFieldsFinder();
      final itemType = BoardItemType.circle;
      final sut = FieldsFinder();
      final actual = sut.findWinningFields(board, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.findWinningFields() should return correct set for large filler board when it\'s cross\' turn',
        () {
      final expected = Set.from([p(3, 3), p(7, 3)]);

      final board = createBoardForFieldsFinder();
      final itemType = BoardItemType.cross;
      final sut = FieldsFinder();
      final actual = sut.findWinningFields(board, itemType);

      expect(actual, equals(expected));
    });

    test('.findWinningFields() should return empty set for a full board', () {
      final expected = Set();

      final board = createBoardFull();
      final itemType = BoardItemType.circle;
      final sut = FieldsFinder();
      final actual = sut.findWinningFields(board, itemType);

      expect(actual, equals(expected));
    });
  });
}
