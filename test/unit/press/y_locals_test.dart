import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_locals.dart';

/// Y's local fans: a small cast of ordinary supporters per save, named from
/// the manager's own nation's lists, answering the side's moments without
/// flooding the feed.
void main() {
  final classic =
      jsonDecode(File('assets/data/country_names.json').readAsStringSync())
          as Map<String, Object?>;
  final more =
      jsonDecode(File('assets/data/country_names_more.json').readAsStringSync())
          as Map<String, Object?>;
  List<String> read(Object? m, String key) =>
      (((m as Map?)?[key] as List?) ?? const []).cast<String>();

  const czechia = 12;
  const japan = 170;
  const brazil = 58;
  const finland = 17;

  YNamePool poolOf(int id) => YLocals.poolFrom(
    first: read(classic['$id'], 'first'),
    firstMore: read(more['$id'], 'firstMore'),
    sur: read(classic['$id'], 'sur'),
    surMore: read(more['$id'], 'surMore'),
  );

  List<YPersona> cast(int id, int seed, {Set<String> avoid = const {}}) =>
      YLocals.castFor(
        pool: poolOf(id),
        nation: '$id',
        seed: seed,
        avoid: {...realInternationalNames, ...avoid},
      );

  group('the cast', () {
    test('is named from the nation own lists', () {
      for (final id in [czechia, japan, brazil]) {
        final given = {
          ...read(classic['$id'], 'first'),
          ...read(more['$id'], 'firstMore'),
        };
        final family = {
          ...read(classic['$id'], 'sur'),
          ...read(more['$id'], 'surMore'),
        };
        for (final seed in [1, 42, 9001]) {
          final fans = cast(id, seed);
          expect(fans, hasLength(YLocals.castSize), reason: '$id/$seed');
          for (final f in fans) {
            final parts = f.displayName.split(' ');
            expect(family, contains(parts.last), reason: f.displayName);
            expect(
              given,
              contains(parts.sublist(0, parts.length - 1).join(' ')),
              reason: f.displayName,
            );
          }
        }
      }
    });

    test('a Czech career has Czech fans, a Japanese one Japanese', () {
      final cz = cast(czechia, 7).map((p) => p.displayName).toList();
      final jp = cast(japan, 7).map((p) => p.displayName).toList();
      final czSur = read(classic['$czechia'], 'sur').toSet()
        ..addAll(read(more['$czechia'], 'surMore'));
      final jpSur = read(classic['$japan'], 'sur').toSet()
        ..addAll(read(more['$japan'], 'surMore'));
      for (final n in cz) {
        expect(czSur, contains(n.split(' ').last));
        expect(jpSur, isNot(contains(n.split(' ').last)));
      }
      for (final n in jp) {
        expect(jpSur, contains(n.split(' ').last));
      }
    });

    test('is the same for a save every time, and differs between saves', () {
      expect(cast(czechia, 42), cast(czechia, 42));
      expect(
        cast(czechia, 42).map((p) => p.displayName),
        isNot(cast(czechia, 43).map((p) => p.displayName)),
      );
    });

    test('one of each disposition, and the profile reads the same one', () {
      final fans = cast(brazil, 5);
      expect(fans.map((p) => p.trait), YLocals.castTraits);
      for (final f in fans) {
        expect(YCast.traitFor(f.displayName), f.trait);
        final post = (
          voice: YVoice.fan,
          handle: f.handle,
          displayName: f.displayName,
          template: YTemplate.reaction,
          variant: 0,
          args: const <String>[],
          date: DateTime(2030),
          key: 'k',
          replyTo: 'p',
          mood: YMood.shrug,
        );
        expect(YFeed.personaOf(post).trait, f.trait);
      }
    });

    test('five different people, with plausible ASCII handles', () {
      for (final id in [czechia, japan, brazil, finland]) {
        for (var seed = 0; seed < 50; seed++) {
          final fans = cast(id, seed);
          expect(fans.map((p) => p.displayName).toSet(), hasLength(5));
          expect(fans.map((p) => p.handle).toSet(), hasLength(5));
          expect(
            fans.map((p) => p.displayName.split(' ').last).toSet(),
            hasLength(5),
          );
          for (final f in fans) {
            expect(f.handle, matches(RegExp(r'^@[a-z0-9_]+$')), reason: '$f');
            expect(
              f.handle.length - 1,
              lessThanOrEqualTo(YLocals.maxHandleBody),
            );
          }
        }
      }
    });

    test('never a real international, folded or not', () {
      // Every name the guard lists, against every nation and many saves.
      final real = {
        for (final n in realInternationalNames)
          YLocals.foldToAscii(n).toLowerCase(),
      };
      for (final id in [finland, 10, czechia, brazil, japan]) {
        for (var seed = 0; seed < 200; seed++) {
          for (final f in cast(id, seed)) {
            expect(
              real,
              isNot(contains(YLocals.foldToAscii(f.displayName).toLowerCase())),
            );
          }
        }
      }
    });

    test('never the name of a current player (or the manager)', () {
      final first = cast(czechia, 3);
      final taken = {first.first.displayName, first.last.displayName};
      // Folded too: a player printed with his háčeks still rules out the
      // same man without them.
      final avoid = {
        ...taken,
        YLocals.foldToAscii(first[1].displayName),
      };
      final again = cast(czechia, 3, avoid: avoid);
      expect(again, hasLength(YLocals.castSize));
      for (final f in again) {
        expect(taken, isNot(contains(f.displayName)));
        expect(f.displayName, isNot(first[1].displayName));
      }
      // Only the clashing seats move.
      expect(again[2], first[2]);
      expect(again[3], first[3]);
    });

    test('every nation in the game has a full cast of short names', () {
      for (final id in classic.keys) {
        for (final seed in [1, 2, 3]) {
          final fans = cast(int.parse(id), seed);
          expect(fans, hasLength(YLocals.castSize), reason: 'nation $id');
          for (final f in fans) {
            expect(
              f.displayName.length,
              lessThanOrEqualTo(YLocals.maxNameLength),
            );
          }
        }
      }
    });

    test('no lists, no fans', () {
      expect(
        YLocals.castFor(
          pool: (given: const [], family: const ['Novák']),
          nation: '1',
          seed: 1,
        ),
        isEmpty,
      );
    });

    test('folds every accented letter the name lists hold', () {
      final letters = <String>{};
      for (final id in classic.keys) {
        for (final n in [
          ...read(more[id], 'firstMore'),
          ...read(classic[id], 'sur'),
          ...read(more[id], 'surMore'),
        ]) {
          letters.addAll(YLocals.foldToAscii(n).split(''));
        }
      }
      expect(
        letters.where((c) => c.codeUnitAt(0) > 127),
        isEmpty,
        reason: 'a handle would carry a letter nobody can type',
      );
    });
  });

  group('the posts', () {
    final fans = cast(czechia, 11);
    final handles = {for (final f in fans) f.handle};

    YPost root(int i, YTemplate t, DateTime date) => (
      voice: YVoice.stats,
      handle: '@TheNumbersDesk',
      displayName: 'The Numbers Desk',
      template: t,
      variant: 0,
      args: const ['Norway', '2–1'],
      date: date,
      key: 'fx:$i|stats|${t.name}',
      replyTo: null,
      mood: null,
    );

    List<YPost> locals(List<YPost> out) => [
      for (final p in out)
        if (handles.contains(p.handle)) p,
    ];

    test('reply under the moment, in the existing reaction words', () {
      final posts = [
        for (var i = 0; i < 40; i++)
          root(
            i,
            YTemplate.winTight,
            DateTime(2030).add(Duration(days: 45 * i)),
          ),
      ];
      final out = YLocals.withLocals(posts, cast: fans, seed: 1);
      final mine = locals(out);
      expect(mine, isNotEmpty);
      for (final p in mine) {
        final parent = posts.singleWhere((q) => q.key == p.replyTo);
        expect(p.template, YTemplate.reaction);
        expect(p.voice, YVoice.fan);
        expect(p.mood, YFeed.moodOf(parent.template));
        expect(p.date, parent.date);
        expect(p.key.split('|').first, parent.key.split('|').first);
        expect(
          p.variant,
          lessThan(YFeed.reactionVariantsFor(p.mood!)),
        );
      }
      expect(out.map((p) => p.key).toSet(), hasLength(out.length));
    });

    test('an ordinary result draws one about half the time', () {
      final posts = [
        for (var i = 0; i < 400; i++)
          root(i, YTemplate.drew, DateTime(2030).add(Duration(days: 40 * i))),
      ];
      final mine = locals(YLocals.withLocals(posts, cast: fans, seed: 1));
      expect(mine.length, inInclusiveRange(150, 250));
    });

    test('never more than three a month, and big moments come first', () {
      // A finals month: seven matches and a trophy, all in July.
      final july = [
        for (var i = 0; i < 7; i++)
          root(i, YTemplate.drew, DateTime(2030, 7, 1 + 3 * i)),
        root(99, YTemplate.trophy, DateTime(2030, 7, 30)),
      ];
      final out = YLocals.withLocals(july, cast: fans, seed: 4);
      final mine = locals(out);
      expect(mine.length, lessThanOrEqualTo(YLocals.perMonth));
      expect(
        mine.where((p) => p.replyTo == 'fx:99|stats|trophy'),
        hasLength(2),
        reason: 'a trophy draws two fans and is never squeezed out',
      );
      expect(
        mine.map((p) => p.handle).toSet(),
        hasLength(mine.length),
        reason: 'the month hears from different people',
      );

      // And across a long career, no month ever goes over.
      final career = [
        for (var i = 0; i < 600; i++)
          root(
            i,
            i % 5 == 0 ? YTemplate.qualified : YTemplate.winRoutine,
            DateTime(2030).add(Duration(days: 4 * i)),
          ),
      ];
      final byMonth = <int, int>{};
      for (final p in locals(YLocals.withLocals(career, cast: fans, seed: 9))) {
        final m = p.date.year * 12 + p.date.month;
        byMonth[m] = (byMonth[m] ?? 0) + 1;
      }
      expect(byMonth.values.every((n) => n <= YLocals.perMonth), isTrue);
    });

    test('one per event, two on the biggest nights', () {
      final posts = [
        root(1, YTemplate.winRoutine, DateTime(2030, 1, 5)),
        // A second root of the same match: still one event.
        (
          voice: YVoice.fan,
          handle: '@BadgeKisser',
          displayName: 'BadgeKisser',
          template: YTemplate.scorerHero,
          variant: 0,
          args: const ['A', 'B'],
          date: DateTime(2030, 1, 5),
          key: 'fx:1|fan|scorerHero',
          replyTo: null,
          mood: null,
        ),
        root(2, YTemplate.trophyEuphoric, DateTime(2030, 3, 5)),
      ];
      final mine = locals(YLocals.withLocals(posts, cast: fans, seed: 2));
      expect(mine.where((p) => p.key.startsWith('fx:1|')), hasLength(1));
      expect(mine.where((p) => p.key.startsWith('fx:2|')), hasLength(2));
    });

    test('never repeats a sentence already said under the same event', () {
      final parent = root(1, YTemplate.trophy, DateTime(2030, 1, 5));
      final existing = [
        for (var v = 0; v < YFeed.reactionVariantsFor(YMood.elation); v++)
          if (v.isEven)
            (
              voice: YVoice.meme,
              handle: '@m$v',
              displayName: 'm$v',
              template: YTemplate.reaction,
              variant: v,
              args: const <String>[],
              date: parent.date,
              key: 'fx:1|re|meme$v',
              replyTo: parent.key,
              mood: YMood.elation,
            ),
      ];
      final mine = locals(
        YLocals.withLocals([parent, ...existing], cast: fans, seed: 3),
      );
      final said = {for (final e in existing) e.variant};
      for (final p in mine) {
        expect(said, isNot(contains(p.variant)));
      }
    });

    test('derived: the same feed draws the same fans in the same places', () {
      final posts = [
        for (var i = 0; i < 60; i++)
          root(i, YTemplate.lost, DateTime(2030).add(Duration(days: 20 * i))),
      ];
      final history = [
        for (var i = 0; i < 60; i++)
          (
            date: DateTime(2030).add(Duration(days: 20 * i)),
            standing: ResultStanding.poor,
          ),
      ];
      final a = YLocals.withLocals(posts, cast: fans, seed: 5, dated: history);
      final b = YLocals.withLocals(posts, cast: fans, seed: 5, dated: history);
      expect(a, b);
    });

    test('no cast, the feed as it was', () {
      final posts = [root(1, YTemplate.trophy, DateTime(2030))];
      expect(YLocals.withLocals(posts, cast: const [], seed: 1), same(posts));
    });
  });
}
