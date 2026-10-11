import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';

/// The press before a campaign: what they ask, what an answer puts on the
/// record, and how that record is judged once the campaign is settled.
void main() {
  ConferenceFacts preview(
    PreviewCampaign campaign, {
    int brief = 4,
    int? rival = 30,
    int? key = 9,
    Set<int> open = const {},
  }) => (
    reason: ConferenceReason.preview,
    bestPlayerId: null,
    worstPlayerId: null,
    hasOpenWinNext: false,
    hasOpenJob: false,
    playersWithOpenStatement: open,
    throwback: null,
    preview: (
      campaign: campaign,
      brief: brief,
      rivalNationId: rival,
      keyPlayerId: key,
    ),
  );

  group('which fixture opens which campaign', () {
    test('round codes', () {
      expect(PreviewCampaign.ofRound(null), PreviewCampaign.worldQualifying);
      expect(
        PreviewCampaign.ofRound('CQ'),
        PreviewCampaign.continentalQualifying,
      );
      expect(PreviewCampaign.ofRound('GROUP'), PreviewCampaign.worldFinals);
      expect(
        PreviewCampaign.ofRound('CGROUP'),
        PreviewCampaign.continentalFinals,
      );
      for (final other in ['FRIENDLY', 'NGROUP', 'R16', 'CQF']) {
        expect(PreviewCampaign.ofRound(other), isNull, reason: other);
      }
    });

    test('qualifying asks only that the side gets there', () {
      expect(PreviewCampaign.worldQualifying.briefFor(6), 2);
      expect(PreviewCampaign.continentalQualifying.briefFor(1), 1);
    });

    test('at the finals the floor is getting out of the group', () {
      expect(PreviewCampaign.worldFinals.briefFor(2), 3);
      expect(PreviewCampaign.continentalFinals.briefFor(5), 5);
    });
  });

  group('the beats', () {
    test('a finals preview asks the aim, the draw, then the key man', () {
      final beats = ConferenceBuilder.previewBeats(
        preview(PreviewCampaign.worldFinals),
      );
      expect(beats.map((b) => b.kind), [
        BeatKind.aim,
        BeatKind.rival,
        BeatKind.keyPlayer,
      ]);
      expect(beats.first.answers, [
        AnswerKind.aimHigher,
        AnswerKind.matchBrief,
        AnswerKind.playDown,
      ]);
      expect(beats.last.playerId, 9);
      expect(beats.last.answers, contains(AnswerKind.backPlayer));
    });

    test('a side told to win it cannot aim higher', () {
      final aim = ConferenceBuilder.previewBeats(
        preview(PreviewCampaign.worldFinals, brief: 7),
      ).first;
      expect(aim.answers, isNot(contains(AnswerKind.aimHigher)));
    });

    test('qualifying is asked as a promise to qualify', () {
      final aim = ConferenceBuilder.previewBeats(
        preview(PreviewCampaign.continentalQualifying, brief: 2),
      ).first;
      expect(aim.answers, [
        AnswerKind.promiseQualify,
        AnswerKind.playDown,
        AnswerKind.deflect,
      ]);
    });

    test('no rival or no nameable key man drops that beat', () {
      expect(
        ConferenceBuilder.previewBeats(
          preview(PreviewCampaign.worldFinals, rival: null, key: null),
        ).map((b) => b.kind),
        [BeatKind.aim],
      );
      // A player already on the record is not asked about again.
      expect(
        ConferenceBuilder.previewBeats(
          preview(PreviewCampaign.worldFinals, open: {9}),
        ).map((b) => b.kind),
        [BeatKind.aim, BeatKind.rival],
      );
    });

    test('a preview never throws an old statement back', () {
      expect(
        ConferenceBuilder.throwback(preview(PreviewCampaign.worldFinals)),
        isNull,
      );
    });
  });

  group('the stated target', () {
    final p = preview(PreviewCampaign.worldFinals, brief: 4).preview!;
    test('read off the brief', () {
      expect(ConferenceBuilder.statedTarget(AnswerKind.aimHigher, p), 5);
      expect(ConferenceBuilder.statedTarget(AnswerKind.matchBrief, p), 4);
      expect(ConferenceBuilder.statedTarget(AnswerKind.playDown, p), 3);
      expect(ConferenceBuilder.statedTarget(AnswerKind.promiseQualify, p), 2);
      expect(ConferenceBuilder.statedTarget(AnswerKind.deflect, p), isNull);
      expect(
        ConferenceBuilder.statedTarget(AnswerKind.fearNobody, p),
        isNull,
      );
    });

    test('the aim answers go on the record as a target', () {
      for (final a in [
        AnswerKind.aimHigher,
        AnswerKind.matchBrief,
        AnswerKind.playDown,
        AnswerKind.promiseQualify,
      ]) {
        expect(ConferenceBuilder.statementOf(a), StatementKind.target);
      }
      expect(ConferenceBuilder.statementOf(AnswerKind.fearNobody), isNull);
    });
  });

  group('judging a target', () {
    TargetOutcome at(int actual, {int brief = 4, bool settled = true}) =>
        (brief: brief, actual: actual, settled: settled);

    test('nothing is judged before the campaign is settled', () {
      expect(StatementJudge.judgeTarget(5, at(6, settled: false)), isNull);
    });

    test('aiming higher wins big or costs big', () {
      expect(StatementJudge.judgeTarget(5, at(5)), (
        status: StatementStatus.kept,
        effect: StatementJudge.aimHigherKept,
      ));
      expect(StatementJudge.judgeTarget(5, at(4)), (
        status: StatementStatus.broken,
        effect: StatementJudge.aimHigherBroken,
      ));
    });

    test('matching the brief is a promise to deliver it', () {
      expect(StatementJudge.judgeTarget(4, at(4)), (
        status: StatementStatus.kept,
        effect: StatementJudge.matchBriefKept,
      ));
      expect(StatementJudge.judgeTarget(4, at(3)), (
        status: StatementStatus.broken,
        effect: StatementJudge.matchBriefBroken,
      ));
    });

    test('playing it down earns only when the brief is beaten', () {
      expect(StatementJudge.judgeTarget(3, at(5)), (
        status: StatementStatus.kept,
        effect: StatementJudge.playDownBeaten,
      ));
      // Met but not beaten, or missed: forgotten, never held against him.
      for (final actual in [4, 2]) {
        expect(StatementJudge.judgeTarget(3, at(actual)), (
          status: StatementStatus.lapsed,
          effect: StatementJudge.none,
        ));
      }
    });

    test('promising qualification on a top-half brief is aiming higher', () {
      // Brief 1 (top half of the group), stated 2 (qualify).
      expect(StatementJudge.judgeTarget(2, at(2, brief: 1)), (
        status: StatementStatus.kept,
        effect: StatementJudge.aimHigherKept,
      ));
    });

    PressStatement target({int cycle = 1, int nationId = 1}) => (
      id: 1,
      cycle: cycle,
      nationId: nationId,
      kind: StatementKind.target,
      playerId: null,
      madeOn: DateTime(2030, 6, 1),
      madeAfterFixtureId: 5,
      status: StatementStatus.open,
      judgedOn: null,
      thrownBack: false,
      target: 4,
    );

    test('judge() hands a target its campaign and lapses it on a move', () {
      final kept = StatementJudge.judge(
        target(),
        matches: const [],
        appearances: const [],
        currentNationId: 1,
        currentCycle: 1,
        target: at(4),
      );
      expect(kept?.status, StatementStatus.kept);
      // No campaign reading yet: still open.
      expect(
        StatementJudge.judge(
          target(),
          matches: const [],
          appearances: const [],
          currentNationId: 1,
          currentCycle: 1,
        ),
        isNull,
      );
      expect(
        StatementJudge.judge(
          target(),
          matches: const [],
          appearances: const [],
          currentNationId: 2,
          currentCycle: 1,
          target: at(4),
        )?.status,
        StatementStatus.lapsed,
      );
    });
  });
}
