import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sharing one career out, and taking one in.
///
/// The whole-database backup in Settings is the safety net; this is the
/// sociable one. It MERGES: importing adds a save rather than replacing what
/// is there, which is what makes it safe to accept a file from somebody else.
/// The roots of what format 2 adds to a world, whose references a bundle's
/// world must keep to (see `CareerTransferService._checkWorld`).
const Set<String> _formatTwoRoots = {
  'pools',
  'addedClubs',
  'addedSponsors',
  'addedYAccounts',
};

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
    // The career's own copy of its world comes from outside the device, so
    // it passes the checks a `.fnmdb` file does, or nothing comes in.
    final worldRejection = await _checkWorld(read.bundle!);
    if (worldRejection != null) return worldRejection;
    final db = _ref.read(appDatabaseProvider);
    final newId = await CareerBundle.import(db, read.bundle!);
    // A career that came with a custom world shows its names at once.
    final world = await (db.select(
      db.careerWorlds,
    )..where((t) => t.careerId.equals(newId))).getSingleOrNull();
    if (world != null) _ref.read(activeWorldSyncProvider).noteWorld(newId);
    _ref
      ..invalidate(savesProvider)
      ..invalidate(campaignRunsProvider);
    return null;
  }

  /// Checks the custom world [bundle] carries (`career_worlds` and
  /// `career_world_trophies`) exactly as `PackCodec.decode` checks a
  /// `.fnmdb` file: the pack read by its strict reader and every field held
  /// to the editor's rules, the stored name capped, and every trophy picture
  /// decoded and drawn again. The bundle then carries the normaliser's
  /// pictures in place of its own. A rejection when anything fails, and the
  /// bundle is refused whole: [BundleRejection.fromANewerBuild] for a world
  /// in a pack format this build does not read yet, else
  /// [BundleRejection.unreadable]. Null when it passes; a bundle with no
  /// world passes untouched.
  Future<BundleRejection?> _checkWorld(Map<String, Object?> bundle) async {
    final tables = bundle['tables'];
    if (tables is! Map) return BundleRejection.unreadable;
    final worlds = tables['career_worlds'] ?? const <Object?>[];
    final trophies = tables['career_world_trophies'] ?? const <Object?>[];
    if (worlds is! List || trophies is! List) return BundleRejection.unreadable;
    if (worlds.isEmpty && trophies.isEmpty) return null;
    // One world per career, and no picture without one.
    if (worlds.length != 1) return BundleRejection.unreadable;
    final row = worlds.single;
    if (row is! Map) return BundleRejection.unreadable;
    final packName = row['pack_name'];
    final json = row['json'];
    if (packName is! String || PackRules.checkName(packName) != null) {
      return BundleRejection.unreadable;
    }
    if (json is! String || json.length > PackCodec.maxJsonBytes)
      return BundleRejection.unreadable;
    final WorldPack pack;
    try {
      final raw = jsonDecode(json);
      if (raw is! Map<String, Object?>) return BundleRejection.unreadable;
      final inner = raw['formatVersion'];
      if (inner is int && inner > kPackFormatVersion) {
        return BundleRejection.fromANewerBuild;
      }
      pack = WorldPack.fromJson(WorldPack.migrate(raw));
    } on Object {
      return BundleRejection.unreadable;
    }
    final base = await _ref.read(nationRepositoryProvider).newCareerWorld();
    final codes = {for (final n in base) n.id: n.code};
    if (!PackCodec.fieldsOk(pack, baseCodes: codes))
      return BundleRejection.unreadable;
    // A career world is played as it is, never assessed again: what format 2
    // adds (pools, added clubs, sponsors and Y accounts) must name only what
    // this game has, every pool fringe id its own nation's.
    final unknown = PackGameKeys.of(
      codes.keys,
      codes: codes,
      fringeRanges: await _ref.read(playerRepositoryProvider).fringeRanges(),
    ).check(pack);
    if (unknown.any(
      (i) => _formatTwoRoots.contains(i.where.split('.').first),
    )) {
      return BundleRejection.unreadable;
    }
    if (trophies.length > PackCodec.maxTrophies)
      return BundleRejection.unreadable;
    final keys = <String>{};
    final normalised = <Map<String, Object?>>[];
    for (final t in trophies) {
      if (t is! Map) return BundleRejection.unreadable;
      final key = t['key'];
      final png = t['png'];
      if (key is! String || Trophies.assetForKey(key) == null)
        return BundleRejection.unreadable;
      if (!keys.add(key) || png is! String) return BundleRejection.unreadable;
      final Uint8List input;
      try {
        input = base64Decode(png);
      } on FormatException {
        return BundleRejection.unreadable;
      }
      final out = await TrophyNormaliser.normalise(input, key);
      if (out == null) return BundleRejection.unreadable;
      normalised.add({
        for (final e in t.entries) '${e.key}': e.value,
        'png': base64Encode(out.png),
      });
    }
    tables['career_world_trophies'] = normalised;
    return null;
  }
}

final Provider<CareerTransferService> careerTransferServiceProvider =
    Provider<CareerTransferService>(CareerTransferService.new);
