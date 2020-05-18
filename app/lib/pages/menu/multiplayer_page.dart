import 'package:example_mobile/pages/launch/data_page.dart';
import 'package:flutter/material.dart';

class MultiplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiplayer"),
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
                  child: Text("Local"),
                  onPressed: () => _navigateToSettingsPage(context),
                ),
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Online"),
                  onPressed: () => _displayComingSoonAlert(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayComingSoonAlert(BuildContext context) {
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

  void _navigateToSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DataPage(
        behavior: DataPageFinishBehavior.startGame,
        player: DataPagePlayer.player2,
      ),
    ));
  }
}
