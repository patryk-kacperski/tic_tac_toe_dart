import 'package:example_mobile/pages/launch/data_page.dart';
import 'package:example_mobile/pages/menu/start_page.dart';
import 'package:example_mobile/util/shared_preferences/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesUtil.initialize();
  final initialPage = _getInitailPage();
  runApp(MyApp(initialPage: initialPage));
}

Widget _getInitailPage() {
  if (SharedPreferencesUtil.instance.isNameSet) {
    return StartPage();
  } else {
    return DataPage(
      behavior: DataPageFinishBehavior.pushStart,
      player: DataPagePlayer.player1,
    );
  }
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({Key key, this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic tac toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialPage,
    );
  }
}
