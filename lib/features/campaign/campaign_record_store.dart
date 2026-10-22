import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The shared_preferences key holding one campaign's best result: `0` failed,
/// `1..3` best stars; absent means it was never finished. Records live outside
/// the save database (no schema bump) and outside any one save, so a campaign
/// run can be abandoned or deleted without losing the stamp it earned.
String _bestKey(String campaignId) => 'campaign_best_v1:$campaignId';

/// Remembers the best result per campaign on this device.
class CampaignRecordStore {
  const CampaignRecordStore(this._ref);

  final Ref _ref;

  /// The best result so far: `null` never finished, `0` failed, `1..3` stars.
  Future<int?> best(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestKey(id));
  }

  /// Records a finished run ([stars] 0 for a failure). Keeps the maximum, so a
  /// later failure never lowers a conquest.
  Future<void> record(String id, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_bestKey(id));
    if (current == null || stars > current) {
      await prefs.setInt(_bestKey(id), stars);
    }
    _ref.invalidate(campaignBestProvider(id));
  }
}

final Provider<CampaignRecordStore> campaignRecordStoreProvider = Provider(
  CampaignRecordStore.new,
);

/// One campaign's best result. Reads the store rather than watching it: the
/// store invalidates this provider after every write, and a provider that
/// watched the store would make that a circular dependency.
final AutoDisposeFutureProviderFamily<int?, String> campaignBestProvider =
    FutureProvider.autoDispose.family<int?, String>(
      (ref, id) => ref.read(campaignRecordStoreProvider).best(id),
    );
