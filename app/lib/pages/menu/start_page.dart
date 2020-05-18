import 'package:example_mobile/pages/launch/data_page.dart';
import 'package:example_mobile/pages/menu/multiplayer_page.dart';
import 'package:example_mobile/util/shared_preferences/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${SharedPreferencesUtil.instance.displayName}"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Singleplayer"),
                  onPressed: () => _displayComingSoonAlert(),
                ),
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Multiplayer"),
                  onPressed: () => _navigateToMultiplayerPage(),
                ),
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Settings"),
                  onPressed: () => _navigateToDataPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayComingSoonAlert() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Coming soon"),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _navigateToDataPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DataPage(
          behavior: DataPageFinishBehavior.pop,
          player: DataPagePlayer.player1,
        ),
      ),
    );
    setState(() {});
  }

  void _navigateToMultiplayerPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiplayerPage(),
      ),
    );
  }
}
