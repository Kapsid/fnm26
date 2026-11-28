import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/secondary_positions.dart';

import '../../helpers/classic_world.dart';

/// A Classic Cups man has secondary positions too, by the same derivation
/// as everyone else's: about a third of the outfielders, no keeper.
void main() {
  test('classic squads carry secondary positions like any other', () {
    final world = loadClassicWorld();
    var outfield = 0, withOne = 0;
    for (final y in world.years) {
      for (final t in world.edition(y).teams) {
        for (final p in world.squad(y, t.nationId)) {
          final s = SecondaryPositions.of(p);
          if (p.position == PlayerPosition.gk) {
            expect(s, isEmpty);
            continue;
          }
          outfield++;
          if (s.isNotEmpty) withOne++;
          expect(
            s,
            SecondaryPositions.derive(p.id, p.position, p.attributes),
          );
        }
      }
    }
    final share = withOne / outfield;
    expect(share, inInclusiveRange(0.25, 0.42), reason: '$withOne/$outfield');
  });
}
