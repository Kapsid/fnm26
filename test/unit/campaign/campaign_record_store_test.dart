import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;
  late CampaignRecordStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
    store = container.read(campaignRecordStoreProvider);
  });

  test('nothing recorded yet is null', () async {
    expect(await store.best('grudge'), isNull);
  });

  test('a failure is remembered as 0', () async {
    await store.record('grudge', 0);
    expect(await store.best('grudge'), 0);
  });

  test('keeps the maximum: a later failure never lowers a conquest', () async {
    await store.record('grudge', 0);
    await store.record('grudge', 2);
    expect(await store.best('grudge'), 2);
    await store.record('grudge', 1);
    expect(await store.best('grudge'), 2);
    await store.record('grudge', 0);
    expect(await store.best('grudge'), 2);
  });

  test('another campaign is unaffected', () async {
    await store.record('grudge', 3);
    expect(await store.best('other'), isNull);
  });

  test('record refreshes campaignBestProvider (no circular dependency)',
      () async {
    final sub = container.listen(
      campaignBestProvider('grudge'),
      (_, _) {},
    );
    addTearDown(sub.close);
    expect(await container.read(campaignBestProvider('grudge').future), isNull);
    await store.record('grudge', 1);
    expect(await container.read(campaignBestProvider('grudge').future), 1);
  });
}
