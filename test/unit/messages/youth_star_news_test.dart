import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/features/messages/youth_star_news.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

const _nation = 1;

Fixture _fx(
  int id,
  DateTime date, {
  int opponent = 2,
  bool played = true,
  String? round,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: date,
  homeNationId: _nation,
  awayNationId: opponent,
  round: round,
  played: played,
  homeScore: played ? 1 : null,
  awayScore: played ? 0 : null,
);

Player _boy(
  int id, {
  int age = 19,
  PlayerPosition position = PlayerPosition.st,
  int physical = 60,
  int technical = 55,
  int stamina = 50,
}) => Player(
  id: id,
  nationId: _nation,
  name: 'Boy$id',
  age: age,
  position: position,
  attributes: PlayerAttributes(
    physical: physical,
    technical: technical,
    stamina: stamina,
  ),
);

List<Player> _pyramid() => [
  for (var i = 0; i < 30; i++)
    _boy(
      1000 + i,
      age: 11 + i % 10,
      position: PlayerPosition.values[i % PlayerPosition.values.length],
      physical: 40 + (i * 7) % 30,
      technical: 40 + (i * 11) % 30,
      stamina: 40 + (i * 13) % 30,
    ),
];

void main() {
  group('windows', () {
    final today = DateTime(2027, 4, 1);

    test('groups a fortnight of fixtures into one window, opponent last', () {
      final windows = recentYouthWindows(
        fixtures: [
          _fx(1, DateTime(2027, 3, 20), opponent: 5),
          _fx(2, DateTime(2027, 3, 24), opponent: 6),
        ],
        nationId: _nation,
        today: today,
      );
      expect(windows, hasLength(1));
      expect(windows.single.key, '20270320');
      expect(windows.single.opponentId, 6);
    });

    test('skips unfinished, finals-only and long-gone windows', () {
      final windows = recentYouthWindows(
        fixtures: [
          // Long gone: before the look-back.
          _fx(1, DateTime(2026, 6, 1)),
          // A finals tournament: the youth sides are not in it.
          _fx(2, DateTime(2026, 12, 1), round: 'GROUP'),
          // Unfinished window.
          _fx(3, DateTime(2027, 3, 28)),
          _fx(4, DateTime(2027, 4, 3), played: false),
        ],
        nationId: _nation,
        today: today,
      );
      expect(windows, isEmpty);
    });
  });

  group('frequency', () {
    test('about half the windows bring a report, never more', () {
      var fired = 0;
      for (var i = 0; i < 400; i++) {
        if (youthNewsFires('w$i', 42)) fired++;
      }
      // Occasional: well short of every window, well clear of never.
      expect(fired, inInclusiveRange(140, 260));
    });

    test('a window already reported is never reported again', () {
      final filed = {youthNewsKey('20270320', 1003), 'cycle:0'};
      expect(youthNewsFiled(filed, '20270320'), isTrue);
      expect(youthNewsFiled(filed, '20270601'), isFalse);
    });

    test('the two latest featured boys sit the next one out', () {
      final featured = recentlyFeatured({
        youthNewsKey('20260320', 1),
        youthNewsKey('20261010', 2),
        youthNewsKey('20270320', 3),
        'watch:3',
      });
      expect(featured, {2, 3});
    });
  });

  group('the story', () {
    YouthStandout? story({
      String window = '20270320',
      int seed = 7,
      List<Player>? youth,
      int bar = 70,
      Set<int> excluded = const {},
    }) => youthStandout(
      windowKey: window,
      saveSeed: seed,
      youth: youth ?? _pyramid(),
      squadBar: bar,
      opponent: 'Greece',
      excluded: excluded,
    );

    test('is deterministic for the same save and window', () {
      final a = story()!;
      final b = story()!;
      expect(a.playerId, b.playerId);
      expect(
        encodeMessageSpec(title: a.title, body: a.body),
        encodeMessageSpec(title: b.title, body: b.body),
      );
    });

    test('varies across windows and saves', () {
      final picks = {
        for (var i = 0; i < 40; i++) story(window: 'w$i', seed: i)!.playerId,
      };
      expect(picks.length, greaterThan(1));
    });

    test('names the boy, his age group, the opponent and his strengths', () {
      final youth = _pyramid();
      final en = AppLocalizationsEn();
      final cs = AppLocalizationsCs();
      for (var i = 0; i < 30; i++) {
        final s = story(window: 'w$i', seed: i, youth: youth)!;
        final boy = youth.firstWhere((p) => p.id == s.playerId);
        final body = renderMsgPart(en, s.body);
        expect(body, contains(boy.name));
        expect(body, contains(YouthLevel.forAge(boy.age)!.label));
        expect(body, contains('Greece'));
        expect(body, contains(renderMsgKey(en, MsgText(strengthKey(boy)))));
        expect(body, isNot(contains('{')));
        expect(body, isNot(contains('—')));
        expect(renderMsgPart(cs, s.body), contains(boy.name));
        expect(renderMsgPart(en, s.title), contains(boy.name));
        // Only an under-17 or older is reported on.
        expect(boy.age, greaterThanOrEqualTo(kYouthNewsMinAge));
        // A keeper keeps clean sheets; he does not score.
        if (boy.category == PositionCategory.goalkeeper) {
          expect(s.feat, isNot(YouthFeat.goals));
          expect(s.feat, isNot(YouthFeat.assists));
        }
        expect(s.readiness, readinessOf(boy.overall, 70));
      }
    });

    test('the strength line follows his best attribute and position', () {
      expect(
        strengthKey(_boy(1, position: PlayerPosition.gk, physical: 80)),
        MsgKey.newsYouthStrengthGkPhysical,
      );
      expect(
        strengthKey(
          _boy(2, position: PlayerPosition.cm, technical: 80, physical: 50),
        ),
        MsgKey.newsYouthStrengthMidTechnical,
      );
      expect(
        strengthKey(
          _boy(3, position: PlayerPosition.st, stamina: 90, physical: 50),
        ),
        MsgKey.newsYouthStrengthFwdStamina,
      );
    });

    test('readiness reads the gap to the senior squad', () {
      expect(readinessOf(72, 70), YouthReadiness.ready);
      expect(readinessOf(67, 70), YouthReadiness.close);
      expect(readinessOf(62, 70), YouthReadiness.growing);
      expect(readinessOf(50, 70), YouthReadiness.raw);
      expect(
        seniorSquadBar([for (var i = 0; i < 30; i++) _boy(i, physical: 90)]),
        greaterThan(0),
      );
    });

    test('skips the boys already in the senior picture', () {
      final youth = [_boy(1, age: 19), _boy(2, age: 18)];
      expect(story(youth: youth, excluded: {1})!.playerId, 2);
      expect(story(youth: youth, excluded: {1, 2}), isNull);
      // And the under-15s are watched, not written about.
      expect(story(youth: [_boy(3, age: 13)]), isNull);
    });
  });
}
