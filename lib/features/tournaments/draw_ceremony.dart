import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One drawn group for the ceremony: its display name and the nations in it,
/// ordered by pot (index 0 = pot 1, etc.).
typedef DrawGroup = ({String name, List<int> nationIds});

/// One reveal in the running order: a nation dropping into a group from a pot.
typedef _Step = ({int groupIndex, int nationId, int pot});

/// A reusable, animated pot-draw ceremony: balls are pulled from numbered pots
/// and dropped one by one into their groups. The result is already decided —
/// this presents it with a flourish. Shared by every competition's draw (World
/// Cup finals, continental finals, qualifying group draws).
class DrawCeremony extends StatefulWidget {
  const DrawCeremony({
    required this.groups,
    required this.nations,
    required this.onContinue,
    this.highlightNationId,
    this.potCount,
    this.crossAxisCount = 2,
    super.key,
  });

  /// The drawn groups, each nation ordered by the pot it came from.
  final List<DrawGroup> groups;
  final Map<int, Nation> nations;

  /// Called when the ceremony finishes (or is skipped) and the user continues.
  final VoidCallback onContinue;

  /// The player's nation, kept highlighted throughout the draw so they can spot
  /// where they land.
  final int? highlightNationId;

  /// Number of pots; defaults to the largest group's size.
  final int? potCount;

  /// Columns in the groups grid.
  final int crossAxisCount;

  @override
  State<DrawCeremony> createState() => _DrawCeremonyState();
}

class _DrawCeremonyState extends State<DrawCeremony> {
  int _revealed = 0;
  Timer? _timer;
  late final List<_Step> _steps = _buildSteps();
  late final int _pots = widget.potCount ?? _largestGroup();

  int _largestGroup() => widget.groups
      .fold<int>(0, (m, g) => g.nationIds.length > m ? g.nationIds.length : m);

  List<_Step> _buildSteps() {
    final pots = widget.potCount ?? _largestGroup();
    return [
      for (var pot = 0; pot < pots; pot++)
        for (var gi = 0; gi < widget.groups.length; gi++)
          if (pot < widget.groups[gi].nationIds.length)
            (
              groupIndex: gi,
              nationId: widget.groups[gi].nationIds[pot],
              pot: pot,
            ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 650), (t) {
      if (_revealed >= _steps.length) {
        t.cancel();
        return;
      }
      setState(() => _revealed++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _skip() {
    _timer?.cancel();
    setState(() => _revealed = _steps.length);
  }

  String _code(int id) => widget.nations[id]?.code ?? '??';
  String _name(int id) => widget.nations[id]?.name ?? '—';

  @override
  Widget build(BuildContext context) {
    final shown = _steps.take(_revealed).toList();
    final revealedByGroup = <int, List<int>>{};
    for (final s in shown) {
      (revealedByGroup[s.groupIndex] ??= []).add(s.nationId);
    }
    final done = _revealed >= _steps.length;
    final current = (!done && _revealed >= 0 && _revealed < _steps.length)
        ? _steps[_revealed]
        : null;
    final last = (_revealed > 0) ? _steps[_revealed - 1] : null;

    return Column(
      children: [
        _Pots(
          potCount: _pots,
          groupCount: widget.groups.length,
          shown: shown,
          activePot: current?.pot,
        ),
        _Stage(
          done: done,
          step: last,
          groupName: last == null ? '' : widget.groups[last.groupIndex].name,
          code: _code,
          name: _name,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: widget.crossAxisCount,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            childAspectRatio: 0.92,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            children: [
              for (var gi = 0; gi < widget.groups.length; gi++)
                _GroupCard(
                  title: 'GROUP ${widget.groups[gi].name}',
                  slots: _pots,
                  revealed: revealedByGroup[gi] ?? const [],
                  justAdded: !done && last != null && last.groupIndex == gi
                      ? last.nationId
                      : null,
                  highlightNationId: widget.highlightNationId,
                  code: _code,
                  name: _name,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: done
              ? PrimaryButton(
                  label: 'Continue',
                  icon: Icons.check_rounded,
                  onPressed: widget.onContinue,
                )
              : OutlinedButton(
                  onPressed: _skip,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  child: const Text('Skip'),
                ),
        ),
      ],
    );
  }
}

/// The row of numbered pots with their remaining balls.
class _Pots extends StatelessWidget {
  const _Pots({
    required this.potCount,
    required this.groupCount,
    required this.shown,
    required this.activePot,
  });

  final int potCount;
  final int groupCount;
  final List<_Step> shown;
  final int? activePot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var pot = 0; pot < potCount; pot++)
            _Pot(
              index: pot,
              total: groupCount,
              drawn: shown.where((s) => s.pot == pot).length,
              active: pot == activePot,
            ),
        ],
      ),
    );
  }
}

class _Pot extends StatelessWidget {
  const _Pot({
    required this.index,
    required this.total,
    required this.drawn,
    required this.active,
  });

  final int index;
  final int total;
  final int drawn;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final remaining = total - drawn;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainer,
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: active ? AppColors.primary : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            'POT ${index + 1}',
            style: AppTypography.labelSmall.copyWith(
              color: active ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          // Remaining balls, shrinking as the pot empties.
          SizedBox(
            height: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < total; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(
                      Icons.circle,
                      size: 7,
                      color: i < remaining
                          ? AppColors.primary
                          : AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The centre stage: the ball currently being drawn pops in with its flag.
class _Stage extends StatelessWidget {
  const _Stage({
    required this.done,
    required this.step,
    required this.groupName,
    required this.code,
    required this.name,
  });

  final bool done;
  final _Step? step;
  final String groupName;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: (done || step == null)
            ? Center(
                key: const ValueKey('done'),
                child: Text(
                  done ? 'DRAW COMPLETE' : 'DRAWING…',
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              )
            : Row(
                key: ValueKey('${step!.pot}-${step!.nationId}'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The "ball" with the drawn nation's flag.
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          AppColors.surfaceContainerHighest,
                          AppColors.surfaceContainer,
                        ],
                      ),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: FlagDisc(code(step!.nationId), size: 48),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name(step!.nationId),
                        style: AppTypography.titleMedium,
                      ),
                      Text(
                        '→ GROUP $groupName',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.title,
    required this.slots,
    required this.revealed,
    required this.justAdded,
    required this.highlightNationId,
    required this.code,
    required this.name,
  });

  final String title;
  final int slots;
  final List<int> revealed;
  final int? justAdded;
  final int? highlightNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var slot = 0; slot < slots; slot++)
            Expanded(
              child: slot < revealed.length
                  ? _row(
                      revealed[slot],
                      flashed: revealed[slot] == justAdded,
                      isPlayer: revealed[slot] == highlightNationId,
                    )
                  : const _EmptySlot(),
            ),
        ],
      ),
    );
  }

  Widget _row(int nationId, {required bool flashed, required bool isPlayer}) {
    // The player's nation stays highlighted; a just-drawn ball also flashes.
    final emphasise = flashed || isPlayer;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      decoration: isPlayer
          ? const BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppRadii.smAll,
            )
          : null,
      child: Row(
        children: [
          FlagDisc(code(nationId), size: 18, highlighted: emphasise),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              name(nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: emphasise ? AppColors.primary : AppColors.onSurface,
                fontWeight: emphasise ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outlineVariant),
        ),
      ),
    );
  }
}
