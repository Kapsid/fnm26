@Tags(['slow'])
library;

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/seeded_save.dart' show settle;
import '../unit/greenland/greenland_fixtures.dart';
import 'capture.dart';
import 'driver.dart';

/// The whole life of a world pack, end to end: made from the default world,
/// edited (Czechia renamed, one man rebuilt, the European Championship
/// renamed and given its own trophy), exported to a file, imported back as a
/// copy, and a career played on the copy through the first European
/// Championship, with both packs deleted along the way. A default career on
/// the same seed, in the same database, still reads exactly as it did before
/// world packs existed.

const int _seed = 42;
const String _cupName = 'Crown of Europe';
const String _kadlec = 'Jakub Kadlec';

/// Default careers at [_seed]: the reads pinned before the feature by
/// `test/unit/world_pack/player_repo_world_test.dart` (its `_snapshot`).
const _goldenNations = [1, 2, 10];
const _goldenFile = 'test/unit/world_pack/fixtures/default_world_seed42.json';

/// Czech names for the other 22, none of them the default draw's.
const _firsts = [
  'Přemysl',
  'Bohumil',
  'Ctibor',
  'Dalibor',
  'Hynek',
  'Jaromír',
  'Libor',
  'Miloš',
  'Oldřich',
  'Radim',
  'Svatopluk',
];
const _surs = ['Řezníček', 'Vondráček'];

List<Object> _row(Player p) => [
  p.name,
  p.age,
  p.attributes.physical,
  p.attributes.technical,
  p.attributes.stamina,
  p.club,
  p.clubCountry,
];

Future<Map<String, Object>> _goldenSnapshot(
  ProviderContainer c,
  int career,
) async {
  final players = c.read(playerRepositoryProvider);
  final out = <String, Object>{};
  for (final n in _goldenNations) {
    for (final years in [0, 8]) {
      out['$n/senior/$years'] = {
        for (final p in await players.byNation(
          n,
          agingYears: years,
          saveSeed: _seed,
          careerId: career,
          minAge: 15,
        ))
          '${p.id}': _row(p),
      };
    }
    out['$n/youth/0'] = {
      for (final p in await players.youthByNation(
        n,
        saveSeed: _seed,
        careerId: career,
      ))
        '${p.id}': _row(p),
    };
  }
  return out;
}

/// [reads] with the club and its country taken out of every player row
/// ([cols]: their places in a row). The pins were written before club
/// strength, when every career drew its clubs the old way; a career created
/// now draws them by strength (`clubStrengthKind`), so here the pin holds
/// for names, ratings and traits, and the clubs are held to the career's own
/// first read instead. That the old draw itself is unchanged, careers from
/// before keep it, is pinned in `v1_world_pin_test.dart` and
/// `player_repo_world_test.dart`.
Object? _withoutClubs(Object? reads, Set<int> cols) => switch (reads) {
  final Map<String, Object?> m => {
    for (final e in m.entries) e.key: _withoutClubs(e.value, cols),
  },
  final List<Object?> row when row.isNotEmpty && row.first is String => [
    for (var i = 0; i < row.length; i++)
      if (!cols.contains(i)) row[i],
  ],
  _ => reads,
};

/// [storyContainer], but over the deep pool the app stores (the seed's
/// players expanded with their fringe), which the default golden was taken
/// on: the story world, as a phone player has it.
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

/// A 600x900 opaque picture: what a player might pick for a trophy.
Future<Uint8List> _picture() async {
  final rec = ui.PictureRecorder();
  ui.Canvas(rec)
    ..drawRect(
      const ui.Rect.fromLTWH(0, 0, 600, 900),
      ui.Paint()..color = const ui.Color(0xFF1E3CC8),
    )
    ..drawCircle(
      const ui.Offset(300, 300),
      200,
      ui.Paint()..color = const ui.Color(0xFFE8C547),
    );
  final image = await rec.endRecording().toImage(600, 900);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  // Entering the career puts its world on show for the whole app.
  tearDown(() => ActiveWorld.current = ActiveWorld.none);
  // Name lists first loaded in one zone keep that zone's future in the
  // bundle's cache; a later test awaiting it from another would hang.
  tearDown(rootBundle.clear);

  testWidgets(
    'a world pack from the editor to the end of the first European '
    'Championship',
    timeout: const Timeout(Duration(minutes: 40)),
    (tester) async {
      setPhone(tester);
      final c = _container();
      addTearDown(c.dispose);
      final cze = storyNations.firstWhere((n) => n.code == 'CZE').id;

      late int packId;
      late int copyId;
      late int careerId;
      late int defaultCareerId;
      late Uint8List trophy;
      late Map<int, PackPlayer> edited;
      late PackPlayer kadlec;
      final clock = Stopwatch()..start();

      // 1. Make, edit, export and import.
      await tester.runAsync(() async {
        await c.read(seedLoaderProvider).ensureSeeded();
        final service = c.read(worldPackServiceProvider);
        packId = await service.createFromDefault('Bohemia');

        final sub = c.listen(packEditorProvider(packId), (_, _) {});
        final editor = c.read(packEditorProvider(packId).notifier);
        for (var i = 0; i < 500 && sub.read().valueOrNull == null; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        final squad = sub.read().value!.squads[cze]!;
        expect(squad, hasLength(23));

        // Kadlec: a midfielder young enough to be playing on day one.
        final target = squad.firstWhere(
          (p) => p.position == PlayerPosition.cm && p.age <= 28,
          orElse: () => squad.firstWhere((p) => p.age <= 28),
        );
        var i = 0;
        String nextName() {
          final n = '${_firsts[i % _firsts.length]} ${_surs[i ~/ 11]}';
          i++;
          return n;
        }

        editor
          ..update((pack) {
            var out = pack;
            for (final p in pack.squads[cze]!) {
              final renamed = p.id == target.id
                  ? SquadEdits.withPotential(
                      SquadEdits.rated(
                        SquadEdits.copy(p, name: _kadlec),
                        88,
                        PlayerType.technician,
                      ),
                      92,
                    )
                  : SquadEdits.copy(p, name: nextName());
              out = SquadEdits.replace(out, cze, renamed);
            }
            return out;
          })
          ..update(
            (pack) => pack.copyWith(
              competitions: {
                ...pack.competitions,
                'European Championship': _cupName,
              },
            ),
          );

        final normalised = await TrophyNormaliser.normalise(
          await _picture(),
          'europe',
        );
        trophy = normalised!.png;
        expect(await editor.setTrophy('europe', trophy), isTrue);
        await editor.flush();
        expect(editor.issues, isEmpty);
        sub.close();

        final saved = (await c.read(worldPackRepositoryProvider).load(packId))!;
        edited = {for (final p in saved.squads[cze]!) p.id: p};
        kadlec = edited[target.id]!;
        expect(kadlec.name, _kadlec);
        expect(SquadEdits.overallOf(kadlec), 88);
        expect(kadlec.potential, 92);
        expect(
          PlayerBuild.typeOf(kadlec.position, kadlec.attributes),
          PlayerType.technician,
        );
        expect(edited.values.map((p) => p.name).toSet(), hasLength(23));

        // Through a file and back, as a copy.
        final dir = await Directory.systemTemp.createTemp('fnm_story_');
        addTearDown(() => dir.delete(recursive: true));
        final file = await service.export(packId, into: dir);
        final imported = await service.importFile(file.path);
        copyId = imported.valueOrNull!;
        final packs = c.read(worldPackRepositoryProvider);
        final copy = (await packs.load(copyId))!;
        expect(copy.name, 'Bohemia (2)');
        expect(copy.uuid, isNot(saved.uuid));
        expect(copy.squads, saved.squads);
        expect(copy.competitions['European Championship'], _cupName);
        expect(await packs.trophies(packId), {'europe': trophy});
        // The import runs every picture through the normaliser again (its
        // security gate): the copy's is a fresh 400x600 PNG of the same
        // picture, and that is the one the career takes.
        final copyTrophies = await packs.trophies(copyId);
        expect(copyTrophies.keys, ['europe']);
        trophy = copyTrophies['europe']!;
        final codec = await ui.instantiateImageCodec(trophy);
        final frame = (await codec.getNextFrame()).image;
        expect((frame.width, frame.height), (400, 600));
        frame.dispose();
        codec.dispose();

        careerId =
            (await c
                    .read(careerServiceProvider)
                    .create(
                      nationId: cze,
                      managerName: 'M. Urbanczyk',
                      rngSeed: _seed,
                      worldPackId: copyId,
                    ))
                .valueOrNull!
                .id;
        // The default career alongside, with both packs in the database.
        defaultCareerId =
            (await c
                    .read(careerServiceProvider)
                    .create(nationId: 1, managerName: 'M', rngSeed: _seed))
                .valueOrNull!
                .id;
      });

      final golden = _withoutClubs(
        jsonDecode(File(_goldenFile).readAsStringSync()),
        const {5, 6},
      );
      late Object? firstReads;
      Future<Object?> fullReads() async =>
          jsonDecode(jsonEncode(await _goldenSnapshot(c, defaultCareerId)));
      // The default career as the golden pins it, its clubs aside (see
      // [_withoutClubs]); its clubs stand still for the whole story.
      Future<Object?> defaultReads() async {
        final reads = await fullReads();
        expect(reads, firstReads);
        return _withoutClubs(reads, const {5, 6});
      }

      // 2. Play the career on the copy.
      final players = c.read(playerRepositoryProvider);
      Future<Map<int, (String, PlayerAttributes)>> czechs() async => {
        for (final p in await players.byNation(
          cze,
          saveSeed: _seed,
          careerId: careerId,
        ))
          p.id: (p.name, p.attributes),
      };

      var calledUp = false;
      String? europeYear;
      var steps = 0;
      await tester.runAsync(() async {
        firstReads = await fullReads();
        expect(await defaultReads(), golden);

        final d = StoryDriver(c, careerId)
          ..beforeEvent = (e) async {
            if (calledUp || e.kind != HubEventKind.callUp) return;
            calledUp = true;
            c.invalidate(squadDataProvider(careerId));
            final sub = c.listen(
              squadDataProvider(careerId).future,
              (_, _) {},
            );
            final data = (await sub.read())!;
            sub.close();
            final pool = {for (final p in data.pool) p.id: p};
            // Day-one veterans retire as in a default career; everyone
            // else is in the pool, under the name and rating he was given.
            final playing = edited.values.where((p) => p.age < 34).toList();
            expect(playing.length, greaterThanOrEqualTo(18));
            for (final p in playing) {
              final got = pool[p.id];
              expect(got, isNotNull, reason: '${p.name} in the pool');
              expect(got!.name, p.name);
              expect(got.attributes, p.attributes, reason: p.name);
            }
            expect(pool[kadlec.id]!.overall, 88);

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
        final start =
            (await c.read(careerRepositoryProvider).byId(careerId))!.inGameDate;
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
        // Where the run starts, for reading its timing.
        // ignore: avoid_print
        print('career from $start, past Euros $before');
      });
      expect(calledUp, isTrue);
      expect(europeYear, isNotNull, reason: 'no European Championship');
      // The run's length, for whoever wonders why the suite is slow.
      // ignore: avoid_print
      print(
        'Euro $europeYear after $steps events, ${clock.elapsed.inSeconds}s',
      );

      // 3. What the career keeps, packs gone.
      await tester.runAsync(() async {
        final stored = (await c
            .read(worldPackRepositoryProvider)
            .forCareer(careerId))!;
        expect(stored.pack.competitions['European Championship'], _cupName);
        expect(stored.trophies, {'europe': trophy});
        final now = await czechs();
        expect(now[kadlec.id]?.$1, _kadlec);
        expect(await defaultReads(), golden);
      });

      // 4. The cup screen shows the world's name and trophy.
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
        await pumpApp(tester, c, '${Routes.tournaments}?careerId=$careerId');
        await settle(tester);
      } finally {
        FlutterError.onError = original;
      }
      expect(find.text(_cupName), findsWidgets);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is ResizeImage &&
              (w.image as ResizeImage).imageProvider is MemoryImage &&
              listEquals(
                ((w.image as ResizeImage).imageProvider as MemoryImage).bytes,
                trophy,
              ),
        ),
        findsWidgets,
      );
      expect(find.text('European Championship'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
