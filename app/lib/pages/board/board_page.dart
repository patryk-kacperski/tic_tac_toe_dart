import 'dart:math';

import 'package:example_mobile/model/player.dart';
import 'package:example_mobile/pages/board/game_controller.dart';
import 'package:example_mobile/pages/menu/start_page.dart';
import 'package:example_mobile/util/shared_preferences/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';

class BoardPage extends StatefulWidget {
  final Player player2;
  BoardPage({Key key, this.player2}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

enum _MenuOptions { restart, findValidFields, findWinningFields, undo }

enum _EndGameDialogOptions { restart, returnToMenu }

extension _MenuOptionsExtension on _MenuOptions {
  String get name {
    switch (this) {
      case _MenuOptions.restart:
        return "Restart";
      case _MenuOptions.findValidFields:
        return "Valid fields";
      case _MenuOptions.findWinningFields:
        return "Winning Fields";
      case _MenuOptions.undo:
        return "Undo";
    }
    return null;
  }
}

extension _BoardItemTypeExtension on BoardItemType {
  String get name {
    switch (this) {
      case BoardItemType.cross:
        return "Crosses";
      case BoardItemType.circle:
        return "Circles";
        break;
      case BoardItemType.none:
        return "";
        break;
    }
    return "";
  }
}

extension _GameStateExtension on GameState {
  String get gameFinishedText {
    switch (this) {
      case GameState.ongoing:
        return "";
      case GameState.crossesWon:
        return "Crosses won";
      case GameState.circlesWon:
        return "Circles won";
      case GameState.tie:
        return "A tie";
        break;
      case GameState.invalid:
        return "";
    }
    return "";
  }
}

class _BoardPageState extends State<BoardPage> {
  static final size = 15;
  static final numberOfElementsToWin = 5;

  bool _shouldDisplayValidFields = false;
  bool _shouldDisplayWinningFields = false;

  GameController controller;

  Set<Point<int>> _validFields;
  Set<Point<int>> _winningFields;

  Player _player1;
  Map<BoardItemType, Player> _players;
  _EndGameDialogOptions selectedOption;

  @override
  void initState() {
    controller = GameController(
      size: size,
      numberOfElementsToWin: numberOfElementsToWin,
      onBoardStateChange: (_) => setState(() {}),
      onGameStateChange: _onGameStateChange,
      onValidPlacementFieldsChange: (points) {
        setState(() {
          _validFields = points;
        });
      },
      onWinningPlacementFieldsChange: (points) {
        setState(() {
          _winningFields = points;
        });
      },
      displayAlert: displayAlert,
    );
    _validFields = controller.validFields;
    _winningFields = controller.winningFields;

    _player1 = Player(
      SharedPreferencesUtil.instance.displayName,
      SharedPreferencesUtil.instance.color,
    );
    _players = {
      BoardItemType.circle: _player1,
      BoardItemType.cross: widget.player2
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = 1.0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _getTitle(),
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            PopupMenuButton<_MenuOptions>(
              onSelected: _onSelected,
              itemBuilder: (context) {
                return _MenuOptions.values.map((option) {
                  return PopupMenuItem<_MenuOptions>(
                    value: option,
                    child: Text(option.name),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Center(
            child: GridView.count(
              crossAxisCount: size,
              childAspectRatio: aspectRatio,
              primary: true,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                size * size,
                (index) {
                  final row = index ~/ size;
                  final column = index % size;
                  return Material(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: _colorForFieldAt(x: column, y: row),
                        ),
                      ),
                      onTap: () {
                        controller.onFieldTapped(x: column, y: row);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }

  Future<void> displayAlert(String title, String message) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Resart"),
                onPressed: () {
                  selectedOption = _EndGameDialogOptions.restart;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  selectedOption = _EndGameDialogOptions.returnToMenu;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // PRIVATE METHODS
  Color _colorForBoardItem(BoardItemType item) {
    switch (item) {
      case BoardItemType.cross:
      case BoardItemType.circle:
        return Color(_players[item].color);
      case BoardItemType.none:
        return Colors.white;
    }
    return Colors.white;
  }

  String _getTitle() {
    return "Current Player: ${_players[controller.currentItemType].name}";
  }

  void _onGameStateChange(GameState state) async {
    switch (state) {
      case GameState.ongoing:
        break;
      case GameState.crossesWon:
      case GameState.circlesWon:
        final player = _players[BoardItemType.cross];
        _onGameFinish("${player.name} won!");
        break;
      case GameState.tie:
        _onGameFinish("Tie!");
        break;
      case GameState.invalid:
        print("Game state invalid!");
        break;
    }
  }

  void _onGameFinish(String text) async {
    await displayAlert("Game finished", text);
    if (selectedOption != null) {
      switch (selectedOption) {
        case _EndGameDialogOptions.restart:
          setState(() {
            _shouldDisplayWinningFields = false;
            _shouldDisplayWinningFields = false;
            controller.restart();
          });
          break;
        case _EndGameDialogOptions.returnToMenu:
          int popCount = 3;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => StartPage()
            )
          );
          break;
      }
    }
  }

  void _onSelected(_MenuOptions option) {
    switch (option) {
      case _MenuOptions.restart:
        controller.restart();
        _validFields = controller.validFields;
        _winningFields = controller.winningFields;
        setState(() {});
        break;
      case _MenuOptions.findValidFields:
        setState(() {
          _shouldDisplayValidFields = !_shouldDisplayValidFields;
        });
        break;
      case _MenuOptions.findWinningFields:
        setState(() {
          _shouldDisplayWinningFields = !_shouldDisplayWinningFields;
        });
        break;
      case _MenuOptions.undo:
        setState(() {
          controller.undo();
        });
        break;
    }
  }

  Color _colorForFieldAt({@required int x, @required int y}) {
    final point = Point<int>(x, y);
    if (_shouldDisplayWinningFields && _winningFields.contains(point)) {
      return Colors.lightBlue.withAlpha(100);
    }
    if (_shouldDisplayValidFields && _validFields.contains(point)) {
      return Colors.lightGreen.withAlpha(100);
    }
    final item = controller.boardState[y][x];
    return _colorForBoardItem(item);
  }
}

// TODO: Fix pushing casue no work good :< Final fixes then try making firebase server
