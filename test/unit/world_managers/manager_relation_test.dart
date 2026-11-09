import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';

const _me = 1;
const _him = 2;

final _spell = ManagerSpell(
  spellNo: 1,
  managerId: 7,
  nationId: _him,
  fromDate: DateTime(2020),
  contractUntil: DateTime(2040),
);

Fixture _fx(DateTime d, int mine, int theirs, {String? round = 'QF'}) =>
    Fixture(
      id: d.millisecondsSinceEpoch,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: d,
      homeNationId: _me,
      awayNationId: _him,
      homeScore: mine,
      awayScore: theirs,
      round: round,
      played: true,
    );

ManagerRelation _read({
  required DateTime today,
  List<Fixture> meetings = const [],
  List<ManagerTie> ties = const [],
}) => readRelation(
  spells: [_spell],
  meetings: meetings,
  playerSideAt: (_) => {_me},
  ties: ties,
  today: today,
);

ManagerTie _tie(TieKind k, int delta, DateTime d) =>
    ManagerTie(tieNo: 1, managerId: 7, kind: k, delta: delta, date: d);

void main() {
  test('never met is neutral', () {
    final r = _read(today: DateTime(2026));
    expect(r.label, TieLabel.neutral);
    expect(r.warmth, 0);
    expect(r.meetings, 0);
  });

  test('two knockout exits make rival', () {
    final r = _read(
      meetings: [
        _fx(DateTime(2022, 6), 0, 1),
        _fx(DateTime(2024, 6), 2, 1),
      ],
      today: DateTime(2024, 7),
    );
    expect(r.label, TieLabel.rival);
    expect(r.meetings, 2);
    expect((r.won, r.drawn, r.lost), (1, 0, 1));
    expect(r.warmth, lessThan(0));
  });

  test('rival fades to neutral after two cycles without a meeting', () {
    final meetings = [
      _fx(DateTime(2021, 6), 0, 1),
      _fx(DateTime(2022, 6), 0, 1),
    ];
    expect(
      _read(meetings: meetings, today: DateTime(2030)).label,
      TieLabel.rival,
    );
    final r = _read(meetings: meetings, today: DateTime(2031));
    expect(r.label, TieLabel.neutral);
  });

  test('heavy win costs 5', () {
    final r = _read(
      meetings: [_fx(DateTime(2024, 6), 5, 2, round: 'GROUP')],
      today: DateTime(2024, 6),
    );
    expect(r.warmth, -5);
    expect(r.won, 1);
  });

  test('grudge stays for life while its warmth decays 25% a year', () {
    final t = [_tie(TieKind.grudge, -25, DateTime(2020))];
    expect(_read(ties: t, today: DateTime(2020)).warmth, -25);
    final later = _read(ties: t, today: DateTime(2021, 1, 1));
    expect(later.warmth, closeTo(-25 * 0.75, 0.6));
    final old = _read(ties: t, today: DateTime(2060));
    expect(old.label, TieLabel.grudge);
    expect(old.warmth.abs(), lessThan(2));
  });

  test('protege +40 and former player +20 label over warmth', () {
    final p = _read(
      ties: [_tie(TieKind.protege, 40, DateTime(2024))],
      today: DateTime(2024),
    );
    expect((p.label, p.warmth), (TieLabel.protege, 40));
    final f = _read(
      ties: [_tie(TieKind.formerPlayer, 20, DateTime(2024))],
      today: DateTime(2024),
    );
    expect((f.label, f.warmth), (TieLabel.formerPlayer, 20));
  });

  test('the most recent structural tie sets the label', () {
    final r = _read(
      ties: [
        _tie(TieKind.grudge, -25, DateTime(2022)),
        _tie(TieKind.protege, 40, DateTime(2024)),
      ],
      today: DateTime(2024),
    );
    expect(r.label, TieLabel.protege);
  });

  test('a shootout exit counts as a knockout elimination', () {
    Fixture shootout(DateTime d) => _fx(d, 1, 1).copyWith(
      homePenalties: 3,
      awayPenalties: 5,
    );
    final r = _read(
      meetings: [shootout(DateTime(2022, 6)), shootout(DateTime(2024, 6))],
      today: DateTime(2024, 7),
    );
    expect(r.label, TieLabel.rival);
    expect(r.warmth, lessThan(-10));
  });

  test('press dig -15 and respect +10 move warmth', () {
    final d = DateTime(2024);
    final r = _read(
      ties: [_tie(TieKind.pressDig, -15, d), _tie(TieKind.pressRespect, 10, d)],
      today: d,
    );
    expect(r.warmth, -5);
    expect(r.label, TieLabel.neutral);
    final up = _read(
      ties: [_tie(TieKind.pressRespect, 40, d)],
      today: d,
    );
    expect(up.label, TieLabel.respect);
  });
}
