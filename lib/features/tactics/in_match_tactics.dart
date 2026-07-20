import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The tactical setup a manager confirms from the in-match editor: the shape,
/// the on-pitch XI (slot → player id, in [formation]'s order) and instructions,
/// to take effect from the current minute onward.
class InMatchTacticsResult {
  const InMatchTacticsResult({
    required this.formation,
    required this.lineup,
    required this.instructions,
  });

  final Formation formation;
  final List<int?> lineup;
  final TacticalInstructions instructions;
}

/// Opens the full in-match tactics editor (shape, XI, subs and instructions) as
/// a page and returns the confirmed setup, or null if the manager backed out.
Future<InMatchTacticsResult?> showInMatchTactics(
  BuildContext context, {
  required int minute,
  required Formation formation,
  required List<int?> lineup,
  required TacticalInstructions instructions,
  required List<Player> pool,
  required Set<int> startingIds,
  required int maxSubs,
  Set<int> injuredIds = const {},
  Map<int, int> energyByPlayer = const {},
}) {
  return Navigator.of(context).push<InMatchTacticsResult>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _InMatchTacticsEditor(
        minute: minute,
        formation: formation,
        lineup: lineup,
        instructions: instructions,
        pool: pool,
        startingIds: startingIds,
        maxSubs: maxSubs,
        injuredIds: injuredIds,
        energyByPlayer: energyByPlayer,
      ),
    ),
  );
}

class _InMatchTacticsEditor extends StatefulWidget {
  const _InMatchTacticsEditor({
    required this.minute,
    required this.formation,
    required this.lineup,
    required this.instructions,
    required this.pool,
    required this.startingIds,
    required this.maxSubs,
    this.injuredIds = const {},
    this.energyByPlayer = const {},
  });

  final int minute;
  final Formation formation;
  final List<int?> lineup;
  final TacticalInstructions instructions;
  final List<Player> pool;
  final Set<int> startingIds;
  final int maxSubs;

  /// Live remaining energy (0–100) per player id, shown on the pitch and bench
  /// so the manager can see who's tiring before making a sub.
  final Map<int, int> energyByPlayer;

  /// Players hurt this match and not yet replaced — flagged orange on the pitch
  /// so the manager knows exactly who to take off.
  final Set<int> injuredIds;

  @override
  State<_InMatchTacticsEditor> createState() => _InMatchTacticsEditorState();
}

class _InMatchTacticsEditorState extends State<_InMatchTacticsEditor> {
  late Formation _formation = widget.formation;
  late List<int?> _lineup = [...widget.lineup];
  late TacticalInstructions _instructions = widget.instructions;

  late final Map<int, Player> _byId = {for (final p in widget.pool) p.id: p};

  /// Ids currently on the pitch.
  Set<int> get _onPitch => _lineup.whereType<int>().toSet();

  /// A sub is spent for every starter no longer on the pitch (chains of
  /// replacements still count as a single change to that starter's slot).
  int get _subsUsed =>
      widget.startingIds.where((id) => !_onPitch.contains(id)).length;

  bool get _overLimit => _subsUsed > widget.maxSubs;

  void _setFormation(Formation f) {
    if (f == _formation) return;
    // Keep the players currently on the pitch, refitting them to the new shape.
    final ids = _onPitch;
    final current = widget.pool.where((p) => ids.contains(p.id)).toList();
    final fitPool = current.length >= 11
        ? current
        : [...current, ...widget.pool.where((p) => !ids.contains(p.id))];
    setState(() {
      _formation = f;
      _lineup = bestEleven(f, fitPool);
    });
  }

  void _swap(int a, int b) {
    if (a == b) return;
    setState(() {
      final l = [..._lineup];
      final tmp = l[a];
      l[a] = l[b];
      l[b] = tmp;
      _lineup = l;
    });
  }

  /// Puts [playerId] into [slot], swapping if they already start elsewhere (so
  /// the displaced player moves rather than duplicating), or otherwise pushing
  /// the previous occupant off the pitch (a substitution).
  void _setSlot(int slot, int playerId) {
    setState(() {
      final l = [..._lineup];
      final existing = l.indexOf(playerId);
      if (existing != -1) {
        l[existing] = l[slot];
      }
      l[slot] = playerId;
      _lineup = l;
    });
  }

  void _apply() {
    if (_overLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Too many substitutions (max ${widget.maxSubs}).',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      InMatchTacticsResult(
        formation: _formation,
        lineup: _lineup,
        instructions: _instructions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onPitch = _onPitch;
    final subs = widget.pool.where((p) => !onPitch.contains(p.id)).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "TACTICS · ${widget.minute}'",
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _apply,
            child: Text(
              'APPLY',
              style: AppTypography.labelMedium.copyWith(
                color: _overLimit ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'LINEUP & SUBS'),
                Tab(text: 'TACTICS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _lineupTab(subs),
                  _tacticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The pitch and the bench: pick a slot or drag a substitute on. An injured
  /// player is flagged directly on the pitch (orange, "INJURED — REPLACE"), so
  /// no banner is needed above the squad.
  Widget _lineupTab(List<Player> subs) {
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: TacticsPitch(
            formation: _formation,
            instructions: _instructions,
            lineup: _lineup,
            byId: _byId,
            energyByPlayer: widget.energyByPlayer,
            // Mark the hurt players absent AND injured so their node renders the
            // orange "INJURED — REPLACE" flag, exactly like a pre-match injury.
            absentIds: widget.injuredIds,
            injuredIds: widget.injuredIds,
            onTapSlot: _pickPlayer,
            onSwap: (a, b) {
              switch (resolveDrag(_formation, a, b)) {
                case SwapSlots():
                  _swap(a, b);
                case ReshapeTo(:final formation):
                  _reshapeKeeping(formation, a, b);
              }
            },
            onBenchIn: _setSlot,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'SUBSTITUTES · ${subs.length}',
                    style: AppTypography.labelMedium,
                  ),
                  const Spacer(),
                  Text(
                    'SUBS · $_subsUsed/${widget.maxSubs}',
                    style: AppTypography.labelMedium.copyWith(
                      color: _overLimit ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Drag a sub onto a player to bring them on.',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (subs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          'No substitutes available.',
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                    for (final p in subs)
                      SubDragRow(
                        player: p,
                        trailing: _energyTrailing(p.id),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }

  /// A small energy gauge for a bench row, or null when energy isn't tracked
  /// (pre-match) or this player has no recorded energy yet.
  Widget? _energyTrailing(int id) {
    final e = widget.energyByPlayer[id];
    if (e == null) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt, size: 14, color: energyColor(e)),
        Text(
          '$e%',
          style: AppTypography.labelMedium.copyWith(color: energyColor(e)),
        ),
      ],
    );
  }

  /// Formation and the tactical instruction sliders.
  Widget _tacticsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        const Text('FORMATION', style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final f in Formation.values)
              GestureDetector(
                onTap: () => _setFormation(f),
                child: TacticalChip(f.label, emphasized: f == _formation),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text('INSTRUCTIONS', style: AppTypography.labelMedium),
        _slider('Mentality', 'Defensive', 'Attacking', _instructions.mentality,
            (v) => _instructions = _instructions.copyWith(mentality: v)),
        _slider('Pressing', 'Low block', 'High press', _instructions.pressing,
            (v) => _instructions = _instructions.copyWith(pressing: v)),
        _slider('Tempo', 'Patient', 'Fast', _instructions.tempo,
            (v) => _instructions = _instructions.copyWith(tempo: v)),
        _slider('Width', 'Narrow', 'Wide', _instructions.width,
            (v) => _instructions = _instructions.copyWith(width: v)),
        _slider('Def. line', 'Deep', 'High', _instructions.defensiveLine,
            (v) => _instructions = _instructions.copyWith(defensiveLine: v)),
        _slider('Directness', 'Possession', 'Direct', _instructions.directness,
            (v) => _instructions = _instructions.copyWith(directness: v)),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  /// A cross-line drag that reshapes: refit the current players to [next], then
  /// nudge the dragged player toward the target slot so the intent is kept.
  void _reshapeKeeping(Formation next, int a, int b) {
    final draggedId = _lineup[a];
    _setFormation(next);
    if (draggedId != null) {
      final slot = _lineup.indexOf(draggedId);
      // If the player didn't land near the target line, place them at b.
      if (slot != -1 && slot != b) _setSlot(b, draggedId);
    }
  }

  Future<void> _pickPlayer(int slot) async {
    final position = _formation.positions[slot];
    final isKeeperSlot = position.category == PositionCategory.goalkeeper;
    // A goalkeeping slot is keeper-only; any other slot can be filled by any
    // outfield player (with a heavy out-of-position penalty, shown below).
    final candidates = widget.pool
        .where((p) => isKeeperSlot
            ? p.position.category == PositionCategory.goalkeeper
            : p.position.category != PositionCategory.goalkeeper)
        .toList()
      ..sort(PositionFit.bySlotFit(position));
    final onPitch = _onPitch;

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'PICK ${position.roleName.toUpperCase()}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final p in candidates)
            () {
              final eff = PositionFit.effectiveOverall(p, position);
              final penalised = eff < p.overall;
              return ListTile(
                dense: true,
                leading: TacticalChip(p.position.label),
                title: Text(
                  p.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: onPitch.contains(p.id)
                        ? AppColors.onSurfaceVariant
                        : null,
                  ),
                ),
                subtitle: Text(
                  penalised
                      ? '${p.position.roleName} · out of position'
                      : '${p.position.roleName} · Age ${p.age}',
                  style: AppTypography.labelSmall.copyWith(
                    color: penalised
                        ? AppColors.error
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onPitch.contains(p.id)) ...[
                      const TacticalChip('ON'),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    // The rating as it will count in this slot — the drop from
                    // the base overall is the cost of playing out of position.
                    if (penalised)
                      Text(
                        '${p.overall}→',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      '$eff',
                      style: AppTypography.labelMedium.copyWith(
                        color: penalised ? AppColors.error : null,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.of(context).pop(p.id),
              );
            }(),
        ],
      ),
    );
    if (picked != null) _setSlot(slot, picked);
  }

  Widget _slider(
    String label,
    String low,
    String high,
    int value,
    ValueChanged<int> apply,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.bodyMedium),
            const Spacer(),
            Text('$value', style: AppTypography.labelMedium),
          ],
        ),
        Slider(
          value: value.toDouble(),
          max: 100,
          divisions: 20,
          onChanged: (v) => setState(() => apply(v.round())),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              low,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              high,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
