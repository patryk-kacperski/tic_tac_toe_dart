import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/engine/game_engine.dart';
import 'package:tic_tac_toe/engine/game_engine_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';

class GameController {
  final int size;
  final int numberOfElementsToWin;

  final void Function(List<List<BoardItemType>>) onBoardStateChange;
  final void Function(GameState) onGameStateChange;
  final void Function(Set<Point<int>>) onValidPlacementFieldsChange;
  final void Function(Set<Point<int>>) onWinningPlacementFieldsChange;

  final GameEngineInputs _gameEngine;

  List<List<BoardItemType>> get boardState => _gameEngine.boardState;

  GameController({
    this.size,
    this.numberOfElementsToWin,
    this.onBoardStateChange,
    this.onGameStateChange,
    this.onValidPlacementFieldsChange,
    this.onWinningPlacementFieldsChange,
  }) : _gameEngine = GameEngine.custom(
          size: size,
          numberOfElementsToWin: numberOfElementsToWin,
          onBoardStateChange: onBoardStateChange,
          onGameStateChange: onGameStateChange,
          onValidPlacementFieldsChange: onValidPlacementFieldsChange,
          onWinningPlacementFieldsChange: onWinningPlacementFieldsChange,
        );

  void onFieldTapped({@required int x, @required int y}) {
    final result = _gameEngine.attemptToPlaceWithRawCoords(x, y);
    switch (result) {
      case PlacementResult.valid:
        break;
      case PlacementResult.outOfBoard:
        // Display alert
        break;
      case PlacementResult.nonePassed:
      case PlacementResult.occupied:
        _shakeScreen();
        break;
      case PlacementResult.wrongTypePassed:
        // Display alert
        break;
      case PlacementResult.gameFinished:
        // Display alert
        break;
    }
  }

  void _shakeScreen() {
    // Maybe one day xD
  }
}
