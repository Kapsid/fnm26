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
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/tactics/substitution_rules.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';
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
  Set<int> sentOffIds = const {},
  Map<int, int> energyByPlayer = const {},
  List<Color>? teamColors,
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
        sentOffIds: sentOffIds,
        energyByPlayer: energyByPlayer,
        teamColors: teamColors,
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
    this.sentOffIds = const {},
    this.energyByPlayer = const {},
    this.teamColors,
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

  /// Players sent off this match. They are gone for good: off the pitch, off
  /// the bench, and NOT replaceable — the side simply plays a man down. They
  /// used to sit in the squad list unmarked and could be subbed on again.
  final Set<int> sentOffIds;

  /// The manager's kit colours, filling the player discs on the pitch.
  final List<Color>? teamColors;

  @override
  State<_InMatchTacticsEditor> createState() => _InMatchTacticsEditorState();
}

class _InMatchTacticsEditorState extends State<_InMatchTacticsEditor> {
  late Formation _formation = widget.formation;

  /// The XI with any sent-off player's slot vacated — the shape the manager is
  /// actually working with once someone has walked.
  late List<int?> _lineup = [
    for (final id in widget.lineup)
      if (id != null && widget.sentOffIds.contains(id)) null else id,
  ];
  late TacticalInstructions _instructions = widget.instructions;

  /// Everyone still eligible to be on the pitch: the squad minus the sent off.
  late final List<Player> _eligible = widget.pool
      .where((p) => !widget.sentOffIds.contains(p.id))
      .toList();

  late final Map<int, Player> _byId = {for (final p in widget.pool) p.id: p};

  /// Ids currently on the pitch.
  Set<int> get _onPitch => _lineup.whereType<int>().toSet();

  /// The eleven actually on the pitch, for the side's live overall.
  List<Player> get _onPitchPlayers => [
    for (final id in _lineup)
      if (id != null && _byId[id] != null) _byId[id]!,
  ];

  /// A sub is spent for every starter no longer on the pitch (chains of
  /// replacements still count as a single change to that starter's slot). A
  /// sending-off is not a substitution — it costs a player, not a change.
  int get _subsUsed => widget.startingIds
      .where((id) => !_onPitch.contains(id) && !widget.sentOffIds.contains(id))
      .length;

  bool get _overLimit => _subsUsed > widget.maxSubs;

  /// Starters already taken off. They cannot come back on: football has no
  /// re-entry. Seeded from the XI the sheet opened with, so a manager reopening
  /// the editor later in the match still cannot undo an earlier change.
  late Set<int> _withdrawn = widget.startingIds
      .where((id) => !_onPitch.contains(id))
      .toSet();

  void _setFormation(Formation f) {
    if (f == _formation) return;
    // Keep the players currently on the pitch, refitting them to the new shape.
    final ids = _onPitch;
    final current = _eligible.where((p) => ids.contains(p.id)).toList();
    final fitPool = current.length >= 11
        ? current
        : [...current, ..._eligible.where((p) => !ids.contains(p.id))];
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
  ///
  /// The change is refused outright when it would break the substitution
  /// rules — the snackbar on [_apply] used to be the only thing standing in
  /// the way, which let the board reach a state football does not allow.
  void _setSlot(int slot, int playerId) {
    final refusal = refusalToBringOn(
      startingIds: widget.startingIds,
      onPitch: _onPitch,
      sentOffIds: widget.sentOffIds,
      withdrawnIds: _withdrawn,
      maxSubs: widget.maxSubs,
      playerId: playerId,
    );
    if (refusal != SubRefusal.none) {
      final l = AppLocalizations.of(context);
      // Say WHICH rule stopped him. Every refusal used to be reported as the
      // sub count being spent, so a manager dragging a man he had already
      // taken off was told he had made too many changes.
      final who = _byId[playerId]?.name ?? '';
      final message = switch (refusal) {
        SubRefusal.alreadyWithdrawn => l.tacticsSubAlreadyOff(who),
        SubRefusal.sentOff => l.tacticsSubSentOff(who),
        SubRefusal.noSubsLeft ||
        SubRefusal.none => l.tacticsTooManySubs(widget.maxSubs),
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }
    setState(() {
      final l = [..._lineup];
      final existing = l.indexOf(playerId);
      if (existing != -1) {
        l[existing] = l[slot];
      } else if (l[slot] case final out?) {
        _withdrawn = {..._withdrawn, out};
      }
      l[slot] = playerId;
      _lineup = l;
    });
  }

  void _apply() {
    if (_overLimit) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.tacticsTooManySubs(widget.maxSubs),
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
    final l = AppLocalizations.of(context);
    final onPitch = _onPitch;
    // A sent-off player is not a substitute — he's out of the game.
    final subs = _eligible.where((p) => !onPitch.contains(p.id)).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // The minute, and under it the side's overall as it stands — the same
        // number the pre-match screen shows either side of the "VS". It moves
        // with every change made here, which is the point: a manager taking a
        // tired star off should see what it costs him.
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.tacticsMinuteTitle(widget.minute),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              '${l.teamOverall} ${squadOverall(_onPitchPlayers)}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _apply,
            child: Text(
              l.tacticsApply,
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
            TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: l.tacticsTabLineupSubs),
                Tab(text: l.tacticsTabTactics),
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
    final l = AppLocalizations.of(context);
    return ListView(
      children: [
        // The formation picker lives on the Tactics tab and nowhere else. It
        // used to be repeated here, above the pitch, so the same row of shape
        // chips appeared twice in one sheet — two controls for one setting,
        // which reads as a bug whichever one you touch.
        AspectRatio(
          aspectRatio: 3 / 4,
          child: TacticsPitch(
            formation: _formation,
            instructions: _instructions,
            lineup: _lineup,
            byId: _byId,
            teamColors: widget.teamColors,
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
            onMoveToSpace: (slot, dropY) {
              final outcome = resolveSpaceDrag(
                _formation,
                _instructions,
                slot,
                dropY,
              );
              // Through _setFormation, which refits the players already on the
              // pitch — assigning _formation directly would scramble the side
              // mid-match.
              if (outcome case ReshapeTo(:final formation)) {
                _setFormation(formation);
              }
            },
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
                    l.tacticsSubstitutesCount(subs.length),
                    style: AppTypography.labelMedium,
                  ),
                  const Spacer(),
                  Text(
                    l.tacticsSubsUsed(_subsUsed, widget.maxSubs),
                    style: AppTypography.labelMedium.copyWith(
                      color: _overLimit ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.tacticsDragSubOn,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              // Say plainly that the side is short — the vacated slot on the
              // pitch is otherwise easy to read as an empty position to fill.
              if (widget.sentOffIds.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.block_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l.tacticsSentOffNote(
                          widget.sentOffIds
                              .map((id) => _byId[id]?.name)
                              .whereType<String>()
                              .join(', '),
                        ),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (subs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          l.tacticsNoSubs,
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
  ///
  /// Shouting a side further forward when you are chasing a game is management,
  /// not an exploit — the sliders belong here. What does not belong is applying
  /// a whole prepared PLAYSTYLE mid-match, and that lives on the tactics screen
  /// rather than in this editor.
  Widget _tacticsTab() {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        Text(l.tacticsFormation, style: AppTypography.labelMedium),
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
        Text(l.tacticsInstructions, style: AppTypography.labelMedium),
        _slider(
          l.tacticsInstrMentality,
          l.tacticsInstrDefensive,
          l.tacticsInstrAttacking,
          _instructions.mentality,
          (v) => _instructions = _instructions.copyWith(mentality: v),
        ),
        _slider(
          l.tacticsInstrPressing,
          l.tacticsInstrLowBlock,
          l.tacticsInstrHighPress,
          _instructions.pressing,
          (v) => _instructions = _instructions.copyWith(pressing: v),
        ),
        _slider(
          l.tacticsInstrTempo,
          l.tacticsInstrPatient,
          l.tacticsInstrFast,
          _instructions.tempo,
          (v) => _instructions = _instructions.copyWith(tempo: v),
        ),
        _slider(
          l.tacticsInstrWidth,
          l.tacticsInstrNarrow,
          l.tacticsInstrWide,
          _instructions.width,
          (v) => _instructions = _instructions.copyWith(width: v),
        ),
        _slider(
          l.tacticsInstrDefLine,
          l.tacticsInstrDeep,
          l.tacticsInstrHigh,
          _instructions.defensiveLine,
          (v) => _instructions = _instructions.copyWith(defensiveLine: v),
        ),
        _slider(
          l.tacticsInstrDirectness,
          l.tacticsInstrPossession,
          l.tacticsInstrDirect,
          _instructions.directness,
          (v) => _instructions = _instructions.copyWith(directness: v),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
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
          children: [
            Text(
              low,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              high,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
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
    final candidates =
        _eligible
            .where(
              (p) => isKeeperSlot
                  ? p.position.category == PositionCategory.goalkeeper
                  : p.position.category != PositionCategory.goalkeeper,
            )
            .toList()
          ..sort(PositionFit.bySlotFit(position));
    final onPitch = _onPitch;
    final l = AppLocalizations.of(context);

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l.tacticsPickRole(position.roleName.toUpperCase()),
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
                      ? l.tacticsRoleOutOfPosition(p.position.roleName)
                      : l.tacticsRoleAge(p.position.roleName, p.age),
                  style: AppTypography.labelSmall.copyWith(
                    color: penalised
                        ? AppColors.warning
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onPitch.contains(p.id)) ...[
                      TacticalChip(l.tacticsOn),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    // The rating in THIS slot leads — the number that decides
                    // the match — in amber when it is a docked one, with the
                    // player's own overall behind it for the comparison.
                    Text(
                      '$eff',
                      style: AppTypography.labelMedium.copyWith(
                        color: penalised ? AppColors.warning : null,
                      ),
                    ),
                    if (penalised)
                      Text(
                        ' (${p.overall})',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
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
}
