library tic_tac_toe_engine;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/components/board.dart';
import 'package:tic_tac_toe/components/board_inputs.dart';
import 'package:tic_tac_toe/components/fields_finder.dart';
import 'package:tic_tac_toe/components/fields_finder_input.dart';
import 'package:tic_tac_toe/components/game_engine_serializer_inputs.dart';
import 'package:tic_tac_toe/model/game_engine_dto.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:tic_tac_toe/components/game_state_inspector.dart';
import 'package:tic_tac_toe/components/game_state_inspector_inputs.dart';
import 'package:tic_tac_toe/components/item_placer.dart';
import 'package:tic_tac_toe/components/item_placer_inputs.dart';
import 'package:tic_tac_toe/engine/game_engine_inputs.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';
import 'package:tic_tac_toe/enums/placement_result.dart';
import 'package:tic_tac_toe/model/placement.dart';
import 'package:tic_tac_toe/util/errors.dart';

part 'package:tic_tac_toe/components/game_engine_serializer.dart';

class GameEngine implements GameEngineInputs {
  // Private constant fields:
  final BoardInputs _board;
  final GameStateInspectorInputs _gameStateInspector;
  final FieldsFinderInputs _fieldsFinder;
  final ItemPlacerInputs _itemPlacer;
  final void Function(List<List<BoardItemType>>) _onBoardStateChange;
  final void Function(GameState) _onGameStateChange;
  final void Function(Set<Point<int>>) _onValidPlacementFieldsChange;
  final void Function(Set<Point<int>>) _onWinningPlacementFieldsChange;

  // Private fields:
  BoardItemType _currentType;
  GameState _currentGameState;
  Set<Point<int>> _currentValidFields;
  Set<Point<int>> _currentWinningFields;
  List<Placement> _placementsLog;

  // Computed properties:
  @override
  int get boardSize => _board.size;

  @override
  int get numberOfElementsToWin => _board.numberOfElementsToWin;

  @override
  List<List<BoardItemType>> get boardState => _board.state;

  @override
  BoardItemType get currentType => _currentType;

  @override
  GameState get gameState => _currentGameState;

  @override
  List<Placement> get placementsLog => _placementsLog;

  @visibleForTesting
  Board get board => _board;

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
    this._currentValidFields,
    this._currentWinningFields,
    this._placementsLog,
  );

  /// Creates engine for default Tic Tac Toe game with 3x3 board and 3 fields of the
  /// same type required next to each other to win
  /// [currentType] Item type that will have first move
  /// [onBoardStateChange] This is called whenever state of the board is changed.
  /// It has one parameter which is current state of the board
  /// [onGameStateChange] This is called whenever game state is changed.
  /// It has one parameter which is current state of the game
  /// [onValidPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// [onWinningPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// to win immediately
  /// [gameStateInspector] Use this field only if you want to pass custom implementation of
  /// [GameStateInspectorInputs] interface
  /// [fieldsFinder] Use this field only if you want to pass custom implementation of
  /// [FieldsFinderInputs] interface
  /// [itemPlacer] Use this field only if you want to pass custom implementation of
  /// [ItemPlacerInputs] interface
  factory GameEngine.classic({
    BoardItemType currentType = BoardItemType.circle,
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
    GameStateInspectorInputs gameStateInspector = const GameStateInspector(),
    FieldsFinderInputs fieldsFinder = const FieldsFinder(),
    ItemPlacerInputs itemPlacer = const ItemPlacer(),
  }) {
    final _ = BoardItemType.none;
    final classicBoard = [
      [_, _, _],
      [_, _, _],
      [_, _, _],
    ];
    final board = Board(classicBoard, 3);
    return GameEngine._(
      board,
      gameStateInspector,
      fieldsFinder,
      itemPlacer,
      onBoardStateChange,
      onGameStateChange,
      onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange,
      currentType,
      GameState.ongoing,
      fieldsFinder.findValidFields(board),
      fieldsFinder.findWinningFields(board, currentType),
      List(),
    );
  }

  /// Creates engine for custom game of Tic Tac Toe
  /// [size] Length of the side of a square board
  /// [numberOfElementsToWin] Number of items that must be placed next to each other in
  /// order to win. It must not be greater than [size]
  /// [currentType] Item type that will have first move
  /// [onBoardStateChange] This is called whenever state of the board is changed.
  /// It has one parameter which is current state of the board
  /// [onGameStateChange] This is called whenever game state is changed.
  /// It has one parameter which is current state of the game
  /// [onValidPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// [onWinningPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// to win immediately
  /// [gameStateInspector] Use this field only if you want to pass custom implementation of
  /// [GameStateInspectorInputs] interface
  /// [fieldsFinder] Use this field only if you want to pass custom implementation of
  /// [FieldsFinderInputs] interface
  /// [itemPlacer] Use this field only if you want to pass custom implementation of
  /// [ItemPlacerInputs] interface
  factory GameEngine.custom({
    int size = 3,
    List<List<BoardItemType>> fields,
    int numberOfElementsToWin = 3,
    BoardItemType currentType = BoardItemType.circle,
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
    GameStateInspectorInputs gameStateInspector = const GameStateInspector(),
    FieldsFinderInputs fieldsFinder = const FieldsFinder(),
    ItemPlacerInputs itemPlacer = const ItemPlacer(),
  }) {
    if (size <= 0) {
      throw TicTacToeException(
        TicTacToeErrors.engineConstructionError,
        "Board size must be a positive integer",
      );
    }
    if (numberOfElementsToWin > size) {
      throw TicTacToeException(
        TicTacToeErrors.engineConstructionError,
        "Number of elements to win can not be greater than size",
      );
    }
    if (numberOfElementsToWin <= 0) {
      throw TicTacToeException(
        TicTacToeErrors.engineConstructionError,
        "Number of elements to win must be a positive integer",
      );
    }
    final List<List<BoardItemType>> customBoard = List.generate(
      size,
      (_) => List.generate(
        size,
        (_) => BoardItemType.none,
      ),
    );
    final board = Board(customBoard, numberOfElementsToWin);
    return GameEngine._(
      board,
      gameStateInspector,
      fieldsFinder,
      ItemPlacer(),
      onBoardStateChange,
      onGameStateChange,
      onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange,
      currentType,
      GameState.ongoing,
      fieldsFinder.findValidFields(board),
      fieldsFinder.findWinningFields(board, currentType),
      List(),
    );
  }

  /// Loads engine for previously saved state
  /// [json] JSON string received from [saveState] method
  /// [onBoardStateChange] This is called whenever state of the board is changed.
  /// It has one parameter which is current state of the board
  /// [onGameStateChange] This is called whenever game state is changed.
  /// It has one parameter which is current state of the game
  /// [onValidPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// [onWinningPlacementFieldsChange] This is called whenever a valid move is performed.
  /// It has one parameter which is a set of coordinates where an item can be placed
  /// to win immediately
  /// [gameStateInspector] Use this field only if you want to pass custom implementation of
  /// [GameStateInspectorInputs] interface
  /// [fieldsFinder] Use this field only if you want to pass custom implementation of
  /// [FieldsFinderInputs] interface
  /// [itemPlacer] Use this field only if you want to pass custom implementation of
  /// [ItemPlacerInputs] interface
  factory GameEngine.load(
    String json, {
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
    GameStateInspectorInputs gameStateInspector = const GameStateInspector(),
    FieldsFinderInputs fieldsFinder = const FieldsFinder(),
    ItemPlacerInputs itemPlacer = const ItemPlacer(),
  }) {
    final serializer = GameEngineSerializer();
    return serializer.deserialize(json);
  }

  // Public Methods:
  @override
  PlacementResult attemptToPlaceWithPoint(
      Point<int> point, BoardItemType itemType) {
    if (_isGameFinished()) {
      return PlacementResult.gameFinished;
    }
    final result = _itemPlacer.canPlace(itemType, point, _board, _currentType);
    if (result == PlacementResult.valid) {
      _itemPlacer.place(itemType, point, _board);
      _placementsLog.add(Placement(itemType: _currentType, point: point));
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
  Set<Point<int>> findValidFields() {
    return _currentValidFields;
  }

  @override
  Set<Point<int>> findWinningFields() {
    return _currentWinningFields;
  }

  @override
  void undoPlacement({int count = 1}) {
    if (count < 1) {
      throw TicTacToeException(
        TicTacToeErrors.undoArgumentError,
        "[count] can must be greater or equal to one, but passed value is equal to $count",
      );
    }
    if (count > _placementsLog.length) {
      throw TicTacToeException(
        TicTacToeErrors.undoArgumentError,
        "[count] can not be greater that the size of [placementsLog], but passed value is equal to $count, while the size of [placementsLog] is equal to ${placementsLog.length}",
      );
    }
    _itemPlacer.undo(count, _placementsLog, _board);
    final type = count % 2 == 0 ? _currentType : _nextType();
    _updateGameState(type: type);
  }

  @override
  String saveState() {
    final serializer = GameEngineSerializer();
    return serializer.serialize(this);
  }

  // Private methods:
  void _updateGameState({BoardItemType type}) {
    _updateCurrentType(type);
    final gameState = _checkGameState();
    if (gameState == GameState.ongoing) {
      final validFields = _fieldsFinder.findValidFields(_board);
      _currentValidFields = validFields;
      if (_onValidPlacementFieldsChange != null) {
        _onValidPlacementFieldsChange(validFields);
      }

      final winningFields = _fieldsFinder.findWinningFields(
        _board,
        currentType,
      );
      _currentWinningFields = winningFields;
      if (_onWinningPlacementFieldsChange != null) {
        _onWinningPlacementFieldsChange(winningFields);
      }
    }
    if (gameState != _currentGameState) {
      _currentGameState = gameState;
      if (_onGameStateChange != null) {
        _onGameStateChange(gameState);
      }
    }
  }

  void _updateCurrentType(BoardItemType type) {
    _currentType = type ?? _nextType();
  }

  BoardItemType _nextType() {
    return _currentType == BoardItemType.circle
        ? BoardItemType.cross
        : BoardItemType.circle;
  }

  GameState _checkGameState() {
    return _gameStateInspector.checkGameState(_board);
  }

  bool _isGameFinished() {
    return [GameState.circlesWon, GameState.crossesWon, GameState.tie]
        .contains(_currentGameState);
  }
}

// TODO:
// Travis ??
// Example
// Readme
// Licence to each file
// Remove calculator default examples
// Release
