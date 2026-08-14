import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/awards/awards.dart';
import 'package:fnm/features/career/career_providers.dart';

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
    // Only years that have finished: an award handed out in June would be
    // handed to whoever happened to have played by then.
    final year = career.inGameDate.year - 1;
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
        title: 'World Player of the Year $year',
        body:
            '${best.name} is the best player in the world this year.'
            '${young == null || young.playerId == best.playerId ? '' : ' '
                      '${young.name} takes the young player\'s award.'}',
        year: year,
      );
    }
    _ref.invalidate(playerAwardsProvider);
  }
}

final Provider<AwardService> awardServiceProvider = Provider(AwardService.new);
