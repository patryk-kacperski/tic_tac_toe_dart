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
  final void Function(String, String) displayAlert;

  GameEngineInputs _gameEngine;

  List<List<BoardItemType>> get boardState => _gameEngine.boardState;

  Set<Point<int>> get validFields => _gameEngine.findValidFields();
  Set<Point<int>> get winningFields => _gameEngine.findWinningFields();
  BoardItemType get currentItemType => _gameEngine.currentType;

  GameController({
    this.size,
    this.numberOfElementsToWin,
    this.onBoardStateChange,
    this.onGameStateChange,
    this.onValidPlacementFieldsChange,
    this.onWinningPlacementFieldsChange,
    this.displayAlert,
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
        displayAlert("Error", "Move out of bounds");
        break;
      case PlacementResult.nonePassed:
        displayAlert("Error", "No type passed");
        break;
      case PlacementResult.occupied:
        displayAlert("Error", "You can't place an item on an occupied field");
        break;
      case PlacementResult.wrongTypePassed:
        displayAlert("Error", "Wrong type passed");
        break;
      case PlacementResult.gameFinished:
        displayAlert("Game finished", "Game has ended, restart or start new one");
        break;
    }
  }

  void restart() {
    _gameEngine = GameEngine.custom(
      size: size,
      numberOfElementsToWin: numberOfElementsToWin,
      onBoardStateChange: onBoardStateChange,
      onGameStateChange: onGameStateChange,
      onValidPlacementFieldsChange: onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange: onWinningPlacementFieldsChange,
    );
  }

  void undo() {
    _gameEngine.undoPlacement();
  }

  // PRIVATE METHODS
  void _shakeScreen() {
    // Maybe one day xD
  }
}
