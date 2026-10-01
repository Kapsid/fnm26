import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/statement.dart';

PressStatement st(
  StatementKind kind, {
  int? playerId,
  int nationId = 1,
  int cycle = 0,
  StatementStatus status = StatementStatus.open,
  DateTime? judgedOn,
}) => (
  id: 1,
  cycle: cycle,
  nationId: nationId,
  kind: kind,
  playerId: playerId,
  madeOn: DateTime.utc(2030, 1, 1),
  madeAfterFixtureId: 100,
  status: status,
  judgedOn: judgedOn,
  thrownBack: false,
);
JudgedMatch m(int day, int scored, int conceded) => (
  fixtureId: day,
  date: DateTime.utc(2030, 1, 1 + day),
  scored: scored,
  conceded: conceded,
);
Appearance a(int day, double rating) =>
    (fixtureId: day, date: DateTime.utc(2030, 1, 1 + day), rating: rating);

StatementVerdict? judge(
  PressStatement s, {
  List<JudgedMatch> matches = const [],
  List<Appearance> apps = const [],
  int nation = 1,
  int cycle = 0,
}) => StatementJudge.judge(
  s,
  matches: matches,
  appearances: apps,
  currentNationId: nation,
  currentCycle: cycle,
);

void main() {
  group('winNext', () {
    test(
      'waits for the next match',
      () => expect(judge(st(StatementKind.winNext)), isNull),
    );
    test('is judged by the FIRST match after it, not a later one', () {
      final v = judge(
        st(StatementKind.winNext),
        matches: [m(9, 3, 0), m(3, 0, 1)],
      )!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.winNextBroken);
    });
    test('a win keeps it', () {
      expect(
        judge(st(StatementKind.winNext), matches: [m(3, 2, 1)])!.status,
        StatementStatus.kept,
      );
    });
    test('matches before it do not count', () {
      final early = (
        fixtureId: 1,
        date: DateTime.utc(2029, 12, 1),
        scored: 5,
        conceded: 0,
      );
      expect(judge(st(StatementKind.winNext), matches: [early]), isNull);
    });
  });

  group('jobOnTheLine', () {
    test('needs three matches', () {
      expect(
        judge(
          st(StatementKind.jobOnTheLine),
          matches: [m(1, 1, 0), m(2, 1, 0)],
        ),
        isNull,
      );
    });
    test('two wins in three keep it', () {
      final v = judge(
        st(StatementKind.jobOnTheLine),
        matches: [m(1, 1, 0), m(2, 0, 0), m(3, 2, 1)],
      )!;
      expect(v.status, StatementStatus.kept);
      expect(v.effect, StatementJudge.jobKept);
    });
    test('one win in three breaks it', () {
      final v = judge(
        st(StatementKind.jobOnTheLine),
        matches: [m(1, 1, 0), m(2, 0, 0), m(3, 0, 1)],
      )!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.jobBroken);
    });
  });

  group('players', () {
    test('backing a player who delivers keeps it', () {
      final v = judge(
        st(StatementKind.backPlayer, playerId: 5),
        apps: [a(1, 7.0), a(2, 6.9), a(3, 6.8)],
      )!;
      expect(v.status, StatementStatus.kept);
    });
    test('backing a flop breaks it', () {
      final v = judge(
        st(StatementKind.backPlayer, playerId: 5),
        apps: [a(1, 6.0), a(2, 6.2), a(3, 6.4)],
      )!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.backBroken);
    });
    test('blame stands when he stays poor', () {
      final v = judge(
        st(StatementKind.blamePlayer, playerId: 5),
        apps: [a(1, 6.0), a(2, 6.2), a(3, 6.4)],
      )!;
      expect(v.status, StatementStatus.kept);
      expect(v.effect, StatementJudge.blameStood);
    });
    test('blame is proved wrong when he responds, and costs nothing more', () {
      final v = judge(
        st(StatementKind.blamePlayer, playerId: 5),
        apps: [a(1, 7.5), a(2, 7.0), a(3, 7.2)],
      )!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.none);
    });
  });

  group('lapsing', () {
    test('an incomplete window lapses once the cycle is over', () {
      final v = judge(
        st(StatementKind.jobOnTheLine),
        matches: [m(1, 1, 0)],
        cycle: 1,
      )!;
      expect(v.status, StatementStatus.lapsed);
      expect(v.effect, StatementJudge.none);
    });
    test('a statement about a squad he has left lapses at once', () {
      final v = judge(
        st(StatementKind.backPlayer, playerId: 5, nationId: 1),
        apps: [a(1, 9.0), a(2, 9.0), a(3, 9.0)],
        nation: 2,
      )!;
      expect(v.status, StatementStatus.lapsed);
    });
    test('a judged statement is never judged again', () {
      expect(
        judge(
          st(StatementKind.winNext, status: StatementStatus.kept),
          matches: [m(1, 0, 3)],
        ),
        isNull,
      );
    });
  });

  group('credibility', () {
    test('starts at 50 and moves with the record', () {
      expect(Credibility.of(const [], deflects: 0), 50);
      expect(
        Credibility.of([
          st(StatementKind.winNext, status: StatementStatus.kept),
        ], deflects: 0),
        58,
      );
      expect(
        Credibility.of([
          st(StatementKind.winNext, status: StatementStatus.broken),
        ], deflects: 1),
        38,
      );
    });
    test('is clamped and banded', () {
      final many = List.filled(
        20,
        st(StatementKind.winNext, status: StatementStatus.broken),
      );
      expect(Credibility.of(many, deflects: 0), 0);
      expect(Credibility.band(34), CredibilityBand.low);
      expect(Credibility.band(50), CredibilityBand.mid);
      expect(Credibility.band(66), CredibilityBand.high);
      expect(Credibility.multiplier(0), closeTo(0.6, 1e-9));
      expect(Credibility.multiplier(100), closeTo(1.4, 1e-9));
    });
  });

  group('condition deltas', () {
    test('an open blame weighs on him, a recent kept backing lifts him', () {
      final asOf = DateTime.utc(2030, 3, 1);
      final d = StatementJudge.conditionDeltas([
        st(StatementKind.blamePlayer, playerId: 5),
        st(
          StatementKind.backPlayer,
          playerId: 6,
          status: StatementStatus.kept,
          judgedOn: DateTime.utc(2030, 2, 1),
        ),
        st(
          StatementKind.backPlayer,
          playerId: 7,
          status: StatementStatus.kept,
          judgedOn: DateTime.utc(2029, 6, 1),
        ),
      ], asOf);
      expect(d, {5: -2, 6: 1});
    });
  });
}
