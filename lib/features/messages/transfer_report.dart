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
/// looking for the end. A page of eight fits on the screen it is shown on, the
/// count says how much there is, and the arrows walk through it.
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
          children: [
            Text(
              l.transfersMoves(widget.rows.length),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (_pages > 1)
              Text(
                l.transfersRange(start + 1, end, widget.rows.length),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const Divider(height: AppSpacing.md),
        for (final r in page) _MoveRow(row: r),
        if (_pages > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PagerButton(
                label: l.transfersNewer,
                icon: Icons.chevron_left_rounded,
                leading: true,
                onTap: _page == 0 ? null : () => setState(() => _page--),
              ),
              PagerButton(
                label: l.transfersOlder,
                icon: Icons.chevron_right_rounded,
                leading: false,
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

/// One move: who, from where to where, and for how much.
///
/// The fee is given a column of its own rather than being laid after the name.
/// A Row hands a plain [Text] all the width it asks for, so a long name and a
/// long fee together pushed one of them off the edge; fixing the fee's width
/// and letting the name shrink into what is left is what keeps every row on
/// the screen, in either language.
class _MoveRow extends StatelessWidget {
  const _MoveRow({required this.row});

  final TransferRow row;

  /// The two club names, each under its flag, with the arrow between them.
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

    return Row(
      children: [
        side(row.from, row.fromCountry),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 13,
            // A move abroad is the one thing about a transfer worth a colour,
            // because it is the one thing the two club names do not already
            // say.
            color: row.abroad ? AppColors.primary : AppColors.onSurfaceVariant,
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
              // Wide enough for the widest position code there is. At 32 a
              // two-letter code had 14 points to sit in and came out stacked.
              SizedBox(width: 44, child: TacticalChip(row.position)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: WholeText(
                  row.name,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 76,
                child: WholeText(
                  row.fee,
                  maxLines: 1,
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
            padding: const EdgeInsets.only(left: 44 + AppSpacing.sm),
            child: _move(context),
          ),
        ],
      ),
    );
  }
}
