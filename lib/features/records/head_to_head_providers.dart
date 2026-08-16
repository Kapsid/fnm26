import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/stats/nation_results.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';

/// The (career, nationA, nationB) key for a head-to-head query.
typedef H2HKey = ({int careerId, int nationA, int nationB});

/// The all-time head-to-head record between two nations, from A's viewpoint.
final AutoDisposeFutureProviderFamily<HeadToHead, H2HKey> headToHeadProvider =
    FutureProvider.autoDispose.family<HeadToHead, H2HKey>((ref, key) async {
      final comp = ref.watch(competitionRepositoryProvider);
      return comp.headToHead(key.careerId, key.nationA, key.nationB);
    });

/// One past meeting between two nations: when, in what competition, and the
/// score from side A's point of view.
///
/// A knockout tie that went past 90 minutes carries how it was settled:
/// [afterExtraTime] for an extra-time winner, and [penA]/[penB] for a shootout
/// — otherwise a 1–1 draw and a 1–1 (4–3 pens) semi-final read identically.
typedef H2HMeeting = ({
  DateTime date,
  String competition,
  int forA,
  int forB,
  bool afterExtraTime,
  int? penA,
  int? penB,
});

/// Every past meeting between the two nations in the key, newest first — the
/// full list behind the aggregate record (results, dates, competition).
final AutoDisposeFutureProviderFamily<List<H2HMeeting>, H2HKey>
h2hMeetingsProvider = FutureProvider.autoDispose
    .family<List<H2HMeeting>, H2HKey>((ref, key) async {
      final comp = ref.watch(competitionRepositoryProvider);
      final names = await comp.competitionNames(key.careerId);
      final fixtures = await comp.fixturesForNation(key.careerId, key.nationA);
      final meetings = <H2HMeeting>[];
      for (final f in fixtures) {
        if (!f.hasResult) continue;
        final isB =
            f.homeNationId == key.nationB || f.awayNationId == key.nationB;
        if (!isB) continue;
        final aHome = f.homeNationId == key.nationA;
        meetings.add((
          date: f.date,
          competition:
              names[f.competitionId] ??
              (f.round == 'FRIENDLY' ? 'Friendly' : 'Match'),
          forA: aHome ? f.homeScore! : f.awayScore!,
          forB: aHome ? f.awayScore! : f.homeScore!,
          afterExtraTime: f.afterExtraTime,
          penA: f.wentToShootout
              ? (aHome ? f.homePenalties : f.awayPenalties)
              : null,
          penB: f.wentToShootout
              ? (aHome ? f.awayPenalties : f.homePenalties)
              : null,
        ));
      }
      meetings.sort((a, b) => b.date.compareTo(a.date));
      return meetings;
    });

/// One opponent line in the manager's own head-to-head ledger.
typedef MyH2HLine = ({
  int opponentId,
  String opponentName,
  String opponentCode,
  int played,
  int wins,
  int draws,
  int losses,
  int goalsFor,
  int goalsAgainst,
});

/// The manager's current nation's head-to-head record against every opponent
/// it has ever faced in this save — most-played first. Built from the nation's
/// own fixtures, so it always reflects who you've actually met.
final AutoDisposeFutureProviderFamily<List<MyH2HLine>, int>
myHeadToHeadsProvider = FutureProvider.autoDispose.family<List<MyH2HLine>, int>(
  (ref, careerId) async {
    final career = await ref.watch(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final comp = ref.watch(competitionRepositoryProvider);
    final nationId = career.nationId;
    final nations = <int, Nation>{
      for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
    };

    // The same ledger the fiercest-rival card reads, so the two cannot
    // disagree about a pairing — see [nationResults].
    final ledger = opponentLedger(
      nationResults(
        await comp.fixturesForNation(careerId, nationId),
        nationId,
      ),
    );
    final acc = <int, MyH2HLine>{
      for (final r in ledger.values)
        r.opponentId: (
          opponentId: r.opponentId,
          opponentName: nations[r.opponentId]?.name ?? 'Unknown',
          opponentCode: nations[r.opponentId]?.code ?? '??',
          played: r.played,
          wins: r.wins,
          draws: r.draws,
          losses: r.losses,
          goalsFor: r.goalsFor,
          goalsAgainst: r.goalsAgainst,
        ),
    };
    final list = acc.values.toList()
      ..sort((a, b) {
        final byPlayed = b.played.compareTo(a.played);
        if (byPlayed != 0) return byPlayed;
        return a.opponentName.compareTo(b.opponentName);
      });
    return list;
  },
);
