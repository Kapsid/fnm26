import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/awards/award_providers.dart' show potyYearOn;
import 'package:fnm/features/awards/poty_history.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/messages/poty_card.dart';

/// A player looked up in today's pool, for a year whose message does not
/// name him: his name and position, and his age today.
typedef PotyPoolProfile = ({String name, PlayerPosition position, int ageNow});

/// The voted years, from the stored honours and the yearly vote messages.
///
/// The honours are the record (every year, old saves too); the vote message
/// adds the top five (version 2) or at least the winners' names and ages
/// (version 1). A year with a winner nobody names is filled from [pool]
/// (keyed by player id, ages as of [nowYear]); still unnamed, its name stays
/// null and the screen says so.
List<PotyHistoryYear> assemblePotyYears({
  required List<PlayerAward> honours,
  required List<MessageItem> messages,
  required Map<int, String> nationCodes,
  Map<int, PotyPoolProfile> pool = const {},
  int? nowYear,
}) {
  final best = <int, PlayerAward>{};
  final young = <int, PlayerAward>{};
  for (final h in honours) {
    if (h.kind == AwardKind.playerOfYear) best[h.year] = h;
    if (h.kind == AwardKind.youngPlayerOfYear) young[h.year] = h;
  }
  final votes = <int, PotyVote>{};
  final reports = <int, List<PotyRow>>{};
  for (final m in messages) {
    if (m.category != 'award') continue;
    if (decodePotyVote(m.body) case final v?) {
      votes[m.year] ??= v;
    } else if (decodePotyReport(m.body) case final r?) {
      reports[m.year] ??= r;
    }
  }

  String code(int nationId) => nationCodes[nationId]?.toLowerCase() ?? '';

  PotyHistoryPlayer fromPlace(PotyPlace p) => (
    playerId: p.playerId,
    nationId: p.nationId,
    name: p.name,
    nationCode: p.nationCode.isNotEmpty ? p.nationCode : code(p.nationId),
    position: p.position,
    age: p.age,
  );

  PotyHistoryPlayer fromHonour(
    PlayerAward h,
    List<PotyPlace> places, {
    required bool isYoung,
    required int year,
  }) {
    for (final p in places) {
      if (p.playerId == h.playerId) return fromPlace(p);
    }
    // An older body: the two winners by name, matched on the nation.
    final row = reports[year]
        ?.where(
          (r) =>
              r.young == isYoung &&
              r.nationCode.toLowerCase() == code(h.nationId),
        )
        .firstOrNull;
    final found = pool[h.playerId];
    final ageFromPool = found == null || nowYear == null
        ? null
        : found.ageNow - (nowYear - year);
    return (
      playerId: h.playerId,
      nationId: h.nationId,
      name: row?.name ?? found?.name,
      nationCode: code(h.nationId),
      position: found?.position,
      age: row?.age ?? ageFromPool,
    );
  }

  PotyHistoryPlayer? firstOf(List<PotyPlace>? places) =>
      places == null || places.isEmpty ? null : fromPlace(places.first);

  final years = <int>{...best.keys, ...young.keys, ...votes.keys};
  return [
    for (final year in years.toList()..sort((a, b) => b.compareTo(a)))
      () {
        final vote = votes[year];
        final b = best[year];
        final y = young[year];
        return (
          year: year,
          best: b != null
              ? fromHonour(
                  b,
                  vote?.best ?? const [],
                  isYoung: false,
                  year: year,
                )
              : firstOf(vote?.best),
          young: y != null
              ? fromHonour(
                  y,
                  vote?.young ?? const [],
                  isYoung: true,
                  year: year,
                )
              : firstOf(vote?.young),
          topFive: [
            for (final p in vote?.best ?? const <PotyPlace>[])
              (rank: p.rank, player: fromPlace(p)),
          ],
        );
      }(),
  ];
}

/// The career's Player of the Year history, for the My Career block and its
/// screen. Read on open (auto-dispose), so a year voted since shows next
/// time.
final AutoDisposeFutureProviderFamily<PotyHistory?, int> potyHistoryProvider =
    FutureProvider.autoDispose.family<PotyHistory?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      final codes = {for (final n in nations) n.id: n.code};
      final honours = <PlayerAward>[];
      final last = potyYearOn(career.inGameDate);
      for (var year = CareerService.cycleStart.year; year <= last; year++) {
        honours.addAll(await comp.playerHonoursForYear(careerId, year));
      }
      final messages = await comp.messages(careerId);
      var years = assemblePotyYears(
        honours: honours,
        messages: messages,
        nationCodes: codes,
      );
      // A year filed before its message named anybody: look the winners up
      // in their nation's pool (retired men included), once per nation.
      final missing = <int, Set<int>>{};
      for (final y in years) {
        for (final p in [y.best, y.young]) {
          if (p != null && p.name == null) {
            (missing[p.nationId] ??= {}).add(p.playerId);
          }
        }
      }
      if (missing.isNotEmpty) {
        final pool = <int, PotyPoolProfile>{};
        for (final e in missing.entries) {
          for (final p in await careerPoolOf(
            ref,
            career,
            e.key,
            includeIntlRetired: true,
          )) {
            if (e.value.contains(p.id)) {
              pool[p.id] = (name: p.name, position: p.position, ageNow: p.age);
            }
          }
        }
        years = assemblePotyYears(
          honours: honours,
          messages: messages,
          nationCodes: codes,
          pool: pool,
          nowYear: career.inGameDate.year,
        );
      }
      return PotyHistory.build(years, ownNationId: career.nationId);
    });
