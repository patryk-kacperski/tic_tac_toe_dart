import 'package:example_mobile/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

class BoardPage extends StatefulWidget {
  BoardPage({Key key}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  static final size = 15;
  static final numberOfElementsToWin = 5;

  GameController controller;
  List<List<BoardItemType>> boardState;

  @override
  void initState() {
    controller = GameController(
      size: size,
      numberOfElementsToWin: numberOfElementsToWin,
      onBoardStateChange: (state) {
        setState(() {
          boardState = state;
        });
      },
      onGameStateChange: (state) {},
      onValidPlacementFieldsChange: (points) {},
      onWinningPlacementFieldsChange: (points) {},
    );
    boardState = controller.boardState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boardHeight = MediaQuery.of(context).size.height * 0.75;
    final aspectRatio = 1.0;//MediaQuery.of(context).size.width / boardHeight;
    return Scaffold(
        appBar: AppBar(
          title: Text("Game"),
        ),
        body: Center(
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
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: _colorForBoardItem(boardState[row][column]),
                    ),
                  ),
                  onTap: () {
                    controller.onFieldTapped(x: column, y: row);
                  },
                );
              },
            ),
          ),
        ));
  }

  Color _colorForBoardItem(BoardItemType item) {
    switch (item) {
      case BoardItemType.cross:
        return Colors.red;
      case BoardItemType.circle:
        return Colors.green;
      case BoardItemType.none:
        return Colors.white;
    }
    return null;
  }
}
