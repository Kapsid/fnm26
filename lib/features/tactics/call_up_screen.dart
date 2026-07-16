import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/hub/hub_screen.dart' show matchStageLabel;
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Call-ups: choose which of the nation's eligible players are in the squad
/// for this save. Only called-up players can be picked in the XI or brought on
/// as substitutes. The squad must keep at least [kMinSquadSize] players.
class CallUpScreen extends ConsumerStatefulWidget {
  const CallUpScreen({
    required this.careerId,
    this.eventKind,
    this.eventCycle,
    super.key,
  });

  final int careerId;

  /// When launched as a timeline event, confirming the squad records this
  /// call-up window as done (so it fires only once) and returns to the hub.
  final String? eventKind;
  final int? eventCycle;

  @override
  ConsumerState<CallUpScreen> createState() => _CallUpScreenState();
}

class _CallUpScreenState extends ConsumerState<CallUpScreen> {
  Set<int>? _selected;

  static const List<PositionCategory> _order = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  static String _heading(PositionCategory c) => switch (c) {
        PositionCategory.goalkeeper => 'GOALKEEPERS',
        PositionCategory.defender => 'DEFENDERS',
        PositionCategory.midfielder => 'MIDFIELDERS',
        PositionCategory.forward => 'FORWARDS',
      };

  /// Nobody, to start with.
  ///
  /// Nominating used to open with the previous squad already ticked, which
  /// quietly answered the question it was asking — and it re-ticked players who
  /// had since been banned or injured. Picking a squad should be a decision,
  /// with [_bestQuality] and [_previousSquad] there for when it isn't.
  Set<int> _initialSquad(List<Player> pool, Iterable<int> current) => {};

  /// The best [kMaxSquadSize] available players by rating.
  Set<int> _bestQuality(List<Player> pool, Map<int, PlayerAbsence> absences) {
    final fit = pool.where((p) => absences[p.id]?.isAvailable ?? true).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    return fit.take(kMaxSquadSize).map((p) => p.id).toSet();
  }

  /// Last time's squad, minus anyone who can no longer play.
  Set<int> _previousSquad(
    List<Player> pool,
    Iterable<int> previous,
    Map<int, PlayerAbsence> absences,
  ) {
    final was = previous.toSet();
    final fit = pool
        .where((p) => was.contains(p.id))
        .where((p) => absences[p.id]?.isAvailable ?? true)
        .toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    return fit.take(kMaxSquadSize).map((p) => p.id).toSet();
  }

  /// Back to the hub when this was a timeline event, else back to tactics.
  String get _exitRoute => widget.eventKind != null
      ? '${Routes.hub}?careerId=${widget.careerId}'
      : '${Routes.tactics}?careerId=${widget.careerId}';

  Future<void> _confirm(Set<int> selected) async {
    final saved = await ref
        .read(squadServiceProvider)
        .setCallUps(widget.careerId, selected);
    // Don't retire the event (or leave) for a squad that wasn't saved — the
    // manager would come back to no squad and no way to be asked again.
    if (!saved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pick at least $kMinSquadSize players.'),
          ),
        );
      }
      return;
    }
    // A timeline call-up records itself done so the event fires only once.
    final kind = widget.eventKind;
    final cycle = widget.eventCycle;
    if (kind != null && cycle != null) {
      await ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(widget.careerId, cycle, kind);
    }
    if (mounted) context.go(_exitRoute);
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(squadDataProvider(widget.careerId));
    final window =
        ref.watch(nominationWindowProvider(widget.careerId)).valueOrNull;
    // Editable only during a nomination window (or when opened as the forced
    // pre-campaign event); otherwise the squad is locked between windows.
    final locked = widget.eventKind == null && window != null && !window.open;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(_exitRoute),
        ),
        title: Text(
          'CALL-UPS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load squad.\n$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No squad.'));
          final condition =
              ref.watch(squadConditionProvider(widget.careerId)).valueOrNull ??
                  const <int, PlayerCondition>{};
          final selected = _selected ??= _initialSquad(data.pool, data.callUps);
          final count = selected.length;
          final ok = count >= kMinSquadSize && count <= kMaxSquadSize;

          return Column(
            children: [
              if (window != null && window.matches.isNotEmpty)
                _CoverageBanner(window: window, locked: locked),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.sm,
                  AppSpacing.marginMobile,
                  0,
                ),
                child: Row(
                  children: [
                    Text(
                      'SQUAD · $count/$kMaxSquadSize',
                      style: AppTypography.labelMedium.copyWith(
                        color: ok ? AppColors.onSurface : AppColors.error,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Min $kMinSquadSize · Max $kMaxSquadSize',
                      style: AppTypography.labelSmall.copyWith(
                        color: ok
                            ? AppColors.onSurfaceVariant
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              // The squad starts empty, so offer the two answers a manager
              // actually wants: the best available, or the last lot again.
              if (!locked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    AppSpacing.sm,
                    AppSpacing.marginMobile,
                    0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(
                            () => _selected =
                                _bestQuality(data.pool, data.absences),
                          ),
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: const Text('Best quality'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          // Nothing to restore before a squad has been named.
                          onPressed: !data.hasPreviousSquad
                              ? null
                              : () => setState(
                                    () => _selected = _previousSquad(
                                      data.pool,
                                      data.callUps,
                                      data.absences,
                                    ),
                                  ),
                          icon: const Icon(Icons.history, size: 16),
                          label: const Text('Previous squad'),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  children: [
                    for (final category in _order)
                      ..._section(
                        category,
                        data.pool,
                        selected,
                        data.absences,
                        condition,
                        locked: locked,
                      ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: locked
                      ? OutlinedButton.icon(
                          onPressed: () => context.go(_exitRoute),
                          icon: const Icon(Icons.lock_outline, size: 18),
                          label: const Text('Squad locked — back'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onSurfaceVariant,
                            side: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                        )
                      : PrimaryButton(
                          label: 'Confirm squad',
                          icon: Icons.check_rounded,
                          onPressed: ok ? () => _confirm(selected) : null,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _section(
    PositionCategory category,
    List<Player> pool,
    Set<int> selected,
    Map<int, PlayerAbsence> absences,
    Map<int, PlayerCondition> condition, {
    bool locked = false,
  }) {
    final players = pool.where((p) => p.position.category == category).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    if (players.isEmpty) return const [];
    return [
      const SizedBox(height: AppSpacing.sm),
      Text(_heading(category), style: AppTypography.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final p in players)
              _PlayerToggle(
                player: p,
                selected: selected.contains(p.id),
                absence: absences[p.id],
                condition: condition[p.id],
                // A player serving a ban or an injury can't be picked — the
                // badge used to say so while the toggle happily let him in,
                // and the match then quietly refused to field him.
                onChanged: locked || !(absences[p.id]?.isAvailable ?? true)
                    ? null
                    : (on) {
                        if (on && selected.length >= kMaxSquadSize) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Squad full — max $kMaxSquadSize'),
                        ),
                      );
                    return;
                  }
                  setState(() {
                    if (on) {
                      selected.add(p.id);
                    } else {
                      selected.remove(p.id);
                    }
                  });
                },
                onInfo: () => context.push(
                  '${Routes.player}?careerId=${widget.careerId}'
                  '&playerId=${p.id}',
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
    ];
  }
}

/// The banner atop the call-ups screen: whether the squad is open to change or
/// locked between windows, and exactly which matches this nomination covers.
class _CoverageBanner extends StatelessWidget {
  const _CoverageBanner({required this.window, required this.locked});

  final NominationWindow window;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final accent = locked ? AppColors.onSurfaceVariant : AppColors.positive;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        0,
      ),
      child: AppCard(
        color: locked ? null : AppColors.positive.withValues(alpha: 0.08),
        border: locked
            ? null
            : Border.all(color: AppColors.positive.withValues(alpha: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  locked ? Icons.lock_outline : Icons.how_to_reg,
                  size: 18,
                  color: accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    locked
                        ? 'SQUAD LOCKED'
                        : 'NOMINATION OPEN — PICK YOUR SQUAD',
                    style: AppTypography.labelSmall.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              locked
                  ? 'This squad is fixed for the matches below. You can '
                      're-select before the next nomination window.'
                  : 'This squad will play the matches below.',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final f in window.matches.take(6)) _matchLine(f),
          ],
        ),
      ),
    );
  }

  Widget _matchLine(Fixture f) {
    final oppId = f.homeNationId == window.playerNationId
        ? f.awayNationId
        : f.homeNationId;
    final opp = window.nations[oppId];
    final home = f.homeNationId == window.playerNationId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              DateFormat('d MMM').format(f.date),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(home ? 'v ' : '@ ',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.onSurfaceVariant)),
          FlagDisc(opp?.code ?? '??', size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              opp?.name ?? 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          Text(
            matchStageLabel(f),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerToggle extends StatelessWidget {
  const _PlayerToggle({
    required this.player,
    required this.selected,
    required this.onChanged,
    required this.onInfo,
    this.absence,
    this.condition,
  });

  final Player player;
  final bool selected;

  /// Toggles the call-up; null when the squad is locked (between windows).
  final ValueChanged<bool>? onChanged;
  final VoidCallback onInfo;
  final PlayerAbsence? absence;
  final PlayerCondition? condition;

  @override
  Widget build(BuildContext context) {
    final reason = absence?.reason;
    final isInjury = (absence?.injuryMatches ?? 0) > 0;
    final change = onChanged;
    return ListTile(
      dense: true,
      onTap: change == null ? null : () => change(!selected),
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      title: Row(
        children: [
          Flexible(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
          if (condition != null) ...[
            const SizedBox(width: AppSpacing.xs),
            _FormDot(form: condition!.form),
          ],
        ],
      ),
      // The absence badge lives on the subtitle line, not beside the name: in
      // the title it crowded the name into an ellipsis on a phone, so it read
      // as if the badge were covering it.
      subtitle: Row(
        children: [
          // Position is already shown by the leading chip — no role text.
          Text(
            'Age ${player.age} · ${_money(player.value)}',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (reason != null) ...[
            const SizedBox(width: AppSpacing.sm),
            _AbsenceBadge(reason: reason, isInjury: isInjury),
          ],
          if (condition != null &&
              condition!.fatigueState != FatigueState.fresh) ...[
            const SizedBox(width: AppSpacing.sm),
            _FatigueTag(state: condition!.fatigueState),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.info_outline,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: onInfo,
          ),
          Text('${player.overall}', style: AppTypography.labelMedium),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            size: 22,
          ),
        ],
      ),
    );
  }

  /// Formats a euro value compactly, e.g. €12.5M / €650K / €0.
  static String _money(int euros) {
    if (euros >= 1000000) return '€${(euros / 1000000).toStringAsFixed(1)}M';
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }
}

/// A compact chip flagging an unavailable player as injured or suspended.
/// A small coloured dot showing a player's current form (hidden for steady).
class _FormDot extends StatelessWidget {
  const _FormDot({required this.form});

  final PlayerForm form;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (form) {
      PlayerForm.onFire => (
          const Color(0xFFE8622C),
          Icons.local_fire_department,
        ),
      PlayerForm.good => (AppColors.positive, Icons.trending_up),
      PlayerForm.steady => (AppColors.onSurfaceVariant, Icons.remove),
      PlayerForm.poor => (const Color(0xFFEFC94C), Icons.trending_down),
      PlayerForm.cold => (const Color(0xFFD64545), Icons.ac_unit),
    };
    if (form == PlayerForm.steady) return const SizedBox.shrink();
    return Icon(icon, size: 14, color: color);
  }
}

/// A compact tag flagging a fatigued player, to nudge rotation.
class _FatigueTag extends StatelessWidget {
  const _FatigueTag({required this.state});

  final FatigueState state;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (state) {
      FatigueState.exhausted => (const Color(0xFFD64545), 'Exhausted'),
      FatigueState.tired => (const Color(0xFFEFC94C), 'Tired'),
      FatigueState.ready => (AppColors.onSurfaceVariant, 'Match legs'),
      FatigueState.fresh => (AppColors.onSurfaceVariant, ''),
    };
    if (state == FatigueState.fresh) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.battery_alert_rounded, size: 11, color: color),
        const SizedBox(width: 2),
        Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
      ],
    );
  }
}

class _AbsenceBadge extends StatelessWidget {
  const _AbsenceBadge({required this.reason, required this.isInjury});

  final String reason;
  final bool isInjury;

  @override
  Widget build(BuildContext context) {
    final color = isInjury ? const Color(0xFFD64545) : const Color(0xFFEFC94C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isInjury ? Icons.medical_services : Icons.gavel,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            reason,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
