import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// One leaderboard entry (a player and their tally).
typedef RecordLeader = ({int playerId, String name, int value});

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

/// The deepest World Cup finals round reached maps to a "best finish" label.
const _wcFinishLabel = {
  'FINAL': 'World Cup Final',
  '3RD': 'World Cup Semi-final',
  'SF': 'World Cup Semi-final',
  'QF': 'World Cup Quarter-final',
  'R16': 'World Cup Round of 16',
  'R32': 'World Cup Round of 32',
  'GROUP': 'World Cup Group Stage',
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

final AutoDisposeFutureProviderFamily<RecordBook?, int> recordBookProvider =
    FutureProvider.autoDispose.family<RecordBook?, int>((ref, careerId) async {
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

  final nameCache = <int, String>{};
  Future<String> nameOf(int id) async {
    if (nameCache.containsKey(id)) return nameCache[id]!;
    final p = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    return nameCache[id] = p?.name ?? 'Unknown';
  }

  final capsRaw = await comp.nationTopAppearances(careerId, nationId, limit: 5);
  final scorersRaw = await comp.nationTopScorers(careerId, nationId, limit: 5);
  final assistsRaw = await comp.nationTopAssists(careerId, nationId, limit: 5);

  final mostCaps = <RecordLeader>[
    for (final c in capsRaw)
      (playerId: c.playerId, name: await nameOf(c.playerId), value: c.games),
  ];
  final topScorers = <RecordLeader>[
    for (final s in scorersRaw)
      (playerId: s.playerId, name: await nameOf(s.playerId), value: s.goals),
  ];
  final topAssists = <RecordLeader>[
    for (final a in assistsRaw)
      (playerId: a.playerId, name: await nameOf(a.playerId), value: a.assists),
  ];

  // Biggest win, longest unbeaten run, and deepest World Cup run — over every
  // competitive result the nation has ever posted.
  final fixtures = (await comp.fixturesForNation(careerId, nationId))
      .where((f) => f.hasResult)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  ({int oppId, int gf, int ga})? biggestWin;
  var bestMargin = 0;
  var unbeaten = 0;
  var longestUnbeaten = 0;
  var deepestRank = 0;
  var deepestRound = '';
  for (final f in fixtures) {
    final home = f.homeNationId == nationId;
    final gf = home ? f.homeScore! : f.awayScore!;
    final ga = home ? f.awayScore! : f.homeScore!;
    final oppId = home ? f.awayNationId : f.homeNationId;
    if (gf > ga && gf - ga > bestMargin) {
      bestMargin = gf - ga;
      biggestWin = (oppId: oppId, gf: gf, ga: ga);
    }
    if (gf >= ga) {
      unbeaten++;
      if (unbeaten > longestUnbeaten) longestUnbeaten = unbeaten;
    } else {
      unbeaten = 0;
    }
    final rank = _wcFinishRank[f.round] ?? 0;
    if (rank > deepestRank) {
      deepestRank = rank;
      deepestRound = f.round!;
    }
  }

  // A title trumps any run; otherwise the deepest World Cup round reached.
  final honours = await comp.honours(careerId);
  final wonWc = honours.any(
    (h) => h.competition == 'World Championship' &&
        h.championId == nationId &&
        h.year >= CareerService.cycleStart.year,
  );
  final bestFinish = wonWc
      ? 'World Champions'
      : deepestRound.isEmpty
          ? 'No finals appearance yet'
          : _wcFinishLabel[deepestRound] ?? 'World Cup Finals';

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
