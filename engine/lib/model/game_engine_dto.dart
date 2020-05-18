// To parse this JSON data, do
//
//     final gameEngineDto = gameEngineDtoFromJson(jsonString);

import 'dart:convert';

import 'package:tic_tac_toe/enums/board_item_type.dart';

class GameEngineDto {
  String version;
  BoardDto board;
  BoardItemType currentType;
  String currentGameState;
  List<CurrentValidField> currentValidFields;
  List<CurrentValidField> currentWinningFields;
  List<PlacementsLog> placementsLog;

  GameEngineDto({
    this.version,
    this.board,
    this.currentType,
    this.currentGameState,
    this.currentValidFields,
    this.currentWinningFields,
    this.placementsLog,
  });

  factory GameEngineDto.fromRawJson(String str) =>
      GameEngineDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GameEngineDto.fromJson(Map<String, dynamic> json) => GameEngineDto(
        version: json["version"] == null ? null : json["version"],
        board: json["board"] == null ? null : BoardDto.fromJson(json["board"]),
        currentType: json["currentType"] == null
            ? null
            : currentTypeValues.map[json["currentType"]],
        currentGameState:
            json["currentGameState"] == null ? null : json["currentGameState"],
        currentValidFields: json["currentValidFields"] == null
            ? null
            : List<CurrentValidField>.from(json["currentValidFields"]
                .map((x) => CurrentValidField.fromJson(x))),
        currentWinningFields: json["currentWinningFields"] == null
            ? null
            : List<CurrentValidField>.from(json["currentWinningFields"]
                .map((x) => CurrentValidField.fromJson(x))),
        placementsLog: json["placementsLog"] == null
            ? null
            : List<PlacementsLog>.from(
                json["placementsLog"].map((x) => PlacementsLog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "version": version == null ? null : version,
        "board": board == null ? null : board.toJson(),
        "currentType":
            currentType == null ? null : currentTypeValues.reverse[currentType],
        "currentGameState": currentGameState == null ? null : currentGameState,
        "currentValidFields": currentValidFields == null
            ? null
            : List<dynamic>.from(currentValidFields.map((x) => x.toJson())),
        "currentWinningFields": currentWinningFields == null
            ? null
            : List<dynamic>.from(currentWinningFields.map((x) => x.toJson())),
        "placementsLog": placementsLog == null
            ? null
            : List<dynamic>.from(placementsLog.map((x) => x.toJson())),
      };
}

class BoardDto {
  List<List<BoardItemType>> fields;
  int numberOfElementsToWin;

  BoardDto({
    this.fields,
    this.numberOfElementsToWin,
  });

  factory BoardDto.fromRawJson(String str) =>
      BoardDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BoardDto.fromJson(Map<String, dynamic> json) => BoardDto(
        fields: json["fields"] == null
            ? null
            : List<List<BoardItemType>>.from(json["fields"].map((x) =>
                List<BoardItemType>.from(
                    x.map((x) => currentTypeValues.map[x])))),
        numberOfElementsToWin: json["numberOfElementsToWin"] == null
            ? null
            : json["numberOfElementsToWin"],
      );

  Map<String, dynamic> toJson() => {
        "fields": fields == null
            ? null
            : List<dynamic>.from(fields.map((x) => List<dynamic>.from(
                x.map((x) => currentTypeValues.reverse[x])))),
        "numberOfElementsToWin":
            numberOfElementsToWin == null ? null : numberOfElementsToWin,
      };
}

final currentTypeValues = EnumValues({
  "_": BoardItemType.none,
  "o": BoardItemType.circle,
  "x": BoardItemType.cross
});

class CurrentValidField {
  int x;
  int y;

  CurrentValidField({
    this.x,
    this.y,
  });

  factory CurrentValidField.fromRawJson(String str) =>
      CurrentValidField.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentValidField.fromJson(Map<String, dynamic> json) =>
      CurrentValidField(
        x: json["x"] == null ? null : json["x"],
        y: json["y"] == null ? null : json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x == null ? null : x,
        "y": y == null ? null : y,
      };
}

class PlacementsLog {
  CurrentValidField point;
  BoardItemType itemType;

  PlacementsLog({
    this.point,
    this.itemType,
  });

  factory PlacementsLog.fromRawJson(String str) =>
      PlacementsLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacementsLog.fromJson(Map<String, dynamic> json) => PlacementsLog(
        point: json["point"] == null
            ? null
            : CurrentValidField.fromJson(json["point"]),
        itemType: json["itemType"] == null
            ? null
            : currentTypeValues.map[json["itemType"]],
      );

  Map<String, dynamic> toJson() => {
        "point": point == null ? null : point.toJson(),
        "itemType":
            itemType == null ? null : currentTypeValues.reverse[itemType],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
