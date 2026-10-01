import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';

ConferenceFacts facts(
  ConferenceReason r, {
  int? best = 7,
  int? worst = 8,
  bool openWin = false,
  bool openJob = false,
  Set<int> open = const {},
  PressStatement? throwback,
}) => (
  reason: r,
  bestPlayerId: best,
  worstPlayerId: worst,
  hasOpenWinNext: openWin,
  hasOpenJob: openJob,
  playersWithOpenStatement: open,
  throwback: throwback,
);

void main() {
  test('only a crisis or a job verdict asks about his future', () {
    for (final r in ConferenceReason.values) {
      final f = facts(r);
      final beats = [
        ConferenceBuilder.opening(f),
        for (final a in ConferenceBuilder.opening(f).answers)
          ConferenceBuilder.reaction(f, a),
      ];
      final asks = beats.any((b) => ConferenceBuilder.asksAboutFuture(b, r));
      expect(
        asks,
        r == ConferenceReason.crisis || r == ConferenceReason.jobVerdict,
        reason: r.name,
      );
    }
  });

  test(
    'jobOnTheLine appears only in reaction to promiseWinNext for big results',
    () {
      for (final r in [ConferenceReason.bigWin, ConferenceReason.bigLoss]) {
        final f = facts(r);
        final opening = ConferenceBuilder.opening(f);

        // jobOnTheLine must not be in opening for big results
        expect(
          opening.answers,
          isNot(contains(AnswerKind.jobOnTheLine)),
          reason: 'opening for $r',
        );

        // walk every reaction
        for (final answer in opening.answers) {
          final reaction = ConferenceBuilder.reaction(f, answer);

          if (answer == AnswerKind.promiseWinNext) {
            // only promiseWinNext reaction may have jobOnTheLine
            // (and only if no open job)
            if (!f.hasOpenJob) {
              expect(
                reaction.answers,
                contains(AnswerKind.jobOnTheLine),
                reason: '$r + promiseWinNext',
              );
            }
          } else {
            // all other reactions must not have jobOnTheLine
            expect(
              reaction.answers,
              isNot(contains(AnswerKind.jobOnTheLine)),
              reason: '$r + $answer',
            );
          }
        }
      }
    },
  );

  test('no free answer: every opening has something that costs', () {
    for (final r in ConferenceReason.values) {
      final answers = ConferenceBuilder.opening(facts(r)).answers;
      expect(answers.length, inInclusiveRange(3, 4));
      expect(
        answers.where((a) => a != AnswerKind.deflect).every((a) {
          final e = ConferenceBuilder.effectOf(a, 50);
          return e.morale != 0 || e.board != 0;
        }),
        isTrue,
      );
    }
  });

  test('a promise is not offered twice while one is open', () {
    expect(
      ConferenceBuilder.opening(
        facts(ConferenceReason.bigLoss, openWin: true),
      ).answers,
      isNot(contains(AnswerKind.promiseWinNext)),
    );
    expect(
      ConferenceBuilder.opening(
        facts(ConferenceReason.crisis, openJob: true),
      ).answers,
      isNot(contains(AnswerKind.jobOnTheLine)),
    );
  });

  test('demanding more asks who, naming his worst player of the match', () {
    final b = ConferenceBuilder.reaction(
      facts(ConferenceReason.bigLoss),
      AnswerKind.demandMore,
    );
    expect(b.kind, BeatKind.whoToBlame);
    expect(b.playerId, 8);
    expect(b.answers, contains(AnswerKind.blamePlayer));
  });

  test('nobody to name means a follow-up about the result', () {
    final b = ConferenceBuilder.reaction(
      facts(ConferenceReason.bigLoss, worst: null),
      AnswerKind.demandMore,
    );
    expect(b.kind, BeatKind.followUp);
    expect(b.playerId, isNull);
  });

  test('a player already on the record is not named again', () {
    final b = ConferenceBuilder.reaction(
      facts(ConferenceReason.bigWin, open: {7}),
      AnswerKind.creditPlayers,
    );
    expect(b.kind, BeatKind.followUp);
  });

  test('a promise is met with "and if you don\'t?"', () {
    final b = ConferenceBuilder.reaction(
      facts(ConferenceReason.bigLoss),
      AnswerKind.promiseWinNext,
    );
    expect(b.kind, BeatKind.ifYouDont);
    expect(b.answers, contains(AnswerKind.jobOnTheLine));
  });

  test(
    'a throwback only when something is due, with answers to its verdict',
    () {
      expect(
        ConferenceBuilder.throwback(facts(ConferenceReason.bigWin)),
        isNull,
      );
      PressStatement s(StatementStatus status) => (
        id: 1,
        cycle: 0,
        nationId: 1,
        kind: StatementKind.backPlayer,
        playerId: 7,
        madeOn: DateTime.utc(2030),
        madeAfterFixtureId: 1,
        status: status,
        judgedOn: DateTime.utc(2030, 2),
        thrownBack: false,
      );
      final kept = ConferenceBuilder.throwback(
        facts(ConferenceReason.bigWin, throwback: s(StatementStatus.kept)),
      )!;
      expect(kept.answers, contains(AnswerKind.takeCredit));
      expect(kept.playerId, 7);
      final broken = ConferenceBuilder.throwback(
        facts(ConferenceReason.bigWin, throwback: s(StatementStatus.broken)),
      )!;
      expect(broken.answers, contains(AnswerKind.admitMistake));
    },
  );

  test('credibility scales effects', () {
    expect(
      ConferenceBuilder.effectOf(AnswerKind.demandMore, 100).board,
      greaterThan(ConferenceBuilder.effectOf(AnswerKind.demandMore, 0).board),
    );
  });

  test('statement answers map to their kinds', () {
    expect(
      ConferenceBuilder.statementOf(AnswerKind.promiseWinNext),
      StatementKind.winNext,
    );
    expect(
      ConferenceBuilder.statementOf(AnswerKind.jobOnTheLine),
      StatementKind.jobOnTheLine,
    );
    expect(
      ConferenceBuilder.statementOf(AnswerKind.backPlayer),
      StatementKind.backPlayer,
    );
    expect(
      ConferenceBuilder.statementOf(AnswerKind.blamePlayer),
      StatementKind.blamePlayer,
    );
    expect(ConferenceBuilder.statementOf(AnswerKind.deflect), isNull);
  });
}
