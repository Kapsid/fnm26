import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/domain/services/nation/nation_facts.dart';
import 'package:fnm/features/nations/nation_detail_providers.dart';

import 'seeded_save.dart';

/// [nationDetailProvider] read for real, then given a history it cannot have
/// in a fresh save: a dozen results against long-named sides (home, away and
/// at a neutral finals, one on penalties), the facts they make, and, on
/// another nation's page, a record against the manager.
Override nationDetailWithHistory() => nationDetailProvider.overrideWith((
  ref,
  arg,
) async {
  final base = await loadNationDetail(ref, arg);
  if (base == null) return null;
  final me = arg.nationId;
  final own = base.managerNationId;
  final opponents = [
    for (final n in [
      ...realNations,
    ]..sort((a, b) => b.name.length - a.name.length))
      if (n.id != me && n.id != own) n.id,
  ];
  var id = 5000;
  Fixture fx(
    int opp,
    int gf,
    int ga, {
    required bool home,
    required int year,
    String? round,
    int? pf,
    int? pa,
  }) => Fixture(
    id: id++,
    careerId: arg.careerId,
    competitionId: 1,
    matchday: 1,
    date: DateTime(year, 6, 10 + id % 15),
    homeNationId: home ? me : opp,
    awayNationId: home ? opp : me,
    homeScore: home ? gf : ga,
    awayScore: home ? ga : gf,
    homePenalties: pf == null ? null : (home ? pf : pa),
    awayPenalties: pf == null ? null : (home ? pa : pf),
    round: round,
    played: true,
  );
  final fixtures = [
    fx(opponents[0], 5, 0, home: true, year: 2027),
    fx(opponents[1], 1, 1, home: false, year: 2027),
    fx(opponents[2], 2, 1, home: true, year: 2028),
    fx(opponents[3], 0, 2, home: false, year: 2028),
    fx(opponents[4], 3, 2, home: true, year: 2028, round: 'CQF', pf: 5, pa: 4),
    if (own != me) ...[
      fx(own, 1, 0, home: true, year: 2029),
      fx(own, 0, 3, home: false, year: 2029),
    ],
    fx(opponents[5], 2, 0, home: true, year: 2029),
    fx(opponents[6], 1, 0, home: true, year: 2029),
    fx(opponents[7], 4, 1, home: true, year: 2029),
    fx(opponents[8], 2, 2, home: true, year: 2030, round: 'GROUP'),
  ]..sort((a, b) => b.date.compareTo(a.date));
  final venues = <int, MatchVenue>{
    for (final f in fixtures)
      f.id: f.round == null
          ? (neutral: false, hostId: 0, tournamentHostIds: const <int>[])
          : (neutral: true, hostId: 0, tournamentHostIds: [opponents[9]]),
  };
  final results = [for (final f in fixtures) formChipOf(f, me)];
  HeadToHeadSummary? against;
  if (own != me) {
    final meetings = [
      for (final r in results)
        if (r.opponentId == own) r,
    ];
    const record = (
      played: 2,
      winsA: 1,
      draws: 0,
      winsB: 1,
      goalsA: 3,
      goalsB: 1,
      biggestWinMarginA: 3,
      biggestWinMarginB: 1,
    );
    against = HeadToHeadSummary(
      record: record,
      last: meetings.first,
      biggestWin: meetings.firstWhere((m) => m.goalsAgainst > m.goalsFor),
    );
  }
  return NationDetail(
    vitrine: base.vitrine,
    now: base.now,
    nations: base.nations,
    managerNationId: own,
    managerName: base.managerName,
    results: results,
    venues: venues,
    facts: NationFacts.derive(
      nationId: me,
      fixtures: fixtures,
      homeFixtureIds: {
        for (final f in fixtures)
          if (f.round == null && f.homeNationId == me) f.id,
      },
      titleYears: [for (final t in base.vitrine.titles) t.year],
      currentYear: 2031,
      rankHistory: const [
        (year: 2026, rank: 48),
        (year: 2030, rank: 21),
      ],
      managerNationId: own == me ? null : own,
      recordScorer: (name: 'Long-Named Record Scorer', goals: 37),
      worldFinalsPlayed: 1,
    ),
    againstYou: against,
    star: base.star,
    youngest: base.youngest,
    captain: base.captain,
    clubCountries: base.clubCountries,
  );
});
