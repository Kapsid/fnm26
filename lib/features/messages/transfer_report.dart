import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
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
});

const String _tag = '#transfers/v1';

/// Encodes the window's moves as a message body.
///
/// Line-based like the squad-development report, and for the same reason: the
/// inbox stores plain text, so a table has to survive a round trip through it.
String encodeTransferReport(List<TransferRow> rows) => [
  _tag,
  for (final r in rows)
    [
      r.name.replaceAll('|', ' '),
      r.position,
      r.from.replaceAll('|', ' '),
      r.to.replaceAll('|', ' '),
      r.fee,
      r.abroad ? 'abroad' : '',
    ].join('|'),
].join('\n');

/// Decodes a body written by [encodeTransferReport], or null if it is not one.
List<TransferRow>? decodeTransferReport(String body) {
  final lines = body.split('\n');
  if (lines.isEmpty || lines.first.trim() != _tag) return null;
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
    ));
  }
  return out;
}

/// The window's moves as a table.
///
/// One message for the whole window rather than one per player. Transfers used
/// to arrive as separate items, capped at three, so a manager saw a handful of
/// his squad change club and no account of the rest — his own players moved
/// without him being told. A window is the unit a transfer market happens in,
/// so it is the unit the news comes in.
class TransferTable extends StatelessWidget {
  const TransferTable({required this.rows, super.key});

  final List<TransferRow> rows;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 34, child: TacticalChip(r.position)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholeText(r.name, maxLines: 1, textAlign: TextAlign.start),
                    Row(
                      children: [
                        Expanded(
                          child: WholeText(
                            '${r.from} → ${r.to}',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: AppTypography.labelSmall.copyWith(
                              color: r.abroad
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                r.fee,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
