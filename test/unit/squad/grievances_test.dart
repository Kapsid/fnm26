import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/grievances.dart';

void main() {
  SquadStanding man(
    int id, {
    int age = 27,
    int caps = 30,
    int overall = 78,
    bool calledUp = true,
    int recent = 3,
  }) =>
      (
        playerId: id,
        playerName: 'P$id',
        age: age,
        caps: caps,
        overall: overall,
        calledUp: calledUp,
        recentAppearances: recent,
      );

  List<Grievance> raise(
    List<SquadStanding> squad, {
    Map<int, int>? ranks,
    Set<String> already = const {},
  }) =>
      Grievances.raise(
        squad,
        poolRank: ranks ?? {for (final s in squad) s.playerId: 5},
        window: 12,
        alreadyRaised: already,
      );

  group('who has a case', () {
    test('a settled squad says nothing', () {
      expect(raise([man(1), man(2), man(3)]), isEmpty);
    });

    test('a capped man in the squad who never plays wants a word', () {
      final out = raise([man(1, recent: 0)]);
      expect(out, hasLength(1));
      expect(out.single.kind, GrievanceKind.gameTime);
    });

    test('an uncapped squad man has no standing to complain yet', () {
      // He has never played for anyone. Being behind others is not an insult.
      expect(raise([man(1, recent: 0, caps: 0)]), isEmpty);
    });

    test('a good player left out entirely wants back in', () {
      final out = raise([man(1, calledUp: false, recent: 0)]);
      expect(out.single.kind, GrievanceKind.squadPlace);
    });

    test('a young man left out is waiting his turn, not aggrieved', () {
      expect(raise([man(1, calledUp: false, recent: 0, age: 21)]), isEmpty);
    });

    test('a fringe player left out has no case', () {
      final out = raise(
        [man(1, calledUp: false, recent: 0)],
        ranks: {1: 60},
      );
      expect(out, isEmpty);
    });
  });

  group('how many speak', () {
    test('never more than two at once', () {
      final squad = [for (var i = 1; i <= 8; i++) man(i, recent: 0)];
      expect(raise(squad), hasLength(Grievances.maxActive));
    });

    test('the most-capped man speaks', () {
      final out = raise([
        man(1, recent: 0, caps: 10),
        man(2, recent: 0, caps: 90),
        man(3, recent: 0, caps: 50),
      ]);
      expect(out.first.playerId, 2);
      expect(out.map((g) => g.playerId), isNot(contains(1)));
    });

    test('one grievance per man', () {
      final out = raise([man(1, recent: 0)]);
      expect(out.map((g) => g.playerId).toSet(), hasLength(out.length));
    });

    test('a grievance already raised is not raised again', () {
      final first = raise([man(1, recent: 0)]);
      final again = raise([man(1, recent: 0)],
          already: {for (final g in first) g.key});
      expect(again, isEmpty);
    });
  });

  group('answering', () {
    test('honesty is never worse for the room than brushing him off', () {
      expect(
        Grievances.effectOf(GrievanceTone.honest).morale,
        greaterThan(Grievances.effectOf(GrievanceTone.dismiss).morale),
      );
    });

    test('a promise buys the room and costs you standing', () {
      final r = Grievances.effectOf(GrievanceTone.reassure);
      expect(r.morale, greaterThan(0));
      expect(r.board, lessThan(0));
    });

    test('every tone is a nudge, not a result', () {
      for (final t in GrievanceTone.values) {
        final e = Grievances.effectOf(t);
        expect(e.morale.abs(), lessThanOrEqualTo(5));
        expect(e.board.abs(), lessThanOrEqualTo(5));
      }
    });
  });

  group('walking away', () {
    test('a veteran ignored twice leaves for good', () {
      expect(Grievances.walksOut(age: 33, windows: 2), isTrue);
    });

    test('a young man sulks instead', () {
      expect(Grievances.walksOut(age: 24, windows: 5), isFalse);
    });

    test('one window is not enough to lose anybody', () {
      expect(Grievances.walksOut(age: 34, windows: 1), isFalse);
    });
  });
}
