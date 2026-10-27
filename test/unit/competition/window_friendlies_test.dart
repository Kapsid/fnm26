import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/window_friendlies.dart';

void main() {
  final nations = [
    for (final n
        in jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List)
      Nation.fromJson(n as Map<String, Object?>),
  ];
  // A window where a third of the world is busy with qualifiers.
  final busy = {
    for (final n in nations)
      if (n.id % 3 == 0) n.id,
  };

  List<FriendlyResult> window(int key, {int seed = 77}) =>
      WindowFriendlies.generate(
        nations: nations,
        busyIds: busy,
        seed: seed,
        windowKey: key,
      );

  test('most free European nations play in every window', () {
    // The tester's report: only eight friendlies a window, and most of Europe
    // sat idle.
    final freeEurope = {
      for (final n in nations)
        if (n.confederation == Confederation.europe && !busy.contains(n.id))
          n.id,
    };
    for (final key in [26330, 26331, 26335, 26339, 26342]) {
      final playing = {
        for (final f in window(key)) ...[f.homeId, f.awayId],
      };
      final share =
          freeEurope.where(playing.contains).length / freeEurope.length;
      expect(share, greaterThanOrEqualTo(0.7), reason: 'window $key');
    }
  });

  test('far more than eight friendlies across the world', () {
    final free = nations.length - busy.length;
    final games = window(26330);
    expect(games.length, greaterThan(40));
    // Most free nations, worldwide, are in action.
    expect(games.length * 2 / free, greaterThanOrEqualTo(0.65));
  });

  test('nobody busy plays, and nobody plays twice', () {
    final games = window(26331);
    final seen = <int>{};
    for (final f in games) {
      expect(busy.contains(f.homeId), isFalse);
      expect(busy.contains(f.awayId), isFalse);
      expect(f.homeId, isNot(f.awayId));
      expect(seen.add(f.homeId), isTrue);
      expect(seen.add(f.awayId), isTrue);
    }
  });

  test('mostly continental opponents, a few from abroad', () {
    final conf = {for (final n in nations) n.id: n.confederation};
    final games = window(26335);
    final same = games.where((f) => conf[f.homeId] == conf[f.awayId]).length;
    expect(same / games.length, greaterThan(0.6));
    expect(same, lessThan(games.length), reason: 'some intercontinental');
  });

  test('deterministic per window, different between windows', () {
    expect(window(26339).toString(), window(26339).toString());
    expect(window(26339).toString(), isNot(window(26342).toString()));
    // The caller's list order does not matter.
    final reversed = WindowFriendlies.generate(
      nations: nations.reversed.toList(),
      busyIds: busy,
      seed: 77,
      windowKey: 26339,
    );
    expect(reversed.toString(), window(26339).toString());
  });
}
