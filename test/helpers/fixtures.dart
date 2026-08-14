import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// Reusable test fixtures so tests stay terse and consistent.

/// Attributes with every value set to [value] (default 80). With weights that
/// sum to 1, this yields an overall exactly equal to [value] for any position.
PlayerAttributes flatAttributes([int value = 80]) => PlayerAttributes(
  physical: value,
  technical: value,
  stamina: value,
);

Nation nation({
  required int id,
  String? name,
  int ranking = 10,
  bool isFreeDemo = false,
  Confederation confederation = Confederation.europe,
}) => Nation(
  id: id,
  name: name ?? 'Nation $id',
  code: 'N$id',
  confederation: confederation,
  ranking: ranking,
  isFreeDemo: isFreeDemo,
);

/// A player whose overall is exactly [overall] — flat attributes at a position
/// whose weights sum to 1, so the rating comes out unrounded.
Player playerWithOverall(int overall, {int id = 1, int nationId = 1}) => player(
  id: id,
  nationId: nationId,
  attributes: flatAttributes(overall),
);

Player player({
  required int id,
  required int nationId,
  String? name,
  int age = 25,
  PlayerPosition position = PlayerPosition.cm,
  PlayerAttributes? attributes,
}) => Player(
  id: id,
  nationId: nationId,
  name: name ?? 'Player $id',
  age: age,
  position: position,
  attributes: attributes ?? flatAttributes(),
);
