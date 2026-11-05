import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One entry of a database's "what's missing" list: where it is (`title`:
/// a nation, or the section), what is wrong (`detail`), and where the entry
/// jumps to (`section`, opened on `nationId` when it is per nation).
typedef PackIssueText = ({
  String title,
  String detail,
  EditorSection section,
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
  final section = EditorSection.ofPath(issue.where);
  final title = sectionTitle(l, section);
  switch (issue) {
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
    case DuplicateCode(:final code, :final nationIds):
      return (
        title: l.editorSectionNations,
        detail: l.editorIssueDuplicateCode(
          code,
          nationIds.map(nation).join(', '),
        ),
        section: EditorSection.nations,
        nationId: null,
      );
    case UnknownId(:final path):
      // The entry itself, named as the editor knows it: a nation by its
      // name in the pack (else its id), a stadium by its city, anything else
      // by its key.
      final dot = path.indexOf('.');
      final key = dot < 0 ? '' : path.substring(dot + 1);
      final id = int.tryParse(key);
      final what = switch (section) {
        EditorSection.players ||
        EditorSection.nations ||
        EditorSection.nameLists when id != null => nation(id),
        EditorSection.stadiums => key.substring(key.indexOf(':') + 1),
        _ => key,
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
  }
}

PackIssueText _badField(
  AppLocalizations l,
  String path,
  FieldReason reason,
  WorldPack pack,
  String sectionTitle,
  EditorSection section,
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
    case 'squads':
      final nationId = idAt(1);
      final playerId = idAt(2);
      final player = nationId == null
          ? null
          : pack.squads[nationId]?.where((p) => p.id == playerId).firstOrNull;
      final name = player?.name.trim() ?? '';
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
        section: EditorSection.nations,
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
