import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/pump_app.dart';

class _FakeService implements ConferenceService {
  _FakeService({this.failFinish = false});
  final bool failFinish;
  final answers = <(int, AnswerKind)>[];
  final finished = <int>[];

  @override
  Future<PressEffect> answer(
    int careerId,
    PendingConference c,
    int beatIndex,
    Beat beat,
    AnswerKind a,
  ) async {
    answers.add((beatIndex, a));
    return ConferenceBuilder.effectOf(a, c.credibility);
  }

  @override
  Future<int> openPreview(int careerId, PreviewDue due) async => 0;

  @override
  Future<void> finish(int careerId, int conferenceId) async {
    finished.add(conferenceId);
    if (failFinish) throw StateError('db gone');
  }
}

void main() {
  final l = AppLocalizationsEn();

  final conference = (
    row: (
      id: 42,
      cycle: 0,
      reason: ConferenceReason.bigLoss,
      fixtureId: 1,
      triggeredOn: DateTime(2026, 6, 1),
      status: ConferenceStatus.pending,
    ),
    facts: (
      reason: ConferenceReason.bigLoss,
      bestPlayerId: 7,
      worstPlayerId: 8,
      hasOpenWinNext: false,
      hasOpenJob: false,
      playersWithOpenStatement: <int>{},
      throwback:
          (
                id: 5,
                cycle: 0,
                nationId: 1,
                kind: StatementKind.backPlayer,
                playerId: 9,
                madeOn: DateTime(2026, 5, 1),
                madeAfterFixtureId: 1,
                status: StatementStatus.kept,
                judgedOn: DateTime(2026, 5, 20),
                thrownBack: false,
                target: null,
              )
              as PressStatement?,
      preview: null,
    ),
    credibility: 50,
    opponentNationId: 2,
  );

  /// Pumps the sheet as a pushed route and answers all three beats.
  Future<void> toVerdict(WidgetTester tester, _FakeService fake) async {
    await tester.binding.setSurfaceSize(const Size(500, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  body: PressSheet(
                    careerId: 1,
                    conference: conference,
                    playerNames: const {7: 'Dvořák', 8: 'Novák', 9: 'Svoboda'},
                    opponentName: 'Brazil',
                  ),
                ),
              ),
            ),
            child: const Text('HOST'),
          ),
        ),
      ),
      overrides: [conferenceServiceProvider.overrideWithValue(fake)],
    );
    await tester.tap(find.text('HOST'));
    await tester.pumpAndSettle();
    expect(find.text(l.pressQuestionOf(1, 3)), findsOneWidget);

    // The first demandMore answer on the opening beat.
    final demandMore = [
      l.pressReplyDemandMore1,
      l.pressReplyDemandMore2,
      l.pressReplyDemandMore3,
      l.pressReplyDemandMore4,
    ];
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is Text && demandMore.any((d) => (w.data ?? '').contains(d)),
      ),
    );
    await tester.pumpAndSettle();
    expect(fake.answers.single.$2, AnswerKind.demandMore);
    expect(find.text(l.pressQuestionOf(2, 3)), findsOneWidget);
    expect(find.textContaining('Novák'), findsWidgets);
    expect(find.textContaining('On the record'), findsOneWidget);

    expect(find.text('On the record: Novák let you down.'), findsOneWidget);
    await tester.tap(find.textContaining('Novák').last);
    await tester.pumpAndSettle();
    expect(fake.answers.last.$2, AnswerKind.blamePlayer);
    // Throwback is question 3 of 3.
    expect(find.text(l.pressQuestionOf(3, 3)), findsOneWidget);
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text(l.pressTomorrowsHeadline), findsOneWidget);
  }

  testWidgets('three beats, the record line, the verdict and leaving', (
    tester,
  ) async {
    final fake = _FakeService();
    await toVerdict(tester, fake);
    await tester.tap(find.text(l.pressLeaveRoom));
    await tester.tap(find.text(l.pressLeaveRoom), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(fake.finished, [42]);
    // Only the sheet popped: the route under it is still there.
    expect(find.text('HOST'), findsOneWidget);
    expect(find.byType(PressSheet), findsNothing);
  });

  testWidgets('a finish that throws still lets him leave', (tester) async {
    final fake = _FakeService(failFinish: true);
    await toVerdict(tester, fake);
    await tester.tap(find.text(l.pressLeaveRoom));
    await tester.pumpAndSettle();
    expect(find.text('HOST'), findsOneWidget);
    expect(find.byType(PressSheet), findsNothing);
  });

  testWidgets('a preview asks the aim, the draw and the key man', (
    tester,
  ) async {
    final fake = _FakeService();
    final preview = (
      row: (
        id: 43,
        cycle: 0,
        reason: ConferenceReason.preview,
        fixtureId: 1,
        triggeredOn: DateTime(2030, 6, 1),
        status: ConferenceStatus.pending,
      ),
      facts: (
        reason: ConferenceReason.preview,
        bestPlayerId: null,
        worstPlayerId: null,
        hasOpenWinNext: false,
        hasOpenJob: false,
        playersWithOpenStatement: <int>{},
        throwback: null,
        preview: (
          campaign: PreviewCampaign.worldFinals,
          brief: 4,
          rivalNationId: 30,
          keyPlayerId: 9,
        ),
      ),
      credibility: 50,
      opponentNationId: 2,
    );
    await tester.binding.setSurfaceSize(const Size(500, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpApp(
      Scaffold(
        body: PressSheet(
          careerId: 1,
          conference: preview,
          playerNames: const {9: 'Svoboda'},
          opponentName: 'Brazil',
          competitionName: 'World Championship',
          rivalName: 'Argentina',
        ),
      ),
      overrides: [conferenceServiceProvider.overrideWithValue(fake)],
    );
    await tester.pumpAndSettle();
    expect(find.text(l.pressQuestionOf(1, 3)), findsOneWidget);
    expect(find.textContaining('World Championship'), findsOneWidget);
    // Aiming higher than a quarter-final brief states the semi-finals.
    expect(
      find.text(l.pressOnRecordTarget(l.objectiveReachSemis)),
      findsOneWidget,
    );
    expect(find.text(l.pressOnRecordPlayDown), findsOneWidget);
    await tester.tap(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            [
              l.pressReplyMatchBrief1,
              l.pressReplyMatchBrief2,
            ].any((t) => (w.data ?? '').contains(t)),
      ),
    );
    await tester.pumpAndSettle();
    expect(fake.answers.single, (0, AnswerKind.matchBrief));

    expect(find.text(l.pressQuestionOf(2, 3)), findsOneWidget);
    expect(find.textContaining('Argentina'), findsOneWidget);
    await tester.tap(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            [
              l.pressReplyFearNobody1,
              l.pressReplyFearNobody2,
            ].any((t) => (w.data ?? '').contains(t)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l.pressQuestionOf(3, 3)), findsOneWidget);
    expect(find.textContaining('Svoboda'), findsWidgets);
    await tester.tap(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            [
              l.pressReplyTeamFirst1,
              l.pressReplyTeamFirst2,
            ].any((t) => (w.data ?? '').contains(t)),
      ),
    );
    await tester.pumpAndSettle();
    expect(fake.answers.map((a) => a.$2), [
      AnswerKind.matchBrief,
      AnswerKind.fearNobody,
      AnswerKind.teamFirst,
    ]);
    expect(find.text(l.pressTomorrowsHeadline), findsOneWidget);
  });

  for (final code in const ['en', 'cs', 'fr', 'it', 'pl', 'es', 'de']) {
    testWidgets('$code: a preview fits a 320 phone, every beat', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final fake = _FakeService();
      await tester.pumpApp(
        Scaffold(
          body: PressSheet(
            careerId: 1,
            conference: (
              row: (
                id: 44,
                cycle: 0,
                reason: ConferenceReason.preview,
                fixtureId: 1,
                triggeredOn: DateTime(2030, 6, 1),
                status: ConferenceStatus.pending,
              ),
              facts: (
                reason: ConferenceReason.preview,
                bestPlayerId: null,
                worstPlayerId: null,
                hasOpenWinNext: false,
                hasOpenJob: false,
                playersWithOpenStatement: <int>{},
                throwback: null,
                preview: (
                  campaign: PreviewCampaign.continentalFinals,
                  brief: 3,
                  rivalNationId: 30,
                  keyPlayerId: 9,
                ),
              ),
              credibility: 50,
              opponentNationId: 2,
            ),
            playerNames: const {9: 'Krzysztofowicz-Wiśniewski'},
            opponentName: 'Bosnia and Herzegovina',
            competitionName: 'Mistrzostwa Afryki Narodów',
            rivalName: 'Bosnia and Herzegovina',
          ),
        ),
        locale: Locale(code),
        overrides: [conferenceServiceProvider.overrideWithValue(fake)],
      );
      await tester.pumpAndSettle();
      for (var beat = 0; beat < 3; beat++) {
        expect(tester.takeException(), isNull, reason: 'beat $beat');
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      expect(fake.answers, hasLength(3));
    });
  }
}
