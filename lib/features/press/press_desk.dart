import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The press's side of the season: after the manager's matches are in, judge
/// what he said and decide whether the room is called. Idempotent, and called
/// from both ways a match of his is committed (the live screen and the
/// quick-sim inside `advance`).
class PressDesk {
  PressDesk(this._ref);

  final Ref _ref;

  /// An unheld conference older than this is no longer news.
  static const int staleDays = 14;

  Future<void> afterMatches(int careerId) async {
    final careers = _ref.read(careerRepositoryProvider);
    final comp = _ref.read(competitionRepositoryProvider);
    final career = await careers.byId(careerId);
    if (career == null) return;
    final now = career.inGameDate;

    final all = await comp.fixturesForNation(careerId, career.nationId);
    final own = [
      for (final f in all)
        if (f.hasResult) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final competitive = [
      for (final f in own)
        if (f.round != Rounds.friendly) f,
    ];
    int mine(Fixture f) =>
        f.homeNationId == career.nationId ? f.homeScore! : f.awayScore!;
    int theirs(Fixture f) =>
        f.homeNationId == career.nationId ? f.awayScore! : f.homeScore!;

    // 1. Judge.
    var jobJustBroken = false;
    for (final s in await careers.statements(careerId)) {
      if (s.status != StatementStatus.open) continue;
      final apps = s.playerId == null
          ? const <Appearance>[]
          : [
              for (final h in await comp.playerMatchHistory(
                careerId,
                s.playerId!,
                limit: 30,
              ))
                (fixtureId: h.fixtureId, date: h.date, rating: h.rating),
            ];
      final v = StatementJudge.judge(
        s,
        matches: [
          for (final f in competitive)
            (
              fixtureId: f.id,
              date: f.date,
              scored: mine(f),
              conceded: theirs(f),
            ),
        ],
        appearances: apps,
        currentNationId: career.nationId,
        currentCycle: career.cyclePointer,
      );
      if (v == null) continue;
      await careers.judgeStatement(s.id, status: v.status, judgedOn: now);
      if (v.effect.morale != 0 || v.effect.board != 0) {
        await careers.recordPressAnswer(
          careerId: careerId,
          cycle: career.cyclePointer,
          questionKey: 'stmt:${s.id}',
          tone: v.status.name,
          moraleDelta: v.effect.morale,
          boardDelta: v.effect.board,
          answeredAt: now,
        );
      }
      if (s.kind == StatementKind.jobOnTheLine &&
          v.status == StatementStatus.broken) {
        jobJustBroken = true;
      }
    }

    // 2. Retire stale invitations.
    final calls = await careers.conferences(careerId);
    for (final c in calls) {
      if (c.status == ConferenceStatus.pending &&
          (c.cycle != career.cyclePointer ||
              now.difference(c.triggeredOn).inDays > staleDays)) {
        await careers.setConferenceStatus(c.id, ConferenceStatus.skipped);
      }
    }

    // 3. Call the room, at most once per match.
    if (competitive.isEmpty) return;
    final latest = competitive.last;
    if (calls.any((c) => c.fixtureId == latest.id)) return;
    final ranking = await _ref.read(worldRankingProvider(careerId).future);
    int rankOf(int id) => ranking?.position[id] ?? 100;
    final played = [
      for (final f in competitive)
        (
          fixtureId: f.id,
          date: f.date,
          scored: mine(f),
          conceded: theirs(f),
          knockout: Rounds.isKnockout(f.round),
          // The group's last game for him: nothing of his left to play in it.
          lastGroupMatch:
              f.groupId != null &&
              !all.any(
                (o) =>
                    o.competitionId == f.competitionId &&
                    o.groupId == f.groupId &&
                    o.matchday > f.matchday,
              ),
          standing: Expectation.standing(
            nationRank: rankOf(career.nationId),
            opponentRank: rankOf(
              f.homeNationId == career.nationId
                  ? f.awayNationId
                  : f.homeNationId,
            ),
            scored: mine(f),
            conceded: theirs(f),
          ),
        ),
    ];
    _ref.invalidate(pressEffectProvider(careerId));
    final board = await _ref.read(satisfactionProvider(careerId).future);
    final thisCycle = [
      for (final c in calls)
        if (c.cycle == career.cyclePointer) c,
    ];
    final reason = ConferenceTrigger.reasonFor(
      played: played,
      board: board,
      jobJustBroken: jobJustBroken,
      conferencesThisCycle: thisCycle.length,
      lastConference: calls.isEmpty ? null : calls.last.triggeredOn,
    );
    if (reason == null) return;
    for (final c in calls) {
      if (c.status == ConferenceStatus.pending) {
        await careers.setConferenceStatus(c.id, ConferenceStatus.skipped);
      }
    }
    await careers.recordConference(
      careerId: careerId,
      cycle: career.cyclePointer,
      reason: reason,
      fixtureId: latest.id,
      triggeredOn: latest.date,
    );
  }
}

final Provider<PressDesk> pressDeskProvider = Provider<PressDesk>(
  PressDesk.new,
);
