import 'package:example_mobile/pages/launch/data_page.dart';
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
                  onPressed: () => _navigateToDataPage(context),
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
            onPressed: () => Navigator.of(context).pop,
          )
        ],
      ),
    );
  }

  void _navigateToDataPage(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DataPage(
          behavior: DataPageFinishBehavior.pop,
        ),
      ),
    );
    setState(() {});
  }
}
