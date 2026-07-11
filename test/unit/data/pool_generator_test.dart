import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('expand pads each nation and assigns clubs, deterministically', () {
    final base = [
      for (var n = 1; n <= 2; n++)
        for (var i = 0; i < 23; i++)
          player(
            id: n * 100 + i,
            nationId: n,
            position: PlayerPosition.cm,
            attributes: flatAttributes(70),
          ),
    ];

    final out = PoolGenerator.expand(base);

    // Each nation grows from 23 to 23 + extraPerNation.
    final byNation = <int, int>{};
    for (final p in out) {
      byNation[p.nationId] = (byNation[p.nationId] ?? 0) + 1;
    }
    expect(byNation[1], 23 + PoolGenerator.extraPerNation);
    expect(byNation[2], 23 + PoolGenerator.extraPerNation);

    // Every player has a real club and a unique id; attributes stay in range.
    expect(out.every((p) => p.club.isNotEmpty), isTrue);
    expect(out.every((p) => p.club != 'Free agent'), isTrue);
    expect(out.map((p) => p.id).toSet(), hasLength(out.length));
    expect(out.every((p) => p.overall >= 1 && p.overall <= 99), isTrue);
    expect(out.every((p) => p.value >= 0), isTrue);

    // Deterministic: same input → identical names/ids.
    final again = PoolGenerator.expand(base);
    expect(out.map((p) => '${p.id}:${p.name}:${p.club}'),
        again.map((p) => '${p.id}:${p.name}:${p.club}'));
  });
}
