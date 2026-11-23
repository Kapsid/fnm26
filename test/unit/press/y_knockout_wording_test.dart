import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Promo-reel run, 2026-11: the feed said "Out at World Championship Finals"
/// after a knockout tie WON (the next round's tie is drawn only once the
/// round is over, so the side briefly had nothing left to play), and replied
/// "Ugly. Three points." after a cup final, where there are no points.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  group('a knockout tie won is not an exit', () {
    YMilestone? end(String round, {required bool won}) => YFeed.endOfCampaign(
      round: round,
      competition: 'World Championship Finals',
      won: won,
      date: DateTime(2030, 7, 1),
      key: 'cmp:9',
    );

    test('won before the final, in any round and any family: no post', () {
      for (final round in ['R32', 'R16', 'QF', 'SF', 'CQF', 'CSF', 'NSF']) {
        expect(end(round, won: true), isNull, reason: round);
      }
    });

    test('lost in those rounds is still an exit', () {
      for (final round in ['R32', 'R16', 'QF', 'SF', 'CSF']) {
        expect(end(round, won: false)?.template, YTemplate.eliminated);
      }
    });

    test('the final and the third-place match still end the run', () {
      expect(end('FINAL', won: true)?.template, YTemplate.trophy);
      expect(end('3RD', won: true)?.template, YTemplate.eliminated);
    });
  });

  group('no league points outside a points match', () {
    YMatch match(YStakes stakes, int seedKey, int scored, int conceded) => (
      opponent: 'Sweden',
      nationRank: 10,
      opponentRank: 30,
      scored: scored,
      conceded: conceded,
      date: DateTime(2030, 6, 20),
      key: 'fx:$seedKey',
      competitive: stakes != YStakes.friendly,
      stakes: stakes,
      shootoutWon: null,
      away: false,
    );

    bool mentionsPoints(String s) =>
        RegExp(r'\b(points?|table)\b', caseSensitive: false).hasMatch(s) &&
        !s.toLowerCase().contains('at what point') &&
        !s.toLowerCase().contains('at some point');

    List<String> bodies(YStakes stakes) => [
      for (var k = 0; k < 400; k++)
        for (final (s, c) in const [(1, 0), (2, 1), (3, 0), (1, 1), (0, 0)])
          for (final p in YFeed.forMatch(
            plainContext(match(stakes, k, s, c)),
            nation: 'Montenegro',
            seed: k * 7 + 3,
          ))
            yPostBody(en, p),
    ];

    test('a knockout tie, a final and a friendly never talk of points', () {
      for (final stakes in [
        YStakes.knockout,
        YStakes.trophyFinal,
        YStakes.friendly,
      ]) {
        final hits = bodies(stakes).where(mentionsPoints).toSet();
        expect(hits, isEmpty, reason: '$stakes');
      }
    });

    test('a qualifier still can (the wordings are not lost)', () {
      expect(bodies(YStakes.qualifier).any(mentionsPoints), isTrue);
    });

    test('the flagged slots are exactly the wordings that say points', () {
      // Guards the slot table against the copy moving under it.
      for (final mood in YFeed.pointsReplies.keys) {
        final total = YFeed.reactionVariantsFor(mood);
        for (var v = 0; v < total; v++) {
          final p = _reply(mood, v);
          expect(
            YFeed.talksOfPoints(p),
            mentionsPoints(yPostBody(en, p)),
            reason: '$mood $v: ${yPostBody(en, p)}',
          );
        }
      }
      for (final t in YFeed.pointsWordings.keys) {
        for (var v = 0; v < YFeed.variantsFor(t); v++) {
          final p = _post(t, v);
          expect(
            YFeed.talksOfPoints(p),
            mentionsPoints(yPostBody(en, p)),
            reason: '$t $v: ${yPostBody(en, p)}',
          );
        }
      }
    });
  });
}

YPost _reply(YMood mood, int variant) => (
  voice: YVoice.fan,
  handle: 'x',
  displayName: 'x',
  template: YTemplate.reaction,
  variant: variant,
  args: const [],
  date: DateTime(2030),
  key: 'k',
  replyTo: 'p',
  mood: mood,
);

YPost _post(YTemplate t, int variant) => (
  voice: YVoice.stats,
  handle: 'x',
  displayName: 'x',
  template: t,
  variant: variant,
  args: const ['Sweden', '1–0'],
  date: DateTime(2030),
  key: 'k',
  replyTo: null,
  mood: null,
);
