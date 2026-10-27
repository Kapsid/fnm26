import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// What Y says about a camp scandal, and who says it.
///
/// @IShowSlowness is under every scandal in every language. Tomáš Ujfaloči
/// and Pitomo Lžimberský are Czech cameos the owner asked for, and Ivan Havíř
/// turns up rarely after a big disappointment: a Czech feed has them, and no
/// other feed ever does.
void main() {
  final when = DateTime(2031, 9, 2);

  List<YPost> scandal({
    ScandalChoice? choice,
    bool czech = false,
    ScandalKind kind = ScandalKind.party,
  }) => YFeed.forScandal(
    kind: kind,
    playerName: 'Jan Novák',
    choice: choice,
    date: when,
    key: 'scandal:1:42',
    nation: 'Czechia',
    seed: 9,
    czechCameos: czech,
  );

  Iterable<YPost> by(List<YPost> posts, String handle) =>
      posts.where((p) => p.handle == handle);

  const streamer = '@IShowSlowness';
  const ujfaloci = '@TomasUjfaloci';
  const lzimbersky = '@PitomoLzimbersky';
  const havir = '@IvanHavir';

  test('the story breaks: the wire first, then the replies under it', () {
    final posts = scandal();
    final story = posts.first;
    expect(story.voice, YVoice.breaking);
    expect(story.template, YTemplate.scandalParty);
    expect(story.replyTo, isNull);
    expect(story.args, ['Jan Novák', 'Novák']);
    final replies = posts.where((p) => p.replyTo != null);
    expect(replies, isNotEmpty);
    expect(replies.every((p) => p.replyTo == story.key), isTrue);
  });

  test('each kind tells its own story', () {
    expect(
      {for (final k in ScandalKind.values) scandal(kind: k).first.template},
      YFeed.scandalTemplates,
    );
  });

  test('@IShowSlowness is under every scandal, in English too', () {
    for (final choice in [null, ...ScandalChoice.values]) {
      final posts = scandal(choice: choice);
      final his = by(posts, streamer).toList();
      expect(his, isNotEmpty, reason: '$choice');
      expect(his.first.displayName, 'IShowSlowness');
      expect(his.first.voice, YVoice.streamer);
      expect(YFeed.personaOf(his.first).trait.name, 'streamer');
    }
    expect(
      by(
        scandal(choice: ScandalChoice.sentHome),
        streamer,
      ).map((p) => p.template),
      containsAll([YTemplate.streamerBreaks, YTemplate.streamerSentHome]),
    );
    expect(
      by(scandal(choice: ScandalChoice.kept), streamer).map((p) => p.template),
      containsAll([YTemplate.streamerBreaks, YTemplate.streamerKept]),
    );
  });

  test('his words keep the caps and the emoji, in Czech as in English', () {
    final en = AppLocalizationsEn();
    final cs = AppLocalizationsCs();
    for (final p in by(scandal(choice: ScandalChoice.kept), streamer)) {
      for (final l in [en, cs]) {
        final text = yPostBody(l, p);
        expect(text, text.toUpperCase());
        expect(text, matches(RegExp('[😭🔥💀🤯]')));
      }
    }
  });

  test('sent home and kept draw different rooms', () {
    final home = scandal(choice: ScandalChoice.sentHome);
    final kept = scandal(choice: ScandalChoice.kept);
    expect(
      home.where((p) => p.template == YTemplate.scandalSentHome),
      isNotEmpty,
    );
    expect(home.where((p) => p.template == YTemplate.scandalKept), isEmpty);
    expect(kept.where((p) => p.template == YTemplate.scandalKept), isNotEmpty);
    expect(kept.where((p) => p.template == YTemplate.scandalSentHome), isEmpty);
    // The rival turns up to mock a man kept, and is not interested in one
    // sent home.
    expect(kept.where((p) => p.voice == YVoice.rival), isNotEmpty);
    expect(home.where((p) => p.voice == YVoice.rival), isEmpty);
    // Nothing about the decision before there is one.
    expect(
      scandal().where(
        (p) =>
            p.template == YTemplate.scandalSentHome ||
            p.template == YTemplate.scandalKept,
      ),
      isEmpty,
    );
  });

  test('a Czech feed has Ujfaloči and Lžimberský; no other feed does', () {
    for (final choice in [null, ...ScandalChoice.values]) {
      final en = scandal(choice: choice);
      expect(by(en, ujfaloci), isEmpty);
      expect(by(en, lzimbersky), isEmpty);
      expect(en.where((p) => p.voice == YVoice.cameo), isEmpty);

      final cs = scandal(choice: choice, czech: true);
      final u = by(cs, ujfaloci).single;
      expect(u.displayName, 'Tomáš Ujfaloči');
      expect(
        yPostBody(AppLocalizationsCs(), u),
        'Nic jsem neplatil a ta částka taky nesouhlasí',
      );
      expect(u.replyTo, cs.first.key);
      final lz = by(cs, lzimbersky).toList();
      if (choice == null) {
        expect(lz, isEmpty, reason: 'he defends a decision, not a rumour');
      } else {
        expect(lz.single.displayName, 'Pitomo Lžimberský');
        expect(
          lz.single.template,
          choice == ScandalChoice.sentHome
              ? YTemplate.cameoLzimberskyHome
              : YTemplate.cameoLzimberskyKept,
        );
      }
    }
  });

  test('every scandal post has words in both languages', () {
    final en = AppLocalizationsEn();
    final cs = AppLocalizationsCs();
    for (final kind in ScandalKind.values) {
      for (final choice in [null, ...ScandalChoice.values]) {
        for (final p in scandal(kind: kind, choice: choice, czech: true)) {
          expect(yPostBody(en, p).trim(), isNotEmpty);
          expect(yPostBody(cs, p).trim(), isNotEmpty);
        }
      }
    }
    // And every wording of every new template, not just the ones drawn.
    for (final t in [
      ...YFeed.scandalTemplates,
      YTemplate.scandalSentHome,
      YTemplate.scandalKept,
      YTemplate.streamerBreaks,
      YTemplate.streamerSentHome,
      YTemplate.streamerKept,
      YTemplate.cameoUjfaloci,
      YTemplate.cameoHavir,
      YTemplate.cameoLzimberskyHome,
      YTemplate.cameoLzimberskyKept,
    ]) {
      for (var v = 0; v < YFeed.variantsFor(t); v++) {
        final p = scandal().first;
        final post = (
          voice: p.voice,
          handle: p.handle,
          displayName: p.displayName,
          template: t,
          variant: v,
          args: p.args,
          date: p.date,
          key: p.key,
          replyTo: null,
          mood: null,
        );
        expect(yPostBody(cs, post).trim(), isNotEmpty, reason: '$t $v');
        expect(yPostBody(en, post).trim(), isNotEmpty, reason: '$t $v');
      }
    }
  });

  group('Ivan Havíř', () {
    Fixture f(
      int id,
      int comp,
      DateTime date,
      int home,
      int away, {
      String? round,
      bool played = true,
    }) => Fixture(
      id: id,
      careerId: 1,
      competitionId: comp,
      matchday: 1,
      date: date,
      homeNationId: home,
      awayNationId: away,
      round: round,
      played: played,
      homeScore: played ? 0 : null,
      awayScore: played ? 1 : null,
    );

    // Nation 1 plays a qualifying group (competition 10) with 2 and 3; 2
    // goes to the finals (competition 20), 1 does not.
    final qualifiers = [
      f(1, 10, DateTime(2033, 9, 5), 1, 2, round: 'CQ'),
      f(2, 10, DateTime(2033, 10, 9), 3, 1, round: 'CQ'),
      f(3, 10, DateTime(2033, 11, 14), 2, 3, round: 'CQ'),
    ];
    final finals = [
      f(4, 20, DateTime(2034, 6, 12), 2, 9, round: 'CGROUP', played: false),
    ];
    // Somebody else's continental finals: none of 1's group is in it.
    final elsewhere = [
      f(5, 30, DateTime(2034, 6, 20), 7, 8, round: 'CGROUP', played: false),
    ];

    test('a failed qualification is read off the world', () {
      final misses = YTournaments.missedQualifications(
        nationFixtures: [qualifiers[0], qualifiers[1]],
        worldFixtures: [...qualifiers, ...finals, ...elsewhere],
        nationId: 1,
      );
      expect(misses, hasLength(1));
      expect(misses.single.key, 'miss:20');
      expect(misses.single.date, DateTime(2033, 10, 9));
    });

    test('nothing before the finals exist, nothing for a qualifier', () {
      expect(
        YTournaments.missedQualifications(
          nationFixtures: [qualifiers[0], qualifiers[1]],
          worldFixtures: [...qualifiers, ...elsewhere],
          nationId: 1,
        ),
        isEmpty,
      );
      expect(
        YTournaments.missedQualifications(
          nationFixtures: [qualifiers[0], qualifiers[2], finals.single],
          worldFixtures: [...qualifiers, ...finals],
          nationId: 2,
        ),
        isEmpty,
      );
    });

    test(
      'he turns up in Czech on a failed qualification, never in English',
      () {
        final misses = YTournaments.missedQualifications(
          nationFixtures: [qualifiers[0], qualifiers[1]],
          worldFixtures: [...qualifiers, ...finals],
          nationId: 1,
        );
        final cs = YFeed.withHavir(
          const [],
          czechCameos: true,
          misses: misses,
        );
        final his = by(cs, havir).single;
        expect(his.displayName, 'Ivan Havíř');
        expect(his.template, YTemplate.cameoHavir);
        expect(his.replyTo, isNull);
        expect(his.date, DateTime(2033, 10, 9));
        expect(yPostBody(AppLocalizationsCs(), his), isNotEmpty);

        final en = YFeed.withHavir(
          const [],
          czechCameos: false,
          misses: misses,
        );
        expect(by(en, havir), isEmpty);
      },
    );

    test('at most once a window, and under a scandal in Czech', () {
      final story = scandal(czech: true);
      final misses = [
        (date: when.add(const Duration(days: 3)), key: 'miss:1'),
        (date: when.add(const Duration(days: 200)), key: 'miss:2'),
      ];
      final out = YFeed.withHavir(story, czechCameos: true, misses: misses);
      final his = by(out, havir).toList();
      expect(his, hasLength(2), reason: 'the scandal, then a window later');
      expect(his.first.replyTo, story.first.key);
      expect(his.last.key, startsWith('miss:2'));
      expect(by(YFeed.withHavir(story, czechCameos: false), havir), isEmpty);
    });

    test('a weak side losing heavily every window: rare all the same', () {
      // Two hammerings every window for four years.
      final posts = <YPost>[
        for (var w = 0; w < 24; w++)
          for (var g = 0; g < 2; g++)
            (
              voice: YVoice.breaking,
              handle: '@TheWire',
              displayName: 'The Wire',
              template: YTemplate.lostBadly,
              variant: 0,
              args: const <String>[],
              date: DateTime(2030).add(Duration(days: w * 60 + g * 3)),
              key: 'fx:${w * 2 + g}|breaking|lostBadly',
              replyTo: null,
              mood: null,
            ),
      ];
      final his = by(YFeed.withHavir(posts, czechCameos: true), havir).toList();
      expect(his.length, lessThanOrEqualTo(4), reason: 'one a year at most');
      for (var i = 1; i < his.length; i++) {
        expect(
          his[i].date.difference(his[i - 1].date).inDays,
          greaterThanOrEqualTo(365),
        );
      }
    });

    test('a hammering never crowds out an exit', () {
      final hammering = (
        voice: YVoice.breaking,
        handle: '@TheWire',
        displayName: 'The Wire',
        template: YTemplate.lostBadly,
        variant: 0,
        args: const <String>[],
        date: DateTime(2034, 6, 1),
        key: 'fx:0|breaking|lostBadly',
        replyTo: null,
        mood: null,
      );
      final misses = [(date: DateTime(2034, 6, 10), key: 'miss:5')];
      final his = by(
        YFeed.withHavir([hammering], czechCameos: true, misses: misses),
        havir,
      ).toList();
      expect(his.map((p) => p.key), contains(startsWith('miss:5')));
    });

    test('under a scandal he only says what fits before a match', () {
      for (var i = 0; i < 60; i++) {
        final story = YFeed.forScandal(
          kind: ScandalKind.casino,
          playerName: 'Jan Novák',
          choice: null,
          date: when,
          key: 'scandal:$i:42',
          nation: 'Czechia',
          seed: 9,
          czechCameos: true,
        );
        final his = by(YFeed.withHavir(story, czechCameos: true), havir).single;
        expect(YFeed.havirScandalLines, contains(his.variant));
      }
    });

    test('his signature line is his, and Czech only', () {
      final post = (
        voice: YVoice.cameo,
        handle: havir,
        displayName: 'Ivan Havíř',
        template: YTemplate.cameoHavir,
        variant: 0,
        args: const <String>[],
        date: when,
        key: 'k',
        replyTo: null,
        mood: null,
      );
      expect(yPostBody(AppLocalizationsCs(), post), 'Kapříci uplavali.');
      expect(yPostBody(AppLocalizationsEn(), post), isNot(contains('Kap')));
    });
  });
}
