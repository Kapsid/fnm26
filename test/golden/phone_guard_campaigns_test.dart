import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone campaigns list after the rework into compact tiles in sections
/// by length (one campaign conquered, one failed), and the Finish the Legacy
/// brief. A free manager, so the Pro tiles wear the lock.
void main() {
  final free = [premiumUnlockedProvider.overrideWith((ref) => false)];

  testWidgets('campaigns_phone', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(() async {
      final store = save.container.read(campaignRecordStoreProvider);
      await store.record('transplant', 2);
      await store.record('grudge', 0);
    });
    await pumpRoute(tester, save, Routes.campaigns);
    expect(find.byType(CampaignTile), findsWidgets);
    await expectAppGolden('goldens/campaigns_phone.png');
  });

  testWidgets('campaign_brief_legacy_phone', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=legacy');
    await expectAppGolden('goldens/campaign_brief_legacy_phone.png');
  });
}
