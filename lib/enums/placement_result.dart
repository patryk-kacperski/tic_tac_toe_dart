import 'package:tic_tac_toe/enums/board_item_type.dart';

/// Result of a placement attempt
enum PlacementResult {
  /// Placement is valid and can be made
  valid,

  /// Cannot place, because coordinates are out of a board
  outOfBoard,

  /// Cannot place, because selected coordinates are occupied
  occupied,

  /// Cannot place, because [BoardItemType.none] field type passed
  nonePassed,

  /// Cannot place, because passed [BoardItemType] is different than current [BoardItemType]
  wrongTypePassed
}
