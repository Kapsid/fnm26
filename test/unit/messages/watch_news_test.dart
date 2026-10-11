import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/messages/watch_news.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/fixtures.dart';

/// The news about a marked boy, and the flood it must not become.
///
/// The threshold is the whole design here. A thirteen-year-old adds five or six
/// rating points a year by growing up and a seventeen-year-old three, so a
/// message about "a jump in rating" measured on the raw gain would be a message
/// about every boy every year. What is reported is the part that beats his own
/// age curve.
void main() {
  Player boy({
    required int id,
    required int age,
    required int rating,
    String name = 'Novák',
  }) => player(
    id: id,
    nationId: 1,
    name: name,
    age: age,
    attributes: flatAttributes(rating),
  );

  Map<int, Player> pool(List<Player> players) => {
    for (final p in players) p.id: p,
  };

  final en = AppLocalizationsEn();

  test('the age curve is steeper for a child than for a teenager', () {
    // Not an implementation detail: it is why the raw year's gain cannot be the
    // threshold. A twelve-year-old's expected step is twice a nineteen-year-old's.
    expect(expectedYearGain(12), greaterThan(expectedYearGain(19)));
    expect(expectedYearGain(19), greaterThan(0));
  });

  test('a boy who only grew with his age is not news', () {
    final was = boy(id: 1, age: 13, rating: 40);
    final now = boy(id: 1, age: 14, rating: 40 + expectedYearGain(13));
    expect(
      watchlistDigest(
        marked: {1},
        now: pool([now]),
        before: pool([was]),
        year: 2030,
      ),
      isNull,
      reason: 'the calendar is not a development',
    );
  });

  test('a boy who beat his age curve is news, in both languages', () {
    final was = boy(id: 1, age: 13, rating: 40);
    final now = boy(
      id: 1,
      age: 14,
      rating: 40 + expectedYearGain(13) + kWatchJumpPoints,
    );
    final digest = watchlistDigest(
      marked: {1},
      now: pool([now]),
      before: pool([was]),
      year: 2030,
    );
    expect(digest, isNotNull);
    for (final l in [en, AppLocalizationsCs()]) {
      final body = renderMsgPart(l, digest!.body);
      expect(body, contains('Novák'));
      expect(body, contains('${now.overall}'));
      expect(renderMsgPart(l, digest.title), contains('2030'));
    }
  });

  test('one point short of the threshold files nothing', () {
    final was = boy(id: 1, age: 17, rating: 55);
    final now = boy(
      id: 1,
      age: 18,
      rating: 55 + expectedYearGain(17) + kWatchJumpPoints - 1,
    );
    expect(
      watchlistDigest(
        marked: {1},
        now: pool([now]),
        before: pool([was]),
        year: 2030,
      ),
      isNull,
    );
  });

  test('reaching the next age band is news on its own', () {
    // Ordinary development, but he has moved up a level: 14 is a U-15 and 15 a
    // U-17.
    final was = boy(id: 1, age: 14, rating: 44);
    final now = boy(id: 1, age: 15, rating: 44 + expectedYearGain(14));
    final digest = watchlistDigest(
      marked: {1},
      now: pool([now]),
      before: pool([was]),
      year: 2031,
    );
    expect(digest, isNotNull);
    expect(renderMsgPart(en, digest!.body), contains('U-17'));
  });

  test('a boy nobody marked is never reported', () {
    final was = boy(id: 1, age: 13, rating: 40);
    final now = boy(id: 1, age: 14, rating: 60);
    expect(
      watchlistDigest(
        marked: const {},
        now: pool([now]),
        before: pool([was]),
        year: 2030,
      ),
      isNull,
    );
  });

  test('a boy who has left the pyramid is not reported as a development', () {
    // Released, or through to the seniors. The shortlist says which; the inbox
    // must not report an absence as a rating move, and must not throw on it.
    expect(
      watchlistDigest(
        marked: {1},
        now: const {},
        before: pool([boy(id: 1, age: 16, rating: 50)]),
        year: 2030,
      ),
      isNull,
    );
  });

  test('a boy with no reading last year has nothing to compare against', () {
    expect(
      watchlistDigest(
        marked: {1},
        now: pool([boy(id: 1, age: 11, rating: 30)]),
        before: const {},
        year: 2030,
      ),
      isNull,
    );
  });

  test('several movers are one message, ordered, not one message each', () {
    final before = pool([
      boy(id: 1, age: 13, rating: 40, name: 'Alfa'),
      boy(id: 2, age: 13, rating: 40, name: 'Beta'),
      boy(id: 3, age: 13, rating: 40, name: 'Gama'),
    ]);
    final step = expectedYearGain(13);
    final now = pool([
      boy(id: 1, age: 14, rating: 40 + step + 3, name: 'Alfa'),
      boy(id: 2, age: 14, rating: 40 + step + 9, name: 'Beta'),
      boy(id: 3, age: 14, rating: 40 + step, name: 'Gama'),
    ]);
    final digest = watchlistDigest(
      marked: {1, 2, 3},
      now: now,
      before: before,
      year: 2030,
    );
    final body = renderMsgPart(en, digest!.body);
    expect(body, contains('Alfa'));
    expect(body, contains('Beta'));
    expect(
      body,
      isNot(contains('Gama')),
      reason: 'Gama grew with the calendar',
    );
    expect(
      body.indexOf('Beta'),
      lessThan(body.indexOf('Alfa')),
      reason: 'the biggest step forward is read first',
    );
  });

  group('a debut', () {
    test('is filed once, for a marked boy who has played', () {
      final debuts = watchlistDebuts(
        marked: {1, 2},
        pool: pool([
          boy(id: 1, age: 18, rating: 60, name: 'Capped'),
          boy(id: 2, age: 18, rating: 60, name: 'Uncapped'),
        ]),
        capsByPlayer: const {1: 1},
      );
      expect(debuts, hasLength(1));
      expect(debuts.single.playerId, 1);
      for (final l in [en, AppLocalizationsCs()]) {
        expect(renderMsgPart(l, debuts.single.title), contains('Capped'));
        expect(renderMsgPart(l, debuts.single.body), contains('Capped'));
      }
    });

    test('is not filed for a boy who has left the pyramid', () {
      expect(
        watchlistDebuts(
          marked: {1},
          pool: const {},
          capsByPlayer: const {1: 4},
        ),
        isEmpty,
      );
    });

    test('is not filed for a boy nobody marked', () {
      expect(
        watchlistDebuts(
          marked: const {},
          pool: pool([boy(id: 1, age: 18, rating: 60)]),
          capsByPlayer: const {1: 9},
        ),
        isEmpty,
      );
    });
  });
}
