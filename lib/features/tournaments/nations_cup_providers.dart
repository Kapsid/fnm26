import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

/// Everything a Nations Cup screen shows: whose cup, its format, the manager's
/// league and group, the tables, the finals rounds, the honours and the
/// scorers.
typedef NationsCupData = ({
  /// Whose cup this is, and whether it is the manager's own (the one with a
  /// draw ceremony, a league or zone of his, and his name in it).
  Confederation confederation,
  String cupName,
  NationsCupFormat format,
  bool isMine,
  String playerLeague,
  String? playerGroup,
  List<FinalsGroupTable> groups,
  List<Fixture> roundOf16,
  List<Fixture> quarters,
  List<Fixture> semis,
  List<Fixture> finalFx,
  List<Honour> honours,
  List<ScorerTally> scorers,
  Map<int, String> playerNames,
  bool drawWatched,
  int playerNationId,

  /// The nations the manager has led, current and past: their scorers are
  /// highlighted.
  Set<int> myNationIds,
  Map<int, Nation> nations,

  /// The lowest league in the cup's confederation — its bottom sides have
  /// nowhere to fall, so they aren't shown as relegated.
  int maxTier,
});

/// Which cup: `confederation`'s, or (null) the manager's own, Europe's for a
/// manager whose confederation has none.
typedef NationsCupKey = ({int careerId, Confederation? confederation});

final AutoDisposeFutureProviderFamily<NationsCupData?, NationsCupKey>
nationsCupProvider = FutureProvider.autoDispose.family<NationsCupData?, NationsCupKey>((
  ref,
  key,
) async {
  final careerId = key.careerId;
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final mine = NationsCups.ofManager(nations[career.nationId]?.confederation);
  final conf = key.confederation ?? mine ?? Confederation.europe;
  final cup = NationsCups.forConfederation(conf);
  if (cup == null) return null;
  final isMine = conf == mine;
  // Every lookup names the cup: all three live in the cycle as competitions
  // of the same kind.
  final groups =
      await comp.tournamentGroupTables(
          careerId,
          CompetitionKind.nationsLeague,
          confederation: conf,
        )
        ..sort((a, b) => a.name.compareTo(b.name));
  final tiers = await ref
      .watch(careerRepositoryProvider)
      .nationsCupTiers(careerId);
  // The group the manager's nation plays in (for "my group first").
  String? playerGroup;
  for (final g in groups) {
    if (g.standings.any((s) => s.nationId == career.nationId)) {
      playerGroup = g.name;
      break;
    }
  }
  // His league is the one his group is drawn in ('B3' -> 'B'); the stored
  // ladder only stands in before the draw. A save seeded before CONCACAF's
  // remainder was folded into League B stores its last three as League C.
  final playerLeague = !isMine
      ? 'A'
      : (playerGroup != null && playerGroup.isNotEmpty)
      ? playerGroup[0]
      : NationsCup.leagueLetter(tiers[career.nationId] ?? 0);
  final honours = [
    for (final h in await comp.honours(careerId))
      if (h.competition == cup.name) h,
  ]..sort((a, b) => b.year.compareTo(a.year));
  Future<List<Fixture>> round(String r) => comp.fixturesByRound(
    careerId,
    r,
    kind: CompetitionKind.nationsLeague,
    confederation: conf,
  );
  // The finals: a ladder cup's Finals Four (League A's group winners contest
  // two semis then a final), or Africa's knockouts, which open with a Round
  // of 16.
  final roundOf16 = await round('NR16');
  final quarters = await round('NQF');
  final semis = await round('NSF');
  final finalFx = await round('NFINAL');
  // Only the manager's own cup is drawn at a ceremony; the others are there to
  // browse from the start.
  final drawWatched =
      !isMine ||
      await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        nationsCupDrawKind,
      );
  final maxTier = NationsCup.lowestTier(
    tiers: tiers,
    confederation: conf,
    confederationOf: (id) => nations[id]?.confederation,
  );

  // The cup's scorer chart — the goals were always recorded, nothing ever read
  // them back for this competition.
  final scorers = await comp.topScorers(
    careerId,
    kind: CompetitionKind.nationsLeague,
    confederation: conf,
    limit: 15,
  );
  final playerRepo = ref.watch(playerRepositoryProvider);
  // A generated player is reconstructed from his id rather than read from a
  // row, and the reconstruction only reaches an intake year that has already
  // happened — so the lookup has to say which year of the save it is asking
  // about, or every newgen scorer comes back null and prints as "Unknown".
  //
  // The year and the seed are all a NAME needs. The two development maps
  // (youth-academy bonuses, career starts) only shift attribute magnitudes,
  // and the career-starts one is an appearance-table scan across the whole
  // save — a real cost for a chart that reads nothing but `p.name`.
  final playerNames = <int, String>{};
  for (final id in {for (final s in scorers) s.playerId}) {
    final p = await playerRepo.byId(
      id,
      agingYears: CareerService.agingYears(career),
      saveSeed: career.rngSeed,
    );
    if (p != null) playerNames[id] = p.name;
  }

  return (
    confederation: conf,
    cupName: cup.name,
    format: cup.format,
    isMine: isMine,
    playerLeague: playerLeague,
    playerGroup: playerGroup,
    groups: groups,
    roundOf16: roundOf16,
    quarters: quarters,
    semis: semis,
    finalFx: finalFx,
    honours: honours,
    scorers: scorers,
    playerNames: playerNames,
    drawWatched: drawWatched,
    playerNationId: career.nationId,
    myNationIds: {
      career.nationId,
      ...(await ref.watch(careerRepositoryProvider).stints(careerId)).values,
    },
    nations: nations,
    maxTier: maxTier,
  );
});
