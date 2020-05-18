import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tic_tac_toe/components/fields_finder_input.dart';
import 'package:tic_tac_toe/components/game_state_inspector_inputs.dart';
import 'package:tic_tac_toe/components/item_placer_inputs.dart';
import 'package:tic_tac_toe/engine/game_engine.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';
import 'package:tic_tac_toe/model/placement.dart';
import 'package:tic_tac_toe/util/errors.dart';

class _MockGameStateInspector extends Mock implements GameStateInspectorInputs {
}

class _MockFieldsFinder extends Mock implements FieldsFinderInputs {}

class _MockItemPlacer extends Mock implements ItemPlacerInputs {}

GameStateInspectorInputs _mockGameStateInspector = _MockGameStateInspector();
FieldsFinderInputs _mockFieldsFinder = _MockFieldsFinder();
ItemPlacerInputs _mockItemPlacer = _MockItemPlacer();

GameEngine _createMockedEngine({
  void Function(List<List<BoardItemType>>) onBoardStateChange,
  void Function(GameState) onGameStateChange,
  void Function(Set<Point>) onValidPlacementFieldsChange,
  void Function(Set<Point>) onWinningPlacementFieldsChange,
}) {
  return GameEngine.classic(
    onBoardStateChange: onBoardStateChange,
    onGameStateChange: onGameStateChange,
    onValidPlacementFieldsChange: onValidPlacementFieldsChange,
    onWinningPlacementFieldsChange: onWinningPlacementFieldsChange,
    gameStateInspector: _mockGameStateInspector,
    fieldsFinder: _mockFieldsFinder,
    itemPlacer: _mockItemPlacer,
  );
}

void main() {
  group('GameEngine', () {
    setUp(() {
      _mockGameStateInspector = _MockGameStateInspector();
      _mockFieldsFinder = _MockFieldsFinder();
      _mockItemPlacer = _MockItemPlacer();
    });

    test(
        '.classic() should return 3x3 board with [numberOfElementsToWin] equal to 3',
        () {
      final expectedSize = 3;
      final expectedNumberOfElementsToWin = 3;

      final sut = GameEngine.classic();
      final actualSize = sut.boardSize;
      final actualNumberOfElementsToWin = sut.board.numberOfElementsToWin;

      expect(actualSize, equals(expectedSize));
      expect(
        actualNumberOfElementsToWin,
        equals(expectedNumberOfElementsToWin),
      );
    });

    test(
        '.classic() should return board that contains only [BoardItemType.none]',
        () {
      final expected = true;

      final sut = GameEngine.classic();
      final actual = sut.boardState.every((row) {
        return row.every((item) => item == BoardItemType.none);
      });

      expect(actual, equals(expected));
    });

    test(
        '.custom() should return board with [size] and [numberOfElementsToWin] equal to those passed',
        () {
      final expectedSize = 8;
      final expectedNumberOfElementsToWin = 5;

      final sut = GameEngine.custom(size: 8, numberOfElementsToWin: 5);
      final actualSize = sut.boardSize;
      final actualNumberOfElementsToWin = sut.board.numberOfElementsToWin;

      expect(actualSize, equals(expectedSize));
      expect(
        actualNumberOfElementsToWin,
        equals(expectedNumberOfElementsToWin),
      );
    });

    test(
        '.custom() should return 3x3 board with [numberOfElementsToWin] equal to 3 when called with default parameters',
        () {
      final expectedSize = 3;
      final expectedNumberOfElementsToWin = 3;

      final sut = GameEngine.custom();
      final actualSize = sut.boardSize;
      final actualNumberOfElementsToWin = sut.board.numberOfElementsToWin;

      expect(actualSize, equals(expectedSize));
      expect(
        actualNumberOfElementsToWin,
        equals(expectedNumberOfElementsToWin),
      );
    });

    test(
        '.custom() should throw an exception when called with [size] lessser than 1',
        () {
      final actual = () => GameEngine.custom(size: 0);
      expect(actual, throwsException);
    });

    test(
        '.custom() should throw an exception when called with [numberOfElementsToWin] greater than [size]',
        () {
      final actual = () => GameEngine.custom(size: 3, numberOfElementsToWin: 4);
      expect(actual, throwsException);
    });

    test(
        '.custom() should throw an exception when called with [numberOfElementsToWin] lessser than 1',
        () {
      final actual = () => GameEngine.custom(numberOfElementsToWin: 0);
      expect(actual, throwsException);
    });

    test(
        '.custom() should return board that contains only [BoardItemType.none]',
        () {
      final expected = true;

      final sut = GameEngine.custom(size: 8, numberOfElementsToWin: 5);
      final actual = sut.boardState.every((row) {
        return row.every((item) => item == BoardItemType.none);
      });

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should return [PlacementResult.valid] when ItemPlacer returns [PlacementResult.valid]',
        () {
      final expected = PlacementResult.valid;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.valid);
      final actual = sut.attemptToPlaceWithPoint(point, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should return [PlacementResult.outOfBoard] when ItemPlacer returns [PlacementResult.outOfBoard]',
        () {
      final expected = PlacementResult.outOfBoard;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.outOfBoard);
      final actual = sut.attemptToPlaceWithPoint(point, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should return [PlacementResult.occupied] when ItemPlacer returns [PlacementResult.occupied]',
        () {
      final expected = PlacementResult.occupied;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.occupied);
      final actual = sut.attemptToPlaceWithPoint(point, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should return [PlacementResult.nonePassed] when ItemPlacer returns [PlacementResult.nonePassed]',
        () {
      final expected = PlacementResult.nonePassed;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.nonePassed);
      final actual = sut.attemptToPlaceWithPoint(point, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should call [_itemPlacer.place()] when move is valid',
        () {
      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      sut.attemptToPlaceWithPoint(point, itemType);

      verify(_mockItemPlacer.place(itemType, point, sut.board));
    });

    test(
        '.attemptToPlaceWithPoint() should not call [_itemPlacer.place()] when move is not valid',
        () {
      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.outOfBoard);
      sut.attemptToPlaceWithPoint(point, itemType);

      verifyNever(_mockItemPlacer.place(itemType, point, sut.board));
    });

    test(
        'attemptToPlaceWithPoint() should call [_onBoardStateChange] when the move is valid and [_onBoardStateChange] is not null',
        () {
      final expected = true;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasCalled = false;
      final sut = _createMockedEngine(
        onBoardStateChange: (_) => wasCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = wasCalled;

      expect(actual, equals(expected));
    });

    test(
        'attemptToPlaceWithPoint() should not call [_onBoardStateChange] when the move is not valid',
        () {
      final expected = false;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasCalled = false;
      final sut = _createMockedEngine(
        onBoardStateChange: (_) => wasCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.outOfBoard);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = wasCalled;

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should change value of [_currentType] when the move is valid',
        () {
      final expected = BoardItemType.cross;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.currentType;

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should not change value of [_currentType] when the move is not valid',
        () {
      final expected = BoardItemType.circle;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.outOfBoard);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.currentType;

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should call [_onValidPlacementFieldsChange] and [_onWinningPlacementFieldsChange] when the move is valid and game state is equal to [GameState.ongoing]',
        () {
      final expected = true;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasOnValidPlacementFieldsChangeCalled = false;
      bool wasOnWinningPlacementFieldsChangeCalled = false;
      final sut = _createMockedEngine(
        onValidPlacementFieldsChange: (_) =>
            wasOnValidPlacementFieldsChangeCalled = true,
        onWinningPlacementFieldsChange: (_) =>
            wasOnWinningPlacementFieldsChangeCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.ongoing);
      sut.attemptToPlaceWithPoint(point, itemType);

      expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
      expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should call neither [_onValidPlacementFieldsChange] nor [_onWinningPlacementFieldsChange] when the move is valid and game state is not equal to [GameState.ongoing]',
        () {
      final expected = false;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasOnValidPlacementFieldsChangeCalled = false;
      bool wasOnWinningPlacementFieldsChangeCalled = false;
      final sut = _createMockedEngine(
        onValidPlacementFieldsChange: (_) =>
            wasOnValidPlacementFieldsChangeCalled = true,
        onWinningPlacementFieldsChange: (_) =>
            wasOnWinningPlacementFieldsChangeCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.crossesWon);
      sut.attemptToPlaceWithPoint(point, itemType);

      expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
      expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should call neither [_onValidPlacementFieldsChange] nor [_onWinningPlacementFieldsChange] when the move is not valid',
        () {
      final expected = false;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasOnValidPlacementFieldsChangeCalled = false;
      bool wasOnWinningPlacementFieldsChangeCalled = false;
      final sut = _createMockedEngine(
        onValidPlacementFieldsChange: (_) =>
            wasOnValidPlacementFieldsChangeCalled = true,
        onWinningPlacementFieldsChange: (_) =>
            wasOnWinningPlacementFieldsChangeCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.nonePassed);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.ongoing);
      sut.attemptToPlaceWithPoint(point, itemType);

      expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
      expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
    });

    test(
        '.attemptToPlaceWithPoint() should change [_currentGameState] and call [_onGameStateChange] if the move is valid and game state inspector returned different value',
        () {
      final expected = GameState.circlesWon;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasCalled = false;
      final sut = _createMockedEngine(
        onGameStateChange: (_) => wasCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.circlesWon);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.gameState;

      expect(actual, equals(expected));
      expect(wasCalled, equals(true));
    });

    test(
        '.attemptToPlaceWithPoint() should neither change [_currentGameState] nor call [_onGameStateChange] if the move is valid and game state inspector returned the same value',
        () {
      final expected = GameState.ongoing;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasCalled = false;
      final sut = _createMockedEngine(
        onGameStateChange: (_) => wasCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.ongoing);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.gameState;

      expect(actual, equals(expected));
      expect(wasCalled, equals(false));
    });

    test(
        '.attemptToPlaceWithPoint() should neither change [_currentGameState] nor call [_onGameStateChange] if the move is not valid',
        () {
      final expected = GameState.ongoing;

      final point = Point<int>(-1, -1);
      final itemType = BoardItemType.circle;
      bool wasCalled = false;
      final sut = _createMockedEngine(
        onGameStateChange: (_) => wasCalled = true,
      );
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.nonePassed);
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.circlesWon);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.gameState;

      expect(actual, equals(expected));
      expect(wasCalled, equals(false));
    });

    test('attemptToPlaceWithPoint() should update log when move is valid', () {
      final expected = [
        Placement(itemType: BoardItemType.circle, point: Point<int>(0, 0))
      ];

      final point = Point<int>(0, 0);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.placementsLog;

      expect(actual, equals(expected));
    });

    test('attemptToPlaceWithPoint() should not update log when move is invalid',
        () {
      final expected = [];

      final point = Point<int>(0, 0);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.outOfBoard);
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.placementsLog;

      expect(actual, equals(expected));
    });

    test(
        'attemptToPlaceWithPoint() should return [PlacementResult.gameFinished] when game is finished',
        () {
      final expected = PlacementResult.gameFinished;

      final point = Point<int>(0, 0);
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.circlesWon);
      when(_mockItemPlacer.canPlace(
              itemType, point, sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      // calling this twice to trigger change of game state from .ongoing
      sut.attemptToPlaceWithPoint(point, itemType);
      final actual = sut.attemptToPlaceWithPoint(point, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithRawCoords() should return [PlacementResult.valid] when ItemPlacer returns [PlacementResult.valid]',
        () {
      final expected = PlacementResult.valid;

      final x = -1, y = -1;
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, Point(x, y), sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.valid);
      final actual = sut.attemptToPlaceWithRawCoords(x, y, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithRawCoords() should return [PlacementResult.outOfBoard] when ItemPlacer returns [PlacementResult.outOfBoard]',
        () {
      final expected = PlacementResult.outOfBoard;

      final x = -1, y = -1;
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, Point(x, y), sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.outOfBoard);
      final actual = sut.attemptToPlaceWithRawCoords(x, y, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithRawCoords() should return [PlacementResult.occupied] when ItemPlacer returns [PlacementResult.occupied]',
        () {
      final expected = PlacementResult.occupied;

      final x = -1, y = -1;
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, Point(x, y), sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.occupied);
      final actual = sut.attemptToPlaceWithRawCoords(x, y, itemType);

      expect(actual, equals(expected));
    });

    test(
        '.attemptToPlaceWithRawCoords() should return [PlacementResult.nonePassed] when ItemPlacer returns [PlacementResult.nonePassed]',
        () {
      final expected = PlacementResult.nonePassed;

      final x = -1, y = -1;
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockItemPlacer.canPlace(
              itemType, Point(x, y), sut.board, sut.currentType))
          .thenAnswer((_) => PlacementResult.nonePassed);
      final actual = sut.attemptToPlaceWithRawCoords(x, y, itemType);

      expect(actual, equals(expected));
    });
  });

  test(
      '.attemptToPlaceWithRawCoords() should call [_itemPlacer.place()] when move is valid',
      () {
    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);

    verify(_mockItemPlacer.place(itemType, Point(x, y), sut.board));
  });

  test(
      '.attemptToPlaceWithRawCoords() should not call [_itemPlacer.place()] when move is not valid',
      () {
    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.outOfBoard);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);

    verifyNever(_mockItemPlacer.place(itemType, Point(x, y), sut.board));
  });

  test(
      'attemptToPlaceWithRawCoords() should call [_onBoardStateChange] when the move is valid and [_onBoardStateChange] is not null',
      () {
    final expected = true;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasCalled = false;
    final sut = _createMockedEngine(
      onBoardStateChange: (_) => wasCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = wasCalled;

    expect(actual, equals(expected));
  });

  test(
      'attemptToPlaceWithRawCoords() should not call [_onBoardStateChange] when the move is not valid',
      () {
    final expected = false;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasCalled = false;
    final sut = _createMockedEngine(
      onBoardStateChange: (_) => wasCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.outOfBoard);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = wasCalled;

    expect(actual, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should change value of [_currentType] when the move is valid',
      () {
    final expected = BoardItemType.cross;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = sut.currentType;

    expect(actual, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should not change value of [_currentType] when the move is not valid',
      () {
    final expected = BoardItemType.circle;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.outOfBoard);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = sut.currentType;

    expect(actual, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should call [_onValidPlacementFieldsChange] and [_onWinningPlacementFieldsChange] when the move is valid and game state is equal to [GameState.ongoing]',
      () {
    final expected = true;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasOnValidPlacementFieldsChangeCalled = false;
    bool wasOnWinningPlacementFieldsChangeCalled = false;
    final sut = _createMockedEngine(
      onValidPlacementFieldsChange: (_) =>
          wasOnValidPlacementFieldsChangeCalled = true,
      onWinningPlacementFieldsChange: (_) =>
          wasOnWinningPlacementFieldsChangeCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.ongoing);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);

    expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
    expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should call neither [_onValidPlacementFieldsChange] nor [_onWinningPlacementFieldsChange] when the move is valid and game state is not equal to [GameState.ongoing]',
      () {
    final expected = false;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasOnValidPlacementFieldsChangeCalled = false;
    bool wasOnWinningPlacementFieldsChangeCalled = false;
    final sut = _createMockedEngine(
      onValidPlacementFieldsChange: (_) =>
          wasOnValidPlacementFieldsChangeCalled = true,
      onWinningPlacementFieldsChange: (_) =>
          wasOnWinningPlacementFieldsChangeCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.crossesWon);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);

    expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
    expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should call neither [_onValidPlacementFieldsChange] nor [_onWinningPlacementFieldsChange] when the move is not valid',
      () {
    final expected = false;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasOnValidPlacementFieldsChangeCalled = false;
    bool wasOnWinningPlacementFieldsChangeCalled = false;
    final sut = _createMockedEngine(
      onValidPlacementFieldsChange: (_) =>
          wasOnValidPlacementFieldsChangeCalled = true,
      onWinningPlacementFieldsChange: (_) =>
          wasOnWinningPlacementFieldsChangeCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.nonePassed);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.ongoing);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);

    expect(wasOnValidPlacementFieldsChangeCalled, equals(expected));
    expect(wasOnWinningPlacementFieldsChangeCalled, equals(expected));
  });

  test(
      '.attemptToPlaceWithRawCoords() should change [_currentGameState] and call [_onGameStateChange] if the move is valid and game state inspector returned different value',
      () {
    final expected = GameState.circlesWon;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasCalled = false;
    final sut = _createMockedEngine(
      onGameStateChange: (_) => wasCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.circlesWon);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = sut.gameState;

    expect(actual, equals(expected));
    expect(wasCalled, equals(true));
  });

  test(
      '.attemptToPlaceWithRawCoords() should neither change [_currentGameState] nor call [_onGameStateChange] if the move is valid and game state inspector returned the same value',
      () {
    final expected = GameState.ongoing;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasCalled = false;
    final sut = _createMockedEngine(
      onGameStateChange: (_) => wasCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.ongoing);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = sut.gameState;

    expect(actual, equals(expected));
    expect(wasCalled, equals(false));
  });

  test(
      '.attemptToPlaceWithRawCoords() should neither change [_currentGameState] nor call [_onGameStateChange] if the move is not valid',
      () {
    final expected = GameState.ongoing;

    final x = -1, y = -1;
    final itemType = BoardItemType.circle;
    bool wasCalled = false;
    final sut = _createMockedEngine(
      onGameStateChange: (_) => wasCalled = true,
    );
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.nonePassed);
    when(_mockGameStateInspector.checkGameState(sut.board))
        .thenReturn(GameState.circlesWon);
    sut.attemptToPlaceWithRawCoords(x, y, itemType);
    final actual = sut.gameState;

    expect(actual, equals(expected));
    expect(wasCalled, equals(false));
  });

  test('attemptToPlaceWithRawCoords() should update log when move is valid',
      () {
    final expected = [
      Placement(itemType: BoardItemType.circle, point: Point<int>(0, 0))
    ];

    final x = 0, y = 0;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    sut.attemptToPlaceWithPoint(Point(x, y), itemType);
    final actual = sut.placementsLog;

    expect(actual, equals(expected));
  });

  test(
      'attemptToPlaceWithRawCoords() should not update log when move is invalid',
      () {
    final expected = [];

    final x = 0, y = 0;
    final itemType = BoardItemType.circle;
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            itemType, Point(x, y), sut.board, sut.currentType))
        .thenReturn(PlacementResult.outOfBoard);
    sut.attemptToPlaceWithPoint(Point(x, y), itemType);
    final actual = sut.placementsLog;

    expect(actual, equals(expected));
  });

  test(
        'attemptToPlaceWithPoint() should return [PlacementResult.gameFinished] when game is finished',
        () {
      final expected = PlacementResult.gameFinished;

      final x = 0, y = 0;
      final itemType = BoardItemType.circle;
      final sut = _createMockedEngine();
      when(_mockGameStateInspector.checkGameState(sut.board))
          .thenReturn(GameState.circlesWon);
      when(_mockItemPlacer.canPlace(
              itemType, Point(x, y), sut.board, sut.currentType))
          .thenReturn(PlacementResult.valid);
      // calling this twice to trigger change of game state from .ongoing
      sut.attemptToPlaceWithPoint(Point(x, y), itemType);
      final actual = sut.attemptToPlaceWithPoint(Point(x, y), itemType);

      expect(actual, equals(expected));
    });

  test(
      'undoPlacement should call [itemPlacer.undo()] if all conditions are met',
      () {
    final count = 1;
    final log = [Placement(itemType: BoardItemType.circle, point: Point(0, 0))];
    final sut = _createMockedEngine();
    when(_mockItemPlacer.canPlace(
            BoardItemType.circle, Point(0, 0), sut.board, sut.currentType))
        .thenReturn(PlacementResult.valid);
    sut.attemptToPlaceWithPoint(Point(0, 0), BoardItemType.circle);
    sut.undoPlacement();

    verify(_mockItemPlacer.undo(count, log, sut.board));
  });

  test(
      'undoPlacement should throw TicTacToeException when count is less than 1',
      () {
    final count = -1;
    final sut = _createMockedEngine();
    final actual = () => sut.undoPlacement(count: count);

    expect(actual, throwsA(isInstanceOf<TicTacToeException>()));
  });

  test(
      'undoPlacement should throw TicTacToeException when count is greater than the size of the log',
      () {
    final count = 1;
    final sut = _createMockedEngine();
    final actual = () => sut.undoPlacement(count: count);

    expect(actual, throwsA(isInstanceOf<TicTacToeException>()));
  });
}
