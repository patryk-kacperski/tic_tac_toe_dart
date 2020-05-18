part of tic_tac_toe_engine;

class GameEngineSerializer implements GameEngineSerializerInputs {
  @override
  GameEngineInputs deserialize(
    String gameEngineJson, {
    void Function(List<List<BoardItemType>>) onBoardStateChange,
    void Function(GameState) onGameStateChange,
    void Function(Set<Point>) onValidPlacementFieldsChange,
    void Function(Set<Point>) onWinningPlacementFieldsChange,
    GameStateInspectorInputs gameStateInspector = const GameStateInspector(),
    FieldsFinderInputs fieldsFinder = const FieldsFinder(),
    ItemPlacerInputs itemPlacer = const ItemPlacer(),
  }) {
    final Map<String, dynamic> jsonMap = json.decode(gameEngineJson);
    if (jsonMap["version"] == null ||
        jsonMap["version"] != jsonSerializationVersion) {
      throw TicTacToeException(
        TicTacToeErrors.parsingError,
        "Invalid version of passed json",
      );
    }
    final engineDto = GameEngineDto.fromJson(jsonMap);
    if (!_validate(engineDto)) {
      throw TicTacToeException(
        TicTacToeErrors.parsingError,
        "Invalid json passed, one of fields contains null",
      );
    }
    return GameEngine._(
      Board(engineDto.board.fields, engineDto.board.numberOfElementsToWin),
      gameStateInspector,
      fieldsFinder,
      itemPlacer,
      onBoardStateChange,
      onGameStateChange,
      onValidPlacementFieldsChange,
      onWinningPlacementFieldsChange,
      engineDto.currentType,
      gameStateFromString(engineDto.currentGameState),
      _mapCurrentFields(engineDto.currentValidFields),
      _mapCurrentFields(engineDto.currentWinningFields),
      _mapPlacementsLog(engineDto.placementsLog),
    );
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
    return log
        .map(
          (placement) => PlacementsLog(
            itemType: placement.itemType,
            point: CurrentValidField(
              x: placement.point.x,
              y: placement.point.y,
            ),
          ),
        )
        .toList();
  }

  Set<Point<int>> _mapCurrentFields(List<CurrentValidField> fields) {
    return fields.map((point) => Point<int>(point.x, point.y)).toSet();
  }

  List<Placement> _mapPlacementsLog(List<PlacementsLog> log) {
    return log
        .map((placement) => Placement(
            itemType: placement.itemType,
            point: Point<int>(placement.point.x, placement.point.y)))
        .toList();
  }

  bool _validate(GameEngineDto dto) {
    return !(dto.version == null ||
        dto.board == null ||
        dto.board.fields == null ||
        dto.board.numberOfElementsToWin == null ||
        dto.currentType == null ||
        dto.currentGameState == null ||
        dto.currentValidFields == null ||
        dto.currentWinningFields == null ||
        dto.placementsLog == null);
  }
}
