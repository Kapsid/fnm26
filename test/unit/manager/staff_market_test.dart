import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/manager/staff.dart';

/// Hiring used to be a choice of price band — "elite scout" — which is a price
/// list, not a staff room. These pin down the person: who applies is derived
/// from the save and the cycle, nothing is stored but the id of the man hired,
/// and his tier is readable straight back out of that id.
void main() {
  // Home, and abroad. Coaching is an international trade: a federation hires
  // the best man who will come, not the best man who holds its passport.
  const pool = <String, List<String>>{
    'cze': [
      'Tomas Novak',
      'Petr Svoboda',
      'Jan Dvorak',
      'Martin Cerny',
      'Lukas Prochazka',
    ],
    'ita': ['Marco Rossi', 'Luca Bianchi', 'Andrea Conti', 'Paolo Greco'],
    'ned': ['Daan Visser', 'Bram Jansen', 'Sem Bakker', 'Luuk de Vries'],
  };

  List<StaffCandidate> market({
    int saveSeed = 7,
    int cycle = 0,
    StaffRole role = StaffRole.assistant,
  }) => StaffMarket.forRole(
    saveSeed: saveSeed,
    cycle: cycle,
    role: role,
    namePool: pool,
  );

  test('the same save and cycle always offer the same people', () {
    expect(market().map((c) => c.name), market().map((c) => c.name));
    expect(market().map((c) => c.id), market().map((c) => c.id));
  });

  test('a different cycle brings different applicants', () {
    expect(
      market(cycle: 0).map((c) => c.name).toList(),
      isNot(market(cycle: 1).map((c) => c.name).toList()),
    );
  });

  test('a different save gets its own room', () {
    expect(
      market(saveSeed: 7).map((c) => c.name).toList(),
      isNot(market(saveSeed: 99).map((c) => c.name).toList()),
    );
  });

  test('there is always somebody cheap and somebody at the top', () {
    final tiers = market().map((c) => c.tier).toList();
    expect(tiers, hasLength(StaffMarket.candidatesPerRole));
    expect(tiers.first, StaffTier.basic);
    expect(tiers.last, StaffTier.elite);
    expect(tiers.toSet(), hasLength(3), reason: 'three distinct bands');
  });

  test('an id remembers the tier and the job, with nothing stored', () {
    for (final role in StaffRole.values) {
      for (final c in market(role: role)) {
        expect(StaffMarket.tierOf(c.id), c.tier, reason: 'tier of ${c.id}');
        expect(StaffMarket.roleOf(c.id), role, reason: 'role of ${c.id}');
        expect(StaffMarket.isCandidateId(c.id), isTrue);
      }
    }
  });

  test('no candidate id could be mistaken for a footballer', () {
    for (final role in StaffRole.values) {
      for (var cycle = 0; cycle < 40; cycle++) {
        for (final c in market(cycle: cycle, role: role)) {
          // Above every seeded player, below the newgen base.
          expect(c.id, greaterThan(1000000));
          expect(c.id, lessThan(1000000000));
        }
      }
    }
  });

  test('every job in every cycle offers a full room', () {
    for (final role in StaffRole.values) {
      for (var cycle = 0; cycle < 12; cycle++) {
        final people = market(cycle: cycle, role: role);
        expect(people, hasLength(StaffMarket.candidatesPerRole));
        expect(people.map((c) => c.id).toSet(), hasLength(3));
        for (final c in people) {
          expect(c.name.trim().split(' ').length, greaterThanOrEqualTo(2));
          expect(pool.keys, contains(c.country));
        }
      }
    }
  });

  test('an empty pool offers nobody rather than inventing somebody', () {
    expect(
      StaffMarket.forRole(
        saveSeed: 1,
        cycle: 0,
        role: StaffRole.scout,
        namePool: const {},
      ),
      isEmpty,
    );
  });

  test('the staff room is not a village', () {
    // Every candidate coming from the manager's own country made a room that
    // read like one club's coaching badge intake. Across enough cycles the
    // market has to reach abroad.
    final seen = <String>{};
    for (var cycle = 0; cycle < 25; cycle++) {
      for (final role in StaffRole.values) {
        for (final c in market(cycle: cycle, role: role)) {
          seen.add(c.country);
        }
      }
    }
    expect(seen.length, greaterThan(1), reason: 'saw only $seen');
  });

  test('a pool with one country still works', () {
    final only = StaffMarket.forRole(
      saveSeed: 3,
      cycle: 0,
      role: StaffRole.assistant,
      namePool: const {
        'cze': ['Tomas Novak', 'Petr Svoboda'],
      },
    );
    expect(only, hasLength(StaffMarket.candidatesPerRole));
    for (final c in only) {
      expect(c.country, 'cze');
    }
  });

  test('a country with no names is skipped rather than crashing', () {
    final some = StaffMarket.forRole(
      saveSeed: 4,
      cycle: 0,
      role: StaffRole.scout,
      namePool: const {
        'cze': [],
        'ita': ['Marco Rossi', 'Luca Bianchi'],
      },
    );
    expect(some, hasLength(StaffMarket.candidatesPerRole));
    for (final c in some) {
      expect(c.country, 'ita');
    }
  });
}
