import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/club_label.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/l10n/app_localizations.dart';

AppLocalizations _l(String code) => lookupAppLocalizations(Locale(code));

WorldPack _pack({
  Map<String, String> clubs = const {},
  Map<String, String> competitions = const {},
  Map<String, String> sponsors = const {},
  Map<String, String> stadiums = const {},
  Map<String, String> yAccounts = const {},
  Map<int, PackReporter> reporters = const {},
  Map<int, ({String name, String code})> nations = const {},
  List<PackClub> addedClubs = const [],
  List<PackSponsor> addedSponsors = const [],
  List<PackYAccount> addedYAccounts = const [],
  Map<String, Map<String, String>> localized = const {},
}) => WorldPack(
  uuid: 'lang',
  name: 'Lang',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  clubs: clubs,
  competitions: competitions,
  sponsors: sponsors,
  stadiums: stadiums,
  yAccounts: yAccounts,
  reporters: reporters,
  nations: nations,
  addedClubs: addedClubs,
  addedSponsors: addedSponsors,
  addedYAccounts: addedYAccounts,
  localized: localized,
);

/// [body] with the screens on [world] in [language], as the router mirrors
/// it.
void _shown(WorldPack world, String language, void Function() body) {
  ActiveWorld.current = ActiveWorld(world).inLanguage(language);
  try {
    body();
  } finally {
    ActiveWorld.current = ActiveWorld.none;
  }
}

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  test("a competition with main 'Pohár' and cs 'Pohár Hamburgerů': cs shows "
      'the cs value, de shows Pohár', () {
    final world = _pack(
      competitions: const {'European Championship': 'Pohár'},
      localized: {
        PackPaths.competition('European Championship'): {
          'cs': 'Pohár Hamburgerů',
        },
      },
    );
    _shown(world, 'cs', () {
      expect(
        competitionLabel(_l('cs'), 'European Championship'),
        'Pohár Hamburgerů',
      );
    });
    _shown(world, 'de', () {
      expect(competitionLabel(_l('de'), 'European Championship'), 'Pohár');
    });
    _shown(world, 'en', () {
      expect(competitionLabel(_l('en'), 'European Championship'), 'Pohár');
    });
  });

  test("cs-only value with no main: cs shows it, de shows the game's German "
      'name', () {
    final world = _pack(
      localized: {
        PackPaths.competition('European Championship'): {
          'cs': 'Pohár Hamburgerů',
        },
      },
    );
    _shown(world, 'cs', () {
      expect(
        competitionLabel(_l('cs'), 'European Championship'),
        'Pohár Hamburgerů',
      );
      // Its qualifiers are named after it too.
      expect(
        competitionLabel(_l('cs'), 'European Championship Qualifiers'),
        _l('cs').compQualifiers('Pohár Hamburgerů'),
      );
    });
    _shown(world, 'de', () {
      expect(
        competitionLabel(_l('de'), 'European Championship'),
        _l('de').compEuropeanChampionship,
      );
    });
  });

  test('a club renamed only for ja shows in ja on the squad screen and as '
      'the original elsewhere', () {
    final original = ClubService.leagueClubs('esp').first;
    final renamed = ClubService.leagueClubs('esp')[1];
    const added = PackClub(
      id: kPackAddedIdBase,
      name: 'Burger FC',
      country: 'esp',
    );
    final world = _pack(
      clubs: {renamed: 'Grill United'},
      addedClubs: const [added],
      localized: {
        PackPaths.club(original): {'ja': 'バーガー'},
        // A renamed club is known at runtime by its new main name.
        PackPaths.club(renamed): {'ja': 'グリル'},
        PackPaths.addedClub(added.id): {'ja': 'バーガーFC'},
      },
    );
    _shown(world, 'ja', () {
      expect(clubName(_l('ja'), original), 'バーガー');
      expect(clubName(_l('ja'), 'Grill United'), 'グリル');
      expect(clubName(_l('ja'), 'Burger FC'), 'バーガーFC');
      expect(
        clubName(_l('ja'), ClubService.freeAgent),
        _l('ja').editorPlayerFreeAgent,
      );
    });
    for (final code in ['en', 'cs', 'de']) {
      _shown(world, code, () {
        expect(clubName(_l(code), original), original, reason: code);
        expect(clubName(_l(code), 'Grill United'), 'Grill United');
        expect(clubName(_l(code), 'Burger FC'), 'Burger FC');
      });
    }
  });

  test('two clubs under one runtime name: the lowest path wins', () {
    final a = ClubService.leagueClubs('esp')[0];
    final b = ClubService.leagueClubs('esp')[1];
    final world = _pack(
      clubs: {b: a},
      localized: {
        PackPaths.club(a): {'ja': 'A'},
        PackPaths.club(b): {'ja': 'B'},
      },
    );
    final paths = [PackPaths.club(a), PackPaths.club(b)]..sort();
    expect(
      ActiveWorld(world).inLanguage('ja').clubLabel(a),
      paths.first == PackPaths.club(a) ? 'A' : 'B',
    );
  });

  test('reporter outlet localized without the name keeps the main name', () {
    final world = _pack(
      reporters: const {2: PackReporter(name: 'Ann Bun', outlet: 'Grill Post')},
      localized: {
        PackPaths.reporterOutlet(2): {'cs': 'Grilovací listy'},
        PackPaths.reporterName(3): {'cs': 'Jana'},
      },
    );
    final cs = ActiveWorld(world).inLanguage('cs');
    expect(cs.reporter(2)?.name, 'Ann Bun');
    expect(cs.reporter(2)?.outlet, 'Grilovací listy');
    // Only a localized name: the outlet stays the game's (blank here).
    expect(cs.reporter(3)?.name, 'Jana');
    expect(ActiveWorld.textOrNull(cs.reporter(3)?.outlet), isNull);
    final de = ActiveWorld(world).inLanguage('de');
    expect(de.reporter(2)?.outlet, 'Grill Post');
    expect(de.reporter(3), isNull);
  });

  test('sponsors, stadiums and Y accounts: language, then main, then the '
      "game's", () {
    final world = _pack(
      sponsors: {SponsorBrand.miners.name: 'Diggers'},
      stadiums: const {'50:Madrid': 'Bun Arena'},
      yAccounts: const {'@fan': '@griller'},
      localized: {
        PackPaths.sponsor(SponsorBrand.miners.name): {'cs': 'Kopáči'},
        PackPaths.sponsor(SponsorBrand.moth.name): {'cs': 'Svižník'},
        PackPaths.stadium('50:Madrid'): {'cs': 'Housková aréna'},
        PackPaths.stadium('50:Seville'): {'cs': 'Sevilla'},
        PackPaths.yAccount('@fan'): {'cs': '@grilovač'},
      },
    );
    final cs = ActiveWorld(world).inLanguage('cs');
    expect(cs.sponsor(SponsorBrand.miners.name), 'Kopáči');
    expect(cs.sponsor(SponsorBrand.moth.name), 'Svižník');
    expect(cs.stadium(50, 'Madrid'), 'Housková aréna');
    expect(cs.stadium(50, 'Seville'), 'Sevilla');
    expect(cs.yAccount('@fan'), '@grilovač');
    final de = ActiveWorld(world).inLanguage('de');
    expect(de.sponsor(SponsorBrand.miners.name), 'Diggers');
    expect(de.sponsor(SponsorBrand.moth.name), isNull);
    expect(de.stadium(50, 'Madrid'), 'Bun Arena');
    expect(de.stadium(50, 'Seville'), isNull);
    expect(de.yAccount('@fan'), '@griller');

    ActiveWorld.current = cs;
    expect(
      sponsorBrandName(_l('cs'), Sponsor.of(SponsorBrand.moth)),
      'Svižník',
    );
    ActiveWorld.current = ActiveWorld.none;
    final game = sponsorBrandName(_l('de'), Sponsor.of(SponsorBrand.moth));
    ActiveWorld.current = de;
    expect(sponsorBrandName(_l('de'), Sponsor.of(SponsorBrand.moth)), game);
  });

  test("added sponsor and Y names: the world's own, in its language", () {
    const sponsor = PackSponsor(
      id: kPackAddedIdBase,
      name: 'Grill Co',
      deal: SponsorDeal.risky,
      industry: 'miners',
    );
    const y = PackYAccount(
      id: kPackAddedIdBase + 1,
      name: 'Grill Fan',
      voice: YVoice.fan,
    );
    final world = _pack(
      addedSponsors: const [sponsor],
      addedYAccounts: const [y],
      localized: {
        PackPaths.addedSponsor(sponsor.id): {'cs': 'Gril s.r.o.'},
        PackPaths.addedSponsorDescription(sponsor.id): {'cs': 'Z grilu.'},
        PackPaths.addedY(y.id): {'cs': 'Grilovač'},
      },
    );
    final cs = ActiveWorld(world).inLanguage('cs');
    expect(cs.addedSponsorName(sponsor.id, world: 'lang'), 'Gril s.r.o.');
    expect(cs.addedSponsorDescription(sponsor.id, world: 'lang'), 'Z grilu.');
    expect(cs.addedYName(y.id, world: 'lang'), 'Grilovač');
    // Another world's item under the same id: nothing.
    expect(cs.addedSponsorName(sponsor.id, world: 'other'), isNull);
    expect(cs.addedYName(y.id, world: 'other'), isNull);
    final de = ActiveWorld(world).inLanguage('de');
    expect(de.addedSponsorName(sponsor.id, world: 'lang'), isNull);
    expect(de.addedYName(y.id, world: 'lang'), isNull);

    ActiveWorld.current = cs;
    final s = Sponsor.added(sponsor, world: 'lang');
    expect(sponsorBrandName(_l('cs'), s), 'Gril s.r.o.');
    expect(sponsorFlavour(_l('cs'), s), 'Z grilu.');
    ActiveWorld.current = de;
    expect(sponsorBrandName(_l('de'), s), 'Grill Co');
  });

  test('nation names are not localized, and unknown languages never show', () {
    final world = _pack(
      nations: const {50: (name: 'Burgerland', code: 'BGL')},
      competitions: const {'European Championship': 'Pohár'},
      localized: {
        PackPaths.competition('European Championship'): {'xx': 'Neznámý'},
      },
    );
    final xx = ActiveWorld(world).inLanguage('xx');
    expect(xx.competition('European Championship'), 'Pohár');
    expect(xx.nationName(50), 'Burgerland');
    expect(ActiveWorld(world).inLanguage('cs').nationName(50), 'Burgerland');
    expect(PackPaths.roots, isNot(contains('nations')));
  });

  test('ActiveWorld.none.inLanguage(x) is none', () {
    for (final code in ['en', 'cs', 'ja', 'xx']) {
      expect(
        identical(ActiveWorld.none.inLanguage(code), ActiveWorld.none),
        isTrue,
      );
    }
  });

  test('a language view keeps the world: trophies, codes, nation names', () {
    final base = ActiveWorld(
      _pack(nations: const {50: (name: 'Burgerland', code: 'BGL')}),
      realCodes: const {50: 'ESP'},
    );
    final cs = base.inLanguage('cs');
    expect(cs.isDefault, isFalse);
    expect(cs.pack, same(base.pack));
    expect(cs.codeLabel('ESP'), 'BGL');
    expect(cs.nationCode(50), 'BGL');
  });

  group('Y persona keys on the account, not its shown name', () {
    // A built-in account renamed, and an added one, both shown in Czech as
    // 'Pepík': the profile must still read each by its own name.
    const builtIn = 'Old Fan Account';
    final addedName = [
      'Burger Baron',
      'Patty Prophet',
      'Bun Whisperer',
      'Grill Master Supreme',
      'Sesame Seed',
    ].firstWhere((n) => YCast.traitFor(n) != YCast.traitFor(builtIn));
    final added = PackYAccount(
      id: kPackAddedIdBase,
      name: addedName,
      voice: YVoice.fan,
    );
    final world = _pack(
      yAccounts: const {builtIn: 'Renamed Fan'},
      addedYAccounts: [added],
      localized: {
        PackPaths.yAccount(builtIn): {'cs': 'Pepík'},
        PackPaths.addedY(added.id): {'cs': 'Pepík'},
      },
    );

    YPost post(String name, String key) => (
      voice: YVoice.fan,
      handle: YFeed.handleFor(name),
      displayName: name,
      template: YTemplate.values.first,
      variant: 0,
      args: const <String>[],
      date: DateTime(2027),
      key: key,
      replyTo: null,
      mood: null,
    );

    test('renamedIn shows both as Pepík; each profile keeps its trait', () {
      final cs = ActiveWorld(world).inLanguage('cs');
      final feed = YFeed.renamedIn(
        (posts: [post(builtIn, 'a'), post(addedName, 'b')], reserveFrom: null),
        cs,
        added: [added],
        addedWorld: 'lang',
      );
      expect(feed.posts.map((p) => p.displayName), ['Pepík', 'Pepík']);
      ActiveWorld.current = cs;
      expect(
        YFeed.personaOf(feed.posts[0]).trait,
        YCast.traitFor(builtIn),
      );
      expect(
        YFeed.personaOf(feed.posts[1]).trait,
        YCast.traitFor(addedName),
      );
      // In German the main names show, and still read right.
      final de = ActiveWorld(world).inLanguage('de');
      final deFeed = YFeed.renamedIn(
        (posts: [post(builtIn, 'a'), post(addedName, 'b')], reserveFrom: null),
        de,
        added: [added],
        addedWorld: 'lang',
      );
      expect(deFeed.posts.map((p) => p.displayName), [
        'Renamed Fan',
        addedName,
      ]);
      ActiveWorld.current = de;
      expect(YFeed.personaOf(deFeed.posts[0]).trait, YCast.traitFor(builtIn));
      expect(YFeed.personaOf(deFeed.posts[1]).trait, YCast.traitFor(addedName));
    });

    test('an unrenamed post shown under a name another account takes in '
        'this language keeps its own trait', () {
      final cs = ActiveWorld(world).inLanguage('cs');
      // A game account whose own name is what the others show as.
      final feed = YFeed.renamedIn(
        (posts: [post('Pepík', 'c')], reserveFrom: null),
        cs,
        added: [added],
        addedWorld: 'lang',
      );
      ActiveWorld.current = cs;
      expect(YFeed.personaOf(feed.posts.single).trait, YCast.traitFor('Pepík'));
    });

    test('the pack flags the per-language clash as a NameClash', () {
      final issues = PackRules.issues(world);
      final clashes = {
        for (final i in issues)
          if (i is NameClash) i.where,
      };
      expect(
        clashes,
        containsAll([
          'localized.${PackPaths.addedY(added.id)}.cs',
          'localized.${PackPaths.yAccount(builtIn)}.cs',
        ]),
      );
      // Apart in every language: no clash.
      final apart = _pack(
        yAccounts: const {builtIn: 'Renamed Fan'},
        addedYAccounts: [added],
        localized: {
          PackPaths.yAccount(builtIn): {'cs': 'Pepík'},
          PackPaths.addedY(added.id): {'cs': 'Pepa', 'de': 'Pepík'},
        },
      );
      expect(
        PackRules.issues(apart).whereType<NameClash>().where(
          (i) => i.where.startsWith('localized.'),
        ),
        isEmpty,
      );
    });

    test('an added name taking a game account name in one language is '
        'flagged', () {
      final game = YFeed.namedAccounts.first;
      final p = _pack(
        addedYAccounts: [added],
        localized: {
          PackPaths.addedY(added.id): {'ja': game},
        },
      );
      expect(
        PackRules.issues(p).whereType<NameClash>().map((i) => i.where),
        contains('localized.${PackPaths.addedY(added.id)}.ja'),
      );
    });

    test('a language this build does not speak never clashes', () {
      final game = YFeed.namedAccounts.first;
      final p = _pack(
        yAccounts: const {builtIn: 'Renamed Fan'},
        addedYAccounts: [added],
        localized: {
          PackPaths.addedY(added.id): {'xx': game},
          PackPaths.yAccount(builtIn): {'xx': game},
        },
      );
      expect(PackRules.issues(p).whereType<NameClash>(), isEmpty);
      expect(
        PackRules.yNameTakenIn(p, PackPaths.addedY(added.id), 'xx'),
        false,
      );
    });

    test('a post rebuilt with args: p.args keeps its persona', () {
      final cs = ActiveWorld(world).inLanguage('cs');
      final feed = YFeed.renamedIn(
        (posts: [post(builtIn, 'a'), post(addedName, 'b')], reserveFrom: null),
        cs,
        added: [added],
        addedWorld: 'lang',
      );
      // Rebuilt the way a screen might: a new record, the same args list.
      YPost rebuilt(YPost p) => (
        voice: p.voice,
        handle: p.handle,
        displayName: p.displayName,
        template: p.template,
        variant: p.variant,
        args: p.args,
        date: p.date.add(const Duration(days: 1)),
        key: '${p.key}-again',
        replyTo: p.replyTo,
        mood: p.mood,
      );
      ActiveWorld.current = cs;
      expect(
        YFeed.personaOf(rebuilt(feed.posts[0])).trait,
        YCast.traitFor(builtIn),
      );
      expect(
        YFeed.personaOf(rebuilt(feed.posts[1])).trait,
        YCast.traitFor(addedName),
      );
    });
  });
}
