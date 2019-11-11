import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/components/game_engine_serializer.dart';
import 'package:tic_tac_toe/engine/game_engine.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/util/constants.dart';

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
  });
}
