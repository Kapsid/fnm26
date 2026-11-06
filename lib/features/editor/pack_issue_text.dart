import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One entry of a database's "what's missing" list: where it is (`title`:
/// a nation, or the section), what is wrong (`detail`), and where the entry
/// jumps to (`section`, opened on `nationId` when it is per nation; null
/// for the whole database, which stays on its home, and
/// [EditorSection.none] for a nation's old rename, fixed there by Remove).
typedef PackIssueText = ({
  String title,
  String detail,
  EditorSection? section,
  int? nationId,
});

/// The display name of nation [id] in [pack]: its new name when the pack
/// gives one, else the game's.
String packNationName(WorldPack pack, Map<int, Nation> world, int id) {
  final renamed = pack.nations[id]?.name.trim();
  if (renamed != null && renamed.isNotEmpty) return renamed;
  return world[id]?.name ?? '#$id';
}

/// Says [issue] in words, for the pack [pack] whose nations are [world].
PackIssueText describePackIssue(
  AppLocalizations l,
  PackIssue issue,
  WorldPack pack,
  Map<int, Nation> world,
) {
  String nation(int id) => packNationName(pack, world, id);
  // The `localized` cap is the whole database's, in no one section.
  final section = issue.where == 'localized'
      ? null
      : EditorSection.ofPath(issue.where);
  final title = section == null ? pack.name : sectionTitle(l, section);
  switch (issue) {
    // A pool over its cap reads as a squad over its: players too many.
    case SquadTooSmall(:final nationId, :final have, :final need):
      return (
        title: nation(nationId),
        detail: have < need
            ? l.editorIssuePlayersShort(need - have)
            : l.editorIssuePlayersOver(have - need),
        section: EditorSection.players,
        nationId: nationId,
      );
    case NeedsPosition(
      :final nationId,
      :final category,
      :final have,
      :final need,
    ):
      final n = need - have;
      return (
        title: nation(nationId),
        detail: switch (category) {
          PositionCategory.goalkeeper => l.editorIssueGoalkeepers(n),
          PositionCategory.defender => l.editorIssueDefenders(n),
          PositionCategory.midfielder => l.editorIssueMidfielders(n),
          PositionCategory.forward => l.editorIssueForwards(n),
        },
        section: EditorSection.players,
        nationId: nationId,
      );
    // A nation's old rename: no section edits it now, so it is fixed from
    // the home, by Remove.
    case DuplicateCode(:final code, :final nationIds):
      return (
        title: l.editorSectionNations,
        detail: l.editorIssueDuplicateCode(
          code,
          nationIds.map(nation).join(', '),
        ),
        section: EditorSection.none,
        nationId: null,
      );
    case UnknownId(:final path):
      // The entry itself, named as the editor knows it: a nation by its
      // name in the pack (else its id), a stadium by its city, anything else
      // by its key.
      final dot = path.indexOf('.');
      final root = dot < 0 ? path : path.substring(0, dot);
      var key = dot < 0 ? '' : path.substring(dot + 1);
      // A `localized` entry is named by the text it translates.
      if (root == 'localized') key = key.substring(key.indexOf('.') + 1);
      final id = int.tryParse(key);
      final what = switch (root) {
        // A pool by its nation; a player (his unknown traits) by his name.
        'pools' => _playerEntry(pack, pack.pools, key, nation),
        'squads' when key.contains('.') => _playerEntry(
          pack,
          pack.squads,
          key,
          nation,
        ),
        // An added item (its unknown deal or voice) by its name.
        'addedClubs' || 'addedSponsors' || 'addedYAccounts' =>
          _addedName(pack, root, int.tryParse(key.split('.').first)) ?? key,
        _ => switch (section) {
          EditorSection.players ||
          EditorSection.none ||
          EditorSection.nameLists when id != null => nation(id),
          EditorSection.stadiums => key.substring(key.indexOf(':') + 1),
          _ => key,
        },
      };
      return (
        title: title,
        detail: what.isEmpty
            ? l.editorIssueUnknown
            : l.editorIssueUnknownEntry(what),
        section: section,
        nationId: null,
      );
    case BadField(:final path, :final reason):
      return _badField(l, path, reason, pack, title, section, nation);
    // Said as a taken name: the fix is a rename, or Remove.
    case NameClash(:final path):
      return _badField(
        l,
        path,
        FieldReason.duplicate,
        pack,
        title,
        section,
        nation,
      );
  }
}

PackIssueText _badField(
  AppLocalizations l,
  String path,
  FieldReason reason,
  WorldPack pack,
  String sectionTitle,
  EditorSection? section,
  String Function(int) nation,
) {
  final parts = path.split('.');
  final root = parts.first;

  /// A name problem, in words: [value] is the name as it stands, [original]
  /// what it renames (for an empty one), when known.
  String nameProblem(String value, {String? original}) => switch (reason) {
    FieldReason.empty =>
      original == null
          ? l.editorIssueNameEmpty
          : l.editorIssueRenameEmpty(original),
    FieldReason.tooLong => l.editorIssueNameTooLong(value.trim()),
    FieldReason.badCharacters => l.editorIssueNameBadCharacters(value.trim()),
    FieldReason.duplicate => l.editorIssueNameTaken(value.trim()),
    FieldReason.outOfRange => l.editorIssueValue,
  };

  int? idAt(int i) => parts.length > i ? int.tryParse(parts[i]) : null;
  final key = parts.length > 1 ? parts.sublist(1).join('.') : '';

  switch (root) {
    case 'squads' || 'pools':
      final nationId = idAt(1);
      final playerId = idAt(2);
      final players = root == 'pools' ? pack.pools : pack.squads;
      final player = nationId == null
          ? null
          : players[nationId]?.where((x) => x.id == playerId).firstOrNull;
      final name = player?.name.trim() ?? '';
      // No field: the id itself (out of range, or another player's), or the
      // whole list. A trait list (too many, or one twice) is a value.
      final field = parts.length > 3 ? parts[3] : '';
      final detail = switch (field) {
        'name' =>
          reason == FieldReason.empty
              ? l.editorIssuePlayerNoName
              : nameProblem(name),
        'age' => l.editorIssueAge(name),
        'attributes' => l.editorIssueRating(name),
        'potential' => l.editorIssuePotential(name),
        _ => l.editorIssueValue,
      };
      return (
        title: nationId == null ? sectionTitle : nation(nationId),
        detail: detail,
        section: EditorSection.players,
        nationId: nationId,
      );
    case 'nations':
      final nationId = idAt(1);
      final field = parts.length > 2 ? parts[2] : '';
      final value = nationId == null ? null : pack.nations[nationId];
      return (
        title: nationId == null ? sectionTitle : nation(nationId),
        detail: field == 'code'
            ? l.editorIssueCode
            : nameProblem(value?.name ?? ''),
        section: EditorSection.none,
        nationId: nationId,
      );
    case 'nameLists':
      final nationId = idAt(1);
      final kind = parts.length > 2 ? parts[2] : '';
      final index = idAt(3);
      final lists = nationId == null ? null : pack.nameLists[nationId];
      final list = kind == 'first' ? lists?.first : lists?.sur;
      final detail = index == null
          ? (kind == 'first'
                ? l.editorIssueFirstNames(PackRules.nameListMin)
                : l.editorIssueSurnames(PackRules.nameListMin))
          : nameProblem(
              list != null && index < list.length ? list[index] : '',
            );
      return (
        title: nationId == null ? sectionTitle : nation(nationId),
        detail: detail,
        section: EditorSection.nameLists,
        nationId: nationId,
      );
    case 'reporters':
      final index = idAt(1);
      final field = parts.length > 2 ? parts[2] : '';
      final r = index == null ? null : pack.reporters[index];
      return (
        title: sectionTitle,
        detail: nameProblem(
          field == 'outlet' ? r?.outlet ?? '' : r?.name ?? '',
        ),
        section: section,
        nationId: null,
      );
    case 'stadiums':
      // Keyed '<nationId>:<city>'; the city says which.
      final colon = key.indexOf(':');
      final city = colon < 0 ? key : key.substring(colon + 1);
      return (
        title: sectionTitle,
        detail: nameProblem(pack.stadiums[key] ?? '', original: city),
        section: section,
        nationId: null,
      );
    case 'addedClubs' || 'addedSponsors' || 'addedYAccounts':
      // `<root>` (the list over its cap), `<root>.<id>` (the name),
      // `<root>.<id>.id`, `.country` or `.description`.
      final field = parts.length > 2 ? parts[2] : '';
      final value = switch (field) {
        '' => _addedName(pack, root, idAt(1)),
        'description' =>
          pack.addedSponsors
              .where((x) => x.id == idAt(1))
              .firstOrNull
              ?.description,
        _ => null,
      };
      return (
        title: sectionTitle,
        detail: parts.length == 1 || value == null
            ? l.editorIssueValue
            : nameProblem(value),
        section: section,
        nationId: null,
      );
    case 'localized':
      // `localized` (over the cap), `localized.<path>` (a path naming
      // nothing) or `localized.<path>.<language>` (a value).
      final last = key.lastIndexOf('.');
      final value = last < 0
          ? null
          : pack.localized[key.substring(0, last)]?[key.substring(last + 1)];
      return (
        title: sectionTitle,
        detail: value == null ? l.editorIssueValue : nameProblem(value),
        section: section,
        nationId: null,
      );
    default:
      final renames = switch (root) {
        'clubs' => pack.clubs,
        'competitions' => pack.competitions,
        'yAccounts' => pack.yAccounts,
        'sponsors' => pack.sponsors,
        _ => const <String, String>{},
      };
      return (
        title: sectionTitle,
        detail: nameProblem(renames[key] ?? '', original: key),
        section: section,
        nationId: null,
      );
  }
}

/// The name pack [pack] gives its added item [id] of [root]
/// (`addedClubs`, `addedSponsors` or `addedYAccounts`), if it has one.
String? _addedName(WorldPack pack, String root, int? id) => switch (root) {
  'addedClubs' => pack.addedClubs.where((x) => x.id == id).firstOrNull?.name,
  'addedSponsors' =>
    pack.addedSponsors.where((x) => x.id == id).firstOrNull?.name,
  'addedYAccounts' =>
    pack.addedYAccounts.where((x) => x.id == id).firstOrNull?.name,
  _ => null,
};

/// A squad or pool entry of [players], `<nationId>` or
/// `<nationId>.<playerId>[.traits]`, in words: the nation, or the player by
/// his name.
String _playerEntry(
  WorldPack pack,
  Map<int, List<PackPlayer>> players,
  String key,
  String Function(int) nation,
) {
  final parts = key.split('.');
  final nationId = int.tryParse(parts.first);
  if (nationId == null) return key;
  if (parts.length < 2) return nation(nationId);
  final playerId = int.tryParse(parts[1]);
  final player = players[nationId]?.where((p) => p.id == playerId).firstOrNull;
  final name = player?.name.trim() ?? '';
  return name.isEmpty ? key : name;
}
