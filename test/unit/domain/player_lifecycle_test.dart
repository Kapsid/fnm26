import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

void main() {
  // A plausible seeded nation: a spread of ages so some age out over cycles.
  final seeded = [
    for (var i = 0; i < 23; i++)
      player(
        id: 100 + i,
        nationId: 1,
        name: 'First$i Last$i',
        position: PlayerPosition.values[i % PlayerPosition.values.length],
        age: 20 + (i % 15), // 20 … 34
        attributes: flatAttributes(70),
      ),
  ];

  test('year 0 returns exactly the seeded players, unaged', () {
    final pool = PlayerLifecycle.poolAt(seeded, 1, 0);
    expect(pool.map((p) => p.id).toSet(), seeded.map((p) => p.id).toSet());
    expect(pool.every((p) => !PlayerLifecycle.isNewgenId(p.id)), isTrue);
  });

  test('each past cycle boundary adds a fresh newgen intake', () {
    // poolAt now takes years; a cycle is four years, so the first intake
    // debuts at year 4.
    final pool = PlayerLifecycle.poolAt(seeded, 1, 4);
    final newgens = pool.where((p) => PlayerLifecycle.isNewgenId(p.id)).toList();
    expect(newgens, hasLength(PlayerLifecycle.intakePerCycle));
    // Debut youngsters: aged 16-19 at their birth cycle.
    expect(newgens.every((p) => p.age >= 16 && p.age <= 19), isTrue);
    expect(newgens.every((p) => p.nationId == 1), isTrue);
  });

  test('veterans retire once they pass the retirement age', () {
    // Seed one 36-year-old; after four years they are 40 and gone.
    final vets = [
      player(id: 900, nationId: 1, name: 'Old Timer', age: 36),
      ...seeded,
    ];
    final now = PlayerLifecycle.poolAt(vets, 1, 4);
    expect(now.any((p) => p.id == 900), isFalse);
  });

  test('newgens accumulate across cycles, aged from their debut', () {
    final pool = PlayerLifecycle.poolAt(seeded, 1, 12); // three cycles
    final newgens =
        pool.where((p) => PlayerLifecycle.isNewgenId(p.id)).toList();
    // Three intakes' worth of young players still active (none retired yet).
    expect(newgens, hasLength(PlayerLifecycle.intakePerCycle * 3));
    // The earliest intake (born cycle 1, debut year 4) has aged +8 years, so
    // is now at least 24 (debut 16-19 + 8).
    final earliest =
        PlayerLifecycle.newgenById(seeded, seeded.isEmpty ? 0 : 0, 12);
    expect(earliest, isNull); // sanity: id 0 is not a newgen
    final born1 = newgens.where(_bornAtCycle(1)).toList();
    expect(born1, isNotEmpty);
    expect(born1.every((p) => p.age >= 24), isTrue);
  });

  test('deterministic: same inputs produce identical newgens', () {
    final a = PlayerLifecycle.poolAt(seeded, 1, 8);
    final b = PlayerLifecycle.poolAt(seeded, 1, 8);
    expect(
      a.map((p) => '${p.id}:${p.name}:${p.overall}'),
      b.map((p) => '${p.id}:${p.name}:${p.overall}'),
    );
  });

  test('newgenById round-trips a generated player', () {
    final pool = PlayerLifecycle.poolAt(seeded, 1, 8);
    final ng = pool.firstWhere((p) => PlayerLifecycle.isNewgenId(p.id));
    final byId = PlayerLifecycle.newgenById(seeded, ng.id, 8);
    expect(byId, isNotNull);
    expect(byId!.id, ng.id);
    expect(byId.name, ng.name);
    expect(byId.age, ng.age);
    expect(PlayerLifecycle.nationIdOf(ng.id), 1);
  });

  test('newgenById returns null for a seeded id', () {
    expect(PlayerLifecycle.newgenById(seeded, 100, 12), isNull);
  });
}

/// Matches newgens whose id encodes [bornCycle] (base 1e9 + nation*1e6 +
/// cycle*1e3 + slot).
bool Function(Player) _bornAtCycle(int bornCycle) => (p) {
      final rem = p.id - 1000000000;
      return (rem % 1000000) ~/ 1000 == bornCycle;
    };
