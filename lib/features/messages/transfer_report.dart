import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One move in the window's transfer report.
typedef TransferRow = ({
  String name,
  String position,
  String from,
  String to,
  String fee,

  /// Whether the move crossed a border — the part of a transfer that is the
  /// news, and the only reason to spend a word on the country.
  bool abroad,

  /// The player's rating now. Zero in a report written before v2, which is how
  /// the table knows not to print a column of noughts.
  int rating,

  /// What the year did to that rating, or null when nothing is known — a
  /// report written by an older build, or a face too new to compare with.
  int? change,

  /// Which way the move went between league tiers: +1 up, −1 down, 0 sideways.
  /// The thing a transfer actually MEANS for a player's season, which a club
  /// name alone does not say to anybody who does not know the leagues.
  int step,

  /// FIFA codes of the two clubs' countries, so each side of the move can wear
  /// its flag. Empty in a report written before v3, and in that case the row
  /// simply shows the names — which is what it always did.
  String fromCountry,
  String toCountry,
});

/// v1 carried name, position, from, to, fee and the abroad flag. v2 adds the
/// player's rating, what the year did to it, and which way the move went
/// between tiers. v3 adds the two clubs' countries, so the move can be read at
/// a glance off a pair of flags. All three decode: older bodies are sitting in
/// players' saves and must keep opening.
const String _tagV1 = '#transfers/v1';
const String _tagV2 = '#transfers/v2';
const String _tagV3 = '#transfers/v3';

/// Encodes the window's moves as a message body.
///
/// Line-based like the squad-development report, and for the same reason: the
/// inbox stores plain text, so a table has to survive a round trip through it.
String encodeTransferReport(List<TransferRow> rows) => [
  _tagV3,
  for (final r in rows)
    [
      r.name.replaceAll('|', ' '),
      r.position,
      r.from.replaceAll('|', ' '),
      r.to.replaceAll('|', ' '),
      r.fee,
      if (r.abroad) 'abroad' else '',
      '${r.rating}',
      r.change?.toString() ?? '',
      '${r.step}',
      r.fromCountry,
      r.toCountry,
    ].join('|'),
].join('\n');

/// Decodes a body written by [encodeTransferReport], or null if it is not one.
List<TransferRow>? decodeTransferReport(String body) {
  final lines = body.split('\n');
  if (lines.isEmpty) return null;
  final tag = lines.first.trim();
  if (tag != _tagV1 && tag != _tagV2 && tag != _tagV3) return null;
  final out = <TransferRow>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final f = line.split('|');
    if (f.length < 5) continue;
    out.add((
      name: f[0],
      position: f[1],
      from: f[2],
      to: f[3],
      fee: f[4],
      abroad: f.length > 5 && f[5] == 'abroad',
      // The three v2 columns. A v1 body simply has no seventh field, and a
      // rating of zero is what tells the table to leave the column out rather
      // than print a nought beside every name.
      rating: f.length > 6 ? (int.tryParse(f[6]) ?? 0) : 0,
      change: f.length > 7 ? int.tryParse(f[7]) : null,
      step: f.length > 8 ? (int.tryParse(f[8]) ?? 0) : 0,
      fromCountry: f.length > 9 ? f[9] : '',
      toCountry: f.length > 10 ? f[10] : '',
    ));
  }
  return out;
}

/// The window's moves, a page at a time.
///
/// The report is COMPACT — who went where, and for how much — and it stays
/// that way. It briefly grew the player's rating and what the year had done to
/// it, and flags for the tier he had moved between: a development report
/// wearing a transfer report's name. That belongs on the development report
/// that already carries it, and on the player's own screen. (The v2 columns are
/// still DECODED, see [decodeTransferReport], so bodies written while they were
/// shown keep working; they are simply not printed.)
///
/// What it could not be was ONE LIST. A window moves thirty or forty players,
/// and thirty rows inside a popup is a column of text with the button that
/// closes it somewhere off the bottom — the manager scrolls past his own squad
/// looking for the end. A page of six fits on the screen it is shown on, the
/// count says how much there is, and the numbered pager walks through it.
class TransferTable extends StatefulWidget {
  const TransferTable({required this.rows, super.key});

  final List<TransferRow> rows;

  /// Moves per page. A move is two lines now — who and for how much, then
  /// where from and where to — so six is the count that leaves the popup a
  /// shape a phone can hold, header and confirming button included.
  static const int perPage = 6;

  @override
  State<TransferTable> createState() => _TransferTableState();
}

class _TransferTableState extends State<TransferTable> {
  int _page = 0;

  int get _pages => (widget.rows.length / TransferTable.perPage).ceil();

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final start = _page * TransferTable.perPage;
    final end = (start + TransferTable.perPage).clamp(0, widget.rows.length);
    final page = widget.rows.sublist(start, end);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // The count flexes and the page label does not: a Spacer between
            // two Flexible children splits the free space three ways and
            // leaves the page label nothing, which is how "Page 1 of 3" came
            // out as "Page 1 o…" on a screen with room to spare.
            Flexible(
              child: Text(
                l.transfersMoves(widget.rows.length),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            // Which page, said in the header rather than down beside the
            // buttons: at 360 points the Czech for "Previous", "Page 1 of 3"
            // and "Next" do not fit on one line together, and a page count
            // squeezed between two buttons is the first thing to be cut.
            if (_pages > 1) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.transfersPageOf(_page + 1, _pages),
                maxLines: 1,
                textAlign: TextAlign.end,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        const Divider(height: AppSpacing.md),
        for (final r in page) _MoveRow(row: r),
        if (_pages > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          // PAGING, and nothing else. The two chevrons that used to sit here
          // were arrows on a screen whose rows are also arrows, so one glyph
          // meant "this player moved to that club" in the table and "show me
          // six more" underneath it. Arrows are reserved for moves now; the
          // pager is two words and the page count between them, which cannot
          // be read as anything but a pager.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PageButton(
                label: l.transfersPagePrevious,
                onTap: _page == 0 ? null : () => setState(() => _page--),
              ),
              _PageButton(
                label: l.transfersPageNext,
                onTap: _page >= _pages - 1
                    ? null
                    : () => setState(() => _page++),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// A page control. A WORD, never an arrow: the whole complaint this row
/// answers is that arrows on this screen meant two different things at once.
class _PageButton extends StatelessWidget {
  const _PageButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = onTap == null
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.4)
        : AppColors.primary;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

/// One move, read in one order: WHO, from where, to where, for how much, and
/// which way that is a step.
///
/// The fee is given a column of its own rather than being laid after the name.
/// A Row hands a plain [Text] all the width it asks for, so a long name and a
/// long fee together pushed one of them off the edge; fixing the fee's width
/// and letting the name shrink into what is left is what keeps every row on
/// the screen, in either language.
///
/// The FEE is a plain [Text], deliberately, so the width guard can see it: a
/// [WholeText] scales itself down to fit and never reports a cut, and a fee
/// that has quietly lost a digit is the one failure this table cannot have.
///
/// The NAME is a [WholeText] for the opposite reason. There is no layout that
/// prints "Nomenjanahary Raheriniaina" at sixteen points on a 360-point phone
/// beside a fee, so the only question is what it gives up — and an ellipsis is
/// the worst answer available. It gives up the forename first
/// ([initialledName]), which is the half that does not identify a footballer,
/// and only scales if even that will not fit. It never ends in a full stop it
/// did not earn.
class _MoveRow extends StatelessWidget {
  const _MoveRow({required this.row});

  final TransferRow row;

  /// Width of the fee column, in points. Sized against the longest fee the
  /// report can write in either language: six monospace characters, which
  /// covers "€1200M" and the Czech word for a free transfer. At 76 it covered
  /// neither — every free transfer in the table read "Zdarm…", and the width
  /// test that was supposed to catch it could not, because the fee was a
  /// [WholeText] that shrank instead of complaining.
  static const double _feeWidth = 96;

  /// Width of the position chip. At 32 a two-letter code had 14 points to sit
  /// in and came out stacked.
  static const double _chipWidth = 44;

  /// The two club names, each under its flag, with the move between them.
  ///
  /// A LINE OF ITS OWN. Squeezed in beside the name and the fee, two club
  /// names and an arrow had about a third of the row to live in: they were
  /// scaled down to something unreadable, and a long pair read as one club and
  /// a smudge. Given the width of the row they are simply legible, and the
  /// flags say where the move went without spending a word on it.
  Widget _move(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget side(String club, String country) => Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (country.isNotEmpty) ...[
            FlagDisc(country, size: 14),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: WholeText(
              // A club with no name is a club the report never learned; say so
              // rather than leaving the side of the move blank, which reads as
              // a bug in the row.
              club.isEmpty ? l.transfersUnknownClub : club,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );

    // ONE arrow, and it is the move. It points right because that is the way
    // the row is read, and it tilts to say which way the move went between
    // league tiers — the thing a pair of club names does not tell anybody who
    // does not already know the leagues. The row used to draw a flat arrow
    // here and leave [TransferRow.step] unprinted, so the two chevrons under
    // the table were the only arrows that meant anything, and they meant
    // paging.
    final (icon, colour, label) = switch (row.step) {
      > 0 => (Icons.north_east_rounded, AppColors.positive, l.transfersStepUp),
      < 0 => (
        Icons.south_east_rounded,
        AppColors.warning,
        l.transfersStepDown,
      ),
      _ => (
        Icons.east_rounded,
        AppColors.onSurfaceVariant,
        l.transfersStepLevel,
      ),
    };
    return Row(
      children: [
        side(row.from, row.fromCountry),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Semantics(
            label: label,
            child: Icon(icon, size: 13, color: colour),
          ),
        ),
        side(row.to, row.toCountry),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: _chipWidth, child: TacticalChip(row.position)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: WholeText(
                  row.name,
                  shortText: initialledName(row.name),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: _feeWidth,
                child: Text(
                  row.fee,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: _chipWidth + AppSpacing.sm),
            child: _move(context),
          ),
        ],
      ),
    );
  }
}
