import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sharing one career out, and taking one in.
///
/// The whole-database backup in Settings is the safety net; this is the
/// sociable one. It MERGES: importing adds a save rather than replacing what
/// is there, which is what makes it safe to accept a file from somebody else.
class CareerTransferService {
  CareerTransferService(this._ref);

  final Ref _ref;

  /// Writes [careerId] to a file ready to be shared, and returns it.
  ///
  /// Written to the temporary directory: the share sheet copies it wherever
  /// the player wants, and a permanent second copy of a career in app storage
  /// is just a way to run out of room.
  Future<File> export(int careerId, {DateTime? at}) async {
    final db = _ref.read(appDatabaseProvider);
    final bundle = await CareerBundle.export(db, careerId);
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        CareerBundle.suggestedFileName(
          (bundle['managerName'] as String?) ?? 'career',
          at ?? DateTime.now(),
        ),
      ),
    );
    await file.writeAsBytes(CareerBundle.encode(bundle));
    return file;
  }

  /// The career's copy in the app's own `FNM` folder, written at the end of
  /// every cycle. One file per career, overwritten each time, so it stays the
  /// size of one career: the folder rides in the phone's own backup, and that
  /// has a quota. It lives inside the app, so uninstalling removes it; a copy
  /// off the phone is the saves list's Back up button.
  Future<File> appFolderBackupFile(int careerId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(
      p.join(dir.path, 'FNM', 'career-$careerId.${CareerBundle.extension}'),
    );
  }

  /// Writes [careerId] to [appFolderBackupFile], replacing the last one.
  Future<File> backupToAppFolder(int careerId) async {
    final file = await appFolderBackupFile(careerId);
    await file.parent.create(recursive: true);
    final bundle = await CareerBundle.export(
      _ref.read(appDatabaseProvider),
      careerId,
    );
    // Written beside and renamed over, so a backup cut short never replaces
    // the good one with half a file.
    final partial = File('${file.path}.partial');
    await partial.writeAsBytes(CareerBundle.encode(bundle), flush: true);
    return partial.rename(file.path);
  }

  /// Removes [careerId]'s app-folder copy, when the career itself is deleted.
  Future<void> removeAppFolderBackup(int careerId) async {
    final file = await appFolderBackupFile(careerId);
    if (file.existsSync()) await file.delete();
  }

  /// Adds the career in [path] as a new save. Returns why it was refused, or
  /// null once it is in.
  ///
  /// A free player is held to the same two limits here as everywhere else: an
  /// import takes a save slot, and a career past the free cycle is what the
  /// purchase sells, whoever played it.
  Future<BundleRejection?> import(String path) async {
    // The stored ranking must be current before a career lands: an update's
    // reconcile freezes every career it finds on the ranking it replaces.
    await _ref.read(seedLoaderProvider).ensureSeeded();
    final read = await CareerBundle.readFile(File(path));
    if (read.rejection != null) return read.rejection;
    final premium = _ref.read(premiumUnlockedProvider);
    // An unmoved campaign run holds no slot and may not duplicate a run.
    final kinds = CareerBundle.watchedKindsOf(read.bundle!);
    final campaign = kinds.contains(campaignMovedKind)
        ? null
        : kinds
              .map(
                (k) => k.startsWith('campaign:')
                    ? Campaigns.byId(k.substring('campaign:'.length))
                    : null,
              )
              .nonNulls
              .firstOrNull;
    final existing = await _ref.read(careerRepositoryProvider).all();
    final tags = await campaignTags(_ref.read(competitionRepositoryProvider));
    if (campaign != null) {
      final runExists = existing.any((c) {
        final t = tags[c.id];
        return t != null && !t.moved && t.def.id == campaign.id;
      });
      if (runExists) return BundleRejection.campaignRunExists;
    } else {
      // An unmoved campaign run holds no slot (see countsAsSave).
      final slotsUsed = existing.where((c) => countsAsSave(tags[c.id])).length;
      if (!canCreateSave(
        existingSaves: slotsUsed,
        premiumUnlocked: premium,
      )) {
        return BundleRejection.slotsFull;
      }
    }
    // The same rule that locks a save already here (see saveNeedsPremium): a
    // file is not a way round it. A Pro campaign run, moved or not, needed Pro
    // to start, so it needs Pro to come in.
    final proCampaign = kinds.any(
      (k) =>
          k.startsWith('campaign:') &&
          (Campaigns.byId(k.substring('campaign:'.length))?.needsPro ?? false),
    );
    if (importNeedsPremium(
      cyclePointer: CareerBundle.cyclePointerOf(read.bundle!),
      premiumUnlocked: premium,
      proCampaign: proCampaign,
    )) {
      return BundleRejection.needsPremium;
    }
    await CareerBundle.import(_ref.read(appDatabaseProvider), read.bundle!);
    _ref
      ..invalidate(savesProvider)
      ..invalidate(campaignRunsProvider);
    return null;
  }
}

final Provider<CareerTransferService> careerTransferServiceProvider =
    Provider<CareerTransferService>(CareerTransferService.new);
