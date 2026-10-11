import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
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

    // 1. Judge. A target is judged against the board's own grading of its
    // campaign, which the match just changed and which no provider here would
    // notice, so it is read fresh.
    _ref
      ..invalidate(cycleObjectiveOutcomesProvider(careerId))
      ..invalidate(cycleObjectivesProvider(careerId));
    final statements = await careers.statements(careerId);
    final outcomes =
        statements.any(
          (s) =>
              s.kind == StatementKind.target &&
              s.status == StatementStatus.open,
        )
        ? await _ref.read(cycleObjectiveOutcomesProvider(careerId).future)
        : const <ObjectiveOutcome>[];
    TargetOutcome? targetOutcome(PressStatement s) {
      if (s.kind != StatementKind.target) return null;
      final opener = all.where((f) => f.id == s.madeAfterFixtureId).firstOrNull;
      final campaign = PreviewCampaign.ofRound(opener?.round);
      if (opener == null || campaign == null) return null;
      final o = outcomes
          .where((o) => o.tier == previewTier(campaign))
          .firstOrNull;
      if (o == null) return null;
      // Qualifying is settled the moment the side is in the finals draw (or
      // the verdict says it is not), and judged on getting there at all.
      final brief = campaign.briefFor(o.target);
      return campaign.isQualifying
          ? (
              brief: brief,
              actual: o.actual.clamp(0, 2),
              settled: o.actual >= 2 || o.decided,
            )
          : (brief: brief, actual: o.actual, settled: o.decided);
    }

    var jobJustBroken = false;
    for (final s in statements) {
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
        target: targetOutcome(s),
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

    // 2. Retire stale invitations, and a preview left open once the match it
    // was the preview of has been played.
    final allCalls = await careers.conferences(careerId);
    for (final c in allCalls) {
      if (c.status == ConferenceStatus.pending &&
          (c.cycle != career.cyclePointer ||
              now.difference(c.triggeredOn).inDays > staleDays ||
              (c.reason == ConferenceReason.preview &&
                  own.any((f) => f.id == c.fixtureId)))) {
        await careers.setConferenceStatus(c.id, ConferenceStatus.skipped);
      }
    }
    // Previews keep their own calendar: they neither count toward the cap and
    // the quiet below, nor stand in for the match they came before.
    final calls = [
      for (final c in allCalls)
        if (c.reason != ConferenceReason.preview) c,
    ];

    // 3. Call the room, at most once per match. Only this cycle's matches of
    // the nation he leads now are news: the all-time list would offer last
    // cycle's final game (or, after a move, his new nation's games before he
    // took over) to a ceiling the rollover has just reset.
    final cycleAll = await comp.cycleFixturesForNation(
      careerId,
      career.nationId,
    );
    final recent = [
      for (final f in cycleAll)
        if (f.hasResult && f.round != Rounds.friendly) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    if (recent.isEmpty) return;
    final latest = recent.last;
    if (calls.any((c) => c.fixtureId == latest.id)) return;
    // A match is called now or never: the desk would skip it as stale anyway.
    if (now.difference(latest.date).inDays > staleDays) return;
    final ranking = await _ref.read(worldRankingProvider(careerId).future);
    int rankOf(int id) => ranking?.position[id] ?? 100;
    final played = [
      for (final f in recent)
        (
          fixtureId: f.id,
          date: f.date,
          scored: mine(f),
          conceded: theirs(f),
          knockout: Rounds.isKnockout(f.round),
          // The group's last game for him: nothing of his left to play in it.
          lastGroupMatch:
              f.groupId != null &&
              !cycleAll.any(
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
    // The board's mood is derived from objectives and form the match just
    // changed, through providers that do not notice a write; a live hub keeps
    // them alive, so refresh them by hand (as SeasonService does) or the
    // crisis check reads the board as it stood before the match.
    _ref
      ..invalidate(cycleObjectiveOutcomesProvider(careerId))
      ..invalidate(cycleObjectivesProvider(careerId))
      ..invalidate(pressEffectProvider(careerId))
      ..invalidate(satisfactionProvider(careerId));
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
    for (final c in allCalls) {
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
