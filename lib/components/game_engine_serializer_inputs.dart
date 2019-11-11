import 'package:tic_tac_toe/engine/game_engine_inputs.dart';

abstract class GameEngineSerializerInputs {
  /// Serializes instance of [GameEngineInputs] to JSON string
  String serialize(GameEngineInputs gameEngine);

  /// Deserializes instance of [GameEngineInputs] from JSON string
  GameEngineInputs deserialize(String gameEngineJson);
}