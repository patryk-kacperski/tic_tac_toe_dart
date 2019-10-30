import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/enums/game_state.dart';

/// Examines current state of the game
abstract class GameStateInspectorInputs {
  /// Checks and returns current state of the game
  /// For possible outcomes, see documentation for [GameState] enum
  GameState checkGameState(BoardInputs board);
}