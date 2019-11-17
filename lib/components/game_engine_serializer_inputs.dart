import 'dart:math';

import 'package:tic_tac_toe/components/fields_finder.dart';
import 'package:tic_tac_toe/components/fields_finder_input.dart';
import 'package:tic_tac_toe/components/game_state_inspector.dart';
import 'package:tic_tac_toe/components/game_state_inspector_inputs.dart';
import 'package:tic_tac_toe/components/item_placer.dart';
import 'package:tic_tac_toe/components/item_placer_inputs.dart';
import 'package:tic_tac_toe/engine/game_engine.dart';
import 'package:tic_tac_toe/engine/game_engine_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';

abstract class GameEngineSerializerInputs {
  /// Serializes instance of [GameEngineInputs] to JSON string
  String serialize(GameEngineInputs gameEngine);

  /// Deserializes instance of [GameEngineInputs] from JSON string
  /// All optional parameters have been described in [GameEngine] class
  /// Throws FormatException, when passed string is not a JSON
  /// If any field in JSON is invalid or missing throws TicTacToeException
  /// When JSON's version field has incorrect value throws TicTacToeException
  GameEngineInputs deserialize(
    String gameEngineJson, {
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
    GameStateInspectorInputs gameStateInspector = const GameStateInspector(),
    FieldsFinderInputs fieldsFinder = const FieldsFinder(),
    ItemPlacerInputs itemPlacer = const ItemPlacer(),
  });
}
