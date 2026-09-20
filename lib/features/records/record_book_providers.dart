import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/stats/nation_results.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One leaderboard entry (a player and their tally).
/// One line of a nation's record book: a player, his tally, and whether he is
/// still playing — the same rule the pool retires on, so a record book reads
/// as half history and half squad rather than as one flat list.
typedef RecordLeader = ({
  int playerId,
  String name,
  int value,
  bool active,
});

/// The manager's nation's all-time record book, spanning every cycle.
typedef RecordBook = ({
  String nationName,
  List<RecordLeader> mostCaps,
  List<RecordLeader> topScorers,
  List<RecordLeader> topAssists,
  ({int oppId, int gf, int ga})? biggestWin,
  int longestUnbeaten,
  String bestFinish,
  Map<int, Nation> nations,
});

/// The deepest World Championship finals round reached, written for the
/// manager.
///
/// This was a const map of English sentences printed straight onto the record
/// book — the one row on that screen that never spoke Czech, and the last
/// place the old competition name survived. The round code is the data; the
/// wording is a display decision, so it is made here, against the same finish
/// labels every other screen uses.
String _wcFinishLabel(AppLocalizations l, String round) => switch (round) {
  'FINAL' => l.finishRunnersUp,
  '3RD' || 'SF' => l.finishSemiFinals,
  'QF' => l.finishQuarterFinals,
  'R16' => l.finishRoundOf16,
  'R32' => l.hubStageRoundOf32,
  'GROUP' => l.finishGroupStage,
  _ => l.compWorldCupFinals,
};
const _wcFinishRank = {
  'GROUP': 1,
  'R32': 2,
  'R16': 3,
  'QF': 4,
  'SF': 5,
  '3RD': 5,
  'FINAL': 6,
};

final AutoDisposeFutureProviderFamily<RecordBook?, int>
recordBookProvider = FutureProvider.autoDispose.family<RecordBook?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final playerRepo = ref.watch(playerRepositoryProvider);
  final nationId = career.nationId;
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final careerDev = await ref.watch(careerDevBonusProvider(careerId).future);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };

  final playerCache = <int, ({String name, bool active})>{};
  Future<({String name, bool active})> resolve(int id) async {
    final hit = playerCache[id];
    if (hit != null) return hit;
    final p = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    return playerCache[id] = (
      name: p?.name ?? 'Unknown',
      active: p != null && !PlayerLifecycle.hasRetiredAt(p.id, p.age, aging),
    );
  }

  final capsRaw = await comp.nationTopAppearances(careerId, nationId, limit: 5);
  final scorersRaw = await comp.nationTopScorers(careerId, nationId, limit: 5);
  final assistsRaw = await comp.nationTopAssists(careerId, nationId, limit: 5);

  final mostCaps = <RecordLeader>[
    for (final c in capsRaw)
      (
        playerId: c.playerId,
        name: (await resolve(c.playerId)).name,
        value: c.games,
        active: (await resolve(c.playerId)).active,
      ),
  ];
  final topScorers = <RecordLeader>[
    for (final s in scorersRaw)
      (
        playerId: s.playerId,
        name: (await resolve(s.playerId)).name,
        value: s.goals,
        active: (await resolve(s.playerId)).active,
      ),
  ];
  final topAssists = <RecordLeader>[
    for (final a in assistsRaw)
      (
        playerId: a.playerId,
        name: (await resolve(a.playerId)).name,
        value: a.assists,
        active: (await resolve(a.playerId)).active,
      ),
  ];

  // Biggest win, longest unbeaten run, and deepest World Cup run — over every
  // result the nation has ever posted, friendlies included. The comment here
  // used to say "competitive" while the code counted everything; the rule is
  // now stated once, in [nationResults], and shared with the rival card and
  // the head-to-head screen.
  final results = nationResults(
    await comp.fixturesForNation(careerId, nationId),
    nationId,
  );
  final best = biggestWinOf(results);
  final biggestWin = best == null
      ? null
      : (oppId: best.opponentId, gf: best.scored, ga: best.conceded);
  final longestUnbeaten = longestUnbeatenOf(results);

  var deepestRank = 0;
  var deepestRound = '';
  for (final r in results) {
    final rank = _wcFinishRank[r.round] ?? 0;
    if (rank > deepestRank) {
      deepestRank = rank;
      deepestRound = r.round!;
    }
  }

  // A title trumps any run; otherwise the deepest World Cup round reached.
  final honours = await comp.honours(careerId);
  final wonWc = honours.any(
    (h) =>
        h.competition == 'World Championship' &&
        h.championId == nationId &&
        h.year >= CareerService.cycleStart.year,
  );
  final l = ref.watch(appLocalizationsProvider);
  final bestFinish = wonWc
      ? l.tourCupWorldChampionsTitle
      : deepestRound.isEmpty
      ? l.recordsNoFinalsYet
      : _wcFinishLabel(l, deepestRound);

  return (
    nationName: nations[nationId]?.name ?? 'Your nation',
    mostCaps: mostCaps,
    topScorers: topScorers,
    topAssists: topAssists,
    biggestWin: biggestWin,
    longestUnbeaten: longestUnbeaten,
    bestFinish: bestFinish,
    nations: nations,
  );
});
