import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/messages/paged_report.dart';
import 'package:fnm/features/world_managers/manager_row.dart' show spellEndText;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One national team's change in the manager changes report.
typedef ManagerChangeRow = ({
  int nationId,
  String nationCode,

  /// The nation's name when the report was written, for a nation the reader
  /// can no longer look up. The table prefers the name of the day.
  String nationName,

  /// The man who left, or null when a vacant post was filled.
  int? outgoingId,
  String outgoingName,

  /// Why he left; null exactly when [outgoingId] is.
  SpellEnd? why,

  /// The man appointed, or null when the post is still vacant.
  int? incomingId,
  String incomingName,

  /// Where a poached man went, when it is known: the nation that took him.
  int? toNationId,
  String toCode,
  String toName,
});

/// The tag of a manager changes report body. v1 is the first; a later
/// version adds columns and keeps decoding this one.
const String _tagV1 = '#mgrchanges/v1';

/// The rows of one decision point's [moves], in the order given: each
/// nation's change with the names of the men it names. A poached man's
/// destination is the move whose incoming man he is.
List<ManagerChangeRow> managerChangeRows(
  List<ManagerMove> moves, {
  required Map<int, ({String code, String name})> nations,
  required Map<int, String> managerNames,
}) {
  final hiredBy = {
    for (final m in moves) ?m.incomingId: m.nationId,
  };
  return [
    for (final m in moves)
      if (m.outgoingId != null || m.incomingId != null)
        () {
          final to = m.why == SpellEnd.poached ? hiredBy[m.outgoingId] : null;
          return (
            nationId: m.nationId,
            nationCode: nations[m.nationId]?.code ?? '',
            nationName: nations[m.nationId]?.name ?? '',
            outgoingId: m.outgoingId,
            outgoingName: managerNames[m.outgoingId] ?? '',
            why: m.outgoingId == null ? null : m.why,
            incomingId: m.incomingId,
            incomingName: managerNames[m.incomingId] ?? '',
            toNationId: to,
            toCode: nations[to]?.code ?? '',
            toName: nations[to]?.name ?? '',
          );
        }(),
  ];
}

/// Encodes a manager changes report as a message body: plain text, a line a
/// change, so it survives the inbox's text column like the transfer report.
/// Language-free: names of men are never translated, nations are read again
/// by id when shown, and the reason is stored as its [SpellEnd] name.
String encodeManagerChanges(List<ManagerChangeRow> rows) {
  String clean(String s) => s.replaceAll('|', ' ').replaceAll('\n', ' ');
  return [
    _tagV1,
    for (final r in rows)
      [
        '${r.nationId}',
        r.nationCode,
        clean(r.nationName),
        r.outgoingId?.toString() ?? '',
        clean(r.outgoingName),
        r.why?.name ?? '',
        r.incomingId?.toString() ?? '',
        clean(r.incomingName),
        r.toNationId?.toString() ?? '',
        r.toCode,
        clean(r.toName),
      ].join('|'),
  ].join('\n');
}

/// Decodes a body written by [encodeManagerChanges], or null if it is not
/// one.
List<ManagerChangeRow>? decodeManagerChanges(String body) {
  final lines = body.split('\n');
  if (lines.first.trim() != _tagV1) return null;
  final out = <ManagerChangeRow>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final f = line.split('|');
    if (f.length < 11) continue;
    final nationId = int.tryParse(f[0]);
    if (nationId == null) continue;
    out.add((
      nationId: nationId,
      nationCode: f[1],
      nationName: f[2],
      outgoingId: int.tryParse(f[3]),
      outgoingName: f[4],
      why: SpellEnd.values.asNameMap()[f[5]],
      incomingId: int.tryParse(f[6]),
      incomingName: f[7],
      toNationId: int.tryParse(f[8]),
      toCode: f[9],
      toName: f[10],
    ));
  }
  return out;
}

/// A decision point's manager changes, a page at a time: the same paged
/// design as the transfer window's report ([PagedReport]). A row is the
/// nation, the man who left and the man who came in (each opens his page),
/// and why the change happened.
class ManagerChangesTable extends StatelessWidget {
  const ManagerChangesTable({
    required this.rows,
    this.nationName,
    this.onOpenManager,
    super.key,
  });

  final List<ManagerChangeRow> rows;

  /// The nation's name in the reader's language today, or null to use the
  /// name stored with the report.
  final String? Function(int nationId)? nationName;

  /// Opens a manager's page. Without it the names are plain text.
  final void Function(int managerId)? onOpenManager;

  /// Changes per page, as many as the transfer report's moves.
  static const int perPage = 6;

  /// The key of the link to the manager [managerId]'s page.
  static Key managerKey(int managerId) => ValueKey('mgrChanges.$managerId');

  @override
  Widget build(BuildContext context) => PagedReport(
    itemCount: rows.length,
    perPage: perPage,
    countLabel: AppLocalizations.of(context).mgrChangesCount(rows.length),
    itemBuilder: (context, i) => _ChangeRow(
      row: rows[i],
      nationName: nationName,
      onOpenManager: onOpenManager,
    ),
  );
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({
    required this.row,
    required this.nationName,
    required this.onOpenManager,
  });

  final ManagerChangeRow row;
  final String? Function(int nationId)? nationName;
  final void Function(int managerId)? onOpenManager;

  static const double _flag = 20;

  String _nation(int? id, String stored) {
    if (id == null) return stored;
    final now = nationName?.call(id);
    return now == null || now.isEmpty ? stored : now;
  }

  String _reason(AppLocalizations l) {
    final why = row.why;
    if (row.outgoingId == null || why == null) return l.mgrChangesAppointed;
    if (why == SpellEnd.poached) {
      final to = _nation(row.toNationId, row.toName);
      if (to.isNotEmpty) return l.mgrChangesLeftFor(to);
    }
    return spellEndText(l, why);
  }

  Widget _man(int? id, String name) {
    final style = AppTypography.labelMedium.copyWith(
      color: onOpenManager == null ? AppColors.onSurface : AppColors.primary,
    );
    final text = WholeText(
      name,
      maxLines: 1,
      textAlign: TextAlign.start,
      style: style,
    );
    final open = onOpenManager;
    if (id == null || open == null) return Flexible(child: text);
    return Flexible(
      child: InkWell(
        key: ManagerChangesTable.managerKey(id),
        onTap: () => open(id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (row.nationCode.isNotEmpty)
                FlagDisc(row.nationCode, size: _flag)
              else
                const SizedBox(width: _flag),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: WholeText(
                  _nation(row.nationId, row.nationName),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: _flag + AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (row.outgoingId != null) ...[
                      _man(row.outgoingId, row.outgoingName),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        child: Icon(
                          Icons.east_rounded,
                          size: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (row.incomingId != null)
                      _man(row.incomingId, row.incomingName)
                    else
                      Flexible(
                        child: Text(
                          l.mgrChangesVacant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: muted,
                        ),
                      ),
                  ],
                ),
                Text(
                  _reason(l),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
