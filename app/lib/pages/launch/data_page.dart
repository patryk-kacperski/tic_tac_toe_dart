import 'package:example_mobile/model/player.dart';
import 'package:example_mobile/pages/board/board_page.dart';
import 'package:example_mobile/pages/menu/start_page.dart';
import 'package:example_mobile/util/shared_preferences/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum DataPageFinishBehavior { pushStart, pop, startGame }
enum DataPagePlayer { player1, player2 }

extension DataPagePlayerExtension on DataPagePlayer {
  int get color {
    switch (this) {
      case DataPagePlayer.player1:
        return Colors.blue.value;
      case DataPagePlayer.player2:
        return Colors.red.value;
    }
    return null;
  }

  String get name {
    switch (this) {
      case DataPagePlayer.player1:
        return "Player 1";
      case DataPagePlayer.player2:
        return "Player 2";
    }
    return null;
  }

  String get hintText {
    switch (this) {
      case DataPagePlayer.player1:
        return "Enter your Display Name:";
      case DataPagePlayer.player2:
        return "Enter Player 2 Display Name:";
    }
    return null;
  }

  String get colorText {
    switch (this) {
      case DataPagePlayer.player1:
        return "Choose your preferred color:";
      case DataPagePlayer.player2:
        return "Choose preferred color for Player 2:";
    }
    return null;
  }
}

class DataPage extends StatefulWidget {
  final DataPageFinishBehavior behavior;
  final DataPagePlayer player;

  DataPage({Key key, this.behavior, this.player}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final TextEditingController _controller = TextEditingController();

  Color currentColor;

  @override
  void initState() {
    if (widget.player == DataPagePlayer.player2) {
      _controller.text = "";
      currentColor = Color(widget.player.color);
    } else {
      _controller.text = SharedPreferencesUtil.instance.displayName == null
          ? ""
          : SharedPreferencesUtil.instance.displayName;
      currentColor = SharedPreferencesUtil.instance.color == null
          ? Color(widget.player.color)
          : Color(SharedPreferencesUtil.instance.color);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Text(widget.player.hintText),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Display Name"),
                  ),
                  SizedBox(height: 32.0),
                  Text(widget.player.colorText),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 64.0,
                    width: 64.0,
                    child: RaisedButton(
                      onPressed: _showChangeColorDialog,
                      color: currentColor,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: RaisedButton(
                child: Text("OK"),
                onPressed: () {
                  final text = _controller.text;
                  if (text == null || text.isEmpty) {
                    _setPlayerData(widget.player.name, context);
                  } else {
                    _setPlayerData(text, context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _setPlayerData(String text, BuildContext context) {
    switch (widget.behavior) {
      case DataPageFinishBehavior.pushStart:
        SharedPreferencesUtil.instance.displayName = text;
        SharedPreferencesUtil.instance.color = currentColor.value;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StartPage(),
          ),
        );
        break;
      case DataPageFinishBehavior.pop:
        SharedPreferencesUtil.instance.displayName = text;
        SharedPreferencesUtil.instance.color = currentColor.value;
        Navigator.of(context).pop();
        break;
      case DataPageFinishBehavior.startGame:
        final player = Player(text, currentColor.value);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BoardPage(player2: player),
        ));
        break;
    }
  }

  void _showChangeColorDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) => currentColor = color,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Done'),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
