import 'package:example_mobile/pages/board/board_page.dart';
import 'package:example_mobile/pages/menu/start_page.dart';
import 'package:example_mobile/util/shared_preferences/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum DataPageFinishBehavior { pushStart, pop }

class DataPage extends StatefulWidget {
  final DataPageFinishBehavior behavior;

  DataPage({Key key, this.behavior}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final TextEditingController _controller = TextEditingController();

  Color currentColor;

  @override
  void initState() {
    currentColor = SharedPreferencesUtil.instance.color == null
        ? Colors.blue
        : Color(SharedPreferencesUtil.instance.color);
    _controller.text = SharedPreferencesUtil.instance.displayName == null
        ? ""
        : SharedPreferencesUtil.instance.displayName;
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
                  Text("Enter your Display Name:"),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Display Name"),
                  ),
                  SizedBox(height: 32.0),
                  Text("Choose your preferred color:"),
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
                    _setPlayerData("Player 1", context);
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
    SharedPreferencesUtil.instance.displayName = text;
    SharedPreferencesUtil.instance.color = currentColor.value;
    switch (widget.behavior) {
      case DataPageFinishBehavior.pushStart:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StartPage(),
          ),
        );
        break;
      case DataPageFinishBehavior.pop:
        Navigator.of(context).pop();
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
