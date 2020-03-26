import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/board.dart';
import 'package:tic_tac_toe/engine/game_engine.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/model/placement.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:tic_tac_toe/util/errors.dart';

import '../testing_utils/board_utils.dart';

const _ = BoardItemType.none;

void main() {
  group('GameEngineSerializer', () {
    test(
        '.serialize() should properly serialize game engine with no moves made',
        () {
      final expected =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["_","_","_"],["_","_","_"],["_","_","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":1,"y":0},{"x":1,"y":1},{"x":1,"y":2},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[],"placementsLog":[]}';

      final engine = GameEngine.classic();
      final sut = GameEngineSerializer();
      final actual = sut.serialize(engine);

      expect(actual, equals(expected));
    });

    test(
        '.serialize() should properly serialize game engine with some moves made',
        () {
      final expected =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["_","_","o"],["_","_","o"],["_","_","x"]],"numberOfElementsToWin":3},"currentType":"x","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":1,"y":0},{"x":1,"y":1},{"x":1,"y":2}],"currentWinningFields":[],"placementsLog":[{"point":{"x":2,"y":0},"itemType":"o"},{"point":{"x":2,"y":2},"itemType":"x"},{"point":{"x":2,"y":1},"itemType":"o"}]}';

      final engine = GameEngine.classic();
      engine.attemptToPlaceWithPoint(Point(2, 0), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(2, 2), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(2, 1), BoardItemType.circle);
      final sut = GameEngineSerializer();
      final actual = sut.serialize(engine);

      expect(actual, equals(expected));
    });

    test(
        '.serialize() should properly serialize game engine with some moves made and undone',
        () {
      final expected =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["_","_","o"],["_","_","_"],["_","_","_"]],"numberOfElementsToWin":3},"currentType":"x","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":1,"y":0},{"x":1,"y":1},{"x":1,"y":2},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[],"placementsLog":[{"point":{"x":2,"y":0},"itemType":"o"}]}';

      final engine = GameEngine.classic();
      engine.attemptToPlaceWithPoint(Point(2, 0), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(2, 2), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(2, 1), BoardItemType.circle);
      engine.undoPlacement(count: 2);
      final sut = GameEngineSerializer();
      final actual = sut.serialize(engine);

      expect(actual, equals(expected));
    });

    test(
        '.serialize() should properly serialize game engine with enough moves made to fill the board',
        () {
      final expected =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["o","x","o"],["o","x","o"],["x","o","x"]],"numberOfElementsToWin":3},"currentType":"x","currentGameState":"GameState.tie","currentValidFields":[{"x":1,"y":2}],"currentWinningFields":[],"placementsLog":[{"point":{"x":2,"y":0},"itemType":"o"},{"point":{"x":2,"y":2},"itemType":"x"},{"point":{"x":2,"y":1},"itemType":"o"},{"point":{"x":1,"y":0},"itemType":"x"},{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":1,"y":1},"itemType":"x"},{"point":{"x":0,"y":1},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":2},"itemType":"o"}]}';

      final engine = GameEngine.classic();
      engine.attemptToPlaceWithPoint(Point(2, 0), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(2, 2), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(2, 1), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(1, 0), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(0, 0), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(1, 1), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(0, 1), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(0, 2), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(1, 2), BoardItemType.circle);
      final sut = GameEngineSerializer();
      final actual = sut.serialize(engine);

      expect(actual, equals(expected));
    });

    test(
        '.serialize() should properly serialize game engine with some winning fields',
        () {
      final expected =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["o","_","_"],["_","o","_"],["x","x","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":1},{"x":1,"y":0},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[{"x":2,"y":2}],"placementsLog":[{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":1},"itemType":"o"},{"point":{"x":1,"y":2},"itemType":"x"}]}';

      final engine = GameEngine.classic();
      engine.attemptToPlaceWithPoint(Point(0, 0), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(0, 2), BoardItemType.cross);
      engine.attemptToPlaceWithPoint(Point(1, 1), BoardItemType.circle);
      engine.attemptToPlaceWithPoint(Point(1, 2), BoardItemType.cross);
      final sut = GameEngineSerializer();
      final actual = sut.serialize(engine);

      expect(actual, equals(expected));
    });

    test(
        '.deserialize() should properly deserialize game engine with no moves made',
        () {
      final expectedFields = createFieldsEmpty();
      final expectedNumberOfElementsToWin = 3;
      final expectedCurrentType = BoardItemType.circle;
      final expectedValidFields = Set<Point<int>>.from([
        p(0, 0),
        p(0, 1),
        p(0, 2),
        p(1, 0),
        p(1, 1),
        p(1, 2),
        p(2, 0),
        p(2, 1),
        p(2, 2),
      ]);
      final expectedWinningFields = Set<Point<int>>.from([]);
      final expectedPlacementsLog = List<Placement>();
      final expectedGameState = GameState.ongoing;

      final json =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["_","_","_"],["_","_","_"],["_","_","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":1,"y":0},{"x":1,"y":1},{"x":1,"y":2},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[],"placementsLog":[]}';
      final sut = GameEngineSerializer();
      final engine = sut.deserialize(json);
      final actualFields = engine.boardState;
      final actualNumberOfElementsToWin = engine.numberOfElementsToWin;
      final actualCurrentType = engine.currentType;
      final actualValidFields = engine.findValidFields();
      final actualWinningFields = engine.findWinningFields();
      final actualPlacementsLog = engine.placementsLog;
      final actualGameState = engine.gameState;

      expect(actualFields, equals(expectedFields));
      expect(
          actualNumberOfElementsToWin, equals(expectedNumberOfElementsToWin));
      expect(actualCurrentType, equals(expectedCurrentType));
      expect(actualValidFields, equals(expectedValidFields));
      expect(actualWinningFields, equals(expectedWinningFields));
      expect(actualPlacementsLog, equals(expectedPlacementsLog));
      expect(actualGameState, equals(expectedGameState));
    });

    test(
        '.deserialize() should properly deserialize game engine with some moves made',
        () {
      final expectedFields = createFieldsFilled();
      final expectedNumberOfElementsToWin = 3;
      final expectedCurrentType = BoardItemType.cross;
      final expectedValidFields = Set<Point<int>>.from([
        p(0, 0),
        p(0, 1),
        p(0, 2),
        p(1, 0),
        p(1, 1),
        p(1, 2),
      ]);
      final expectedWinningFields = Set<Point<int>>.from([]);
      final expectedPlacementsLog = List<Placement>.from([
        Placement(itemType: BoardItemType.circle, point: p(2, 0)),
        Placement(itemType: BoardItemType.cross, point: p(2, 2)),
        Placement(itemType: BoardItemType.circle, point: p(2, 1)),
      ]);
      final expectedGameState = GameState.ongoing;

      final json =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["_","_","o"],["_","_","o"],["_","_","x"]],"numberOfElementsToWin":3},"currentType":"x","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":1,"y":0},{"x":1,"y":1},{"x":1,"y":2}],"currentWinningFields":[],"placementsLog":[{"point":{"x":2,"y":0},"itemType":"o"},{"point":{"x":2,"y":2},"itemType":"x"},{"point":{"x":2,"y":1},"itemType":"o"}]}';
      final sut = GameEngineSerializer();
      final engine = sut.deserialize(json);
      final actualFields = engine.boardState;
      final actualNumberOfElementsToWin = engine.numberOfElementsToWin;
      final actualCurrentType = engine.currentType;
      final actualValidFields = engine.findValidFields();
      final actualWinningFields = engine.findWinningFields();
      final actualPlacementsLog = engine.placementsLog;
      final actualGameState = engine.gameState;

      expect(actualFields, equals(expectedFields));
      expect(
          actualNumberOfElementsToWin, equals(expectedNumberOfElementsToWin));
      expect(actualCurrentType, equals(expectedCurrentType));
      expect(actualValidFields, equals(expectedValidFields));
      expect(actualWinningFields, equals(expectedWinningFields));
      expect(actualPlacementsLog, equals(expectedPlacementsLog));
      expect(actualGameState, equals(expectedGameState));
    });

    test(
        '.deserialize() should properly deserialize game engine with enough moves made to fill the board',
        () {
      final expectedFields = createFieldsFull();
      final expectedNumberOfElementsToWin = 3;
      final expectedCurrentType = BoardItemType.cross;
      final expectedValidFields = Set<Point<int>>.from([p(1, 2)]);
      final expectedWinningFields = Set<Point<int>>.from([]);
      final expectedPlacementsLog = List<Placement>.from([
        Placement(itemType: BoardItemType.circle, point: p(2, 0)),
        Placement(itemType: BoardItemType.cross, point: p(2, 2)),
        Placement(itemType: BoardItemType.circle, point: p(2, 1)),
        Placement(itemType: BoardItemType.cross, point: p(1, 0)),
        Placement(itemType: BoardItemType.circle, point: p(0, 0)),
        Placement(itemType: BoardItemType.cross, point: p(1, 1)),
        Placement(itemType: BoardItemType.circle, point: p(0, 1)),
        Placement(itemType: BoardItemType.cross, point: p(0, 2)),
        Placement(itemType: BoardItemType.circle, point: p(1, 2)),
      ]);
      final expectedGameState = GameState.tie;

      final json =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["o","x","o"],["o","x","o"],["x","o","x"]],"numberOfElementsToWin":3},"currentType":"x","currentGameState":"GameState.tie","currentValidFields":[{"x":1,"y":2}],"currentWinningFields":[],"placementsLog":[{"point":{"x":2,"y":0},"itemType":"o"},{"point":{"x":2,"y":2},"itemType":"x"},{"point":{"x":2,"y":1},"itemType":"o"},{"point":{"x":1,"y":0},"itemType":"x"},{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":1,"y":1},"itemType":"x"},{"point":{"x":0,"y":1},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":2},"itemType":"o"}]}';
      final sut = GameEngineSerializer();
      final engine = sut.deserialize(json);
      final actualFields = engine.boardState;
      final actualNumberOfElementsToWin = engine.numberOfElementsToWin;
      final actualCurrentType = engine.currentType;
      final actualValidFields = engine.findValidFields();
      final actualWinningFields = engine.findWinningFields();
      final actualPlacementsLog = engine.placementsLog;
      final actualGameState = engine.gameState;

      expect(actualFields, equals(expectedFields));
      expect(
          actualNumberOfElementsToWin, equals(expectedNumberOfElementsToWin));
      expect(actualCurrentType, equals(expectedCurrentType));
      expect(actualValidFields, equals(expectedValidFields));
      expect(actualWinningFields, equals(expectedWinningFields));
      expect(actualPlacementsLog, equals(expectedPlacementsLog));
      expect(actualGameState, equals(expectedGameState));
    });

    test(
        '.deserialize() should properly deserialize game engine with some winning fields',
        () {
      final expectedFields = [
        [o, _, _],
        [_, o, _],
        [x, x, _],
      ];
      final expectedNumberOfElementsToWin = 3;
      final expectedCurrentType = BoardItemType.circle;
      final expectedValidFields = Set<Point<int>>.from([
        p(0, 1),
        p(1, 0),
        p(2, 0),
        p(2, 1),
        p(2, 2),
      ]);
      final expectedWinningFields = Set<Point<int>>.from([
        p(2, 2),
      ]);
      final expectedPlacementsLog = List<Placement>.from([
        Placement(itemType: BoardItemType.circle, point: p(0, 0)),
        Placement(itemType: BoardItemType.cross, point: p(0, 2)),
        Placement(itemType: BoardItemType.circle, point: p(1, 1)),
        Placement(itemType: BoardItemType.cross, point: p(1, 2)),
      ]);
      final expectedGameState = GameState.ongoing;

      final json =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["o","_","_"],["_","o","_"],["x","x","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":1},{"x":1,"y":0},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[{"x":2,"y":2}],"placementsLog":[{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":1},"itemType":"o"},{"point":{"x":1,"y":2},"itemType":"x"}]}';
      final sut = GameEngineSerializer();
      final engine = sut.deserialize(json);
      final actualFields = engine.boardState;
      final actualNumberOfElementsToWin = engine.numberOfElementsToWin;
      final actualCurrentType = engine.currentType;
      final actualValidFields = engine.findValidFields();
      final actualWinningFields = engine.findWinningFields();
      final actualPlacementsLog = engine.placementsLog;
      final actualGameState = engine.gameState;

      expect(actualFields, equals(expectedFields));
      expect(
          actualNumberOfElementsToWin, equals(expectedNumberOfElementsToWin));
      expect(actualCurrentType, equals(expectedCurrentType));
      expect(actualValidFields, equals(expectedValidFields));
      expect(actualWinningFields, equals(expectedWinningFields));
      expect(actualPlacementsLog, equals(expectedPlacementsLog));
      expect(actualGameState, equals(expectedGameState));
    });

    test('.deserialize() should throw TicTacToeExcpetion when passed json has invalid version', () {
      final json =
          '{"version":"0","board":{"fields":[["o","_","_"],["_","o","_"],["x","x","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":1},{"x":1,"y":0},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"currentWinningFields":[{"x":2,"y":2}],"placementsLog":[{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":1},"itemType":"o"},{"point":{"x":1,"y":2},"itemType":"x"}]}';
      final sut = GameEngineSerializer();
      final actual = () => sut.deserialize(json);

      expect(actual, throwsA(isInstanceOf<TicTacToeException>()));
    });

    test('.deserialize() should throw TicTacToeException when passed json is missing some fields', () {
      final json =
          '{"version":"$jsonSerializationVersion","board":{"fields":[["o","_","_"],["_","o","_"],["x","x","_"]],"numberOfElementsToWin":3},"currentType":"o","currentGameState":"GameState.ongoing","currentValidFields":[{"x":0,"y":1},{"x":1,"y":0},{"x":2,"y":0},{"x":2,"y":1},{"x":2,"y":2}],"placementsLog":[{"point":{"x":0,"y":0},"itemType":"o"},{"point":{"x":0,"y":2},"itemType":"x"},{"point":{"x":1,"y":1},"itemType":"o"},{"point":{"x":1,"y":2},"itemType":"x"}]}';
      final sut = GameEngineSerializer();
      final actual = () => sut.deserialize(json);

      expect(actual, throwsA(isInstanceOf<TicTacToeException>()));
    });
  });
}
