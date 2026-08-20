import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Where a player stands in this year's squad report.
enum SquadDevStatus {
  /// In the pool last year and this one — they have a rating change.
  stayed,

  /// New to the pool: a debuting youngster, called up for the first time.
  arrived,

  /// In last year's pool and no longer in it — retired from internationals.
  gone,
}

/// One player's line in the yearly squad-development report.
class SquadDevRow {
  const SquadDevRow({
    required this.name,
    required this.age,
    required this.position,
    required this.rating,
    required this.status,
    this.change,
    this.stars,
    this.wonderkid = false,
  });

  final String name;
  final int age;

  /// Short position label (`GK`, `ST`, …).
  final String position;

  /// The player's rating now — or, for someone who has [SquadDevStatus.gone],
  /// the rating they left on.
  final int rating;

  /// Rating points gained or lost over the year; null for a newcomer (there is
  /// nothing to compare with) and for a player who has left.
  final int? change;

  /// The scouting read on a newcomer's ceiling, 1–5 stars; null for anyone
  /// already established (nobody scouts a player you have watched for years).
  /// A guess, and below seventeen a vague one — see [wonderkid], which is not
  /// derived from it.
  final int? stars;

  /// Whether this really is a generational talent.
  ///
  /// It used to be "the scouts gave him four stars", which made the badge out
  /// of scout NOISE rather than talent: below seventeen the star read is
  /// deliberately vague by up to two stars either way, so an ordinary boy was
  /// routinely flagged and roughly one intake child in every two and a half
  /// wore the word — about three a year, at an intake of seven. Whatever that
  /// is, it is not generational.
  ///
  /// So the badge is now set from the player's ACTUAL hidden ceiling rather
  /// than from the estimate beside it. The stars stay the scout's guess,
  /// because not knowing is the whole point of watching a boy come through;
  /// the badge is the game saying this one is real, which it can afford to do
  /// honestly precisely because it is now rare — one every two or three
  /// intakes.
  final bool wonderkid;

  final SquadDevStatus status;
}

/// Marks a message body as an encoded squad-development report. Versioned so a
/// message written by an older build still renders — as its own plain text.
///
/// v2 adds an optional note line directly under the tag. v1 bodies are still
/// decoded: they are sitting in players' saves and must keep rendering.
const String _devReportTagV1 = 'SQUADDEV1';
const String _devReportTagV2 = 'SQUADDEV2';

/// A decoded report: the table, and the line of context above it.
typedef SquadDevReport = ({String? note, List<SquadDevRow> rows});

/// Encodes [rows] into a message body the inbox can render as a table.
///
/// The report used to be a paragraph of "📈 Improved: A 78→82, B 74→76, …",
/// which ran together into an unreadable wall as soon as a few players moved.
/// The body is now structured, so the sheet can lay it out as a table and the
/// manager can scan the whole pool: who came in, who grew, who faded, who went.
///
/// Order: newcomers first (the headline of any year), then everyone else by
/// what they gained — improvers down to decliners — and finally those who have
/// retired.
String encodeSquadDevReport(List<SquadDevRow> rows, {String? note}) {
  int rank(SquadDevRow r) => switch (r.status) {
    SquadDevStatus.arrived => 0,
    SquadDevStatus.stayed => 1,
    SquadDevStatus.gone => 2,
  };
  final sorted = [...rows]
    ..sort((a, b) {
      final byGroup = rank(a).compareTo(rank(b));
      if (byGroup != 0) return byGroup;
      // Among newcomers the scouts' verdict leads — the point of the list is
      // who is worth a look, not who is already the tallest of the children.
      final byStars = (b.stars ?? 0).compareTo(a.stars ?? 0);
      if (byStars != 0) return byStars;
      final byChange = (b.change ?? 0).compareTo(a.change ?? 0);
      if (byChange != 0) return byChange;
      return b.rating.compareTo(a.rating);
    });
  final lines = [
    _devReportTagV2,
    // Always present, so the row block always begins at the same offset. A
    // note is flattened to one line: the format is line-based, and a stray
    // newline would otherwise be read as a malformed row.
    (note ?? '').replaceAll('\n', ' ').trim(),
    for (final r in sorted)
      [
        r.name.replaceAll('|', ' '),
        '${r.age}',
        r.position,
        '${r.rating}',
        r.change?.toString() ?? '',
        switch (r.status) {
          SquadDevStatus.stayed => '',
          SquadDevStatus.arrived => 'new',
          SquadDevStatus.gone => 'out',
        },
        r.stars?.toString() ?? '',
        r.wonderkid ? 'wk' : '',
      ].join('|'),
  ];
  return lines.join('\n');
}

/// Decodes a body written by [encodeSquadDevReport], or null if [body] is not
/// one (an older plain-text report, or any other message).
SquadDevReport? decodeSquadDevReport(String body) {
  final lines = body.split('\n');
  if (lines.isEmpty) return null;
  final tag = lines.first.trim();
  if (tag != _devReportTagV1 && tag != _devReportTagV2) return null;
  final isV2 = tag == _devReportTagV2;
  final note = isV2 && lines.length > 1 && lines[1].trim().isNotEmpty
      ? lines[1].trim()
      : null;
  final rows = <SquadDevRow>[];
  for (final line in lines.skip(isV2 ? 2 : 1)) {
    if (line.trim().isEmpty) continue;
    final f = line.split('|');
    if (f.length < 6) continue;
    rows.add(
      SquadDevRow(
        name: f[0],
        age: int.tryParse(f[1]) ?? 0,
        position: f[2],
        rating: int.tryParse(f[3]) ?? 0,
        change: int.tryParse(f[4]),
        // The stars column arrived with the split report; a body written before
        // it simply has no seventh field.
        stars: f.length > 6 ? int.tryParse(f[6]) : null,
        // The badge arrived after the stars column; a body written before it
        // simply has no eighth field and claims nobody.
        wonderkid: f.length > 7 && f[7] == 'wk',
        status: switch (f[5]) {
          'new' => SquadDevStatus.arrived,
          'out' => SquadDevStatus.gone,
          _ => SquadDevStatus.stayed,
        },
      ),
    );
  }
  return (note: note, rows: rows);
}

/// The yearly squad report as a table: every player in the pool with their age,
/// position, rating and what the year did to it — newcomers flagged as a first
/// call-up, retirements at the bottom.
///
/// PAGED, a fixed [_pageSize] rows at a time. A full pool is a hundred players,
/// and printing them all pushed the popup's own "Next" button off the bottom of
/// the screen — the news could be read but not dismissed. A page keeps the
/// sheet a constant height whatever the year did to the squad.
class SquadDevTable extends StatefulWidget {
  const SquadDevTable({required this.rows, super.key});

  final List<SquadDevRow> rows;

  @override
  State<SquadDevTable> createState() => _SquadDevTableState();
}

class _SquadDevTableState extends State<SquadDevTable> {
  static const int _pageSize = 10;

  int _page = 0;

  int get _pageCount => (widget.rows.length / _pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (widget.rows.isEmpty) return Text(l.squadDevEmpty);
    final page = _page.clamp(0, _pageCount - 1);
    final start = page * _pageSize;
    final shown = widget.rows.skip(start).take(_pageSize).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(child: _head(l.squadDevPlayer)),
              SizedBox(width: 30, child: _head(l.squadDevAge)),
              SizedBox(width: 34, child: _head(l.squadDevPosition)),
              SizedBox(width: 62, child: _head(l.squadDevChange)),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.outlineVariant),
        for (final r in shown) _SquadDevLine(row: r),
        // Every page holds the same number of lines, so paging never resizes
        // the sheet under the reader's thumb.
        for (var i = shown.length; i < _pageSize; i++)
          const _SquadDevLine(row: null),
        if (_pageCount > 1) ...[
          const Divider(height: 1, color: AppColors.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: page == 0
                    ? null
                    : () => setState(() => _page = page - 1),
                icon: const Icon(Icons.chevron_left_rounded),
                color: AppColors.primary,
              ),
              Text(
                l.squadDevPageOf(
                  '${page + 1}',
                  '$_pageCount',
                  '${widget.rows.length}',
                ),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: page >= _pageCount - 1
                    ? null
                    : () => setState(() => _page = page + 1),
                icon: const Icon(Icons.chevron_right_rounded),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _head(String text) => Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _SquadDevLine extends StatelessWidget {
  const _SquadDevLine({required this.row});

  /// The player on this line, or null for a blank line that keeps a short last
  /// page the same height as a full one.
  final SquadDevRow? row;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final row = this.row;
    if (row == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [SizedBox(height: 18)]),
      );
    }
    final gone = row.status == SquadDevStatus.gone;
    final change = row.change;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    row.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: gone
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                    ),
                  ),
                ),
                if (row.wonderkid) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _Tag(label: l.squadDevWonderkid, color: AppColors.primary),
                ] else if (row.status == SquadDevStatus.arrived) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _Tag(label: l.squadDevNew, color: AppColors.positive),
                ],
                if (gone) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _Tag(
                    label: l.squadDevRetired,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 30, child: _cell('${row.age}')),
          SizedBox(width: 34, child: _cell(row.position)),
          // The scouts' ceiling, for a face nobody has seen play yet. It is an
          // estimate, which is exactly why it belongs next to the name.
          if (row.stars != null)
            SizedBox(
              width: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: row.wonderkid
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  Text(
                    '${row.stars}',
                    style: AppTypography.labelSmall.copyWith(
                      color: row.wonderkid
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${row.rating}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    change == null || change == 0
                        ? ''
                        : (change > 0 ? '+$change' : '$change'),
                    textAlign: TextAlign.right,
                    style: AppTypography.labelSmall.copyWith(
                      color: change == null || change == 0
                          ? AppColors.onSurfaceVariant
                          : (change > 0 ? AppColors.positive : AppColors.error),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text) => Text(
    text,
    maxLines: 1,
    style: AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: AppRadii.smAll,
    ),
    child: Text(
      label,
      style: AppTypography.labelSmall.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 9,
      ),
    ),
  );
}
