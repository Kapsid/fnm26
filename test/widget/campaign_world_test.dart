import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/campaign/campaign_brief_screen.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart' show insertPack, testPack;
import '../helpers/seeded_save.dart';

/// A campaign's brief offers the world chip a new career has: Default, or a
/// custom database, those that cannot start this campaign greyed out.
void main() {
  final free = [premiumUnlockedProvider.overrideWith((ref) => false)];
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  Finder chipText(String name) => find.descendant(
    of: find.byKey(CampaignBriefScreen.worldKey),
    matching: find.text(enL.worldChip(name)),
  );

  Future<void> openSheet(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(CampaignBriefScreen.worldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CampaignBriefScreen.worldKey));
    await settle(tester);
  }

  testWidgets('Start on a chosen database makes the run on it', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    final c = save.container;
    final id = await insertPack(tester, c, testPack('Mine'));
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=grudge');
    // A designed scenario: Default unless the manager picks otherwise.
    expect(chipText(enL.worldDefault), findsOneWidget);

    await openSheet(tester);
    await tester.tap(find.byKey(WorldChoiceSheet.packKey(id)));
    await settle(tester);
    expect(chipText('Mine'), findsOneWidget);
    expect(c.read(campaignWorldProvider('grudge')), id);

    await tester.ensureVisible(find.byKey(CampaignBriefScreen.startKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CampaignBriefScreen.startKey));
    await settle(tester, allowSpinner: true);
    final uri = c.read(routerProvider).routeInformationProvider.value.uri;
    expect(uri.path, Routes.hub);
    final runId = int.parse(uri.queryParameters['careerId']!);
    final onPack = await tester.runAsync(
      () => c
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(runId, 0, worldPackMarker('uuid-Mine')),
    );
    expect(onPack, isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('a database renaming a nation the campaign names is greyed out '
      'with the reason, and its name is masked', (tester) async {
    final save = await seedSave(tester, overrides: free);
    final c = save.container;
    final id = await insertPack(
      tester,
      c,
      const WorldPack(
        uuid: 'uuid-renamed',
        name: 'Fuck Face',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: kPackGameVersion,
        nations: {1: (name: 'Illyria', code: '')}, // Albania
      ),
    );
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=grudge');
    await openSheet(tester);

    final row = find.byKey(WorldChoiceSheet.packKey(id));
    expect(
      find.descendant(of: row, matching: find.text('F*** Face')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: row,
        matching: find.text(enL.campaignWorldRenames('Albania')),
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<ListTile>(
            find.descendant(of: row, matching: find.byType(ListTile)),
          )
          .enabled,
      isFalse,
    );
  });

  testWidgets('a pick that went stale is refused at Start and goes back to '
      'Default; nothing is made', (tester) async {
    final save = await seedSave(tester, overrides: free);
    final c = save.container;
    final id = await insertPack(tester, c, testPack('Doomed'));
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=grudge');
    await openSheet(tester);
    await tester.tap(find.byKey(WorldChoiceSheet.packKey(id)));
    await settle(tester);
    expect(chipText('Doomed'), findsOneWidget);

    await tester.runAsync(
      () => c.read(worldPackRepositoryProvider).delete(id),
    );
    c.invalidate(worldPacksProvider);
    await tester.ensureVisible(find.byKey(CampaignBriefScreen.startKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CampaignBriefScreen.startKey));
    await settle(tester);
    expect(find.text(enL.worldPackGone), findsOneWidget);
    expect(c.read(campaignWorldProvider('grudge')), isNull);
    final runs = await tester.runAsync(
      () => c.read(campaignRunsProvider.future),
    );
    expect(runs, isEmpty);
  });
}
