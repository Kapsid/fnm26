import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart' show settle;
import '../unit/greenland/greenland_fixtures.dart';
import 'capture.dart';
import 'driver.dart';

/// Every part of editor 2, end to end. A 1.1.0 (format 1) file is imported
/// and a career started on it at once; then the pack is edited: Kadlec gets
/// picked traits and raw attributes (Advanced), Czechia's pool is fixed with
/// one player renamed, a club, a sponsor and a Y account are added, and the
/// European Championship gets a Czech-only name. The pack goes out to a file
/// and back in as a copy, a Czech career on the copy is played through the
/// first European Championship with both packs deleted along the way, and
/// each edit shows in it. The 1.1.0 career and a default one, alongside in
/// the same database, still read exactly as the Task 1 pin has them.

/// The seed the Task 1 pin was taken at.
const int _pinSeed = 42;

/// The first seed in 42..60 whose first sponsor round offers Pivo Max to
/// Czechia (the story checks the search lands here).
const int _seed = 49;

const _pinNations = [1, 23, 140];
const _pinAgingYears = [0, 6];
const _v1File = 'test/unit/world_pack/fixtures/v1_pack.json';
const _pinFile = 'test/unit/world_pack/fixtures/v1_world_pin.json';

const _kadlec = 'Jakub Kadlec';
const List<PlayerTrait> _kadlecTraits = [
  PlayerTrait.setPiece,
  PlayerTrait.leader,
];
const _kadlecAttributes = PlayerAttributes(
  physical: 90,
  technical: 83,
  stamina: 79,
);
const _poolName = 'Vojtěch Hospodský';
const _club = 'Brno Rovers';
const _sponsor = 'Pivo Max';
const _yName = 'HospodaFC';
const _csCup = 'Pohár hospod';

// The Task 1 pin's reads (`test/unit/world_pack/v1_world_pin_test.dart`).

List<Object?> _pinRow(Player p) => [
  p.name,
  p.overall,
  p.club,
  p.clubCountry,
  [for (final t in PlayerTraits.of(p, saveSeed: _pinSeed)) t.name],
];

Future<Map<String, Object>> _pinPlayers(
  ProviderContainer c,
  int career,
) async {
  final players = c.read(playerRepositoryProvider);
  final out = <String, Object>{};
  for (final n in _pinNations) {
    for (final years in _pinAgingYears) {
      final pool = await players.byNation(
        n,
        agingYears: years,
        saveSeed: _pinSeed,
        careerId: career,
        minAge: 15,
      );
      out['$n/$years'] = {for (final p in pool) '${p.id}': _pinRow(p)};
    }
  }
  return out;
}

Map<String, Object> _pinSponsors() => {
  for (var s = 1; s <= 20; s++)
    for (var cycle = 0; cycle <= 3; cycle++)
      '$s/$cycle': [
        for (final b in Sponsors.brandsFor(
          seed: s,
          cycle: cycle,
          czech: false,
        ))
          b.id,
      ],
};

Map<String, Object> _pinY() => {
  for (final v in YVoice.values)
    for (var i = 0; i < 10; i++)
      '${v.name}/$i': YFeed.personaFor(
        v,
        'Czechia',
        _pinSeed,
        'k$i',
      ).displayName,
};

/// The story world over the deep pool the app stores, as in the 1.1.0
/// story (`world_pack_story_test.dart`).
ProviderContainer _container() {
  final cities = {
    for (final e
        in (jsonDecode(
                  File('assets/data/country_cities.json').readAsStringSync(),
                )
                as Map<String, Object?>)
            .entries)
      int.parse(e.key): (e.value! as List).cast<String>(),
  };
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(storyDb()),
      premiumUnlockedProvider.overrideWith((ref) => true),
      matchAttemptSaltProvider.overrideWithValue(() => 0),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(
          nationList: seedNations,
          playerList: seedPlayers,
          dormantNations: DormantNations.all,
          dormantPlayers: dormantPool(),
        ),
      ),
      formFactorProvider.overrideWithValue(FormFactor.phone),
      countryCitiesProvider.overrideWith((ref) async => cities),
    ],
  );
}

void main() {
  // Entering the career puts its world on show for the whole app.
  tearDown(() => ActiveWorld.current = ActiveWorld.none);
  // Name lists first loaded in one zone keep that zone's future in the
  // bundle's cache; a later test awaiting it from another would hang.
  tearDown(rootBundle.clear);

  testWidgets(
    'editor 2 from a 1.1.0 file to the end of the first European '
    'Championship',
    timeout: const Timeout(Duration(minutes: 40)),
    (tester) async {
      setPhone(tester);
      final c = _container();
      addTearDown(c.dispose);
      final cze = storyNations.firstWhere((n) => n.code == 'CZE').id;
      final pin = jsonDecode(File(_pinFile).readAsStringSync());

      late int packId;
      late int copyId;
      late int careerId;
      late int v1CareerId;
      late int defaultCareerId;
      late PackPlayer kadlec;
      late PackPlayer renamed;
      late PackPlayer atClub;
      late PackSponsor pivo;
      late PackYAccount hospoda;
      final clock = Stopwatch()..start();

      Future<Object?> pinReads() async => jsonDecode(
        jsonEncode({
          'default': await _pinPlayers(c, defaultCareerId),
          'v1Pack': await _pinPlayers(c, v1CareerId),
          'sponsors': _pinSponsors(),
          'y': _pinY(),
        }),
      );

      // 1. A 1.1.0 file in, a career on it, then the editing.
      await tester.runAsync(() async {
        await c.read(seedLoaderProvider).ensureSeeded();
        final service = c.read(worldPackServiceProvider);
        final packs = c.read(worldPackRepositoryProvider);
        final careers = c.read(careerServiceProvider);
        final dir = await Directory.systemTemp.createTemp('fnm_editor2_');
        addTearDown(() => dir.delete(recursive: true));

        // The fixture as the 1.1.0 build wrote it to a file.
        final raw =
            jsonDecode(File(_v1File).readAsStringSync())
                as Map<String, Object?>;
        expect(raw['formatVersion'], 1);
        final v1 = File('${dir.path}/Pin.fnmdb')
          ..writeAsBytesSync(
            gzip.encode(
              utf8.encode(
                jsonEncode({
                  'format': 1,
                  'pack': raw,
                  'trophies': <String, Object?>{},
                }),
              ),
            ),
          );
        packId = (await service.importFile(v1.path)).valueOrNull!;
        final lifted = (await packs.load(packId))!;
        expect(lifted.formatVersion, kPackFormatVersion);
        expect(
          lifted.squads,
          WorldPack.fromJson(WorldPack.migrate(raw)).squads,
        );
        expect(lifted.pools, isEmpty);

        v1CareerId = (await careers.create(
          nationId: 1,
          managerName: 'M',
          rngSeed: _pinSeed,
          worldPackId: packId,
        )).valueOrNull!.id;
        defaultCareerId = (await careers.create(
          nationId: 1,
          managerName: 'M',
          rngSeed: _pinSeed,
        )).valueOrNull!.id;
        expect(await pinReads(), pin, reason: 'before any editing');

        // The editing, as the editor's screens make each change.
        final sub = c.listen(packEditorProvider(packId), (_, _) {});
        final editor = c.read(packEditorProvider(packId).notifier);
        for (var i = 0; i < 500 && sub.read().valueOrNull == null; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        final pack = sub.read().value!;
        final squad = pack.squads[cze]!;
        final target = squad.firstWhere(
          (p) => p.position == PlayerPosition.cm && p.age <= 28,
          orElse: () => squad.firstWhere((p) => p.age <= 28),
        );
        // The pool the Pool tab shows before its first edit.
        final shown = await service.generatedPool(cze, pack);
        final squadIds = {for (final p in squad) p.id};
        final candidates =
            shown
                .where(
                  (p) => !squadIds.contains(p.id) && p.age >= 20 && p.age <= 28,
                )
                .toList()
              ..sort(
                (a, b) =>
                    SquadEdits.overallOf(b).compareTo(SquadEdits.overallOf(a)),
              );
        expect(candidates.length, greaterThanOrEqualTo(2));

        kadlec = SquadEdits.withTraits(
          SquadEdits.withAttributes(
            SquadEdits.copy(target, name: _kadlec),
            _kadlecAttributes,
          ),
          _kadlecTraits,
        );
        renamed = SquadEdits.copy(candidates[0], name: _poolName);
        atClub = SquadEdits.withClub(candidates[1], _club, 'cze');

        editor
          ..update((p) => SquadEdits.replace(p, cze, kadlec))
          ..update((p) => SquadEdits.poolReplace(p, cze, shown, renamed))
          ..update((p) => AddedEdits.addClub(p, _club, 'cze'))
          ..update((p) => SquadEdits.poolReplace(p, cze, shown, atClub))
          ..update(
            (p) => AddedEdits.addSponsor(
              p,
              _sponsor,
              SponsorDeal.risky,
              SponsorBrand.agrofart.name,
              '',
            ),
          )
          ..update((p) => AddedEdits.addY(p, _yName, YVoice.fan, cze))
          ..update(
            (p) => p.copyWith(
              localized: {
                ...p.localized,
                PackPaths.competition('European Championship'): {
                  'cs': _csCup,
                },
              },
            ),
          );
        await editor.flush();
        expect(editor.issues, isEmpty, reason: '${editor.issues}');
        sub.close();

        final saved = (await packs.load(packId))!;
        expect(
          saved.squads[cze]!.firstWhere((p) => p.id == kadlec.id).traits,
          _kadlecTraits,
        );
        expect(saved.pools[cze], hasLength(shown.length));
        expect(saved.addedClubs.single.name, _club);
        pivo = saved.addedSponsors.single;
        expect(pivo.description, isEmpty);
        hospoda = saved.addedYAccounts.single;
        expect(hospoda.nationId, cze);
        expect(saved.competitions, isNot(contains('European Championship')));

        // Through a file and back, as a copy.
        final file = await service.export(packId, into: dir);
        copyId = (await service.importFile(file.path)).valueOrNull!;
        final copy = (await packs.load(copyId))!;
        expect(copy.uuid, isNot(saved.uuid));
        expect(copy.squads, saved.squads);
        expect(copy.pools, saved.pools);
        expect(copy.addedClubs, saved.addedClubs);
        expect(copy.addedSponsors, saved.addedSponsors);
        expect(copy.addedYAccounts, saved.addedYAccounts);
        expect(copy.localized, saved.localized);

        // The seed: the first in 42..60 whose first round offers Pivo Max.
        final extra = [for (final s in copy.addedSponsors) Sponsor.added(s)];
        final offering = [
          for (var s = 42; s <= 60; s++)
            if (Sponsors.brandsFor(
              seed: s,
              cycle: 0,
              czech: true,
              extra: extra,
            ).contains(extra.single))
              s,
        ];
        expect(offering.first, _seed);

        careerId = (await careers.create(
          nationId: cze,
          managerName: 'M. Urbanczyk',
          rngSeed: _seed,
          worldPackId: copyId,
        )).valueOrNull!.id;

        // Pivo Max is offered in the first sponsor round.
        c.invalidate(sponsorRoundProvider(careerId));
        final round = (await c.read(sponsorRoundProvider(careerId).future))!;
        final offer = round.offers.firstWhere(
          (o) => o.brand.id == pivo.key,
          orElse: () => fail('Pivo Max not offered: ${round.offers}'),
        );
        expect(offer.brand.added?.name, _sponsor);
        expect(offer.risky, isTrue);

        expect(await pinReads(), pin, reason: 'with editor 2 packs about');
      });

      // 2. Play the career on the copy.
      final players = c.read(playerRepositoryProvider);
      Future<Map<int, (String, PlayerAttributes, String)>> czechs() async => {
        for (final p in await players.byNation(
          cze,
          saveSeed: _seed,
          careerId: careerId,
        ))
          p.id: (p.name, p.attributes, p.club),
      };

      var calledUp = false;
      var yPosted = false;
      String? europeYear;
      var steps = 0;
      await tester.runAsync(() async {
        final d = StoryDriver(c, careerId)
          ..beforeEvent = (e) async {
            if (e.kind != HubEventKind.callUp) return;
            if (!yPosted) {
              final feed = await c.read(yFeedProvider(careerId).future);
              yPosted = feed.posts.any((p) => p.displayName == _yName);
            }
            if (calledUp) return;
            calledUp = true;
            c.invalidate(squadDataProvider(careerId));
            final sub = c.listen(
              squadDataProvider(careerId).future,
              (_, _) {},
            );
            final data = (await sub.read())!;
            sub.close();
            final pool = {for (final p in data.pool) p.id: p};

            // Kadlec: his picked traits and his raw attributes.
            final k = pool[kadlec.id];
            expect(k, isNotNull, reason: 'Kadlec in the pool');
            expect(k!.name, _kadlec);
            expect(k.attributes, _kadlecAttributes);
            expect(PlayerTraits.of(k, saveSeed: _seed), _kadlecTraits);
            // He leads on a leader tie-break: the same man without the
            // trait ranks behind him.
            final twin = k.copyWith(id: -1, fixedTraits: const []);
            expect(
              Captaincy.leadership(k, saveSeed: _seed) -
                  Captaincy.leadership(twin, saveSeed: _seed),
              5,
            );
            expect(
              Captaincy.shortlist([twin, k], saveSeed: _seed).first.id,
              k.id,
            );

            // The fixed pool: the renamed man, and the man at the new club.
            final r = pool[renamed.id];
            expect(r, isNotNull, reason: '$_poolName in the pool');
            expect(r!.name, _poolName);
            final a = pool[atClub.id];
            expect(a, isNotNull, reason: '${atClub.name} in the pool');
            expect(a!.name, atClub.name);
            expect(a.club, _club);
            expect(a.clubCountry, 'cze');

            // Both packs deleted mid-run: the career has its own copy.
            final before = await czechs();
            final service = c.read(worldPackServiceProvider);
            await service.delete(packId);
            await service.delete(copyId);
            expect(await c.read(worldPackRepositoryProvider).list(), isEmpty);
            expect(await czechs(), before);
          };

        final comp = c.read(competitionRepositoryProvider);
        // The history the career starts with already holds past editions:
        // the first played is the first one it does not.
        final before = {
          for (final h in await comp.honours(careerId))
            if (h.competition == 'European Championship') h.year,
        };
        for (var i = 0; i < 6000 && europeYear == null; i++) {
          await d.step();
          for (final h in await comp.honours(careerId)) {
            if (h.competition == 'European Championship' &&
                !before.contains(h.year)) {
              europeYear = '${h.year}';
              steps = i + 1;
            }
          }
        }
        if (!yPosted) {
          final feed = await c.read(yFeedProvider(careerId).future);
          yPosted = feed.posts.any((p) => p.displayName == _yName);
        }
      });
      expect(calledUp, isTrue);
      expect(europeYear, isNotNull, reason: 'no European Championship');
      expect(yPosted, isTrue, reason: '$_yName never posted');
      // The run's length, for whoever wonders why the suite is slow.
      // ignore: avoid_print
      print(
        'Euro $europeYear after $steps events, ${clock.elapsed.inSeconds}s',
      );

      // 3. What the careers keep, packs gone.
      late WorldPack stored;
      await tester.runAsync(() async {
        stored =
            (await c.read(worldPackRepositoryProvider).forCareer(careerId))!
                .pack;
        expect(stored.addedSponsors, [pivo]);
        expect(stored.addedYAccounts, [hospoda]);
        expect(stored.addedClubs.single.name, _club);
        final now = await czechs();
        expect(now[kadlec.id]?.$1, _kadlec);
        expect(now[renamed.id]?.$1, _poolName);
        expect(await pinReads(), pin, reason: 'after the run, packs gone');
      });

      // 4. The cup's Czech name in Czech, the game's in other languages.
      String label(String language) {
        ActiveWorld.current = ActiveWorld(stored).inLanguage(language);
        try {
          return competitionLabel(
            lookupAppLocalizations(Locale(language)),
            'European Championship',
          );
        } finally {
          ActiveWorld.current = ActiveWorld.none;
        }
      }

      expect(label('cs'), _csCup);
      expect(
        label('en'),
        lookupAppLocalizations(const Locale('en')).compEuropeanChampionship,
      );
      expect(
        label('de'),
        lookupAppLocalizations(const Locale('de')).compEuropeanChampionship,
      );

      // And on the cup screen itself.
      c.read(activeWorldSyncProvider).noteWorld(careerId);
      // At phone width a tile whose name takes two lines overflows its cell
      // by a few pixels, in every career (see
      // test/golden/phone_guard_tournaments_test.dart): let those through.
      final original = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
          return;
        }
        original?.call(details);
      };
      try {
        await pumpApp(
          tester,
          c,
          '${Routes.tournaments}?careerId=$careerId',
          locale: const Locale('cs'),
        );
        await settle(tester);
        expect(find.text(_csCup), findsWidgets);

        await tester.pumpWidget(const SizedBox());
        c.read(localeProvider.notifier).state = const Locale('en');
        await pumpApp(tester, c, '${Routes.tournaments}?careerId=$careerId');
        await settle(tester);
        expect(find.text('European Championship'), findsWidgets);
        expect(find.text(_csCup), findsNothing);
      } finally {
        FlutterError.onError = original;
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
}
