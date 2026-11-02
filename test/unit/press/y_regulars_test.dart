import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// The Czech feed's regulars under a result: Mařena after a hammering,
/// KudyChodíKrálík after a defeat, POŠUK shouting now and then under any
/// result. Owner-requested Czech in-jokes: a Czech feed has them, no other
/// feed ever does.
void main() {
  const marena = '@Marena';
  const kralik = '@KudyChodiKralik';
  const posuk = '@POSUK';
  const havir = '@IvanHavir';

  /// The headline of match [i], as [YFeed.forMatch] puts it first.
  YPost result(int i, YTemplate template, DateTime date) => (
    voice: YVoice.stats,
    handle: '@TheNumbersDesk',
    displayName: 'The Numbers Desk',
    template: template,
    variant: 0,
    args: const ['Norway', '0–4'],
    date: date,
    key: 'fx:$i|stats|${template.name}',
    replyTo: null,
    mood: null,
  );

  /// [count] matches, one per window (60 days apart), all [template].
  List<YPost> season(int count, YTemplate template, {int offset = 0}) => [
    for (var i = 0; i < count; i++)
      result(
        i + offset,
        template,
        DateTime(2030).add(Duration(days: i * 60)),
      ),
  ];

  Iterable<YPost> by(List<YPost> posts, String handle) =>
      posts.where((p) => p.handle == handle);

  test('never in a feed that is not Czech', () {
    final posts = [
      ...season(200, YTemplate.lostBadly),
      ...season(200, YTemplate.lost, offset: 1000),
    ];
    final out = YFeed.withRegulars(posts, czechCameos: false);
    expect(out, same(posts));
    expect(out.where((p) => p.voice == YVoice.cameo), isEmpty);
  });

  test('Mařena: about one heavy defeat in three, as a reply', () {
    final posts = season(600, YTemplate.lostBadly);
    final hers = by(
      YFeed.withRegulars(posts, czechCameos: true),
      marena,
    ).toList();
    expect(hers.length, inInclusiveRange(150, 250));
    for (final p in hers) {
      expect(p.displayName, 'Mařena');
      expect(p.template, YTemplate.cameoMarena);
      expect(p.voice, YVoice.cameo);
      final parent = posts.singleWhere((q) => q.key == p.replyTo);
      expect(YFeed.havirHeavyDefeats, contains(parent.template));
      expect(p.date, parent.date);
    }
  });

  test('Mařena never answers an ordinary defeat or a win', () {
    final posts = [
      ...season(200, YTemplate.lost),
      ...season(200, YTemplate.winRoutine, offset: 1000),
      ...season(200, YTemplate.drew, offset: 2000),
    ];
    expect(by(YFeed.withRegulars(posts, czechCameos: true), marena), isEmpty);
  });

  test('KudyChodíKrálík: about one defeat in four, never a win', () {
    final losses = season(800, YTemplate.lost);
    final his = by(
      YFeed.withRegulars(losses, czechCameos: true),
      kralik,
    ).toList();
    expect(his.length, inInclusiveRange(150, 250));
    expect(his.every((p) => p.displayName == 'KudyChodíKrálík'), isTrue);
    expect(his.every((p) => p.template == YTemplate.cameoKralik), isTrue);

    final wins = season(400, YTemplate.winTight);
    expect(by(YFeed.withRegulars(wins, czechCameos: true), kralik), isEmpty);
  });

  test('POŠUK: about one result in ten, any result, all three shouts', () {
    final posts = [
      ...season(500, YTemplate.winRoutine),
      ...season(500, YTemplate.drew, offset: 1000),
      ...season(500, YTemplate.lost, offset: 2000),
    ];
    final his = by(
      YFeed.withRegulars(posts, czechCameos: true),
      posuk,
    ).toList();
    // 1500 results, but the three seasons overlap in time, so the window
    // limit caps him at one per 60-day slot: about 500 slots, each with three
    // tries at one in ten.
    expect(his.length, inInclusiveRange(90, 190));
    final parents = {
      for (final p in his)
        posts.singleWhere((q) => q.key == p.replyTo).template,
    };
    expect(parents, containsAll([YTemplate.winRoutine, YTemplate.drew]));
    expect({for (final p in his) p.variant}, {0, 1, 2});
    expect(his.every((p) => p.displayName == 'POŠUK'), isTrue);
  });

  test('each at most once a window', () {
    // Eight defeats a window, four days apart, for five years.
    final posts = [
      for (var w = 0; w < 30; w++)
        for (var g = 0; g < 8; g++)
          result(
            w * 8 + g,
            g.isEven ? YTemplate.lostBadly : YTemplate.lost,
            DateTime(2030).add(Duration(days: w * 60 + g * 4)),
          ),
    ];
    final out = YFeed.withRegulars(posts, czechCameos: true);
    for (final handle in const [marena, kralik, posuk]) {
      final dates = [for (final p in by(out, handle)) p.date]..sort();
      expect(dates, isNotEmpty, reason: handle);
      for (var i = 1; i < dates.length; i++) {
        expect(
          dates[i].difference(dates[i - 1]),
          greaterThanOrEqualTo(YFeed.regularGap),
          reason: handle,
        );
      }
      expect(dates.length, lessThanOrEqualTo(30), reason: handle);
    }
  });

  test('Mařena never under Havíř, Králík never under Mařena', () {
    final posts = season(600, YTemplate.lostBadly);
    final out = YFeed.withRegulars(
      YFeed.withHavir(posts, czechCameos: true),
      czechCameos: true,
    );
    String parentOf(YPost p) => p.replyTo ?? p.key;
    final havirUnder = {for (final p in by(out, havir)) parentOf(p)};
    final marenaUnder = {for (final p in by(out, marena)) parentOf(p)};
    final kralikUnder = {for (final p in by(out, kralik)) parentOf(p)};
    expect(havirUnder, isNotEmpty);
    expect(marenaUnder, isNotEmpty);
    expect(kralikUnder, isNotEmpty);
    expect(marenaUnder.intersection(havirUnder), isEmpty);
    expect(kralikUnder.intersection(marenaUnder), isEmpty);
  });

  test('a save always draws them in the same places', () {
    final posts = [
      ...season(300, YTemplate.lostBadly),
      ...season(300, YTemplate.lost, offset: 1000),
    ];
    List<String> keys() => [
      for (final p in YFeed.withRegulars(posts, czechCameos: true))
        if (p.voice == YVoice.cameo) '${p.key}#${p.variant}',
    ];
    expect(keys(), isNotEmpty);
    expect(keys(), keys());
  });

  group('the words, exactly as the owner wrote them', () {
    YPost post(YTemplate t, int variant) => (
      voice: YVoice.cameo,
      handle: '@x',
      displayName: 'x',
      template: t,
      variant: variant,
      args: const <String>[],
      date: DateTime(2031),
      key: 'k',
      replyTo: null,
      mood: null,
    );
    final cs = AppLocalizationsCs();
    final en = AppLocalizationsEn();

    test('in Czech', () {
      expect(
        yPostBody(cs, post(YTemplate.cameoMarena, 0)),
        'To bych mohla trénovat i já',
      );
      expect(
        yPostBody(cs, post(YTemplate.cameoKralik, 0)),
        'Tak cos čekal hehehe, kupuj naše ZeroZero',
      );
      expect(yPostBody(cs, post(YTemplate.cameoPosuk, 0)), 'SLABOTA');
      expect(yPostBody(cs, post(YTemplate.cameoPosuk, 1)), 'TY CIWE');
      expect(yPostBody(cs, post(YTemplate.cameoPosuk, 2)), 'Nekdo do knajpy?');
    });

    test('and not in English', () {
      for (final (t, n) in const [
        (YTemplate.cameoMarena, 1),
        (YTemplate.cameoKralik, 1),
        (YTemplate.cameoPosuk, 3),
      ]) {
        for (var v = 0; v < n; v++) {
          expect(
            yPostBody(en, post(t, v)),
            isNot(yPostBody(cs, post(t, v))),
          );
        }
      }
    });
  });

  test('their profiles carry their own dispositions', () {
    for (final persona in [
      YFeed.marenaPersona,
      YFeed.kralikPersona,
      YFeed.posukPersona,
    ]) {
      expect(YFeed.czechCameos, contains(persona));
      final post = (
        voice: YVoice.cameo,
        handle: persona.handle,
        displayName: persona.displayName,
        template: YTemplate.cameoMarena,
        variant: 0,
        args: const <String>[],
        date: DateTime(2031),
        key: 'k',
        replyTo: null,
        mood: null,
      );
      expect(YFeed.personaOf(post).trait, persona.trait);
    }
  });
}
