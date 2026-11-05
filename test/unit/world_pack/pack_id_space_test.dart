import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// Every lower-case three-letter code: the keys a league can have.
Iterable<String> _allCodes() sync* {
  const a = 'abcdefghijklmnopqrstuvwxyz';
  for (final x in a.split('')) {
    for (final y in a.split('')) {
      for (final z in a.split('')) {
        yield '$x$y$z';
      }
    }
  }
}

void main() {
  test(r'no SponsorBrand name, YFeed.namedAccounts entry or league club '
      r'matches ^pack\d', () {
    // A pack sponsor is stored as 'pack<id>' (PackSponsor.key); a game name
    // of that shape would be mistaken for one.
    final shape = RegExp(r'^pack\d', caseSensitive: false);
    expect(
      const PackSponsor(
        id: kPackAddedIdBase,
        name: 'S',
        deal: SponsorDeal.risky,
        industry: 'x',
      ).key,
      matches(shape),
    );
    expect([
      for (final b in SponsorBrand.values)
        if (shape.hasMatch(b.name)) b.name,
    ], isEmpty);
    expect(YFeed.namedAccounts.where(shape.hasMatch), isEmpty);
    final clubs = [for (final c in _allCodes()) ...ClubService.leagueClubs(c)];
    expect(clubs, isNotEmpty);
    expect(clubs.where(shape.hasMatch), isEmpty);
  });

  test('reserved ranges do not overlap players, newgens or golden ids', () {
    // Added items, then pack-made players, sit above the seeded fringe (80
    // a nation from firstFringeId, for far fewer than 1 000 nations).
    const fringeTop =
        PoolGenerator.firstFringeId + 1000 * PoolGenerator.extraPerNation;
    expect(kPackAddedIdBase, greaterThan(fringeTop));
    expect(kPackAddedIdMax, greaterThan(kPackAddedIdBase));
    expect(kPackAddedIdMax, lessThan(kPackPlayerIdBase));
    expect(kPackPlayerIdBase, lessThan(GoldenGeneration.idBase));
    for (final id in [
      kPackAddedIdBase,
      kPackAddedIdMax,
      kPackPlayerIdBase,
      GoldenGeneration.idBase - 1,
    ]) {
      expect(PlayerLifecycle.isNewgenId(id), isFalse, reason: '$id');
    }
    // Ids stay ints that JSON and SQLite carry exactly.
    expect(GoldenGeneration.idBase, lessThan(1 << 31));
  });

  test(
    "fringeRanges gives each nation's stored fringe, no two overlapping",
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final ranges = await c.read(playerRepositoryProvider).fringeRanges();
      expect(ranges, isNotEmpty);
      final sorted = ranges.values.toList()
        ..sort((a, b) => a.first.compareTo(b.first));
      expect(sorted.first.first, PoolGenerator.firstFringeId);
      for (final r in sorted) {
        expect(r.last - r.first + 1, PoolGenerator.extraPerNation);
        expect(r.last, lessThan(kPackAddedIdBase));
      }
      for (var i = 1; i < sorted.length; i++) {
        expect(sorted[i].first, greaterThan(sorted[i - 1].last));
      }
    },
  );
}
