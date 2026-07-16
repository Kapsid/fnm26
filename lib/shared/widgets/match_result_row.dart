import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';

/// One match result: each side's flag and code either side of a pill-shaped
/// score chip.
///
/// Shared by the post-match round-results screen and the hub's round popup, so
/// a tournament the player only follows reads exactly like one they played in.
class MatchResultRow extends StatelessWidget {
  const MatchResultRow({
    required this.fixture,
    required this.code,
    this.emphasiseNationId,
    this.emphasiseWinner = false,
    super.key,
  });

  final Fixture fixture;
  final String Function(int) code;

  /// Bolds this nation's side — the manager's own, on screens where they took
  /// part.
  final int? emphasiseNationId;

  /// Bolds whichever side went through, for knockout rounds the manager is
  /// only watching (where no side is "theirs").
  final bool emphasiseWinner;

  @override
  Widget build(BuildContext context) {
    final home = fixture.homeNationId;
    final away = fixture.awayNationId;
    final hs = fixture.homeScore ?? 0;
    final as = fixture.awayScore ?? 0;

    // A level knockout tie was settled on penalties, and the stored home side
    // is the winner; anything else can simply be a draw.
    final isKnockout = Rounds.isKnockout(fixture.round);
    final pens = isKnockout && hs == as;
    final drawn = !isKnockout && hs == as;

    bool bold(int nationId) {
      if (emphasiseNationId != null) return nationId == emphasiseNationId;
      if (!emphasiseWinner || drawn) return false;
      return nationId == home ? hs >= as : as > hs;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: _Side(id: home, code: code, bold: bold(home), end: true),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              pens ? '$hs - $as p' : '$hs - $as',
              style: AppTypography.labelMedium,
            ),
          ),
          Expanded(
            child: _Side(id: away, code: code, bold: bold(away), end: false),
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.id,
    required this.code,
    required this.bold,
    required this.end,
  });

  final int id;
  final String Function(int) code;
  final bool bold;
  final bool end;

  @override
  Widget build(BuildContext context) {
    final label = Flexible(
      child: Text(
        code(id),
        overflow: TextOverflow.ellipsis,
        textAlign: end ? TextAlign.end : TextAlign.start,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
    final flag = FlagDisc(code(id), size: 16);
    return Row(
      mainAxisAlignment: end ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: end
          ? [label, const SizedBox(width: AppSpacing.xs), flag]
          : [flag, const SizedBox(width: AppSpacing.xs), label],
    );
  }
}
