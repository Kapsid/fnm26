import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart' show yPostBody;
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

List<YPost> _post({
  TieLabel label = TieLabel.grudge,
  String key = 'mgrTie:12:4',
  int seed = 7,
  ResultStanding standing = ResultStanding.par,
}) => YFeed.forOpponentManager(
  manager: 'Karel Dvořák',
  label: label,
  date: DateTime(2031, 3, 20),
  key: key,
  nation: 'Norway',
  seed: seed,
  standing: standing,
);

void main() {
  test('one post before a match against a grudge', () {
    for (final label in TieLabel.values) {
      if (label == TieLabel.neutral) continue;
      final posts = _post(label: label);
      expect(posts, hasLength(1), reason: '$label');
      final p = posts.single;
      expect(p.template, YTemplate.managerTieLooms);
      expect(p.replyTo, isNull);
      expect(p.args, ['Karel Dvořák']);
      expect(p.date, DateTime(2031, 3, 20));
      for (final l in [AppLocalizationsEn(), AppLocalizationsCs()]) {
        // Names are never translated.
        expect(yPostBody(l, p), contains('Karel Dvořák'));
      }
    }
  });

  test('none for neutral', () {
    expect(_post(label: TieLabel.neutral), isEmpty);
  });

  test('four variants reachable', () {
    expect(YFeed.variantsFor(YTemplate.managerTieLooms), 4);
    final seen = <int>{};
    for (var i = 0; i < 200; i++) {
      for (final standing in ResultStanding.values) {
        final p = _post(key: 'mgrTie:$i:4', seed: i, standing: standing).single;
        seen.add(p.variant);
        // The tone follows whoever is speaking: the same account, in the
        // same mood, always reaches into the same band.
        final persona = YFeed.personaFor(
          YVoice.fan,
          'Norway',
          i,
          'mgrTie:$i:4',
        );
        expect(p.handle, persona.handle);
        final tone = YCast.toneFor(
          persona,
          standing,
          YCast.stance(persona, const []),
        );
        final (offset, size) = YCast.band(tone, 4);
        expect(p.variant, inInclusiveRange(offset, offset + size - 1));
      }
    }
    expect(seen, {0, 1, 2, 3});
    final en = AppLocalizationsEn();
    final words = {
      for (var v = 0; v < 4; v++)
        yPostBody(en, (
          voice: YVoice.fan,
          handle: '@a',
          displayName: 'A',
          template: YTemplate.managerTieLooms,
          variant: v,
          args: const ['Karel Dvořák'],
          date: DateTime(2031),
          key: 'k',
          replyTo: null,
          mood: null,
        )),
    };
    expect(words, hasLength(4));
  });

  test('the manager posts join the top of the feed', () {
    final feed = (posts: _post(key: 'old'), reserveFrom: 1);
    final extra = _post(key: 'new');
    final merged = withManagerTiePosts(feed, extra);
    expect(merged.posts.first.key, extra.first.key);
    expect(merged.posts, hasLength(2));
    expect(merged.reserveFrom, 2);
    expect(identical(withManagerTiePosts(feed, const []), feed), isTrue);
  });
}
