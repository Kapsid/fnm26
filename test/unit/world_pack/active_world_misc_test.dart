import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart' show uiLanguageCodeProvider;
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/federation/sponsor_screen.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

const _czechia = 12;
const _spain = 50;

WorldPack _pack({
  Map<String, String> sponsors = const {},
  Map<String, String> stadiums = const {},
  Map<int, PackReporter> reporters = const {},
  Map<String, String> yAccounts = const {},
  Map<int, PackNameLists> nameLists = const {},
}) => WorldPack(
  uuid: 'u',
  name: 'Burgers',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  sponsors: sponsors,
  stadiums: stadiums,
  reporters: reporters,
  yAccounts: yAccounts,
  nameLists: nameLists,
);

ActiveWorld _world(WorldPack pack) => ActiveWorld(pack);

AppLocalizations _l(String code) => lookupAppLocalizations(Locale(code));

/// The pack's own first names and surnames: short, invented, and on no
/// default list, so a name built from them could have come from nowhere else.
const _packFirst = [
  'Aldo', 'Bram', 'Cyro', 'Dov', 'Emek', 'Fyn', 'Gale', 'Hobb', 'Ivo', //
  'Jory', 'Kael', 'Lio', 'Mott', 'Nyle', 'Orin', 'Pell', 'Quin', 'Rafe', //
  'Soll', 'Tove', 'Ulme', 'Vann', 'Wyck', 'Xan', 'Yorr',
];
const _packSur = [
  'Brisket', 'Chuck', 'Flank', 'Grill', 'Patty', 'Rump', 'Sear', 'Skewer', //
  'Smoke', 'Tongs', 'Bun', 'Pickle', 'Relish', 'Mustard', 'Onion', 'Cheddar',
  'Ketchup', 'Slaw', 'Coal', 'Ember', 'Spatula', 'Basting', 'Marinade', //
  'Brine', 'Rib',
];

/// What a post says, apart from who says it. Records compare their lists
/// by identity, so the args are joined.
Object _said(YPost p) => (
  p.key,
  p.template,
  p.variant,
  p.args.join('|'),
  p.voice,
  p.mood,
  p.date,
  p.replyTo,
);

/// Everything a post shows.
Object _shown(YPost p) => (_said(p), p.displayName, p.handle);

/// Who is in and applying for each job.
Object _staff(StaffRoom r) => [
  for (final e in r.hired.entries) '${e.key}:${e.value?.id}:${e.value?.name}',
  for (final e in r.applicants.entries)
    for (final a in e.value) '${e.key}:${a.id}:${a.name}:${a.country}',
  r.wagesPerCycle,
];

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  // -------------------------------------------------------------------------
  // The pure and widget reads.
  // -------------------------------------------------------------------------

  group('renamed sponsor brand shows on the sponsor screen and its Y post', () {
    testWidgets('on the sponsor screen, the same in every language', (
      tester,
    ) async {
      ActiveWorld.current = _world(
        _pack(sponsors: {SponsorBrand.agrofart.name: 'Grill Co'}),
      );
      for (final code in ['en', 'cs']) {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpApp(
          const SponsorScreen(careerId: 1),
          locale: Locale(code),
          overrides: [
            sponsorRoundProvider.overrideWith(
              (ref, id) async => (
                cycle: 0,
                year: 2026,
                offers: [
                  Sponsors.offerOf(SponsorBrand.agrofart, 1),
                  Sponsors.offerOf(SponsorBrand.miners, 1, index: 1),
                ],
                chosen: null,
                decided: false,
              ),
            ),
          ],
        );
        await tester.pumpAndSettle();
        expect(find.text('Grill Co'), findsOneWidget, reason: code);
        // The brand nobody renamed keeps its translated name.
        expect(
          find.text(sponsorBrandName(_l(code), SponsorBrand.miners)),
          findsOneWidget,
        );
      }
      // A blank override is no override.
      ActiveWorld.current = _world(
        _pack(sponsors: {SponsorBrand.agrofart.name: '  '}),
      );
      expect(
        sponsorBrandName(_l('en'), SponsorBrand.agrofart),
        _l('en').sponsorBrandAgrofart,
      );
    });
  });

  test('renamed national stadium and renamed host venue show', () {
    final cities = {
      for (final g in nationalStadiumData[_spain]!) g.$1,
    }.toList();
    final before = VenueGenerator.forHost(hostId: _spain, cities: cities);
    final madrid = before.indexWhere((v) => v.city == 'Madrid');
    ActiveWorld.current = _world(
      _pack(stadiums: {'$_spain:Madrid': 'Bun Arena'}),
    );
    final after = VenueGenerator.forHost(hostId: _spain, cities: cities);
    // The host venue: Madrid's first ground, and no other.
    expect(after[madrid].stadium, 'Bun Arena');
    for (var i = 0; i < after.length; i++) {
      if (i == madrid) continue;
      expect(after[i], before[i]);
    }
    // The national stadium list, built on the seed grounds.
    final stadiums = NationalStadiums.forNation(
      nationId: _spain,
      seed: [
        (city: 'Madrid', stadium: 'Old Name', capacity: 80000),
        (city: 'Madrid', stadium: 'Second Ground', capacity: 70000),
        (city: 'Seville', stadium: 'Seville Ground', capacity: 60000),
      ],
      works: const [],
    );
    expect(stadiums.map((s) => s.name), [
      'Bun Arena',
      'Second Ground',
      'Seville Ground',
    ]);
  });

  testWidgets('renamed reporter shows in the byline', (tester) async {
    final room = Press.roomFor(7);
    final renamed = room.firstWhere((r) => r.index == 2);
    final other = room.firstWhere((r) => r.index == 3);
    ActiveWorld.current = _world(
      _pack(
        reporters: const {
          2: PackReporter(name: 'Ann Bun', outlet: 'Grill Post'),
          3: PackReporter(name: ' ', outlet: 'The Skewer'),
        },
      ),
    );
    await tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            PressByline(reporter: renamed),
            PressByline(reporter: other),
          ],
        ),
      ),
    );
    expect(find.text('Ann Bun'), findsOneWidget);
    expect(find.text('Grill Post'), findsOneWidget);
    expect(find.text(renamed.name), findsNothing);
    // A blank name keeps the reporter's own; the outlet he was given shows.
    expect(find.text(other.name), findsOneWidget);
    expect(find.text('The Skewer'), findsOneWidget);
  });

  test('a renamed Y account handle is its name without spaces, capped', () {
    expect(YFeed.handleFor('Grill Master Supreme'), '@GrillMasterSupreme');
    final long = 'A' * PackRules.handleMax;
    final handle = YFeed.handleFor(long);
    expect(handle.length, PackRules.handleMax);
    expect(handle, '@${'A' * (PackRules.handleMax - 1)}');
  });

  group('a Y account cannot be renamed onto another account', () {
    final a = YFeed.namedAccounts[0];
    final b = YFeed.namedAccounts[1];

    List<String> clashes(Map<String, String> renames) => [
      for (final i in PackRules.issues(_pack(yAccounts: renames)))
        if (i is BadField && i.reason == FieldReason.duplicate) i.path,
    ];

    /// The paths flagged, not refused: a clash with a game account's name.
    List<String> flagged(Map<String, String> renames) => [
      for (final i in PackRules.issues(_pack(yAccounts: renames)))
        if (i is NameClash) i.path,
    ];

    test('a rename onto another account\'s original name is flagged, '
        'not refused', () {
      expect(clashes({a: ' ${b.toUpperCase()} '}), isEmpty);
      expect(flagged({a: ' ${b.toUpperCase()} '}), ['yAccounts.$a']);
    });

    test('two renames to the same name are refused', () {
      expect(
        clashes({a: 'Burger Baron', b: 'burger baron'}),
        unorderedEquals(['yAccounts.$a', 'yAccounts.$b']),
      );
    });

    test('a swap is flagged, not refused', () {
      expect(clashes({a: b, b: a}), isEmpty);
      expect(
        flagged({a: b, b: a}),
        unorderedEquals(['yAccounts.$a', 'yAccounts.$b']),
      );
    });

    test('a plain rename passes', () {
      expect(clashes({a: 'Burger Baron', b: ' ${b.toLowerCase()} '}), isEmpty);
      expect(clashes({a: 'Burger Baron'}), isEmpty);
    });

    test('a clash that slipped through reads back the lowest original', () {
      final world = _world(_pack(yAccounts: {'Zed': 'Same', 'Abe': 'Same'}));
      expect(world.yAccountOriginal('Same'), 'Abe');
    });
  });

  test('blank means none', () {
    expect(ActiveWorld.textOrNull(null), isNull);
    expect(ActiveWorld.textOrNull('  '), isNull);
    expect(ActiveWorld.textOrNull('Ann'), 'Ann');
  });

  // -------------------------------------------------------------------------
  // The wiring, on a seeded career.
  // -------------------------------------------------------------------------

  group('on a career', () {
    late AppDatabase db;
    late List<Nation> nations;
    late List<Player> players;
    late Map<int, NameLists> lists;

    ProviderContainer open() {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          uiLanguageCodeProvider.overrideWithValue('en'),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(
              nationList: nations,
              playerList: players,
              nameListMap: lists,
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    void enter(ProviderContainer c, ActiveWorld world) {
      c.read(activeWorldProvider.notifier).state = world;
      ActiveWorld.current = world;
    }

    setUp(() async {
      db = createTestDatabase();
      addTearDown(db.close);
      nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
      players =
          (jsonDecode(File('assets/data/players.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, Object?>))
              .toList();
      final classic =
          jsonDecode(File('assets/data/country_names.json').readAsStringSync())
              as Map<String, Object?>;
      final more =
          jsonDecode(
                File('assets/data/country_names_more.json').readAsStringSync(),
              )
              as Map<String, Object?>;
      List<String> read(Object? m, String key) =>
          (((m as Map?)?[key] as List?) ?? const []).cast<String>();
      lists = {
        _czechia: (
          first: read(classic['$_czechia'], 'first'),
          firstMore: read(more['$_czechia'], 'firstMore'),
          sur: read(classic['$_czechia'], 'sur'),
          surLate: read(classic['$_czechia'], 'surLate'),
          surMore: read(more['$_czechia'], 'surMore'),
        ),
      };
      await open().read(seedLoaderProvider).ensureSeeded();
    });

    /// A Czech career with eight fixtures played and a dubious sponsor
    /// signed on its first day.
    Future<Career> played(ProviderContainer c) async {
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: _czechia,
                    managerName: 'M',
                    rngSeed: 20301,
                  ))
              .valueOrNull!;
      final comp = c.read(competitionRepositoryProvider);
      final fixtures = (await comp.fixturesForNation(career.id, _czechia))
        ..sort((a, b) => a.date.compareTo(b.date));
      var i = 0;
      for (final f in fixtures.take(8)) {
        final home = f.homeNationId == _czechia;
        final (us, them) = [(2, 1), (0, 0), (0, 3), (4, 0)][i++ % 4];
        await comp.recordResult(
          fixtureId: f.id,
          homeScore: home ? us : them,
          awayScore: home ? them : us,
        );
      }
      await c
          .read(careerRepositoryProvider)
          .recordPressAnswer(
            careerId: career.id,
            cycle: 0,
            questionKey: Sponsors.pressKey(2026, SponsorBrand.agrofart),
            tone: Sponsors.pressTone,
            moraleDelta: 0,
            boardDelta: 0,
            answeredAt: CareerService.cycleOpens(0),
          );
      return career;
    }

    Future<List<YPost>> feed(ProviderContainer c, int careerId) async {
      c.invalidate(yFeedProvider(careerId));
      return (await c.read(yFeedProvider(careerId).future)).posts;
    }

    test('the renamed sponsor brand is the one its Y post names', () async {
      final c = open();
      final career = await played(c);
      enter(
        c,
        _world(_pack(sponsors: {SponsorBrand.agrofart.name: 'Grill Co'})),
      );
      final sponsorPosts = [
        for (final p in await feed(c, career.id))
          if (p.template == YTemplate.sponsorDubious) p,
      ];
      expect(sponsorPosts, isNotEmpty);
      for (final p in sponsorPosts) {
        expect(p.args, contains('Grill Co'));
      }
    });

    test(
      'renamed Y account keeps its trait and shows its new name and handle',
      () async {
        final c = open();
        final career = await played(c);
        final before = await feed(c, career.id);
        // A cast account (no space: not a local fan, not a player) that
        // posted under the sponsor story.
        final account = before.firstWhere(
          (p) =>
              p.template == YTemplate.sponsorDubious &&
              p.voice == YVoice.fan &&
              !p.displayName.contains(' '),
        );
        final original = account.displayName;
        final trait = YCast.traitFor(original);
        // A new name whose own trait differs, so keeping the voice is
        // something the code has to do.
        final renamed = [
          'Grill Master Supreme',
          'Burger Baron',
          'Patty Prophet',
          'Bun Whisperer',
        ].firstWhere((n) => YCast.traitFor(n) != trait);

        enter(c, _world(_pack(yAccounts: {original: renamed})));
        final after = await feed(c, career.id);

        expect(after.length, before.length);
        var seen = 0;
        for (var i = 0; i < after.length; i++) {
          final a = after[i];
          final b = before[i];
          // Every post says exactly what it said, in the same voice.
          expect(
            _said(a),
            _said(b),
          );
          if (b.displayName == original) {
            seen++;
            expect(a.displayName, renamed);
            expect(a.handle, YFeed.handleFor(renamed));
            expect(a.handle.length, lessThanOrEqualTo(PackRules.handleMax));
            // The profile reads the account's own disposition.
            expect(YFeed.personaOf(a).trait, trait);
          } else {
            expect((a.displayName, a.handle), (b.displayName, b.handle));
          }
        }
        expect(seen, greaterThan(0));
      },
    );

    test("staff and local fans draw from the pack's name lists", () async {
      final c = open();
      final career = await played(c);
      enter(
        c,
        _world(
          _pack(
            nameLists: {
              for (final n in nations)
                n.id: const PackNameLists(first: _packFirst, sur: _packSur),
            },
          ),
        ),
      );

      final room = (await c.read(staffRoomProvider(career.id).future))!;
      final applicants = [for (final l in room.applicants.values) ...l];
      expect(applicants, isNotEmpty);
      for (final a in applicants) {
        final parts = a.name.split(' ');
        expect(_packFirst, contains(parts.first), reason: a.name);
        expect(_packSur, contains(parts.last), reason: a.name);
      }

      final locals = [
        for (final p in await feed(c, career.id))
          if (p.template == YTemplate.reaction &&
              p.displayName.contains(' ') &&
              _packSur.contains(p.displayName.split(' ').last))
            p,
      ];
      expect(locals, isNotEmpty);
      for (final p in locals) {
        expect(_packFirst, contains(p.displayName.split(' ').first));
      }
      // And none of the default lists' fans is left.
      final czechSur = {...lists[_czechia]!.sur, ...lists[_czechia]!.surMore};
      expect(
        [
          for (final p in await feed(c, career.id))
            if (p.template == YTemplate.reaction &&
                p.displayName.contains(' ') &&
                czechSur.contains(p.displayName.split(' ').last))
              p,
        ],
        isEmpty,
      );
    });

    test(
      'a nation whose pack list is empty keeps its default staff names',
      () async {
        final c = open();
        final career = await played(c);
        final before = _staff(
          (await c.read(staffRoomProvider(career.id).future))!,
        );
        enter(
          c,
          _world(
            _pack(
              nameLists: {
                for (final n in nations)
                  n.id: const PackNameLists(first: [], sur: [' ']),
              },
            ),
          ),
        );
        expect(
          _staff((await c.read(staffRoomProvider(career.id).future))!),
          before,
        );
        expect(
          staffNamesFrom(const PackNameLists(first: ['Aldo'], sur: [])),
          isEmpty,
        );
      },
    );

    test('default world unchanged', () async {
      final c = open();
      final career = await played(c);
      final feedNone = await feed(c, career.id);
      final staffNone = await c.read(staffRoomProvider(career.id).future);
      // A world that renames nothing this career shows: every read is the
      // default one.
      enter(
        c,
        _world(
          _pack(
            sponsors: {SponsorBrand.miners.name: 'Grill Co'},
            stadiums: {'$_spain:Madrid': 'Bun Arena'},
            yAccounts: {'Nobody On This Feed': 'Burger Baron'},
          ),
        ),
      );
      c.invalidate(staffRoomProvider(career.id));
      expect((await feed(c, career.id)).map(_shown), feedNone.map(_shown));
      expect(
        _staff((await c.read(staffRoomProvider(career.id).future))!),
        _staff(staffNone!),
      );

      enter(c, ActiveWorld.none);
      expect((await feed(c, career.id)).map(_shown), feedNone.map(_shown));
      final l = _l('en');
      expect(
        sponsorBrandName(l, SponsorBrand.agrofart),
        l.sponsorBrandAgrofart,
      );
      final cities = {
        for (final g in nationalStadiumData[_spain]!) g.$1,
      }.toList();
      final grounds = VenueGenerator.forHost(hostId: _spain, cities: cities);
      expect(grounds.map((v) => v.stadium), isNot(contains('Bun Arena')));
      // The press room is the same people as ever, in the same order.
      expect(Press.roomFor(7).map((r) => r.name).toSet().length, 10);
      expect(
        YFeed.personaOf(feedNone.first).displayName,
        feedNone.first.displayName,
      );
    });
  });
}
