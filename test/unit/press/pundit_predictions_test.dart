import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/press/pundit_predictions.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/press/pundit_prediction_service.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../story/driver.dart';

/// Before a finals tournament the pundits call it: the favourite, a dark
/// horse, and how far the manager's side goes, in a band of its own. Read
/// off the field alone, so the call is the same on every rebuild.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  // Six groups of four: ids 1..24. Strength falls with the id, and the
  // ranking follows it, except that 9 is ranked far below its squad.
  final groups = [
    for (var g = 0; g < 6; g++) [for (var i = 0; i < 4; i++) 1 + g + i * 6],
  ];
  final sides = <int, PunditSide>{
    for (var id = 1; id <= 24; id++)
      id: (
        nationId: id,
        strength: 90.0 - id,
        rank: id == 9 ? 40 : id,
      ),
  };

  PunditCall call(int mine) =>
      PunditPredictions.call(groups: groups, sides: sides, mine: mine);

  test('the favourite is the strongest side', () {
    expect(call(5).favourite, 1);
  });

  test('the dark horse is rated well above its ranking', () {
    expect(call(5).darkHorse, 9);
  });

  test('a strong side gets a deep run, the best of all the trophy', () {
    expect(call(1).mine, PredictedFinish.winner);
    expect(call(2).mine, PredictedFinish.finalist);
    expect(call(3).mine, PredictedFinish.semiFinal);
    expect(call(4).mine, PredictedFinish.semiFinal);
  });

  test('a weak side is bottom of its group', () {
    // Group 1 holds 1, 7, 13 and 19: 19 is its weakest.
    expect(call(19).mine, PredictedFinish.bottomOfGroup);
    expect(call(13).mine, PredictedFinish.outInGroup);
    expect(call(7).mine, PredictedFinish.quarterFinal);
  });

  test('a side ranked far below its squad going far is a dark horse', () {
    final c = call(9);
    expect(c.mine, PredictedFinish.firstKnockout);
    expect(c.mineDarkHorse, isFalse, reason: 'not seen past the last 16');
    final strong = PunditPredictions.call(
      groups: groups,
      sides: {
        ...sides,
        9: (nationId: 9, strength: 87.5, rank: 40),
      },
      mine: 9,
    );
    expect(strong.mine, PredictedFinish.semiFinal);
    expect(strong.mineDarkHorse, isTrue);
  });

  test('a side not in the field gets no line of its own', () {
    final c = call(99);
    expect(c.mine, isNull);
    final body = renderMsgPart(
      en,
      punditsMessageBody(
        call: c,
        nameOf: (id) => 'Nation $id',
        mine: 'San Marino',
        seed: 3,
        key: 'pundits:0:1:world:1:9:2030-1-5',
      ),
    );
    expect(body, contains('Nation 1'));
    expect(body, contains('Nation 9'));
    expect(body.split('\n\n'), hasLength(1));
  });

  test('a side in the field gets its band, in words', () {
    String words(int mine) => renderMsgPart(
      en,
      punditsMessageBody(
        call: call(mine),
        nameOf: (id) => 'Nation $id',
        mine: 'Nation $mine',
        seed: 3,
        key: 'pundits:0:1:world:1:9:2030-1-5',
      ),
    );
    final bottom = words(19);
    expect(bottom.split('\n\n'), hasLength(2));
    expect(
      bottom.split('\n\n').last,
      anyOf(
        contains(en.punditsMineBottom0('Nation 19').split(':').last.trim()),
        contains(en.punditsMineBottom1('Nation 19').split(':').last.trim()),
      ),
    );
    expect(
      words(1).split('\n\n').last,
      anyOf(
        contains(en.punditsMineWinner0('Nation 1')),
        contains(en.punditsMineWinner1('Nation 1')),
      ),
    );
  });

  test('the key carries the call and reads back', () {
    final key = PunditPredictions.key(
      cycle: 2,
      tournament: 2,
      region: 'europe',
      favourite: 11,
      darkHorse: 40,
      date: DateTime(2032, 3, 14),
    );
    expect(key, startsWith(PunditPredictions.keyPrefix(2, 2)));
    final back = PunditPredictions.decodeKey(key)!;
    expect(back.region, 'europe');
    expect(back.favourite, 11);
    expect(back.darkHorse, 40);
    expect(back.date, DateTime(2032, 3, 14));
    expect(PunditPredictions.decodeKey('warmUpOffer:1:2:3'), isNull);
  });

  test('on Y two pundits name the favourite and the dark horse', () {
    final posts = YFeed.forPundits(
      competition: 'European Championship',
      favourite: 'Spain',
      darkHorse: 'Denmark',
      date: DateTime(2032, 3, 14),
      key: 'pundits:2:2:europe:11:40:2032-3-14',
      nation: 'Montenegro',
      seed: 3,
    );
    expect(posts, hasLength(2));
    for (final p in posts) {
      final words = yPostBody(en, p);
      expect(words, contains('Spain'));
      expect(words, contains('Denmark'));
      expect(words, contains('European Championship'));
    }
    expect(posts.map((p) => p.variant).toSet(), hasLength(2));
  });

  test(
    'before the finals the pundits are filed once, with his side in them',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 3);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);
      final svc = c.read(punditPredictionServiceProvider);
      Future<List<String>> keys() async => [
        for (final k in await comp.messageKeys(d.careerId))
          if (k.startsWith('pundits:')) k,
      ];
      for (var i = 0; i < 4000; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(2028, 7))) break;
        if ((await keys()).isNotEmpty) break;
        await d.step();
      }
      final filed = await keys();
      expect(filed, hasLength(1), reason: 'the Euro 2028 call');
      // Asked again, nothing new.
      await svc.fileMessages(d.careerId);
      expect(await keys(), filed);
      final message = (await comp.messages(
        d.careerId,
      )).singleWhere((m) => m.category == 'pundits');
      final spec = decodeMessageSpec(message.spec)!;
      final body = renderMsgPart(en, spec.body!);
      final call = PunditPredictions.decodeKey(filed.single)!;
      expect(body, contains(nationById[call.favourite]!.name));
      expect(
        body.split('\n\n'),
        hasLength(2),
        reason: 'a qualified side hears where it will finish',
      );
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}
