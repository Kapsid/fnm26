import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show immutable;
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/util/off_ui.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/world_pack/pack_gzip.dart';

import 'pack_rules.dart';
import 'trophy_normaliser.dart';
import 'world_pack.dart';

/// Why a `.fnmdb` file was refused.
enum PackRejection { tooBig, notAPack, newerFormat, badData, badTrophy }

/// What reading a `.fnmdb` file gave.
sealed class PackDecode {
  const PackDecode();
}

/// A file that passed every check. [trophies] are the normaliser's output,
/// never the file's own bytes.
@immutable
class PackDecoded extends PackDecode {
  const PackDecoded(this.pack, this.trophies);
  final WorldPack pack;
  final Map<String, Uint8List> trophies;
}

@immutable
class PackRejected extends PackDecode {
  const PackRejected(this.reason);
  final PackRejection reason;
}

/// Thrown when a pack would make a file over [PackCodec.maxFileBytes]:
/// every device would refuse it, so none is written. [bytes] is the size it
/// would have had.
@immutable
class PackTooBigToShare implements Exception {
  const PackTooBigToShare(this.bytes);
  final int bytes;
}

class _TooBig implements Exception {
  const _TooBig();
}

/// A sink that keeps what it is given and throws once there is too much.
class _CappedSink implements Sink<List<int>> {
  _CappedSink(this.limit);
  final int limit;
  final BytesBuilder _out = BytesBuilder(copy: false);

  @override
  void add(List<int> data) {
    if (_out.length + data.length > limit) throw const _TooBig();
    _out.add(data);
  }

  @override
  void close() {}

  Uint8List take() => _out.takeBytes();
}

/// The `.fnmdb` file: a gzip of `{format, pack, trophies: {key: base64}}`.
///
/// It is data only. Reading one never executes anything: the size is capped,
/// the unzip is streamed and aborted past [maxJsonBytes], the JSON is read
/// by [WorldPack.fromJson]'s strict reader, every field is checked against
/// the editor's rules and every trophy is decoded and drawn again.
abstract final class PackCodec {
  static const extension = 'fnmdb';

  /// The type a pack is shared with, and the one the app registers to open
  /// (`application/x-fnmdb`; on iOS the `com.fnm.fnmdb` type carries it).
  static const mimeType = 'application/x-fnmdb';
  static const maxFileBytes = 8 << 20;

  /// The most a file (or a career bundle's world) may unzip to. The
  /// largest legal world (every nation with a 40-man squad and a fixed pool
  /// of 150, every added list and `localized` at its cap) is about 11 MB
  /// of JSON; this leaves it twice that.
  static const maxJsonBytes = 24 << 20;

  /// The most players a nation's squad holds in a file; a pool holds at
  /// most [PackRules.poolMax].
  static const maxPlayersPerNation = PackRules.squadMax;
  static const maxTrophies = 9;

  /// The most nations a file gives a pool. The game has about 210.
  static const maxPoolNations = 400;

  /// Longest key an override map may carry.
  static const keyMax = 100;

  static const _topKeys = {'format', 'pack', 'trophies'};

  /// [p] as a `.fnmdb` file, in the oldest format that holds it
  /// ([WorldPack.asWritten]): format 3, which a 1.1.x build without managers
  /// reads, unless it names managers (format 4), sets an industry or a
  /// handle (5) or adds a reporter or a stadium (6).
  static Uint8List encode(WorldPack p, Map<String, Uint8List> trophies) {
    final written = p.asWritten;
    final json = jsonEncode({
      'format': written.formatVersion,
      'pack': written.toJson(),
      'trophies': {
        for (final e in trophies.entries) e.key: base64Encode(e.value),
      },
    });
    return gzipBytes(utf8.encode(json));
  }

  /// Reads [bytes]. [baseCodes] are the default world's nation codes; a
  /// pack giving two nations one code is kept and flagged ([fieldsOk]).
  static Future<PackDecode> decode(
    Uint8List bytes, {
    Map<int, String> baseCodes = const {},
  }) async {
    if (bytes.length > maxFileBytes) {
      return const PackRejected(PackRejection.tooBig);
    }
    if (bytes.length < 2 || bytes[0] != 0x1f || bytes[1] != 0x8b) {
      return const PackRejected(PackRejection.notAPack);
    }
    final (:code, :json) = await runOffUi(() => _read(bytes));
    if (code == 1) return const PackRejected(PackRejection.tooBig);
    final top = json;
    if (code != 0 || top is! Map<String, Object?>) {
      return const PackRejected(PackRejection.notAPack);
    }
    // No `pack` at all: some other file (a career bundle, say).
    if (top['pack'] is! Map<String, Object?>) {
      return const PackRejected(PackRejection.notAPack);
    }
    final format = top['format'];
    if (format is! int) return const PackRejected(PackRejection.notAPack);
    if (format > kPackFormatVersion) {
      return const PackRejected(PackRejection.newerFormat);
    }
    if (top.length != _topKeys.length || !top.keys.every(_topKeys.contains)) {
      return const PackRejected(PackRejection.badData);
    }
    final rawPack = top['pack'];
    final rawTrophies = top['trophies'];
    if (rawPack is! Map<String, Object?> ||
        rawTrophies is! Map<String, Object?>) {
      return const PackRejected(PackRejection.badData);
    }
    if (rawTrophies.length > maxTrophies ||
        !rawTrophies.keys.every((k) => Trophies.assetForKey(k) != null) ||
        !rawTrophies.values.every((v) => v is String)) {
      return const PackRejected(PackRejection.badData);
    }

    WorldPack pack;
    final inner = rawPack['formatVersion'];
    if (inner is int && inner > kPackFormatVersion) {
      return const PackRejected(PackRejection.newerFormat);
    }
    try {
      pack = WorldPack.fromJson(WorldPack.migrate(rawPack));
    } on Object {
      return const PackRejected(PackRejection.badData);
    }
    // A day-one manager the game cannot use (a blank name, an unknown
    // nationality or nation) is dropped alone, never the pack (checked only
    // against a known world). What is left must pass [fieldsOk]: a name too
    // long or unshowable refuses the file like any other.
    if (baseCodes.isNotEmpty && pack.managers.isNotEmpty) {
      pack = pack.copyWith(
        managers: WorldPack.usableManagers(
          pack.managers,
          nationIds: baseCodes.keys.toSet(),
          codes: {for (final c in baseCodes.values) c.toUpperCase()},
          dropped: (id, why) =>
              AppLog.info('pack-import', 'manager of nation $id dropped: $why'),
        ),
      );
    }
    if (!fieldsOk(pack, baseCodes: baseCodes)) {
      return const PackRejected(PackRejection.badData);
    }

    final trophies = <String, Uint8List>{};
    for (final e in rawTrophies.entries) {
      final Uint8List input;
      try {
        input = base64Decode(e.value! as String);
      } on FormatException {
        return const PackRejected(PackRejection.badTrophy);
      }
      final out = await TrophyNormaliser.normalise(input, e.key);
      if (out == null) return const PackRejected(PackRejection.badTrophy);
      trophies[e.key] = out.png;
    }
    return PackDecoded(
      pack.copyWith(trophies: trophies.keys.toSet()),
      trophies,
    );
  }

  /// Runs off the UI isolate: 0 = read, 1 = too big, 2 = not a pack.
  static ({int code, Object? json}) _read(Uint8List bytes) {
    try {
      final json = jsonDecode(utf8.decode(_gunzip(bytes)));
      return (code: 0, json: json);
    } on _TooBig {
      return (code: 1, json: null);
    } on Object {
      return (code: 2, json: null);
    }
  }

  /// Streamed, so a file that unzips to gigabytes is dropped at the cap.
  static Uint8List _gunzip(Uint8List bytes) {
    final sink = _CappedSink(maxJsonBytes);
    gunzipInto(bytes, sink);
    return sink.take();
  }

  /// Whether every field of [p] keeps to the editor's rules: names, caps on
  /// keys, squads, pools, added items and `localized` values, codes
  /// ([baseCodes] as for [decode]), ids, traits and the shapes of
  /// countries, industries and languages. Every pack that comes onto the
  /// device from outside passes this, a `.fnmdb` file's and a `.fnmcareer`
  /// bundle's world alike.
  ///
  /// Only safety refuses a file. Two nations under one code
  /// ([DuplicateCode]) are kept as well: the pack's own to fix, and a
  /// career waits until it is. A well-formed name this build does not
  /// know (a nation, country, industry, language, trait, deal or voice) is
  /// kept and flagged by [PackRules.compatibility], so files travel between
  /// newer and older games; so is an added club or Y account under one of
  /// the game's own names ([NameClash]), which a game update can add.
  ///
  /// The caps are checked first, so a hostile file is refused before any
  /// of its thousands of entries is looked at one by one.
  static bool fieldsOk(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
  }) {
    if (PackRules.checkName(p.name) != null) return false;
    if (p.author.isNotEmpty && PackRules.checkName(p.author) != null) {
      return false;
    }
    if (p.madeWithVersion.length > 20) return false;
    for (final m in <Map<String, Object>>[
      p.clubs,
      p.clubStrengths,
      p.stadiums,
      p.competitions,
      p.sponsors,
      p.yAccounts,
      p.localized,
      p.sponsorIndustries,
      p.yHandles,
    ]) {
      if (m.keys.any((k) => k.length > keyMax)) return false;
    }
    if (p.squads.values.any((s) => s.length > maxPlayersPerNation)) {
      return false;
    }
    if (p.pools.length > maxPoolNations ||
        p.pools.values.any((s) => s.length > PackRules.poolMax)) {
      return false;
    }
    if (p.clubStrengths.length > PackRules.clubStrengthsMax ||
        p.addedClubs.length > PackRules.addedClubsMax ||
        p.addedSponsors.length > PackRules.addedSponsorsMax ||
        p.addedYAccounts.length > PackRules.addedYMax ||
        p.addedReporters.length > PackRules.addedReportersMax ||
        p.addedStadiums.length > PackRules.addedStadiumsMax) {
      return false;
    }
    var localized = 0;
    for (final m in p.localized.values) {
      localized += m.length;
      if (localized > PackRules.localizedMax) return false;
    }
    // A code two nations share is the pack's to fix, not a danger: it is
    // kept, and it keeps the pack from a career until fixed (it is one of
    // [PackRules.issues]), as a 1.1.0 build did.
    return !PackRules.issues(p, baseCodes: baseCodes).any(
      (i) => i is BadField || i is UnknownId,
    );
  }

  /// A safe file name stem for [name]: letters, digits, spaces, `-` and `_`,
  /// at most 60 characters, never empty.
  static String fileStem(String name) {
    final s = name
        .replaceAll(RegExp(r'[^\p{L}\p{N} _-]', unicode: true), '_')
        .trim();
    final cut = s.length > 60 ? s.substring(0, 60).trim() : s;
    return cut.isEmpty ? 'world' : cut;
  }
}
