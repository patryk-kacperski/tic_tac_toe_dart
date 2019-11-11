import 'dart:math';

import 'package:tic_tac_toe/components/game_engine_serializer_inputs.dart';
import 'package:tic_tac_toe/engine/game_engine_inputs.dart';
import 'package:tic_tac_toe/model/game_engine_dto.dart';
import 'package:tic_tac_toe/model/placement.dart';
import 'package:tic_tac_toe/util/constants.dart';

class GameEngineSerializer implements GameEngineSerializerInputs {
  @override
  GameEngineInputs deserialize(String gameEngineJson) {
    // remember to check file's version if it's correct
    // enum from string Fruit f = Fruit.values.firstWhere((e) => e.toString() == 'Fruit.' + str);
    // TODO: implement deserialize
    return null;
  }

  @override
  String serialize(GameEngineInputs gameEngine) {
    final dto = _mapToDto(gameEngine);
    return dto.toRawJson();
  }

  GameEngineDto _mapToDto(GameEngineInputs gameEngine) {
    return GameEngineDto(
      version: jsonSerializationVersion,
      board: BoardDto(
        fields: gameEngine.boardState,
        numberOfElementsToWin: gameEngine.numberOfElementsToWin,
      ),
      currentType: gameEngine.currentType,
      currentGameState: gameEngine.gameState.toString(),
      currentValidFields: _mapPointsList(gameEngine.findValidFields()),
      currentWinningFields: _mapPointsList(gameEngine.findWinningFields()),
      placementsLog: _mapPlacementsList(gameEngine.placementsLog),
    );
  }

  List<CurrentValidField> _mapPointsList(Set<Point<int>> fields) {
    return fields
        .map((point) => CurrentValidField(x: point.x, y: point.y))
        .toList();
  }

  List<PlacementsLog> _mapPlacementsList(List<Placement> log) {
    return log.map(
      (placement) => PlacementsLog(
        itemType: placement.itemType,
        point: CurrentValidField(
          x: placement.point.x,
          y: placement.point.y,
        ),
      ),
    ).toList();
  }
}
