import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/press/press_desk.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';

bool _counts(PressAnswerRow a) => !a.questionKey.startsWith('grv:');

final AutoDisposeFutureProviderFamily<List<PressStatement>, int>
pressStatementsProvider = FutureProvider.autoDispose
    .family<List<PressStatement>, int>(
      (ref, careerId) =>
          ref.watch(careerRepositoryProvider).statements(careerId),
    );

final AutoDisposeFutureProviderFamily<int, int> credibilityProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final statements = await ref.watch(
        pressStatementsProvider(careerId).future,
      );
      final answers = await ref
          .watch(careerRepositoryProvider)
          .pressAnswers(careerId);
      final deflects = answers
          .where(
            (a) =>
                a.questionKey.startsWith('conf:') &&
                a.tone == AnswerKind.deflect.name,
          )
          .length;
      return Credibility.of(statements, deflects: deflects);
    });

/// What the manager has said this cycle, plus half of last cycle's, as a
/// single nudge to the dressing room and to the board. Grievance rows
/// (`grv:`) are the squad's doing, not his words, and do not count.
final AutoDisposeFutureProviderFamily<PressEffect, int> pressEffectProvider =
    FutureProvider.autoDispose.family<PressEffect, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return (morale: 0, board: 0);
      PressEffect of(PressAnswerRow a) =>
          (morale: a.moraleDelta, board: a.boardDelta);
      final now = await repo.pressAnswers(careerId, cycle: career.cyclePointer);
      final before = career.cyclePointer == 0
          ? const <PressAnswerRow>[]
          : await repo.pressAnswers(careerId, cycle: career.cyclePointer - 1);
      return Press.carryOver(
        [
          for (final a in now)
            if (_counts(a)) of(a),
        ],
        [
          for (final a in before)
            if (_counts(a)) of(a),
        ],
      );
    });

/// A preview conference that is due: the campaign, and the fixture that
/// opens it.
typedef PreviewDue = ({PreviewCampaign campaign, Fixture fixture});

/// The preview conference due now, if any: the manager's next fixture opens a
/// campaign he is in (see [PreviewCampaign]), he has played none of that
/// campaign yet, and no preview has been opened for it.
///
/// Derived, never stored by the season: the row is written only when he
/// opens it (see [ConferenceService.openPreview]), and once the fixture is
/// played the preview is simply no longer due.
final AutoDisposeFutureProviderFamily<PreviewDue?, int> previewDueProvider =
    FutureProvider.autoDispose.family<PreviewDue?, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final comp = ref.watch(competitionRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return null;
      final fixtures = await comp.cycleFixturesForNation(
        careerId,
        career.nationId,
      );
      final unplayed =
          [
            for (final f in fixtures)
              if (!f.hasResult) f,
          ]..sort((a, b) {
            final byDate = a.date.compareTo(b.date);
            return byDate != 0 ? byDate : a.id.compareTo(b.id);
          });
      if (unplayed.isEmpty) return null;
      final next = unplayed.first;
      final campaign = PreviewCampaign.ofRound(next.round);
      if (campaign == null) return null;
      if (fixtures.any(
        (f) => f.hasResult && PreviewCampaign.ofRound(f.round) == campaign,
      )) {
        return null;
      }
      final calls = await repo.conferences(careerId);
      if (calls.any(
        (c) => c.reason == ConferenceReason.preview && c.fixtureId == next.id,
      )) {
        return null;
      }
      return (campaign: campaign, fixture: next);
    });

/// The tier of the board objective a preview [campaign] is judged against.
TournamentTier previewTier(PreviewCampaign campaign) =>
    campaign.isWorld ? TournamentTier.world : TournamentTier.continental;

/// What a preview conference about [campaign] is about: the board's brief, the
/// best-ranked other side in his group and his best called-up player.
Future<PreviewFacts> _previewFacts(
  Ref ref,
  int careerId,
  PreviewCampaign campaign,
) async {
  final career = (await ref.read(careerRepositoryProvider).byId(careerId))!;
  final comp = ref.read(competitionRepositoryProvider);
  final outcomes = await ref.watch(
    cycleObjectiveOutcomesProvider(careerId).future,
  );
  final tier = previewTier(campaign);
  final objective = outcomes.where((o) => o.tier == tier).firstOrNull;
  final brief = campaign.briefFor(objective?.target ?? 2);

  final nations = await ref.read(nationRepositoryProvider).all();
  final conf = nations
      .where((n) => n.id == career.nationId)
      .map((n) => n.confederation)
      .firstOrNull;
  final kind = switch (campaign) {
    PreviewCampaign.worldQualifying => CompetitionKind.worldCupQualifying,
    PreviewCampaign.continentalQualifying =>
      CompetitionKind.continentalQualifying,
    PreviewCampaign.worldFinals => CompetitionKind.worldCupFinals,
    PreviewCampaign.continentalFinals => CompetitionKind.continentalFinals,
  };
  final tables = await comp.tournamentGroupTables(
    careerId,
    kind,
    confederation: campaign == PreviewCampaign.worldFinals ? null : conf,
  );
  final group = tables
      .where((t) => t.standings.any((s) => s.nationId == career.nationId))
      .firstOrNull;
  final ranking = await ref.watch(worldRankingProvider(careerId).future);
  int rankOf(int id) => ranking?.position[id] ?? 999;
  final others = [
    for (final s in group?.standings ?? const <GroupStanding>[])
      if (s.nationId != career.nationId) s.nationId,
  ]..sort((a, b) => rankOf(a).compareTo(rankOf(b)));

  final called = await ref.read(squadRepositoryProvider).callUps(careerId);
  final squad = called.isEmpty
      ? const <Player>[]
      : await ref
            .read(playerRepositoryProvider)
            .byNation(
              career.nationId,
              agingYears: CareerService.agingYears(career),
              saveSeed: career.rngSeed,
              minAge: 15,
            );
  final picked = [
    for (final p in squad)
      if (called.contains(p.id)) p,
  ]..sort((a, b) => b.overall.compareTo(a.overall));

  return (
    campaign: campaign,
    brief: brief,
    rivalNationId: others.firstOrNull,
    keyPlayerId: picked.firstOrNull?.id,
  );
}

typedef PendingConference = ({
  PressConferenceRow row,
  ConferenceFacts facts,
  int credibility,
  int opponentNationId,
});

final AutoDisposeFutureProviderFamily<PendingConference?, int>
pendingConferenceProvider = FutureProvider.autoDispose
    .family<PendingConference?, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final comp = ref.watch(competitionRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return null;
      final calls = await repo.conferences(careerId);
      // Offered on the desk's own terms: a row it would retire as stale (an
      // earlier cycle, or news gone cold) is never put to the manager, even
      // before the next advance gets round to retiring it.
      final pending = calls.where(
        (c) =>
            c.status == ConferenceStatus.pending &&
            c.cycle == career.cyclePointer &&
            career.inGameDate.difference(c.triggeredOn).inDays <=
                PressDesk.staleDays,
      );
      if (pending.isEmpty) return null;
      final row = pending.last;
      // The last conference he actually faced before this one; only what was
      // judged since then is fresh enough to throw back.
      final previous = calls
          .where(
            (c) => c.id < row.id && c.status == ConferenceStatus.held,
          )
          .lastOrNull;
      final fixture = (await comp.fixturesForNation(
        careerId,
        career.nationId,
      )).where((f) => f.id == row.fixtureId).firstOrNull;
      if (fixture == null) return null;
      final opponent = fixture.homeNationId == career.nationId
          ? fixture.awayNationId
          : fixture.homeNationId;
      final statementsNow = await ref.watch(
        pressStatementsProvider(careerId).future,
      );
      final openNow = [
        for (final s in statementsNow)
          if (s.status == StatementStatus.open) s,
      ];
      // A preview is about the campaign ahead: no result to react to, and
      // nothing old to throw back.
      if (row.reason == ConferenceReason.preview) {
        final campaign = PreviewCampaign.ofRound(fixture.round);
        if (campaign == null || fixture.hasResult) return null;
        return (
          row: row,
          facts: (
            reason: row.reason,
            bestPlayerId: null,
            worstPlayerId: null,
            hasOpenWinNext: openNow.any(
              (s) => s.kind == StatementKind.winNext,
            ),
            hasOpenJob: openNow.any(
              (s) => s.kind == StatementKind.jobOnTheLine,
            ),
            playersWithOpenStatement: {
              for (final s in openNow)
                if (s.playerId != null) s.playerId!,
            },
            throwback: null,
            preview: await _previewFacts(ref, careerId, campaign),
          ),
          credibility: await ref.watch(credibilityProvider(careerId).future),
          opponentNationId: opponent,
        );
      }
      final lines = [
        for (final r in await comp.ratingsForFixture(careerId, fixture.id))
          if (r.nationId == career.nationId) r,
      ]..sort((a, b) => b.rating.compareTo(a.rating));
      final statements = await ref.watch(
        pressStatementsProvider(careerId).future,
      );
      final open = [
        for (final s in statements)
          if (s.status == StatementStatus.open) s,
      ];
      // His newest judged statement for the nation he leads now, since the
      // last conference he faced (or this cycle, if none). Anything older, or
      // said for another job, is simply never thrown back.
      final due =
          [
            for (final s in statements)
              if ((s.status == StatementStatus.kept ||
                      s.status == StatementStatus.broken) &&
                  !s.thrownBack &&
                  s.nationId == career.nationId &&
                  s.judgedOn != null &&
                  (previous == null
                      ? s.cycle == career.cyclePointer
                      : s.judgedOn!.isAfter(previous.triggeredOn)) &&
                  // The opening of a job-verdict conference IS that broken
                  // promise; asking it again as a throwback would be the same
                  // question twice.
                  !(row.reason == ConferenceReason.jobVerdict &&
                      s.kind == StatementKind.jobOnTheLine))
                s,
          ]..sort((a, b) {
            final byDate = a.judgedOn!.compareTo(b.judgedOn!);
            return byDate != 0 ? byDate : a.id.compareTo(b.id);
          });
      return (
        row: row,
        facts: (
          reason: row.reason,
          bestPlayerId: lines.isEmpty ? null : lines.first.playerId,
          worstPlayerId: lines.length < 2 ? null : lines.last.playerId,
          hasOpenWinNext: open.any((s) => s.kind == StatementKind.winNext),
          hasOpenJob: open.any((s) => s.kind == StatementKind.jobOnTheLine),
          playersWithOpenStatement: {
            for (final s in open)
              if (s.playerId != null) s.playerId!,
          },
          throwback: due.isEmpty ? null : due.last,
          preview: null,
        ),
        credibility: await ref.watch(credibilityProvider(careerId).future),
        opponentNationId: fixture.homeNationId == career.nationId
            ? fixture.awayNationId
            : fixture.homeNationId,
      );
    });

/// Records a conference's answers and statements and closes it.
class ConferenceService {
  ConferenceService(this._ref);
  final Ref _ref;

  Future<PressEffect> answer(
    int careerId,
    PendingConference c,
    int beatIndex,
    Beat beat,
    AnswerKind a,
  ) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = (await repo.byId(careerId))!;
    // Idempotent: a beat already answered (the sheet was reopened) records
    // nothing a second time.
    final key = 'conf:${c.row.id}:$beatIndex';
    for (final row in await repo.pressAnswers(careerId)) {
      if (row.questionKey == key) {
        return (morale: row.moraleDelta, board: row.boardDelta);
      }
    }
    final effect = ConferenceBuilder.effectOf(a, c.credibility);
    await repo.recordPressAnswer(
      careerId: careerId,
      cycle: career.cyclePointer,
      questionKey: key,
      tone: a.name,
      moraleDelta: effect.morale,
      boardDelta: effect.board,
      answeredAt: career.inGameDate,
    );
    final kind = ConferenceBuilder.statementOf(a);
    final preview = c.facts.preview;
    final stated = preview == null
        ? null
        : ConferenceBuilder.statedTarget(a, preview);
    // A target needs a campaign to be judged against; outside a preview there
    // is none, so nothing goes on the record.
    if (kind != null && (kind != StatementKind.target || stated != null)) {
      await repo.recordStatement(
        careerId: careerId,
        cycle: career.cyclePointer,
        nationId: career.nationId,
        kind: kind,
        playerId: beat.playerId,
        madeOn: c.row.triggeredOn,
        madeAfterFixtureId: c.row.fixtureId,
        target: stated,
      );
    }
    if (beat.kind == BeatKind.throwback && c.facts.throwback != null) {
      await repo.markThrownBack(c.facts.throwback!.id);
    }
    // A statement on the record shifts a named player's condition.
    _ref
      ..invalidate(pressStatementsProvider(careerId))
      ..invalidate(squadConditionProvider(careerId));
    return effect;
  }

  /// Writes the row for a preview that is [due], the moment he opens it, so
  /// the sheet runs against a conference like any other. Returns its id.
  Future<int> openPreview(int careerId, PreviewDue due) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = (await repo.byId(careerId))!;
    final existing = (await repo.conferences(careerId)).where(
      (c) =>
          c.reason == ConferenceReason.preview && c.fixtureId == due.fixture.id,
    );
    final id = existing.isNotEmpty
        ? existing.first.id
        : await repo.recordConference(
            careerId: careerId,
            cycle: career.cyclePointer,
            reason: ConferenceReason.preview,
            fixtureId: due.fixture.id,
            triggeredOn: career.inGameDate,
          );
    _ref
      ..invalidate(previewDueProvider(careerId))
      ..invalidate(pendingConferenceProvider(careerId));
    return id;
  }

  Future<void> finish(int careerId, int conferenceId) async {
    final repo = _ref.read(careerRepositoryProvider);
    final held = (await repo.conferences(
      careerId,
    )).where((c) => c.id == conferenceId).firstOrNull;
    // A job-verdict conference opens on the broken job promise itself, so it
    // is spent: no later conference may throw it back a second time.
    if (held?.reason == ConferenceReason.jobVerdict) {
      for (final s in await repo.statements(careerId)) {
        if (s.kind == StatementKind.jobOnTheLine &&
            (s.status == StatementStatus.broken ||
                s.status == StatementStatus.kept) &&
            !s.thrownBack) {
          await repo.markThrownBack(s.id);
        }
      }
    }
    await repo.setConferenceStatus(conferenceId, ConferenceStatus.held);
    _ref
      ..invalidate(pendingConferenceProvider(careerId))
      ..invalidate(previewDueProvider(careerId))
      ..invalidate(pressStatementsProvider(careerId))
      ..invalidate(credibilityProvider(careerId))
      ..invalidate(pressEffectProvider(careerId))
      ..invalidate(squadConditionProvider(careerId));
  }
}

final Provider<ConferenceService> conferenceServiceProvider =
    Provider<ConferenceService>(ConferenceService.new);
