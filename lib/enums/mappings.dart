import 'package:tic_tac_toe/enums/board_item_type.dart';
import 'package:tic_tac_toe/enums/game_state.dart';

GameState boardItemTypeToGameState(BoardItemType itemType) {
  switch (itemType) {
    case BoardItemType.cross:
      return GameState.crossesWon;
    case BoardItemType.circle:
      return GameState.circlesWon;
    case BoardItemType.none:
      return GameState.ongoing;
  }
  return GameState.invalid;
}
