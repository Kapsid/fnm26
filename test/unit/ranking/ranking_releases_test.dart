import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

import '../../helpers/test_database.dart';

/// The world ranking is republished as the save advances, and each release is
/// announced in the inbox. Previously the ranking was only reported once per
/// four-year cycle, so it read as though it never changed.
void main() {
  test(
    'the ranking is published periodically and announced',
    () async {
      final db = createTestDatabase();
      final nations =
          (jsonDecode(
                    File('assets/data/nations.json').readAsStringSync(),
                  )
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);

      await container.read(seedLoaderProvider).ensureSeeded();
      // A mid-table nation: the very top and very bottom barely move by design
      // (Elo gives little for an expected result), so the middle is where the
      // table's responsiveness actually shows.
      final european =
          nations.where((n) => n.confederation == Confederation.europe).toList()
            ..sort((a, b) => a.ranking.compareTo(b.ranking));
      final player = european[european.length ~/ 2];
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: player.id,
                    managerName: 'A',
                  ))
              .valueOrNull!;

      final season = container.read(seasonServiceProvider);
      var lastDate = DateTime(1900);
      for (var i = 0; i < 60; i++) {
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (!hub.career.inGameDate.isAfter(lastDate)) break;
        lastDate = hub.career.inGameDate;
      }

      final releases = await container
          .read(rankingReleaseRepositoryProvider)
          .all(career.id);
      expect(
        releases.length,
        greaterThan(3),
        reason: 'the ranking should be republished as windows are played',
      );

      // At most one release per calendar month, and never two for a month.
      final months = releases
          .map((r) => '${r.publishedOn.year}-${r.publishedOn.month}')
          .toList();
      expect(months.toSet().length, months.length, reason: 'one per month');

      // Ordered oldest first, and every release names a real leader.
      for (var i = 1; i < releases.length; i++) {
        expect(
          releases[i].publishedOn.isAfter(releases[i - 1].publishedOn),
          isTrue,
        );
      }
      final ids = nations.map((n) => n.id).toSet();
      for (final r in releases) {
        expect(ids, contains(r.leaderNationId));
        expect(r.playerRank, greaterThanOrEqualTo(1));
      }

      // The whole complaint: the table looked frozen. A mid-table nation playing
      // a season of competitive football must actually move.
      final ranks = releases.map((r) => r.playerRank).toSet();
      expect(
        ranks.length,
        greaterThan(1),
        reason: 'the ranking must move across releases, not sit still',
      );
      final spread =
          ranks.reduce((a, b) => a > b ? a : b) -
          ranks.reduce((a, b) => a < b ? a : b);
      expect(
        spread,
        greaterThanOrEqualTo(2),
        reason: 'movement should be worth more than a single place',
      );

      // Each release is announced, and the copy carries the leader and the rank.
      final inbox = await container.read(
        messageInboxProvider(career.id).future,
      );
      final rankMessages = inbox.messages
          .where((m) => m.category == 'ranking')
          .toList();
      expect(
        rankMessages.length,
        releases.length,
        reason: 'every release is announced exactly once',
      );
      for (final m in rankMessages) {
        expect(m.body, contains('The world ranking has been updated'));
        expect(m.body, contains('top the world'));
      }

      // Every release names the cycle and nation it describes, so its movement
      // can be measured against the right baseline.
      for (final r in releases) {
        expect(r.nationId, player.id);
        expect(r.cycle, greaterThanOrEqualTo(0));
      }

      // THE ANCHOR: a message's movement must be measured from the shared
      // freeze — `movementBaselineFor`, the World Championship draw that ended
      // the previous cycle, falling back to the cycle's own starting positions
      // — which is the same baseline the ranking screen's arrows use.
      // Reporting the move since the previous release made the inbox narrate
      // monthly wiggles the screen never showed.
      final seedRanks = container.read(seedRankingRepositoryProvider);
      final staticRank = {for (final n in nations) n.id: n.ranking};
      for (final r in releases) {
        final baseline = (await movementBaselineFor(
          seedRanks,
          career.id,
          r.cycle,
        )).rankById;
        final was = baseline[r.nationId] ?? staticRank[r.nationId]!;
        final expectedMove = was - r.playerRank;
        final body = rankMessages
            .firstWhere((m) => m.title == 'World ranking · #${r.playerRank}')
            .body;
        if (expectedMove == 0) {
          expect(body, contains('#${r.playerRank}'));
        } else {
          // The message must report the cycle move's magnitude ("N place(s)"),
          // not a release-to-release delta — the exact phrasing varies.
          expect(
            body.toLowerCase(),
            contains('${expectedMove.abs()} place'),
            reason: 'movement must be cycle-anchored, not release-to-release',
          );
        }
      }

      // And the screen agrees: at a release the published rank IS the live rank,
      // so both sides report the same movement for the same nation.
      final ranking = await container.read(
        worldRankingProvider(career.id).future,
      );
      final live = ranking!.position[player.id];
      final latest = releases.last;
      if (latest.playerRank == live) {
        final baseline = (await movementBaselineFor(
          seedRanks,
          career.id,
          latest.cycle,
        )).rankById;
        final was = baseline[latest.nationId] ?? staticRank[latest.nationId]!;
        expect(
          ranking.movement[player.id],
          was - latest.playerRank,
          reason: 'the screen and the inbox must measure the same thing',
        );
      }

      // Re-syncing must not duplicate them.
      await container.read(messageServiceProvider).sync(career.id);
      container.invalidate(messageInboxProvider);
      final again = await container.read(
        messageInboxProvider(career.id).future,
      );
      expect(
        again.messages.where((m) => m.category == 'ranking').length,
        rankMessages.length,
        reason: 'dedup keys must keep re-syncs idempotent',
      );

      // The ranking chart draws from these releases, so it has several points —
      // not the single flat line the old per-cycle history gave a young career.
      final history = await container.read(
        rankHistoryProvider(career.id).future,
      );
      expect(
        history.length,
        greaterThanOrEqualTo(3),
        reason: 'the chart should plot the recent releases, not one point',
      );
      expect(
        history.length,
        lessThanOrEqualTo(kRankHistoryPoints),
        reason: 'only the most recent handful are shown',
      );
      // Chronological, and every point is a real world position.
      for (var i = 1; i < history.length; i++) {
        expect(
          history[i].date.isBefore(history[i - 1].date),
          isFalse,
          reason: 'the line runs left-to-right in time',
        );
      }
      expect(history.every((p) => p.rank >= 1), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
