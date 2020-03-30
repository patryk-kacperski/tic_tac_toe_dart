import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Single Player"),
                  onPressed: () => _displayComingSoonAlert(context),
                ),
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Multi Player"),
                  onPressed: () => _displayComingSoonAlert(context),
                ),
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Change Data"),
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
            onPressed: Navigator.of(context).pop,
          )
        ],
      ),
    );
  }
}
