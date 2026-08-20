import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// Y used to write from the scoreline alone, so a long save said the same four
/// things about every result. It now reads what actually happened.
void main() {
  YContext contextForRun(int i) {
    final scored = i % 4;
    final conceded = (i * 3) % 4;
    return (
      match: (
        opponent: 'Nation ${i % 7}',
        nationRank: 10,
        opponentRank: 10 + (i % 40) - 20,
        scored: scored,
        conceded: conceded,
        date: DateTime(2030, 1, 1).add(Duration(days: i * 7)),
        key: 'fx:$i',
      ),
      scorerName: scored > 0 ? 'Scorer ${i % 5}' : null,
      scorerGoals: scored > 0 ? scored : null,
      winStreak: i % 6,
      lossStreak: (i + 3) % 6,
      isRivalry: i % 5 == 0,
      injuredNames: i % 9 == 0 ? const ['Hurt Man'] : const [],
      boardMood: 50 - (i % 60),
    );
  }

  YContext withScorer(String name, {required int goals}) {
    final base = contextForRun(1);
    return (
      match: base.match,
      scorerName: name,
      scorerGoals: goals,
      winStreak: 0,
      lossStreak: 0,
      isRivalry: false,
      injuredNames: const [],
      boardMood: 50,
    );
  }

  YContext withWinStreak(int count) {
    final base = contextForRun(2);
    return (
      match: base.match,
      scorerName: null,
      scorerGoals: null,
      winStreak: count,
      lossStreak: 0,
      isRivalry: false,
      injuredNames: const [],
      boardMood: 50,
    );
  }

  test('a long run of results does not repeat itself', () {
    final posts = YFeed.forRun(
      [
        for (var i = 0; i < 40; i++) contextForRun(i),
      ],
      nation: 'Testland',
      seed: 1,
    );

    expect(posts.length, greaterThan(40), reason: 'the feed should be busy');
    for (var i = 0; i < posts.length - YFeed.noRepeatWindow; i++) {
      final window = posts.skip(i).take(YFeed.noRepeatWindow);
      // Shaped exactly as [YFeed.forRun] shapes them: a reply carries no
      // arguments and one template, so its mood and wording ARE its shape.
      final shapes = window.map(
        (p) => p.mood == null
            ? '${p.template.name}|${p.args.join(",")}'
            : 'reaction|${p.mood!.name}|${p.variant}',
      );
      expect(
        shapes.toSet(),
        hasLength(window.length),
        reason: 'repeat inside the window at $i',
      );
    }
  });

  test('a post names the scorer when there was one', () {
    final posts = YFeed.forMatch(
      withScorer('Halvorsen', goals: 2),
      nation: 'Testland',
      seed: 1,
    );
    expect(posts.any((p) => p.args.contains('Halvorsen')), isTrue);
    expect(posts.any((p) => p.template == YTemplate.scorerStar), isTrue);
  });

  test('a streak is remarked on', () {
    final posts = YFeed.forMatch(
      withWinStreak(5),
      nation: 'Testland',
      seed: 1,
    );
    expect(posts.any((p) => p.template == YTemplate.winStreak), isTrue);
    expect(posts.any((p) => p.args.contains('5')), isTrue);
  });

  test('a quiet match stays quiet', () {
    // No scorer, no run, no injuries, a content board: nothing beyond the
    // result itself. The feed must not invent news.
    final posts = YFeed.forMatch(
      plainContext((
        opponent: 'Nation 2',
        nationRank: 10,
        opponentRank: 11,
        scored: 0,
        conceded: 0,
        date: DateTime(2030, 6, 1),
        key: 'fx:quiet',
      )),
      nation: 'Testland',
      seed: 1,
    );
    const extras = {
      YTemplate.scorerStar,
      YTemplate.winStreak,
      YTemplate.lossStreak,
      YTemplate.rivalry,
      YTemplate.injuryBlow,
      YTemplate.boardPressure,
    };
    expect(posts.any((p) => extras.contains(p.template)), isFalse);
  });

  test('a board losing patience is talked about', () {
    final base = contextForRun(3);
    final posts = YFeed.forMatch(
      (
        match: base.match,
        scorerName: null,
        scorerGoals: null,
        winStreak: 0,
        lossStreak: 0,
        isRivalry: false,
        injuredNames: const [],
        boardMood: YFeed.boardPressureBelow,
      ),
      nation: 'Testland',
      seed: 1,
    );
    expect(posts.any((p) => p.template == YTemplate.boardPressure), isTrue);
  });
}
