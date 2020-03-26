import 'package:example_mobile/board_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic tac toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoardPage(),
    );
  }
}
