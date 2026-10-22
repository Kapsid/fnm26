import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

void main() {
  test('campaign markers read back as tags per career', () async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
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
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await container.read(seedLoaderProvider).ensureSeeded();
    final svc = container.read(careerServiceProvider);
    final a = (await svc.create(
      nationId: nations[0].id,
      managerName: 'A',
      rngSeed: 1,
    )).valueOrNull!;
    final b = (await svc.create(
      nationId: nations[1].id,
      managerName: 'B',
      rngSeed: 2,
    )).valueOrNull!;
    final comp = container.read(competitionRepositoryProvider);

    expect(await container.read(campaignOfProvider(a.id).future), isNull);
    expect(countsAsSave(null), isTrue);

    await comp.markDrawWatched(a.id, 0, campaignMarker('grudge'));
    container.invalidate(campaignOfProvider(a.id));
    final first = await container.read(campaignOfProvider(a.id).future);
    expect(first!.def, Campaigns.grudge);
    expect(first.moved, isFalse);
    expect(countsAsSave(first), isFalse);

    await comp.markDrawWatched(a.id, 0, campaignMovedKind);
    container.invalidate(campaignOfProvider(a.id));
    final second = await container.read(campaignOfProvider(a.id).future);
    expect(second!.moved, isTrue);
    expect(countsAsSave(second), isTrue);

    await comp.markDrawWatched(b.id, 0, campaignMarker('nope'));
    container.invalidate(campaignOfProvider(b.id));
    expect(await container.read(campaignOfProvider(b.id).future), isNull);

    await comp.markDrawWatched(b.id, 0, campaignMarker('transplant'));
    final rows = await comp.watchedKindsWithPrefix('campaign:');
    expect(rows.map((r) => r.careerId).toSet(), {a.id, b.id});
    final tags = await campaignTags(comp);
    expect(tags[a.id]!.def, Campaigns.grudge);
    expect(tags[b.id]!.def, Campaigns.transplant);
  });

  test('a transplant run moved before moving was closed off still works', () {
    // The tag is all a moved run is: it keeps its slot and rolls as a career,
    // whatever canContinue says today.
    const moved = (def: Campaigns.transplant, moved: true);
    expect(Campaigns.transplant.canContinue, isFalse);
    expect(countsAsSave(moved), isTrue);
    expect(campaignMayRoll(moved, 0), isTrue);
  });
}
