import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/statement.dart';
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
      final pending = calls.where((c) => c.status == ConferenceStatus.pending);
      if (pending.isEmpty) return null;
      final row = pending.last;
      final fixture = (await comp.fixturesForNation(
        careerId,
        career.nationId,
      )).where((f) => f.id == row.fixtureId).firstOrNull;
      if (fixture == null) return null;
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
      final due = [
        for (final s in statements)
          if ((s.status == StatementStatus.kept ||
                  s.status == StatementStatus.broken) &&
              !s.thrownBack &&
              // The opening of a job-verdict conference IS that broken
              // promise; asking it again as a throwback would be the same
              // question twice.
              !(row.reason == ConferenceReason.jobVerdict &&
                  s.kind == StatementKind.jobOnTheLine))
            s,
      ];
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
          throwback: due.isEmpty ? null : due.first,
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
    if (kind != null) {
      await repo.recordStatement(
        careerId: careerId,
        cycle: career.cyclePointer,
        nationId: career.nationId,
        kind: kind,
        playerId: beat.playerId,
        madeOn: c.row.triggeredOn,
        madeAfterFixtureId: c.row.fixtureId,
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
      ..invalidate(pressStatementsProvider(careerId))
      ..invalidate(credibilityProvider(careerId))
      ..invalidate(pressEffectProvider(careerId))
      ..invalidate(squadConditionProvider(careerId));
  }
}

final Provider<ConferenceService> conferenceServiceProvider =
    Provider<ConferenceService>(ConferenceService.new);
