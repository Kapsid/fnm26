import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';

/// Real codes, so pedigrees and styles are the game's own.
const _codes = [
  // Pedigree 1.
  'ENG', 'FRA', 'ESP', 'GER', 'ITA', 'NED', 'POR', 'BRA', 'ARG',
  // Pedigree 2.
  'BEL', 'CRO', 'URU', 'MEX', 'MAR',
  // Pedigree 3.
  'SUI', 'SWE', 'DEN', 'NOR', 'AUT', 'SRB', 'POL', 'CZE', 'TUR', 'GRE',
  'SCO', 'COL', 'CHI', 'PER', 'ECU', 'BOL', 'VEN', 'ANG', 'BEN', 'BOT',
  // Pedigree 4 and 5.
  'IRL', 'WAL', 'RSA', 'QAT', 'GRL', 'BLR', 'ZAN',
];

final List<Nation> _nations = [
  for (var i = 0; i < _codes.length; i++)
    Nation(
      id: i + 1,
      name: _codes[i],
      code: _codes[i],
      confederation: Confederation.europe,
      ranking: i + 1,
    ),
];

final Map<String, NamePoolLists> _pools = {
  for (final c in _codes)
    c: (
      first: [for (var i = 0; i < 30; i++) '${c}f$i'],
      sur: [for (var i = 0; i < 30; i++) '${c}s$i'],
    ),
};

/// CZE.
const _player = 22;
final DateTime _asOf = DateTime(2030, 9);

ManagerWorld _seed(
  int seed, {
  Map<int, ({String name, String nationality})> pack = const {},
}) => ManagerSeeder.seed(
  rngSeed: seed,
  seedCycle: 1,
  asOf: _asOf,
  nations: _nations,
  rankById: {for (final n in _nations) n.id: n.ranking},
  playerNationIds: {_player},
  pools: _pools,
  packManagers: pack,
);

String _describe(ManagerWorld w) => [
  for (final m in w.managers)
    [
      m.managerId,
      m.name,
      m.nationality,
      m.birthYear,
      m.style,
      m.enteredAt.toIso8601String(),
    ].join(' '),
  for (final s in w.spells)
    [
      s.spellNo,
      s.managerId,
      s.nationId,
      s.fromDate,
      s.toDate,
      s.endReason,
      s.contractUntil,
    ].join(' '),
].join('\n');

void main() {
  test('same seed same world', () {
    expect(_describe(_seed(7)), _describe(_seed(7)));
    expect(_describe(_seed(7)) == _describe(_seed(8)), isFalse);
  });

  test("one incumbent per AI nation and none at the player's", () {
    final w = _seed(3);
    for (final n in _nations) {
      final current = [
        for (final s in w.spells)
          if (s.nationId == n.id && s.current) s,
      ];
      expect(current.length, n.id == _player ? 0 : 1, reason: n.code);
    }
    // No earlier spell at the player's nation either.
    expect(w.spells.where((s) => s.nationId == _player), isEmpty);
    // Nobody holds two jobs.
    final busy = [
      for (final s in w.spells)
        if (s.current) s.managerId,
    ];
    expect(busy.toSet().length, busy.length);
  });

  test('60 free', () {
    final w = _seed(3);
    expect(w.free(_asOf).length, 60);
    expect(w.managers.length, _nations.length - 1 + 60);
    expect(w.managers.every((m) => m.origin == ManagerOrigin.fresh), isTrue);
  });

  test('domestic share by pedigree within ±8 points over seeds 1..20', () {
    final home = {for (final n in _nations) n.id: n.code};
    final counts = <String, ({int domestic, int all})>{};
    String band(int p) => p <= 2
        ? '1-2'
        : p == 3
        ? '3'
        : '4-5';
    for (var seed = 1; seed <= 20; seed++) {
      final w = _seed(seed);
      final byId = {for (final m in w.managers) m.managerId: m};
      for (final s in w.spells.where((s) => s.current)) {
        final code = home[s.nationId]!;
        final b = band(NationIdentity.of(code).pedigree);
        final was = counts[b] ?? (domestic: 0, all: 0);
        counts[b] = (
          domestic:
              was.domestic + (byId[s.managerId]!.nationality == code ? 1 : 0),
          all: was.all + 1,
        );
      }
    }
    const target = {'1-2': 85, '3': 70, '4-5': 55};
    for (final e in target.entries) {
      final c = counts[e.key]!;
      final share = 100 * c.domestic / c.all;
      expect(
        (share - e.value).abs(),
        lessThanOrEqualTo(8),
        reason: 'pedigree ${e.key}: $share% of ${c.all}',
      );
    }
  });

  test("every name is first + surname from that nationality's pool", () {
    for (final seed in [1, 2, 3]) {
      for (final m in _seed(seed).managers) {
        final pool = _pools[m.nationality]!;
        final space = m.name.indexOf(' ');
        expect(pool.first, contains(m.name.substring(0, space)));
        expect(pool.sur, contains(m.name.substring(space + 1)));
      }
    }
    // And each name is someone's own.
    final names = [for (final m in _seed(1).managers) m.name];
    expect(names.toSet().length, names.length);
  });

  test('a real name in the pool is never given', () {
    // Pools of one first name and two surnames, so 'CZEf0 CZEs0' would be
    // drawn about half the time.
    final tiny = {
      for (final c in _codes) c: (first: ['${c}f0'], sur: ['${c}s0', '${c}s1']),
    };
    final real = {for (final c in _codes) '${c}f0 ${c}s0'};
    final w = ManagerSeeder.seed(
      rngSeed: 4,
      seedCycle: 0,
      asOf: _asOf,
      nations: _nations,
      rankById: const {},
      playerNationIds: const {},
      pools: tiny,
      packManagers: const {},
      realNames: real,
    );
    expect(w.managers.where((m) => real.contains(m.name)), isEmpty);
  });

  test('spell starts lie within 6 years of asOf', () {
    final earliest = DateTime(_asOf.year - 6, _asOf.month, _asOf.day);
    final contractFloor = DateTime(_asOf.year + 1, _asOf.month, _asOf.day);
    for (final seed in [1, 2, 3, 4]) {
      final w = _seed(seed);
      for (final s in w.spells.where((s) => s.current)) {
        expect(s.fromDate.isAfter(_asOf), isFalse);
        expect(s.fromDate.isBefore(earliest), isFalse);
        expect(s.contractUntil.isBefore(contractFloor), isFalse);
        // Two to six years from the start, unless that falls short of a
        // year past asOf.
        final six = DateTime(
          s.fromDate.year + 6,
          s.fromDate.month,
          s.fromDate.day,
        );
        expect(
          s.contractUntil.isAfter(
            six.isAfter(contractFloor) ? six : contractFloor,
          ),
          isFalse,
        );
      }
      for (final m in w.managers) {
        final age = _asOf.year - m.birthYear;
        expect(age, inInclusiveRange(38, 66));
      }
    }
  });

  test("no earlier spell overlaps its manager's current one", () {
    for (final seed in [1, 2, 3, 4, 5]) {
      final w = _seed(seed);
      final starts = {
        for (final s in w.spells)
          if (s.current) s.nationId: s.fromDate,
      };
      for (final m in w.managers) {
        final own = [
          for (final s in w.spells)
            if (s.managerId == m.managerId) s,
        ]..sort((a, b) => a.fromDate.compareTo(b.fromDate));
        expect(own.where((s) => s.current).length, lessThanOrEqualTo(1));
        for (var i = 0; i + 1 < own.length; i++) {
          final to = own[i].toDate!;
          expect(to.isAfter(own[i + 1].fromDate), isFalse);
          expect(own[i].endReason, isNotNull);
        }
        for (final s in own.where((s) => !s.current)) {
          expect(s.fromDate.isBefore(s.toDate!), isTrue);
          // Over before that nation's incumbent arrived.
          if (starts[s.nationId] case final arrived?) {
            expect(s.toDate!.isAfter(arrived), isFalse);
          }
          expect(
            {SpellEnd.sacked, SpellEnd.resigned, SpellEnd.contractEnd},
            contains(s.endReason),
          );
        }
      }
      // So whoever is in charge on asOf is each nation's incumbent.
      for (final MapEntry(key: nationId, value: from) in starts.entries) {
        expect(w.inChargeOn(nationId, _asOf)!.fromDate, from);
      }
    }
  });

  test('no two spells at one nation overlap', () {
    for (var seed = 1; seed <= 20; seed++) {
      final w = _seed(seed);
      final byNation = <int, List<ManagerSpell>>{};
      for (final s in w.spells) {
        (byNation[s.nationId] ??= []).add(s);
      }
      final open = DateTime(9999);
      for (final spells in byNation.values) {
        for (var i = 0; i < spells.length; i++) {
          for (var j = i + 1; j < spells.length; j++) {
            final a = spells[i];
            final b = spells[j];
            final overlap =
                a.fromDate.isBefore(b.toDate ?? open) &&
                b.fromDate.isBefore(a.toDate ?? open);
            expect(
              overlap,
              isFalse,
              reason:
                  'seed $seed nation ${a.nationId}: spells '
                  '${a.spellNo} and ${b.spellNo}',
            );
          }
        }
      }
    }
  });

  test('every manager has one or two earlier spells', () {
    for (var seed = 1; seed <= 20; seed++) {
      final w = _seed(seed);
      for (final m in w.managers) {
        final past = w.spells.where(
          (s) => s.managerId == m.managerId && !s.current,
        );
        expect(
          past.length,
          inInclusiveRange(1, 2),
          reason: 'seed $seed manager ${m.managerId}',
        );
        for (final s in past) {
          expect(
            s.fromDate.year - m.birthYear,
            greaterThanOrEqualTo(ManagerSeeder.minFirstJobAge),
          );
        }
      }
    }
  });

  test('a world whose lists give only real names falls back, never throws', () {
    // Czechia's world lists make one name, a real one.
    final worldPools = {
      ..._pools,
      'CZE': (first: ['Real'], sur: ['Person']),
      'POL': (first: ['Real'], sur: ['Pole']),
    };
    final defaults = {
      ..._pools,
      'POL': (first: <String>[], sur: <String>[]),
    };
    final w = ManagerSeeder.seed(
      rngSeed: 2,
      seedCycle: 0,
      asOf: _asOf,
      nations: _nations,
      rankById: const {},
      playerNationIds: const {},
      pools: worldPools,
      packManagers: const {},
      realNames: const {'Real Person', 'Real Pole'},
      defaultPools: defaults,
    );
    for (final m in w.managers.where((m) => m.nationality == 'CZE')) {
      // From Czechia's own default pool.
      expect(m.name, startsWith('CZEf'));
    }
    for (final m in w.managers.where((m) => m.nationality == 'POL')) {
      // Poland has no default pool: England's.
      expect(m.name, startsWith('ENGf'));
    }
    expect(
      w.managers.where((m) => m.nationality == 'CZE' || m.nationality == 'POL'),
      isNotEmpty,
    );
  });

  test('a pack manager keeps its name and nationality', () {
    const named = (name: 'Ota Brnak', nationality: 'CZE');
    final w = _seed(5, pack: {1: named, _player: named});
    final spell = w.currentAt(1)!;
    final m = w.managers.firstWhere((m) => m.managerId == spell.managerId);
    expect(m.name, 'Ota Brnak');
    expect(m.nationality, 'CZE');
    // His style is drawn from his nationality's: Czechia's or a neighbour.
    final czech = NationIdentity.styleOf('CZE');
    expect(
      {czech, ...kNeighbourStyles[czech]!}.map((s) => s.name),
      contains(m.style),
    );
    // The player's nation still has nobody, and only nation 1 is renamed.
    expect(w.currentAt(_player), isNull);
    expect(w.managers.where((m) => m.name == 'Ota Brnak').length, 1);
    // Every other nation's incumbent is as the default world draws him.
    final plain = _seed(5);
    for (final n in _nations.where((n) => n.id != 1 && n.id != _player)) {
      final a = w.managers.firstWhere(
        (m) => m.managerId == w.currentAt(n.id)!.managerId,
      );
      final b = plain.managers.firstWhere(
        (m) => m.managerId == plain.currentAt(n.id)!.managerId,
      );
      expect(a.name, b.name, reason: n.code);
    }
  });
}
