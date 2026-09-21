import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Where a player stands in this year's squad report.
enum SquadDevStatus {
  /// In the pool last year and this one — they have a rating change.
  stayed,

  /// New to the pool: a debuting youngster, called up for the first time.
  arrived,

  /// In last year's pool and no longer in it — retired from internationals.
  gone,
}

/// Which part of the squad a player belongs to.
///
/// The report used to be one flat list, and "improved from 34" in a flat list
/// says nothing: a 34-rated boy nobody has picked is noise, while the same
/// line about a first-choice regular is the most important thing on the
/// screen. The tier is what turns the one into the other.
enum SquadDevTier {
  /// Has been called up: he is the team, whatever his age.
  regular,

  /// In the pool, never picked, old enough that he probably never will be.
  fringe,

  /// Young and uncapped: the side you might have, not the side you have.
  youth,
}

/// Which tier a player belongs to.
///
/// CALL-UP HISTORY FIRST, then age — and that order is the whole point. A boy
/// of nineteen who has played for you is a regular, and a man of thirty who
/// has never been near the squad is not; read the other way round the report
/// is just a second list of teenagers.
SquadDevTier squadDevTierFor({required bool calledUp, required int age}) {
  if (calledUp) return SquadDevTier.regular;
  return age < 21 ? SquadDevTier.youth : SquadDevTier.fringe;
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
    this.tier,
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

  /// Which block of the squad this line belongs under, or null for a report
  /// that does not group at all — a newcomers list, or a body written by a
  /// build from before the tiers existed and now sitting in somebody's save.
  final SquadDevTier? tier;

  final SquadDevStatus status;
}

/// Marks a message body as an encoded squad-development report. Versioned so a
/// message written by an older build still renders — as its own plain text.
///
/// v2 adds an optional note line directly under the tag. v3 adds each
/// player's tier, so the table can be read in blocks. v1 and v2 bodies are
/// still decoded: they are sitting in players' saves and must keep rendering,
/// tierless and therefore flat, exactly as they always did.
const String _devReportTagV1 = 'SQUADDEV1';
const String _devReportTagV2 = 'SQUADDEV2';
const String _devReportTagV3 = 'SQUADDEV3';

/// The tier column's wire values. Short, and never the enum's own name: the
/// body is stored in saves, so it must not move when the enum does.
const Map<SquadDevTier, String> _tierCodes = {
  SquadDevTier.regular: 'reg',
  SquadDevTier.fringe: 'frn',
  SquadDevTier.youth: 'yth',
};

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
    _devReportTagV3,
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
        if (r.wonderkid) 'wk' else '',
        if (r.tier case final tier?) _tierCodes[tier]! else '',
      ].join('|'),
  ];
  return lines.join('\n');
}

/// The tier a wire code names, or null for a blank or unknown one.
SquadDevTier? _tierFrom(String code) {
  for (final e in _tierCodes.entries) {
    if (e.value == code) return e.key;
  }
  return null;
}

/// Decodes a body written by [encodeSquadDevReport], or null if [body] is not
/// one (an older plain-text report, or any other message).
SquadDevReport? decodeSquadDevReport(String body) {
  final lines = body.split('\n');
  if (lines.isEmpty) return null;
  final tag = lines.first.trim();
  if (tag != _devReportTagV1 &&
      tag != _devReportTagV2 &&
      tag != _devReportTagV3) {
    return null;
  }
  // The note line arrived with v2 and every version since carries it.
  final hasNote = tag != _devReportTagV1;
  final note = hasNote && lines.length > 1 && lines[1].trim().isNotEmpty
      ? lines[1].trim()
      : null;
  final rows = <SquadDevRow>[];
  for (final line in lines.skip(hasNote ? 2 : 1)) {
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
        // The tier arrived with v3; an older body simply has no ninth field,
        // claims no tier, and renders as the flat table it was written as.
        tier: f.length > 8 ? _tierFrom(f[8]) : null,
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
/// Read in blocks — regulars, fringe, youth — because a rating move only
/// means something once you know whose it is. A report whose rows carry no
/// tier (an older body, or the newcomers list) is the flat table it always
/// was.
///
/// PAGED, a fixed number of lines at a time. A full pool is a hundred players,
/// and printing them all pushed the popup's own "Next" button off the bottom of
/// the screen — the news could be read but not dismissed. A page keeps the
/// sheet a constant height whatever the year did to the squad.
class SquadDevTable extends StatefulWidget {
  const SquadDevTable({required this.rows, super.key});

  final List<SquadDevRow> rows;

  @override
  State<SquadDevTable> createState() => _SquadDevTableState();
}

/// One slot on a page: a section heading, a player's line, or neither — a
/// blank that keeps a short last page the height of a full one.
typedef _Slot = ({SquadDevTier? head, SquadDevRow? row});

class _SquadDevTableState extends State<SquadDevTable> {
  /// Slots, not players: a heading costs one, which is what keeps the sheet
  /// the same height whichever page is open.
  static const int _pageSize = 12;

  int _page = 0;

  /// The report as a run of slots: any untiered rows first — a report that
  /// does not group (a newcomers list, or a body from an older build) is the
  /// flat table it always was — then each tier that has somebody in it, under
  /// its own heading. A tier nobody is in is not written at all.
  List<_Slot> get _slots {
    final out = <_Slot>[
      for (final r in widget.rows)
        if (r.tier == null) (head: null, row: r),
    ];
    for (final tier in SquadDevTier.values) {
      final inTier = widget.rows.where((r) => r.tier == tier).toList()
        ..sort(_byMovement);
      if (inTier.isEmpty) continue;
      out.add((head: tier, row: null));
      for (final r in inTier) {
        out.add((head: null, row: r));
      }
    }
    return out;
  }

  /// Inside a section the biggest mover leads and whoever has left the pool
  /// comes last. A block is read for who moved, so the man who moved most is
  /// the first name in it whatever order the body happened to be written in.
  static int _byMovement(SquadDevRow a, SquadDevRow b) {
    int left(SquadDevRow r) => r.status == SquadDevStatus.gone ? 1 : 0;
    final byLeaving = left(a).compareTo(left(b));
    if (byLeaving != 0) return byLeaving;
    final byChange = (b.change ?? 0).compareTo(a.change ?? 0);
    if (byChange != 0) return byChange;
    return b.rating.compareTo(a.rating);
  }

  /// Those slots cut into pages. A heading is never left alone at the foot of
  /// a page, and a section that runs on says its name again at the top of the
  /// next one — otherwise a whole page of names sits under no heading and the
  /// grouping stops answering the only question it was added to answer.
  List<List<_Slot>> get _pages {
    final pages = <List<_Slot>>[];
    var current = <_Slot>[];
    SquadDevTier? open;
    for (final slot in _slots) {
      if (slot.head != null) open = slot.head;
      final orphanHead = slot.head != null && current.length >= _pageSize - 1;
      if (current.length >= _pageSize || orphanHead) {
        pages.add(current);
        current = [
          if (slot.head == null && open != null) (head: open, row: null),
        ];
      }
      current.add(slot);
    }
    if (current.isNotEmpty) pages.add(current);
    return pages.isEmpty ? [const []] : pages;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (widget.rows.isEmpty) return Text(l.squadDevEmpty);
    final pages = _pages;
    final pageCount = pages.length;
    final page = _page.clamp(0, pageCount - 1);
    final shown = pages[page];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(child: _head(l.squadDevPlayer)),
              SizedBox(
                width: _SquadDevLine.ageWidth,
                child: _head(l.squadDevAge),
              ),
              SizedBox(
                width: _SquadDevLine.positionWidth,
                child: _head(l.squadDevPosition),
              ),
              SizedBox(
                width: _SquadDevLine.ratingWidth,
                child: _head(l.squadDevChange),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.outlineVariant),
        for (final slot in shown)
          if (slot.head case final tier?)
            _SectionHead(tier: tier)
          else
            _SquadDevLine(row: slot.row),
        // Every page holds the same number of lines, so paging never resizes
        // the sheet under the reader's thumb.
        for (var i = shown.length; i < _pageSize; i++)
          const _SquadDevLine(row: null),
        if (pageCount > 1) ...[
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
                  '$pageCount',
                  '${widget.rows.length}',
                ),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: page >= pageCount - 1
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

  /// Column widths, sized to the WORD above them rather than to the two or
  /// three characters below it: a header that reads "POS…" is a cut label, and
  /// a cut label is the bug this batch keeps finding.
  static const double ageWidth = 40;
  static const double positionWidth = 52;

  /// Wide enough for a rating, an arrow and a rating: the line's whole point
  /// is where a player came FROM, so 84 on its own will not do.
  static const double ratingWidth = 78;

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
                  child: WholeText(
                    row.name,
                    shortText: initialledName(row.name),
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
          SizedBox(width: ageWidth, child: _cell('${row.age}')),
          SizedBox(width: positionWidth, child: _cell(row.position)),
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
          // Where he came from, and where he got to. "+3" beside a rating made
          // the reader do the subtraction; "81 → 84" is the sentence the
          // manager was trying to read in the first place.
          SizedBox(
            width: ratingWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (change != null && change != 0) ...[
                  Text(
                    '${row.rating - change}',
                    maxLines: 1,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 14,
                    color: change > 0 ? AppColors.positive : AppColors.error,
                  ),
                ],
                Text(
                  '${row.rating}',
                  maxLines: 1,
                  style: AppTypography.bodySmall.copyWith(
                    color: change == null || change == 0
                        ? AppColors.onSurface
                        : (change > 0 ? AppColors.positive : AppColors.error),
                    fontWeight: FontWeight.w700,
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

/// The heading over one block of the table.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.tier});

  final SquadDevTier tier;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = switch (tier) {
      SquadDevTier.regular => l.squadDevTierRegulars,
      SquadDevTier.fringe => l.squadDevTierFringe,
      SquadDevTier.youth => l.squadDevTierYouth,
    };
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 2),
      child: Text(
        label,
        maxLines: 1,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
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
