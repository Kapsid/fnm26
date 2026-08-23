import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

/// A sending-off costs a player for the rest of the match, and changing shape
/// is not a way out of it.
///
/// The in-match editor used to top its pool up from the bench whenever fewer
/// than eleven were on the pitch — exactly the state after a red card — so
/// dragging somebody into a new shape silently restored the eleventh man,
/// spent no substitution, and undid the card.
void main() {
  Player p(int id, PlayerPosition pos) => Player(
    id: id,
    nationId: 1,
    name: 'P$id',
    position: pos,
    age: 25,
    club: 'C',
    attributes: const PlayerAttributes(
      physical: 75,
      technical: 75,
      stamina: 75,
    ),
  );

  final eligible = <Player>[
    p(1, PlayerPosition.gk),
    for (var i = 2; i <= 11; i++) p(i, PlayerPosition.cm),
    // The bench.
    for (var i = 12; i <= 18; i++) p(i, PlayerPosition.cm),
  ];

  test('a reshape draws only on the men already out there', () {
    final onPitch = {for (var i = 1; i <= 10; i++) i};
    final pool = reshapePool(eligible, onPitch);

    expect(pool.map((p) => p.id).toSet(), onPitch);
    expect(
      pool.any((p) => p.id >= 12),
      isFalse,
      reason: 'the bench is not eligible for a shape change',
    );
  });

  test('ten men stay ten men through a change of shape', () {
    final onPitch = {for (var i = 1; i <= 10; i++) i};
    final lineup = bestEleven(
      Formation.f433,
      reshapePool(eligible, onPitch),
    );

    expect(lineup, hasLength(11));
    expect(
      lineup.whereType<int>().length,
      10,
      reason: 'the sent-off man must not be replaced by a reshape',
    );
    expect(lineup.where((id) => id == null).length, 1);
    // And nobody from the bench crept on.
    expect(lineup.whereType<int>().every((id) => id <= 10), isTrue);
  });

  test('nine men stay nine, through any shape', () {
    final onPitch = {for (var i = 1; i <= 9; i++) i};
    for (final shape in Formation.values) {
      final lineup = bestEleven(shape, reshapePool(eligible, onPitch));
      expect(
        lineup.whereType<int>().length,
        9,
        reason: '${shape.label} refilled the side',
      );
    }
  });

  test('a full eleven is simply refitted, losing nobody', () {
    final onPitch = {for (var i = 1; i <= 11; i++) i};
    final lineup = bestEleven(
      Formation.f352,
      reshapePool(eligible, onPitch),
    );

    expect(lineup.whereType<int>().length, 11);
    expect(lineup.whereType<int>().toSet(), onPitch);
  });
}
