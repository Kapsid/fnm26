import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/domain/services/world_managers/manager_reputation.dart';

import 'manager_lab_world.dart';

final _d = DateTime(2030, 7, 15);

DateTime _ago({int years = 0, int days = 0}) =>
    DateTime(_d.year - years, _d.month, _d.day).subtract(Duration(days: days));

WorldManager _m(
  int id, {
  String nat = 'AAA',
  int age = 50,
  ManagerOrigin origin = ManagerOrigin.fresh,
  DateTime? entered,
}) => WorldManager(
  managerId: id,
  name: 'M$id',
  nationality: nat,
  birthYear: _d.year - age,
  style: 'balanced',
  origin: origin,
  enteredAt: entered ?? _ago(years: 3),
);

ManagerSpell _s(
  int no,
  int managerId,
  int nationId, {
  DateTime? from,
  DateTime? until,
  DateTime? to,
  SpellEnd? end,
  int briefNet = 0,
}) => ManagerSpell(
  spellNo: no,
  managerId: managerId,
  nationId: nationId,
  fromDate: from ?? _ago(years: 3),
  contractUntil: until ?? DateTime(_d.year + 2),
  toDate: to,
  endReason: to == null ? null : (end ?? SpellEnd.sacked),
  briefNet: briefNet,
);

/// A zero-length past spell worth `20 + 4 * briefNet` reputation on its own.
ManagerSpell _rep(int no, int managerId, int briefNet) => _s(
  no,
  managerId,
  999,
  from: _ago(years: 10),
  to: _ago(years: 10),
  briefNet: briefNet,
);

NationWindow _w(int briefNet, {double surprise = 0, bool met = false}) => (
  briefNet: briefNet,
  surpriseSum: surprise,
  settledFinalsBriefMet: met,
  anyBriefSettled: true,
);

DecisionContext _ctx({
  required int nations,
  Set<int>? scope,
  Set<int> player = const {},
  String key = 'k',
  bool rollover = false,
  DateTime? date,
  int ranked = 100,
}) => (
  date: date ?? _d,
  // Every ranked nation is an AI nation, so the cap is capShare of these.
  rankById: {
    for (var n = 1; n <= (ranked > nations ? ranked : nations); n++) n: n,
  },
  scope: scope ?? {for (var n = 1; n <= nations; n++) n},
  playerNationIds: player,
  rngSeed: 7,
  key: key,
  rollover: rollover,
);

Set<int> _changed(ManagerChanges c) => {for (final m in c.moves) m.nationId};

void main() {
  test('attractCap rises with rank and stops at 100', () {
    expect(ManagerDecisions.attractCap(1), 100);
    expect(ManagerDecisions.attractCap(200), closeTo(43.3, 1e-9));
    expect(ManagerDecisions.attractCap(211), 40);
  });

  test('reputation follows the formula and is clamped', () {
    final w = ManagerWorld(
      managers: [_m(1), _m(2)],
      spells: [
        // 2 years at rank 1: 2 * 210 / 211 * 6.
        _s(1, 1, 1, from: _ago(years: 4), to: _ago(years: 2), briefNet: 1),
        _s(2, 2, 2, briefNet: -30),
      ],
    );
    final r = ManagerReputation.of(1, w, {1: 1, 2: 2}, {1: 2}, asOf: _d);
    final years = _ago(years: 2).difference(_ago(years: 4)).inDays / 365.25;
    expect(r, (20 + years * 210 / 211 * 6 + 2 * 8 + 4).round());
    expect(ManagerReputation.of(2, w, {1: 1, 2: 2}, const {}, asOf: _d), 0);
  });

  test('no results sack inside 12 months', () {
    var youngSacked = 0;
    var oldSacked = 0;
    for (var k = 0; k < 30; k++) {
      final young = ManagerWorld(
        managers: [_m(1), _m(2), _m(3)],
        spells: [_s(1, 1, 1, from: _ago(days: 300))],
      );
      final c1 = ManagerDecisions.decide(young, {
        1: _w(-10),
      }, _ctx(nations: 1, key: 'y$k'));
      if (c1.closed.isNotEmpty) youngSacked++;
      final old = ManagerWorld(
        managers: [_m(1), _m(2), _m(3)],
        spells: [_s(1, 1, 1, from: _ago(days: 400))],
      );
      final c2 = ManagerDecisions.decide(old, {
        1: _w(-10),
      }, _ctx(nations: 1, key: 'o$k'));
      if (c2.closed.any((s) => s.endReason == SpellEnd.sacked)) oldSacked++;
    }
    expect(youngSacked, 0);
    expect(oldSacked, greaterThan(10));
  });

  test('one change per nation per 12 months', () {
    for (var k = 0; k < 30; k++) {
      var w = ManagerWorld(
        managers: [_m(1), _m(2), _m(3), _m(4)],
        spells: [_s(1, 1, 1, from: _ago(years: 3))],
      );
      final first = ManagerDecisions.decide(w, {
        1: _w(-10),
      }, _ctx(nations: 1, key: 'a$k'));
      w = applyManagerChanges(w, first);
      expect(first.moves.length, lessThanOrEqualTo(1));
      if (first.moves.isEmpty) continue;
      final later = ManagerDecisions.decide(
        w,
        {1: _w(-10)},
        _ctx(nations: 1, key: 'b$k', date: _d.add(const Duration(days: 300))),
      );
      expect(later.moves, isEmpty);
      expect(later.closed, isEmpty);
    }
  });

  test("cap keeps the worst scores' changes, trims the mildest and fills "
      'forced vacancies', () {
    // A point judging 12 of 20 AI nations: at most 2 change at once (15% of
    // the 12, rounded up). Nation 12 is vacant (forced), nations 1 to
    // 4 are out of contract with small negative scores (no sack roll), so
    // one of the four contract ends may go: the worst.
    final managers = [for (var i = 1; i <= 20; i++) _m(i)];
    final expired = DateTime(_d.year - 1);
    final spells = [
      for (var n = 1; n <= 11; n++) _s(n, n, n, until: n <= 4 ? expired : null),
    ];
    final w = ManagerWorld(managers: managers, spells: spells);
    final windows = {
      1: _w(0, surprise: -0.4),
      2: _w(0, surprise: -0.8),
      3: _w(0, surprise: -1.2),
      4: _w(0, surprise: -1.6),
    };
    final c = ManagerDecisions.decide(
      w,
      windows,
      _ctx(nations: 12, ranked: 20),
    );
    expect(_changed(c), {12, 4});
    expect(
      {
        for (final s in c.closed)
          if (s.endReason == SpellEnd.contractEnd) s.nationId,
      },
      {4},
    );
    // The trimmed contract ends are held over on the old contract, for the
    // next decision point to look at again.
    for (final s in c.renewed) {
      expect(s.contractUntil.isAfter(_d), isFalse);
    }

    // Forced vacancies beyond the cap are all still filled.
    final w2 = ManagerWorld(
      managers: managers,
      spells: [
        for (var n = 1; n <= 7; n++)
          _s(n, n, n, until: n <= 4 ? expired : null),
      ],
    );
    final c2 = ManagerDecisions.decide(
      w2,
      windows,
      _ctx(nations: 12, ranked: 12),
    );
    expect(_changed(c2), {8, 9, 10, 11, 12});
    expect(c2.closed, isEmpty);
  });

  test('met finals brief shields 12 months', () {
    var shielded = 0;
    var windowShielded = 0;
    var expired = 0;
    for (var k = 0; k < 30; k++) {
      ManagerWorld w() => ManagerWorld(
        managers: [_m(1), _m(2)],
        spells: [_s(1, 1, 1)],
      );
      final a = ManagerDecisions.decide(
        w(),
        {1: _w(-10)},
        _ctx(nations: 1, key: 's$k'),
        finalsBriefMetOn: {1: _ago(days: 300)},
      );
      if (a.closed.isNotEmpty) shielded++;
      final b = ManagerDecisions.decide(w(), {
        1: _w(-10, met: true),
      }, _ctx(nations: 1, key: 't$k'));
      if (b.closed.any((s) => s.endReason == SpellEnd.sacked)) {
        windowShielded++;
      }
      final c = ManagerDecisions.decide(
        w(),
        {1: _w(-10)},
        _ctx(nations: 1, key: 'u$k'),
        finalsBriefMetOn: {1: _ago(days: 400)},
      );
      if (c.closed.any((s) => s.endReason == SpellEnd.sacked)) expired++;
    }
    expect(shielded, 0);
    expect(windowShielded, 0);
    expect(expired, greaterThan(10));
  });

  test('retirement certain at 75 and impossible at 63', () {
    for (var k = 0; k < 30; k++) {
      final w = ManagerWorld(
        managers: [
          _m(1, age: 75),
          _m(2, age: 63),
          _m(3, age: 75),
          _m(4, age: 63),
          _m(5),
        ],
        spells: [_s(1, 1, 1), _s(2, 2, 2)],
      );
      final c = ManagerDecisions.decide(
        w,
        const {},
        _ctx(nations: 2, key: 'r$k', rollover: true),
      );
      expect(
        c.closed.map((s) => (s.managerId, s.endReason)),
        [(1, SpellEnd.retired)],
      );
      expect(
        {
          for (final m in c.updated)
            if (m.retiredAt != null) m.managerId,
        },
        {1, 3},
      );
      expect(_changed(c), {1});
      // The World Championship's point never retires anyone.
      final f = ManagerDecisions.decide(
        w,
        const {},
        _ctx(nations: 2, key: 'f$k'),
      );
      expect(f.updated, isEmpty);
      expect(f.closed, isEmpty);
    }
  });

  test('a continental finals point retires managers in post, not the '
      'free', () {
    for (var k = 0; k < 10; k++) {
      final w = ManagerWorld(
        managers: [_m(1, age: 75), _m(2, age: 75), _m(3)],
        spells: [_s(1, 1, 1)],
      );
      final c = ManagerDecisions.decide(
        w,
        const {},
        _ctx(nations: 1, key: 'cont:UEFA:$k'),
      );
      expect(
        c.closed.map((s) => (s.managerId, s.endReason)),
        [(1, SpellEnd.retired)],
      );
      expect({for (final m in c.updated) m.managerId}, {1});
      expect(_changed(c), {1});
    }
  });

  test('retirements count against the cap, oldest first; the rest stay '
      'on', () {
    // 12 of 20 AI nations judged: at most 2 change. Four men in post retire for
    // certain; the two oldest go, the other two stay in post.
    final w = ManagerWorld(
      managers: [
        _m(1, age: 75),
        _m(2, age: 78),
        _m(3, age: 76),
        _m(4, age: 77),
        for (var i = 5; i <= 14; i++) _m(i),
      ],
      spells: [for (var n = 1; n <= 12; n++) _s(n, n, n)],
    );
    final c = ManagerDecisions.decide(
      w,
      const {},
      _ctx(nations: 12, ranked: 20, rollover: true),
    );
    expect(
      {
        for (final s in c.closed)
          if (s.endReason == SpellEnd.retired) s.managerId,
      },
      {2, 4},
    );
    expect(_changed(c), {2, 4});
    expect(
      {
        for (final m in c.updated)
          if (m.retiredAt != null) m.managerId,
      },
      {2, 4},
    );
  });

  test('the changes of the last 12 months count against the cap', () {
    // 20 AI nations: 3 at one point (15%), 4 in any 12 months (20%).
    // Nations 4 to 20 are out of contract with a mildly negative score.
    final expired = DateTime(_d.year - 1);
    ManagerWorld world(DateTime changedOn) => ManagerWorld(
      managers: [for (var i = 1; i <= 40; i++) _m(i)],
      spells: [
        // Nations 1 to 3 changed manager on [changedOn].
        for (var n = 1; n <= 3; n++) ...[
          _s(
            100 + n,
            20 + n,
            n,
            from: _ago(years: 5),
            to: changedOn,
            end: SpellEnd.sacked,
          ),
          _s(n, n, n, from: changedOn),
        ],
        for (var n = 4; n <= 20; n++) _s(n, n, n, until: expired),
      ],
    );
    final windows = {
      for (var n = 4; n <= 20; n++) n: _w(0, surprise: -1.0 - n / 100),
    };
    final recent = ManagerDecisions.decide(
      world(_ago(days: 30)),
      windows,
      _ctx(nations: 20, ranked: 20),
    );
    expect(_changed(recent), hasLength(1), reason: '4 a year less 3 made');
    final older = ManagerDecisions.decide(
      world(_ago(years: 1, days: 30)),
      windows,
      _ctx(nations: 20, ranked: 20),
    );
    expect(_changed(older), hasLength(3), reason: 'the point cap only');
  });

  test('free 8 years leaves', () {
    final w = ManagerWorld(
      managers: [
        _m(1),
        _m(2, entered: _ago(years: 9)),
        _m(3, entered: _ago(years: 9)),
        _m(4, entered: _ago(years: 9)),
        _m(5, entered: _ago(years: 9)),
      ],
      spells: [
        _s(1, 1, 1),
        _s(2, 2, 5, from: _ago(years: 12), to: _ago(years: 8, days: 1)),
        _s(3, 3, 6, from: _ago(years: 12), to: _ago(years: 7)),
        // Manager 4 never held a job.
      ],
    );
    final c = ManagerDecisions.decide(
      w,
      const {},
      _ctx(nations: 1, rollover: true),
    );
    expect(
      {
        for (final m in c.updated)
          if (m.retiredAt == _d) m.managerId,
      },
      {2, 4, 5},
    );
    final f = ManagerDecisions.decide(w, const {}, _ctx(nations: 1));
    expect(f.updated, isEmpty);
  });

  group('poaching', () {
    // Nation ranks equal their ids. Manager 1 at nation 35 for 6 years has
    // reputation about 50; free manager 9 has 20.
    ManagerWorld world({int poachFrom = 35, int freeRep = 0}) => ManagerWorld(
      managers: [_m(1), _m(2), _m(9)],
      spells: [
        for (var n = 1; n <= 80; n++)
          if (n != 10 && n != poachFrom)
            _s(100 + n, 1000 + n, n, from: _ago(years: 2)),
        _s(1, 1, poachFrom, from: _ago(years: 6)),
        if (freeRep > 0) _rep(2, 9, freeRep),
      ],
    );
    ManagerWorld full(ManagerWorld w) => ManagerWorld(
      managers: [
        ...w.managers,
        for (var n = 1; n <= 80; n++) _m(1000 + n),
      ],
      spells: w.spells,
    );

    test('poach only top-40 vacancy from 20+ places lower with +15 '
        'reputation', () {
      final c = ManagerDecisions.decide(
        full(world()),
        const {},
        _ctx(nations: 80, rollover: true),
      );
      final moves = {for (final m in c.moves) m.nationId: m};
      expect(moves[10]?.incomingId, 1);
      expect(moves[35]?.outgoingId, 1);
      expect(moves[35]?.why, SpellEnd.poached);
      expect(
        c.closed.single.endReason,
        SpellEnd.poached,
      );

      // Not at a finals point.
      final f = ManagerDecisions.decide(
        full(world()),
        const {},
        _ctx(nations: 80),
      );
      expect(f.closed, isEmpty);
      expect(_changed(f), {10});

      // Only 15 places lower: no poach.
      final near = ManagerDecisions.decide(
        full(world(poachFrom: 25)),
        const {},
        _ctx(nations: 80, rollover: true),
      );
      expect(near.closed, isEmpty);

      // The free candidate is within 15 of him: no poach.
      final close = ManagerDecisions.decide(
        full(world(freeRep: 6)),
        const {},
        _ctx(nations: 80, rollover: true),
      );
      expect(close.closed, isEmpty);
    });

    test('a vacancy ranked 41 never poaches', () {
      final w = ManagerWorld(
        managers: [_m(1), _m(9), for (var n = 1; n <= 80; n++) _m(1000 + n)],
        spells: [
          for (var n = 1; n <= 80; n++)
            if (n != 41 && n != 70)
              _s(100 + n, 1000 + n, n, from: _ago(years: 2)),
          _s(1, 1, 70, from: _ago(years: 6)),
        ],
      );
      final c = ManagerDecisions.decide(
        w,
        const {},
        _ctx(nations: 80, rollover: true),
      );
      expect(c.closed, isEmpty);
      expect(c.moves.single.nationId, 41);
    });

    test("poached manager's old nation hires from the pool, no chain", () {
      // Manager 3 at nation 70 would beat the pool by 15 too, but nation
      // 35's vacancy only exists because of a poach.
      final w = ManagerWorld(
        managers: [
          _m(1),
          _m(3),
          _m(9),
          for (var n = 1; n <= 80; n++) _m(1000 + n),
        ],
        spells: [
          for (var n = 1; n <= 80; n++)
            if (n != 10 && n != 35 && n != 70)
              _s(100 + n, 1000 + n, n, from: _ago(years: 2)),
          _s(1, 1, 35, from: _ago(years: 6)),
          _s(3, 3, 70, from: _ago(years: 6)),
        ],
      );
      final c = ManagerDecisions.decide(
        w,
        const {},
        _ctx(nations: 80, rollover: true),
      );
      final moves = {for (final m in c.moves) m.nationId: m};
      expect(moves.keys.toSet(), {10, 35});
      expect(moves[10]!.incomingId, 1);
      expect(moves[35]!.incomingId, 9);
      expect(c.closed.single.managerId, 1);
    });
  });

  test('hiring respects attractCap and the domestic bonus', () {
    // Nation 200 (rank 200) can attract up to 43.3. Reputations: A 52,
    // B 32, C 28 or 24.
    ManagerWorld world(ManagerOrigin cOrigin, int cNet, String cNat) =>
        ManagerWorld(
          managers: [
            _m(1),
            _m(2),
            _m(3, nat: cNat, origin: cOrigin),
          ],
          spells: [_rep(1, 1, 8), _rep(2, 2, 3), _rep(3, 3, cNet)],
        );
    ManagerChanges hire(ManagerWorld w) => ManagerDecisions.decide(
      w,
      const {},
      _ctx(nations: 200, scope: {200}),
      codeById: const {200: 'XYZ'},
    );
    int? incoming(ManagerChanges c) => c.moves.single.incomingId;

    expect(incoming(hire(world(ManagerOrigin.fresh, 2, 'AAA'))), 2);
    expect(incoming(hire(world(ManagerOrigin.exPlayer, 2, 'XYZ'))), 3);
    expect(incoming(hire(world(ManagerOrigin.exAssistant, 2, 'XYZ'))), 3);
    expect(incoming(hire(world(ManagerOrigin.fresh, 2, 'XYZ'))), 3);
    expect(incoming(hire(world(ManagerOrigin.fresh, 1, 'XYZ'))), 2);

    // Nobody under the cap: the lowest reputation free manager.
    final over = ManagerWorld(
      managers: [_m(1), _m(2)],
      spells: [_rep(1, 1, 8), _rep(2, 2, 7)],
    );
    expect(incoming(hire(over)), 2);

    // A new spell runs 2 to 6 years.
    final s = hire(world(ManagerOrigin.fresh, 2, 'AAA')).opened.single;
    expect(s.fromDate, _d);
    final years = s.contractUntil.year - _d.year;
    expect(
      years,
      inInclusiveRange(
        ManagerDecisions.contractMinYears,
        ManagerDecisions.contractMaxYears,
      ),
    );
  });

  test('renewal when score >= 0', () {
    ManagerWorld w() => ManagerWorld(
      managers: [_m(1), _m(2)],
      spells: [_s(1, 1, 1, until: DateTime(_d.year - 1), briefNet: 2)],
    );
    final keep = ManagerDecisions.decide(w(), {
      1: _w(1, surprise: -2),
    }, _ctx(nations: 1));
    expect(keep.closed, isEmpty);
    final r = keep.renewed.single;
    expect(r.briefNet, 2);
    expect(
      r.contractUntil.year - _d.year,
      inInclusiveRange(
        ManagerDecisions.contractMinYears,
        ManagerDecisions.contractMaxYears,
      ),
    );
    expect(r.contractUntil.month, _d.month);

    final go = ManagerDecisions.decide(w(), {
      1: _w(0, surprise: -1),
    }, _ctx(nations: 1));
    expect(go.closed.single.endReason, SpellEnd.contractEnd);
    expect(go.moves.single.incomingId, 2);

    // With no window, the contract is judged on the carried score.
    ManagerWorld carried(int net) => ManagerWorld(
      managers: [_m(1), _m(2)],
      spells: [_s(1, 1, 1, until: DateTime(_d.year - 1), briefNet: net)],
    );
    final ends = ManagerDecisions.decide(
      carried(-1),
      const {},
      _ctx(nations: 1, rollover: true),
    );
    expect(ends.closed.single.endReason, SpellEnd.contractEnd);
    final stays = ManagerDecisions.decide(
      carried(0),
      const {},
      _ctx(nations: 1, rollover: true),
    );
    expect(stays.closed, isEmpty);
    expect(stays.renewed.single.contractUntil.isAfter(_d), isTrue);

    // A score still under contract is stored on the spell.
    final mid = ManagerDecisions.decide(
      ManagerWorld(managers: [_m(1)], spells: [_s(1, 1, 1, briefNet: 2)]),
      {1: _w(3)},
      _ctx(nations: 1),
    );
    expect(mid.renewed.single.briefNet, 5);
    expect(mid.renewed.single.contractUntil, DateTime(_d.year + 2));
  });

  test("decide never touches nations outside scope or the player's", () {
    final expired = DateTime(_d.year - 1);
    final w = ManagerWorld(
      managers: [for (var i = 1; i <= 8; i++) _m(i)],
      spells: [
        _s(1, 1, 1, until: expired),
        _s(2, 2, 2, until: expired),
        _s(3, 3, 3, until: expired),
      ],
    );
    final windows = {
      1: _w(-1),
      2: _w(-1),
      3: _w(-1),
      4: _w(-1),
      5: _w(-1),
    };
    // Nation 4 is vacant out of scope, nation 5 is the player's and vacant.
    final c = ManagerDecisions.decide(
      w,
      windows,
      _ctx(nations: 5, scope: {1, 2, 5}, player: {2, 5}),
    );
    final touched = {
      ..._changed(c),
      for (final s in [...c.closed, ...c.renewed, ...c.opened]) s.nationId,
    };
    expect(touched, {1});
  });

  test('decide is deterministic', () {
    final r1 = runManagerLab(seed: 3, cycles: 2);
    final r2 = runManagerLab(seed: 3, cycles: 2);
    expect(r1, r2);
  });
}
