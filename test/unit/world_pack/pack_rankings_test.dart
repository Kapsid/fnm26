import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/nation_ranking.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _andorra = 2;

WorldPack _pack({Map<int, int> rankings = const {}}) => WorldPack(
  uuid: 'r7',
  name: 'Seven',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.1',
  rankings: rankings,
);

WorldPack _roundTrip(WorldPack p) => WorldPack.fromJson(
  WorldPack.migrate(
    jsonDecode(jsonEncode(p.asWritten.toJson())) as Map<String, Object?>,
  ),
);

/// Format 7 (1.1.1): a nation's starting world ranking, set in the editor
/// and taken by every career started on the database.
void main() {
  group('the file', () {
    test('a pack without a ranking is written as before', () {
      final plain = _pack().asWritten;
      expect(plain.formatVersion, 3);
      expect(plain.toJson().containsKey('rankings'), isFalse);
      // A format-6 pack stays format 6.
      final six = _pack().copyWith(
        addedReporters: const [
          PackAddedReporter(id: kPackAddedIdBase, name: 'A B', outlet: 'C'),
        ],
      );
      expect(six.asWritten.formatVersion, 6);
      expect(six.asWritten.toJson().containsKey('rankings'), isFalse);
    });

    test('a ranking makes it format 7, holding every older key', () {
      final p = _pack(rankings: {_andorra: 3, 1: 120});
      expect(p.asWritten.formatVersion, 7);
      final json = p.asWritten.toJson();
      expect(
        json.keys,
        containsAll(['managers', 'yHandles', 'addedStadiums', 'rankings']),
      );
      expect(json['rankings'], {'2': 3, '1': 120});
      expect(_roundTrip(p), p);
    });

    test('an older file reads with no ranking set', () {
      for (final v in [1, 3, 5, 6]) {
        final json = _pack().copyWith(formatVersion: v).toJson();
        if (v < 6) {
          json
            ..remove('addedReporters')
            ..remove('addedStadiums');
        }
        if (v < 5) {
          json
            ..remove('sponsorIndustries')
            ..remove('yHandles');
        }
        if (v < 4) json.remove('managers');
        if (v < 3) json.remove('clubStrengths');
        if (v < 2) {
          for (final k in [
            'pools',
            'addedClubs',
            'addedSponsors',
            'addedYAccounts',
            'localized',
          ]) {
            json.remove(k);
          }
        }
        final p = WorldPack.fromJson(WorldPack.migrate(json));
        expect(p.formatVersion, kPackFormatVersion, reason: 'format $v');
        expect(p.rankings, isEmpty, reason: 'format $v');
      }
      // A format-6 file already holding the format-7 key is no such file.
      final six = _pack().copyWith(formatVersion: 6).toJson();
      expect(
        () => WorldPack.migrate({...six, 'rankings': <String, Object?>{}}),
        throwsFormatException,
      );
    });

    test('a ranking of the wrong shape is refused', () {
      final json = _pack(rankings: {1: 3}).toJson();
      for (final bad in <Object?>[
        {'1': '3'},
        {'01': 3},
        [3],
      ]) {
        expect(
          () => WorldPack.fromJson({...json, 'rankings': bad}),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });

    test(
      'the .fnmdb file carries it; a place out of range is refused',
      () async {
        final ok = await PackCodec.decode(
          PackCodec.encode(_pack(rankings: {_andorra: 3}), const {}),
        );
        expect((ok as PackDecoded).pack.rankings, {_andorra: 3});

        for (final rank in [0, -1, PackRules.rankingMax + 1]) {
          final bad = await PackCodec.decode(
            PackCodec.encode(_pack(rankings: {_andorra: rank}), const {}),
          );
          expect(bad, isA<PackRejected>(), reason: '$rank');
        }
      },
    );
  });

  group('the rules', () {
    test('a place out of range is a field to fix', () {
      final issues = PackRules.issues(_pack(rankings: {1: 0, 2: 5, 3: 301}));
      expect(
        [
          for (final i in issues)
            if (i is BadField) (i.path, i.reason),
        ],
        [
          ('rankings.1', FieldReason.outOfRange),
          ('rankings.3', FieldReason.outOfRange),
        ],
      );
    });

    test('a nation the game no longer has is flagged and removable', () {
      final p = _pack(rankings: {1: 4, 999: 7});
      final issues = PackRules.compatibility(
        p,
        nationIds: {1, 2},
        competitionNames: const {},
        trophyKeys: const {},
        sponsorBrands: const {},
        yAccounts: const {},
        countryCodes: const {},
        fringeRanges: const {},
      );
      expect(issues.map((i) => i.where), ['rankings.999']);
      expect(issues.single, isA<UnknownId>());
      expect(EditorSection.ofPath('rankings.999'), EditorSection.players);
      expect(PackEditor.dropUnknown(p, 'rankings.999').rankings, {1: 4});
    });
  });

  group('RankingEdits', () {
    test('sets and clears a place, one nation at a time', () {
      final set = RankingEdits.withRanking(_pack(), 5, 12);
      expect(set.rankings, {5: 12});
      expect(RankingEdits.withRanking(set, 5, 12), same(set));
      expect(RankingEdits.withRanking(set, 6, 1).rankings, {5: 12, 6: 1});
      expect(RankingEdits.withRanking(set, 5, null).rankings, isEmpty);
    });
  });

  group('PackRanking.withPinned', () {
    final ranks = {for (var i = 1; i <= 6; i++) i: i};

    test('nothing pinned leaves the ranks', () {
      expect(PackRanking.withPinned(ranks, const {}), same(ranks));
      expect(PackRanking.withPinned(ranks, const {99: 1}), same(ranks));
    });

    test('a pinned nation takes its place and the rest close up', () {
      // Nation 6 to the top: everyone else one down.
      expect(PackRanking.withPinned(ranks, const {6: 1}), {
        6: 1,
        1: 2,
        2: 3,
        3: 4,
        4: 5,
        5: 6,
      });
      // Nation 1 to 4th: 2, 3, 4 move up a place, 5 and 6 stay.
      expect(PackRanking.withPinned(ranks, const {1: 4}), {
        1: 4,
        2: 1,
        3: 2,
        4: 3,
        5: 5,
        6: 6,
      });
    });

    test('two pins on one place share it; past the last reads as last', () {
      final out = PackRanking.withPinned(ranks, const {5: 2, 6: 2, 1: 99});
      expect(out[5], 2);
      expect(out[6], 2);
      expect(out[1], 6);
      expect([out[2], out[3], out[4]], [1, 3, 4]);
    });

    test('places shared before stay shared', () {
      final shared = {1: 1, 2: 2, 3: 2, 4: 3};
      expect(PackRanking.withPinned(shared, const {4: 1}), {
        4: 1,
        1: 2,
        2: 3,
        3: 3,
      });
    });
  });

  test(
    'a ranking set in the editor is where a new career starts',
    timeout: const Timeout.factor(4),
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');

      // Edited as the squad screen does, and saved by the editor.
      final sub = c.listen(packEditorProvider(packId), (_, _) {});
      addTearDown(sub.close);
      while (c.read(packEditorProvider(packId)).valueOrNull == null) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      final editor = c.read(packEditorProvider(packId).notifier)
        ..update((p) => RankingEdits.withRanking(p, _andorra, 3));
      await editor.flush();
      expect(
        (await c.read(worldPackRepositoryProvider).load(packId))!.rankings,
        {_andorra: 3},
      );

      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: 1,
                    managerName: 'M',
                    rngSeed: 7,
                    worldPackId: packId,
                  ))
              .valueOrNull!;

      final ranks = await c
          .read(seedRankingRepositoryProvider)
          .forCycle(career.id, 0);
      expect(ranks[_andorra], 3);
      // No other nation sits on 3rd, and the places run 1..n.
      expect(ranks.entries.where((e) => e.value == 3).map((e) => e.key), [
        _andorra,
      ]);
      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      final base = {for (final n in world) n.id: n.ranking};
      final distinct = base.values.toSet().length == base.length;
      if (distinct) {
        expect(ranks.values.toSet(), {
          for (var i = 1; i <= ranks.length; i++) i,
        });
      }
      // The career's own world reads the same ranking.
      final nations = await c
          .read(nationRepositoryProvider)
          .forCareer(career.id);
      expect(nations.firstWhere((n) => n.id == _andorra).ranking, 3);
    },
  );
}
