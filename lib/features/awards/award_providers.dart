import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/awards/awards.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/features/settings/settings_providers.dart';

/// A player's trophy cabinet, newest first.
typedef AwardArg = ({int careerId, int playerId});

final AutoDisposeFutureProviderFamily<List<PlayerAward>, AwardArg>
playerAwardsProvider = FutureProvider.autoDispose
    .family<List<PlayerAward>, AwardArg>(
      (
        ref,
        arg,
      ) => ref
          .watch(competitionRepositoryProvider)
          .playerHonours(arg.careerId, arg.playerId),
    );

/// Hands out the trophies a finished year has earned.
///
/// One place, run on every advance and idempotent by the table's own primary
/// key, rather than a hook on each settling path — an award handed out twice is
/// a bug nobody notices until a cabinet reads wrong years later.
class AwardService {
  AwardService(this._ref);

  final Ref _ref;

  /// How many of a year's best are looked up by name and age. Ages decide the
  /// young award, and resolving every player in the world would mean building
  /// two hundred squads; the winner is never outside the leading few dozen.
  static const int _shortlist = 60;

  Future<void> settleYear(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final l = _ref.read(appLocalizationsProvider);
    // Only years whose FOOTBALL has finished: an award handed out in June would
    // be handed to whoever happened to have played by then. That moment is 1
    // December — the gap between the November qualifying window and January's
    // African and Asian finals, and the same date the squads re-rate on (see
    // [CareerService.developmentMonth]).
    //
    // It used to wait for the calendar to roll over instead, which put the
    // trophy in the inbox in the NEW year: at a cycle boundary that meant
    // "Player of the Year 2029" arriving as the first thing a manager read in
    // 2030, alongside the new cycle, months after the season it was for.
    final date = career.inGameDate;
    final year = date.month >= CareerService.developmentMonth
        ? date.year
        : date.year - 1;
    if (year < CareerService.cycleStart.year) return;
    final existing = await comp.messageKeys(careerId);
    if (existing.contains('poty:$year')) return;

    final lines = await comp.awardLinesForYear(careerId, year);
    if (lines.isEmpty) return;

    // Fill in who the leading candidates actually are.
    final ranked = [...lines]
      ..sort((a, b) => Awards.score(b).compareTo(Awards.score(a)));
    final shortlist = ranked.take(_shortlist).toList();
    final byNation = <int, List<AwardLine>>{};
    for (final l in shortlist) {
      (byNation[l.nationId] ??= []).add(l);
    }
    final repo = _ref.read(playerRepositoryProvider);
    final resolved = <AwardLine>[];
    for (final entry in byNation.entries) {
      final pool = await repo.byNation(
        entry.key,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
      );
      final byId = {for (final p in pool) p.id: p};
      for (final l in entry.value) {
        final p = byId[l.playerId];
        if (p == null) continue;
        resolved.add((
          playerId: l.playerId,
          nationId: l.nationId,
          name: p.name,
          age: p.age,
          apps: l.apps,
          goals: l.goals,
          assists: l.assists,
          meanRating: l.meanRating,
          motms: l.motms,
        ));
      }
    }
    if (resolved.isEmpty) return;

    final best = Awards.playerOfYear(resolved);
    final young = Awards.youngPlayerOfYear(resolved);
    for (final w in [best, young]) {
      if (w == null) continue;
      await comp.recordPlayerHonour(
        careerId: careerId,
        playerId: w.playerId,
        nationId: w.nationId,
        kind: w.kind,
        year: year,
      );
    }
    if (best != null) {
      await comp.addMessage(
        careerId: careerId,
        dedupKey: 'poty:$year',
        category: 'award',
        title: l.newsPotyTitle(year),
        body: await _body(
          careerId: careerId,
          career: career,
          best: best,
          young: young,
          lines: {for (final r in resolved) r.playerId: r},
          fallback:
              l.newsPotyBody(best.name) +
              (young == null || young.playerId == best.playerId
                  ? ''
                  : l.newsPotyYoungSuffix(young.name)),
        ),
        year: year,
      );
    }
    _ref.invalidate(playerAwardsProvider);
  }

  /// The award's message body: a card per winner, or the old sentence if the
  /// winners cannot be resolved.
  ///
  /// The announcement used to be that sentence and nothing else — a name, and
  /// not one word about the season that earned it or the man who played it.
  /// What goes in the body now is [encodePotyReport], so the popup can show
  /// his flag, his year and his rating (see [PotyCard]).
  ///
  /// The rating is why this resolves each winner AGAIN, by id, rather than
  /// reading the pool the shortlist was built from: a rating is only right
  /// with all four of the repository's inputs, and the pool above is read with
  /// two of them. A name is the same either way; a number is not.
  Future<String> _body({
    required int careerId,
    required Career career,
    required AwardWinner best,
    required AwardWinner? young,
    required Map<int, AwardLine> lines,
    required String fallback,
  }) async {
    final repo = _ref.read(playerRepositoryProvider);
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    final youth = await _ref.read(
      youthBonusByCycleProvider(careerId).future,
    );
    final careerDev = await _ref.read(
      careerDevBonusProvider(careerId).future,
    );
    final rows = <PotyRow>[];
    for (final w in [best, if (young?.playerId != best.playerId) young]) {
      if (w == null) continue;
      final line = lines[w.playerId];
      if (line == null) continue;
      final player = await repo.byId(
        w.playerId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        youthBonusByCycle: youth,
        careerStartsByPlayer: careerDev,
      );
      if (player == null) continue;
      final nation = nations[w.nationId];
      rows.add((
        young: w.kind == AwardKind.youngPlayerOfYear,
        name: player.name,
        nationCode: nation?.code.toLowerCase() ?? '',
        nationName: nation?.name ?? '',
        age: player.age,
        overall: player.overall,
        apps: line.apps,
        goals: line.goals,
        assists: line.assists,
        meanRating: line.meanRating,
        motms: line.motms,
      ));
    }
    // Nothing resolved: say it the way it was always said rather than file an
    // empty card. A body that renders as a blank popup is worse than a name.
    if (rows.isEmpty) return fallback;
    return encodePotyReport(rows);
  }
}

final Provider<AwardService> awardServiceProvider = Provider(AwardService.new);
