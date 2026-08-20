import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One drawn group for the ceremony: its display name and the nations in it,
/// ordered by pot (index 0 = pot 1, etc.).
typedef DrawGroup = ({String name, List<int> nationIds});

/// One reveal in the running order: a nation dropping into a group from a pot.
typedef _Step = ({int groupIndex, int nationId, int pot});

/// How much each draw action reveals — chosen by the manager.
enum _DrawGrain {
  ball('Ball'),
  pot('Pot'),
  all('All')
  ;

  const _DrawGrain(this.label);
  final String label;
}

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

  /// Whether the draw is auto-playing. The manager can pause and pull the balls
  /// one at a time, or let it run.
  bool _auto = true;

  /// A calmer autoplay than before — the old pace flew by before you could see
  /// where anyone landed.
  static const _autoInterval = Duration(milliseconds: 950);

  late final List<_Step> _steps = _buildSteps();
  late final int _pots = widget.potCount ?? _largestGroup();

  /// How much each draw reveals: one ball, a whole pot, or the entire draw.
  /// Pot-by-pot is the default — a real draw's rhythm without the wait.
  _DrawGrain _grain = _DrawGrain.ball;

  int _largestGroup() => widget.groups.fold<int>(
    0,
    (m, g) => g.nationIds.length > m ? g.nationIds.length : m,
  );

  List<_Step> _buildSteps() {
    final pots = widget.potCount ?? _largestGroup();
    // A stable seed from the drawn field, so the reveal order is deterministic
    // (it survives rebuilds) yet isn't the tell-tale group A→B→C→… sequence.
    var seed = 0x9E3779B9;
    for (final g in widget.groups) {
      for (final id in g.nationIds) {
        seed = ((seed ^ id) * 0x85EBCA6B) & 0x7FFFFFFF;
      }
    }
    final rng = Random(seed == 0 ? 1 : seed);
    final steps = <_Step>[];
    // One pot at a time: a random team is drawn from the pot and drops into its
    // group, so the groups fill in an unpredictable order — as at a real draw —
    // rather than always A, B, C, …
    for (var pot = 0; pot < pots; pot++) {
      final potSteps = <_Step>[
        for (var gi = 0; gi < widget.groups.length; gi++)
          if (pot < widget.groups[gi].nationIds.length)
            (
              groupIndex: gi,
              nationId: widget.groups[gi].nationIds[pot],
              pot: pot,
            ),
      ]..shuffle(rng);
      steps.addAll(potSteps);
    }
    return steps;
  }

  @override
  void initState() {
    super.initState();
    _startAuto();
  }

  /// The reveal index the next draw advances to, honouring the chosen grain:
  /// one ball, the rest of the current pot, or the whole draw.
  int _advanceTarget() {
    if (_revealed >= _steps.length) return _revealed;
    switch (_grain) {
      case _DrawGrain.ball:
        return _revealed + 1;
      case _DrawGrain.all:
        return _steps.length;
      case _DrawGrain.pot:
        final pot = _steps[_revealed].pot;
        var r = _revealed;
        while (r < _steps.length && _steps[r].pot == pot) {
          r++;
        }
        return r;
    }
  }

  void _startAuto() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoInterval, (t) {
      if (!_auto || _revealed >= _steps.length) {
        t.cancel();
        return;
      }
      setState(() => _revealed = _advanceTarget());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _done => _revealed >= _steps.length;

  /// Reveal the next ball. Tapping to draw pauses the autoplay, so the manager
  /// stays in control until they press play again.
  void _drawNext() {
    if (_done) return;
    setState(() {
      _revealed = _advanceTarget();
      _auto = false;
    });
    _timer?.cancel();
  }

  void _toggleAuto() {
    setState(() => _auto = !_auto);
    if (_auto) _startAuto();
  }

  void _skip() {
    _timer?.cancel();
    setState(() {
      _revealed = _steps.length;
      _auto = false;
    });
  }

  String _code(int id) => widget.nations[id]?.code ?? '??';
  String _name(int id) => widget.nations[id]?.name ?? '—';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = _steps.take(_revealed).toList();
    final revealedByGroup = <int, List<int>>{};
    for (final s in shown) {
      (revealedByGroup[s.groupIndex] ??= []).add(s.nationId);
    }
    // Nations still waiting in each pot, so the pots can show their flags.
    //
    // Listed in a FIXED order (by nation id) rather than in the order they are
    // about to come out. Showing the draw order meant the ball taken next was
    // always the leftmost flag in the pot: the reveal was random, but it never
    // looked it — you could read off who was coming before it was drawn. A pot
    // that keeps its own order has its ball plucked from somewhere in the
    // middle, which is what a draw looks like.
    final waitingByPot = <int, List<int>>{};
    for (var i = _revealed; i < _steps.length; i++) {
      (waitingByPot[_steps[i].pot] ??= []).add(_steps[i].nationId);
    }
    for (final pot in waitingByPot.values) {
      pot.sort();
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
          waitingByPot: waitingByPot,
          activePot: current?.pot,
          highlightNationId: widget.highlightNationId,
          code: _code,
        ),
        _Stage(
          done: done,
          step: last,
          groupName: last == null ? '' : widget.groups[last.groupIndex].name,
          // The teams already in the group the last team joined, for context.
          groupMembers: last == null
              ? const []
              : (revealedByGroup[last.groupIndex] ?? const []),
          code: _code,
          name: _name,
        ),
        Expanded(
          // Tap anywhere over the groups to pull the next ball.
          child: GestureDetector(
            onTap: done ? null : _drawNext,
            behavior: HitTestBehavior.opaque,
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
                    title: l.tourSharedGroupName(widget.groups[gi].name),
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
        ),
        if (!done) ...[
          // Draw mode: reveal one ball, a whole pot, or the entire draw.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: SegmentedButton<_DrawGrain>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              segments: [
                ButtonSegment(
                  value: _DrawGrain.ball,
                  label: Text(l.tourSharedBall),
                ),
                ButtonSegment(
                  value: _DrawGrain.pot,
                  label: Text(l.tourSharedPot),
                ),
                ButtonSegment(
                  value: _DrawGrain.all,
                  label: Text(l.tourSharedAll),
                ),
              ],
              selected: {_grain},
              onSelectionChanged: (s) => setState(() => _grain = s.first),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Text(
              switch (_grain) {
                _DrawGrain.ball => l.tourSharedTapDrawTeam,
                _DrawGrain.pot => l.tourSharedTapDrawPot,
                _DrawGrain.all => l.tourSharedTapDrawAll,
              },
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: done
                ? PrimaryButton(
                    label: l.tourSharedContinue,
                    icon: Icons.check_rounded,
                    onPressed: widget.onContinue,
                  )
                : Row(
                    children: [
                      // Pause the run, or set it going again.
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _toggleAuto,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          icon: Icon(
                            _auto
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 20,
                          ),
                          label: Text(
                            _auto ? l.tourSharedPause : l.tourSharedPlay,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _skip,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          icon: const Icon(
                            Icons.fast_forward_rounded,
                            size: 20,
                          ),
                          label: Text(l.tourSharedSkip),
                        ),
                      ),
                    ],
                  ),
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
    required this.waitingByPot,
    required this.activePot,
    required this.highlightNationId,
    required this.code,
  });

  final int potCount;
  final int groupCount;
  final Map<int, List<int>> waitingByPot;
  final int? activePot;
  final int? highlightNationId;
  final String Function(int) code;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var pot = 0; pot < potCount; pot++)
            Expanded(
              child: _Pot(
                index: pot,
                total: groupCount,
                waiting: waitingByPot[pot] ?? const [],
                active: pot == activePot,
                highlightNationId: highlightNationId,
                code: code,
              ),
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
    required this.waiting,
    required this.active,
    required this.highlightNationId,
    required this.code,
  });

  final int index;
  final int total;
  final List<int> waiting;
  final bool active;
  final int? highlightNationId;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    // Show every nation still in the pot (no cap) — the active pot larger and
    // highlighted so it's clear which one is being drawn right now.
    final flagSize = active ? 22.0 : 15.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: active ? AppSpacing.sm : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainer,
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: active ? AppColors.primary : AppColors.outlineVariant,
          width: active ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).tourPot(index + 1),
            style:
                (active ? AppTypography.labelMedium : AppTypography.labelSmall)
                    .copyWith(
                      color: active
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    ),
          ),
          const SizedBox(height: 4),
          // The flags of the nations still waiting in this pot. The manager's
          // own ball is a labelled pill rather than one more ringed flag among
          // twelve — a ring alone was impossible to pick out of a full pot.
          Wrap(
            spacing: 3,
            runSpacing: 3,
            alignment: WrapAlignment.center,
            children: [
              for (final id in waiting)
                if (id == highlightNationId)
                  // Scaled down to whatever room the pot column has left: a
                  // six-pot draw leaves each column barely wider than a flag,
                  // and the flag + code pill ran straight out of its box.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.20),
                        borderRadius: AppRadii.smAll,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlagDisc(code(id), size: flagSize, highlighted: true),
                          const SizedBox(width: 3),
                          Text(
                            code(id).toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: active ? 11 : 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  FlagDisc(code(id), size: flagSize),
              if (waiting.isEmpty)
                Text(
                  '✓',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
            ],
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
    required this.groupMembers,
    required this.code,
    required this.name,
  });

  final bool done;
  final _Step? step;
  final String groupName;

  /// Teams already in the group the drawn team joined (includes the drawn one).
  final List<int> groupMembers;
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
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
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
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      if (groupMembers.length > 1) ...[
                        const SizedBox(height: 4),
                        // The group filling up, drawn team highlighted.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final id in groupMembers)
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: FlagDisc(
                                  code(id),
                                  size: 18,
                                  highlighted: id == step!.nationId,
                                ),
                              ),
                          ],
                        ),
                      ],
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
      // The whole row is lifted for the manager's nation — fill plus a left
      // accent bar — so it reads at a glance in a grid of twelve groups.
      decoration: isPlayer
          ? const BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppRadii.smAll,
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 3),
              ),
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
