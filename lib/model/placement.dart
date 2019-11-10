import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tic_tac_toe/enums/board_item_type.dart';

class Placement {
  final Point<int> point;
  final BoardItemType itemType;

  Placement({@required this.point, @required this.itemType});

  bool operator ==(dynamic other) {
    if (!(other is Placement)) {
      return false;
    }
    return this.point == other.point && this.itemType == other.itemType;
  }

  int get hashCode => point.hashCode ^ itemType.hashCode;
}