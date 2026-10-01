import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

PressStatement _s(
  int id,
  StatementStatus status, {
  StatementKind kind = StatementKind.winNext,
}) => (
  id: id,
  cycle: 1,
  nationId: 7,
  kind: kind,
  playerId: null,
  madeOn: DateTime(2027, 3, 1),
  madeAfterFixtureId: 11,
  status: status,
  judgedOn: status == StatementStatus.open ? null : DateTime(2027, 3, 9),
  thrownBack: false,
);

List<YPost> _roots(List<YPost> posts) => [
  for (final p in posts)
    if (p.replyTo == null) p,
];

void main() {
  test('a kept statement draws one statementKept post, dated when judged', () {
    final posts = YFeed.forStatement(
      s: _s(1, StatementStatus.kept),
      nation: 'Czechia',
      seed: 42,
    );
    final roots = _roots(posts);
    expect(roots, hasLength(1));
    expect(roots.single.template, YTemplate.statementKept);
    expect(roots.single.date, DateTime(2027, 3, 9));
    expect(roots.single.key, startsWith('stmt:1'));
    expect(roots.single.args, ['Czechia']);
    expect(
      roots.single.variant,
      lessThan(YFeed.variantsFor(YTemplate.statementKept)),
    );
    // Replies hang off it, and every one of them is a reaction to it.
    for (final r in posts.where((p) => p.replyTo != null)) {
      expect(r.replyTo, roots.single.key);
      expect(r.mood, YMood.elation);
    }
  });

  test('a broken statement draws one statementBroken post', () {
    final posts = YFeed.forStatement(
      s: _s(2, StatementStatus.broken, kind: StatementKind.jobOnTheLine),
      nation: 'Czechia',
      seed: 42,
    );
    final roots = _roots(posts);
    expect(roots, hasLength(1));
    expect(roots.single.template, YTemplate.statementBroken);
    expect(roots.single.key, startsWith('stmt:2'));
    for (final r in posts.where((p) => p.replyTo != null)) {
      expect(r.mood, YMood.fury);
    }
  });

  test('open and lapsed statements say nothing', () {
    for (final status in [StatementStatus.open, StatementStatus.lapsed]) {
      expect(
        YFeed.forStatement(s: _s(3, status), nation: 'Czechia', seed: 42),
        isEmpty,
      );
    }
  });

  test('the same statement always draws the same posts', () {
    final s = _s(4, StatementStatus.broken);
    final a = YFeed.forStatement(s: s, nation: 'Czechia', seed: 42);
    final b = YFeed.forStatement(s: s, nation: 'Czechia', seed: 42);
    // Records holding a List compare the list by identity, so compare what a
    // reader sees instead.
    String show(YPost p) =>
        '${p.key} ${p.handle} ${p.template} ${p.variant} ${p.args} '
        '${p.date} ${p.replyTo} ${p.mood}';
    expect(a.map(show).toList(), b.map(show).toList());
    expect(a, isNotEmpty);
  });

  test('both templates are six tone-banded wordings', () {
    expect(
      YFeed.variantsFor(YTemplate.statementKept),
      YFeed.subjectVariantCount,
    );
    expect(
      YFeed.variantsFor(YTemplate.statementBroken),
      YFeed.subjectVariantCount,
    );
  });

  group('an older post says now what it said then', () {
    final judged = _s(5, StatementStatus.kept);
    final before = [
      for (var i = 0; i < 6; i++)
        (
          date: DateTime(2027, 1, 1 + i * 10),
          standing: i.isEven ? ResultStanding.creditable : ResultStanding.par,
        ),
    ];
    // A run of humiliations AFTER the statement was judged.
    final after = [
      ...before,
      for (var i = 0; i < 8; i++)
        (
          date: DateTime(2027, 4, 1 + i * 3),
          standing: ResultStanding.humiliating,
        ),
    ];

    test('the slice stops at the day it was judged', () {
      final then = YFeed.standingsAsOf(after, judged.judgedOn!);
      expect(then, [for (final d in before) d.standing]);
      // On the day itself counts.
      expect(
        YFeed.standingsAsOf([
          (date: judged.judgedOn!, standing: ResultStanding.par),
        ], judged.judgedOn!),
        [ResultStanding.par],
      );
    });

    test('later results do not re-word it', () {
      List<String> build(
        List<({DateTime date, ResultStanding standing})> dated,
      ) {
        final then = YFeed.standingsAsOf(dated, judged.judgedOn!);
        return [
          for (final p in YFeed.forStatement(
            s: judged,
            nation: 'Czechia',
            seed: 42,
            standing: then.isEmpty ? ResultStanding.par : then.last,
            history: then,
          ))
            '${p.key} ${p.handle} ${p.template} ${p.variant} ${p.mood}',
        ];
      }

      expect(build(after), build(before));
    });
  });
}
