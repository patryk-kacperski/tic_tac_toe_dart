import 'dart:math';

import 'package:tic_tac_toe/components/board.dart';
import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/components/fields_finder.dart';
import 'package:tic_tac_toe/components/fields_finder_input.dart';
import 'package:tic_tac_toe/components/game_state_inspector.dart';
import 'package:tic_tac_toe/components/game_state_inspector_inputs.dart';
import 'package:tic_tac_toe/components/item_placer.dart';
import 'package:tic_tac_toe/components/item_placer_inputs.dart';
import 'package:tic_tac_toe/engine/game_engine_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';

class GameEngine implements GameEngineInputs {
  // Private constant fields:
  final BoardInputs _board;
  final GameStateInspectorInputs _gameStateInspector;
  final FieldsFinderInputs _fieldsFinder;
  final ItemPlacerInputs _itemPlacer;
  final void Function(List<List<BoardItemType>>) _onBoardStateChange;
  final void Function(GameState) _onGameStateChange;
  final void Function(Set<Point>) _onValidPlacementFieldsChange;
  final void Function(Set<Point>) _onWinningPlacementFieldsChange;

  // Private fields:
  BoardItemType _currentType;
  GameState _currentGameState;

  // Computed properties:
  @override
  int get boardSize => _board.size;

  @override
  List<List<BoardItemType>> get boardState => _board.state;

  @override
  BoardItemType get currentType => _currentType;

  // Constructors:
  GameEngine._(
    this._board,
    this._gameStateInspector,
    this._fieldsFinder,
    this._itemPlacer,
    this._onBoardStateChange,
    this._onGameStateChange,
    this._onValidPlacementFieldsChange,
    this._onWinningPlacementFieldsChange,
    this._currentType,
    this._currentGameState,
  );

  factory GameEngine.classic({
    BoardItemType currentType = BoardItemType.circle,
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
  }) {
    final _ = BoardItemType.none;
    final classicBoard = [
      [_, _, _],
      [_, _, _],
      [_, _, _],
    ];
    return GameEngine._(
      Board(classicBoard, 3),
      GameStateInspector(),
      FieldsFinder(),
      ItemPlacer(),
      onBoardStateChange,
      onGameStateChange,
      onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange,
      currentType,
      GameState.ongoing,
    );
  }

  factory GameEngine.custom({
    int size = 3,
    int numberOfElementsToWin = 3,
    BoardItemType currentType = BoardItemType.circle,
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
  }) {
    final List<List<BoardItemType>> customBoard = List.filled(
      size,
      List.filled(
        size,
        BoardItemType.none,
      ),
    );
    return GameEngine._(
      Board(customBoard, numberOfElementsToWin),
      GameStateInspector(),
      FieldsFinder(),
      ItemPlacer(),
      onBoardStateChange,
      onGameStateChange,
      onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange,
      currentType,
      GameState.ongoing,
    );
  }

  // Public Methods:
  @override
  PlacementResult attemptToPlaceWithPoint(
      Point<int> point, BoardItemType itemType) {
    final result = _itemPlacer.canPlace(itemType, point, _board);
    if (result == PlacementResult.valid) {
      _itemPlacer.place(itemType, point, _board);
      if (_onBoardStateChange != null) {
        _onBoardStateChange(_board.state);
      }
      _updateGameState();
    }
    return result;
  }

  @override
  PlacementResult attemptToPlaceWithRawCoords(
      int x, int y, BoardItemType itemType) {
    final point = Point(x, y);
    return attemptToPlaceWithPoint(point, itemType);
  }

  @override
  GameState checkGameState() {
    return _gameStateInspector.checkGameState(_board);
  }

  @override
  Set<Point<int>> findValidFields() {
    return _fieldsFinder.findValidFields(_board);
  }

  @override
  Set<Point<int>> findWinningFields(BoardItemType itemType) {
    return _fieldsFinder.findWinningFields(_board, itemType);
  }

  @override
  String saveState() {
    // TODO: implement saveState
    return null;
  }

  // Private methods:
  void _updateGameState() {
    _updateCurrentType();
    final gameState = checkGameState();
    if (gameState == GameState.ongoing) {
      if (_onValidPlacementFieldsChange != null) {
        _onValidPlacementFieldsChange(findValidFields());
      }
      if (_onWinningPlacementFieldsChange != null) {
        _onWinningPlacementFieldsChange(findWinningFields(currentType));
      }
    }
    if (gameState != _currentGameState && _onGameStateChange != null) {
      _currentGameState = gameState;
      _onGameStateChange(gameState);
    }
  }

  void _updateCurrentType() {
    _currentType = _currentType == BoardItemType.circle
        ? BoardItemType.cross
        : BoardItemType.circle;
  }
}

// TODO:
// Unit tests
// Optimization idea: Keep valid and winning fields as params of this class to avoid having them computed multiple times
// Then delegate calls may be made on more appropriate times
