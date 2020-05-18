import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/game_state_inspector.dart';
import 'package:tic_tac_toe/enums/game_state.dart';

import '../testing_utils/board_utils.dart';

void main() {
  group('GameStateInspector', () {
    test(
        '.checkGameState() should return [GameState.ongoing] when board is empty',
        () {
      final expected = GameState.ongoing;

      final board = createBoardEmpty();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.ongoing] when board is partially filled and no one won',
        () {
      final expected = GameState.ongoing;

      final board = createBoardFilled();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.ongoing] when larger board is partially filled and no one won',
        () {
      final expected = GameState.ongoing;

      final board = createBoardForFieldsFinder();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.tie] when board is fully filled and no one won',
        () {
      final expected = GameState.tie;

      final board = createBoardFull();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.ongoing], when one of players has more items next to each other than it is required to win',
        () {
      final expected = GameState.ongoing;

      final board = createBoardMoreThanRequiredToWin();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon], when crosses have more items next to each other than it is required to win and circles have exactly required amount',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardMoreThanRequiredToWinOtherSideWinning();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.invalid] when there are two or more winning situations on the same axis',
        () {
      final expected = GameState.invalid;

      final board = createBoardInvalidStateSameAxis();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.invalid] when there are two or more winning situations on different axes',
        () {
      final expected = GameState.invalid;

      final board = createBoardInvalidStateDifferentAxis();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.tie] on fully filled large board',
        () {
      final expected = GameState.tie;

      final board = createBoardFullLarge();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon] on a board where circles have winning position on the upper edge of main diagonal',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardCirclesWonMainDiagonalUpperEdge();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon] on a board where circles have winning position in the middle of main diagonal',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardCirclesWonMainDiagonalMiddle();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon] on a board where circles have winning position on the lower edge of main diagonal',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardCirclesWonMainDiagonalLowerEdge();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.crossesWon] on a board where crosses have winning position on the upper edge of minor diagonal',
        () {
      final expected = GameState.crossesWon;

      final board = createBoardCrossesWonMinorDiagonalUpperEdge();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.crossesWon] on a board where crosses have winning position in the middle of minor diagonal',
        () {
      final expected = GameState.crossesWon;

      final board = createBoardCrossesWonMinorDiagonalMiddle();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.crossesWon] on a board where crosses have winning position on the lower edge of minor diagonal',
        () {
      final expected = GameState.crossesWon;

      final board = createBoardCrossesWonMinorDiagonalLowerEdge();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon] on a board where cicles have winning position on the horizontal axis',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardCirclesWonHorizontal();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.crossesWon] on a board where crosses have winning position on the vertical axis',
        () {
      final expected = GameState.crossesWon;

      final board = createBoardCrossesWonVertical();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });

    test(
        '.checkGameState() should return [GameState.circlesWon] on a board where circles have winning position on multiple axes',
        () {
      final expected = GameState.circlesWon;

      final board = createBoardCirclesMultiWin();
      final sut = GameStateInspector();
      final actual = sut.checkGameState(board);

      expect(actual, equals(expected));
    });
  });
}
