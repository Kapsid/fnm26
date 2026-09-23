import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Names the five penalty takers, in order, before a shootout.
///
/// The order is the last decision of a knockout tie and, until now, one the
/// game made for the manager. Each slot can be swapped for anyone still on the
/// pitch; the composure figure beside a name is what actually drives the kick
/// (see [PenaltyTakers.skillOf]), so choosing badly loses shootouts.
class PenaltyOrderSheet extends StatefulWidget {
  const PenaltyOrderSheet({
    required this.squad,
    required this.initialOrder,
    this.traitsByPlayer = const {},
    super.key,
  });

  /// Everyone still on the pitch — the pool a taker can be swapped in from.
  final List<Player> squad;

  /// The automatic order, offered as the starting point.
  final List<Player> initialOrder;

  final Map<int, List<PlayerTrait>> traitsByPlayer;

  @override
  State<PenaltyOrderSheet> createState() => _PenaltyOrderSheetState();
}

class _PenaltyOrderSheetState extends State<PenaltyOrderSheet> {
  late List<Player> _order = [...widget.initialOrder];

  /// Which slot is being reassigned, or null while the list is just shown.
  int? _picking;

  double _skill(Player p) =>
      PenaltyTakers.skillOf(p, widget.traitsByPlayer[p.id] ?? const []);

  void _assign(int slot, Player p) {
    setState(() {
      // Swap, so a taker already further down the list trades places rather
      // than appearing twice.
      final existing = _order.indexWhere((q) => q.id == p.id);
      final outgoing = _order[slot];
      _order[slot] = p;
      if (existing >= 0 && existing != slot) _order[existing] = outgoing;
      _picking = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final picking = _picking;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      picking == null
                          ? l.penaltyOrderTitle
                          : l.penaltyOrderPick(picking + 1),
                      style: AppTypography.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                picking == null ? l.penaltyOrderBlurb : l.penaltyOrderPickBlurb,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: SingleChildScrollView(
                  child: picking == null
                      ? Column(
                          children: [
                            for (var i = 0; i < _order.length; i++)
                              _TakerRow(
                                index: i + 1,
                                player: _order[i],
                                skill: _skill(_order[i]),
                                onTap: () => setState(() => _picking = i),
                              ),
                          ],
                        )
                      : Column(
                          children: [
                            for (final p in _sortedSquad())
                              _TakerRow(
                                player: p,
                                skill: _skill(p),
                                selected: _order[picking].id == p.id,
                                onTap: () => _assign(picking, p),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (picking == null)
                PrimaryButton(
                  label: l.penaltyOrderConfirm,
                  icon: Icons.check_rounded,
                  onPressed: () => Navigator.of(context).pop(_order),
                )
              else
                OutlinedButton(
                  onPressed: () => setState(() => _picking = null),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.onSurfaceVariant,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  child: Text(l.penaltyOrderCancel),
                ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// The pool to swap from, surest first — the same reading the automatic order
  /// uses, so the obvious choice is at the top.
  List<Player> _sortedSquad() =>
      [...widget.squad]..sort((a, b) => _skill(b).compareTo(_skill(a)));
}

class _TakerRow extends StatelessWidget {
  const _TakerRow({
    required this.player,
    required this.skill,
    required this.onTap,
    this.index,
    this.selected = false,
  });

  final Player player;
  final double skill;
  final VoidCallback onTap;

  /// The kick number (1–5) when showing the order; null in the picker.
  final int? index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    // 0.72–1.16 maps onto a 0–1 bar, so the difference between a specialist and
    // a centre-half is visible at a glance.
    final bar = ((skill - 0.72) / 0.44).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          borderRadius: AppRadii.baseAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                if (index != null) ...[
                  SizedBox(
                    width: 18,
                    child: Text(
                      '$index',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                SizedBox(
                  width: 38,
                  child: TacticalChip(player.position.label),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: ClipRRect(
                    borderRadius: AppRadii.smAll,
                    child: LinearProgressIndicator(
                      value: bar,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        bar >= 0.66
                            ? AppColors.positive
                            : bar >= 0.33
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ),
                if (index != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.swap_horiz_rounded,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
