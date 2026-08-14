import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/l10n/app_localizations.dart';
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

  /// The key this screen's draft is stored under, resolved once the nomination
  /// window is known.
  String? _draftKey;

  /// Whether the saved draft has been read back into [_selected] yet, so a
  /// rebuild never re-applies it over later edits.
  bool _draftLoaded = false;

  static const List<PositionCategory> _order = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  /// The line's name, short enough that four of them fit across a phone.
  String _shortHeading(AppLocalizations l, PositionCategory c) => switch (c) {
    PositionCategory.goalkeeper => l.tacticsLineGk,
    PositionCategory.defender => l.tacticsLineDef,
    PositionCategory.midfielder => l.tacticsLineMid,
    PositionCategory.forward => l.tacticsLineFwd,
  };

  /// Nobody, to start with.
  ///
  /// Nominating used to open with the previous squad already ticked, which
  /// quietly answered the question it was asking — and it re-ticked players who
  /// had since been banned or injured. Picking a squad should be a decision,
  /// with [_bestQuality] and [_previousSquad] there for when it isn't.
  Set<int> _initialSquad(List<Player> pool, Iterable<int> current) => {};

  /// Records the squad as it currently stands, so leaving the screen part-way
  /// through a nomination — to read a player's card, or just to look at the
  /// fixtures — no longer means starting again from an empty sheet.
  void _saveDraft() {
    final key = _draftKey;
    final selected = _selected;
    if (key == null || selected == null) return;
    unawaited(
      ref.read(squadRepositoryProvider).saveCallUpDraft(widget.careerId, key, {
        ...selected,
      }),
    );
  }

  /// Applies any change to the selection and drafts the result.
  void _edit(void Function(Set<int> selected) change) {
    setState(() => change(_selected ??= {}));
    _saveDraft();
  }

  /// Whether a player is worth naming for a squad covering [coverage] matches.
  ///
  /// A one-match knock or ban does NOT rule a player out of a squad that covers
  /// four games — he sits out the first and plays the rest, exactly as a real
  /// call-up list works. Only someone missing EVERY match in the period is left
  /// out, which is what the auto-picks used to do to anyone carrying so much as
  /// a single-game absence.
  static bool _usableInPeriod(
    PlayerAbsence? absence,
    int coverage,
  ) {
    if (absence == null || absence.isAvailable) return true;
    final out = absence.injuryMatches > absence.banMatches
        ? absence.injuryMatches
        : absence.banMatches;
    return out < (coverage < 1 ? 1 : coverage);
  }

  /// The best [kMaxSquadSize] players by rating who are usable at some point in
  /// the period, but with **at most three goalkeepers** — a real squad carries
  /// three keepers and fills the rest with outfielders, rather than stacking
  /// whoever rates highest.
  Set<int> _bestQuality(
    List<Player> pool,
    Map<int, PlayerAbsence> absences,
    int coverage,
  ) {
    final fit =
        pool.where((p) => _usableInPeriod(absences[p.id], coverage)).toList()
          // Whoever can play the FIRST match comes first at equal quality, so
          // the named squad can always field an XI straight away.
          ..sort((a, b) {
            final aFit = absences[a.id]?.isAvailable ?? true;
            final bFit = absences[b.id]?.isAvailable ?? true;
            if (aFit != bFit) return aFit ? -1 : 1;
            return b.overall.compareTo(a.overall);
          });
    bool isGk(Player p) => p.position.category == PositionCategory.goalkeeper;
    final keepers = fit.where(isGk).take(3).toList();
    final outfield = fit
        .where((p) => !isGk(p))
        .take(kMaxSquadSize - keepers.length);
    return {...keepers, ...outfield}.map((p) => p.id).toSet();
  }

  /// Last time's squad, minus anyone who cannot play at all in this period.
  Set<int> _previousSquad(
    List<Player> pool,
    Iterable<int> previous,
    Map<int, PlayerAbsence> absences,
    int coverage,
  ) {
    final was = previous.toSet();
    final fit =
        pool
            .where((p) => was.contains(p.id))
            .where((p) => _usableInPeriod(absences[p.id], coverage))
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
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.tacticsPickAtLeastPlayers(kMinSquadSize)),
          ),
        );
      }
      return;
    }
    // The squad is named: the draft has served its purpose.
    final key = _draftKey;
    if (key != null) {
      await ref
          .read(squadRepositoryProvider)
          .clearCallUpDraft(widget.careerId, key);
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
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(squadDataProvider(widget.careerId));
    // The save seed, so a player's derived traits are the same here as
    // everywhere else in the save.
    final saveSeed =
        ref.watch(careerByIdProvider(widget.careerId)).valueOrNull?.rngSeed ??
        0;
    final window = ref
        .watch(nominationWindowProvider(widget.careerId))
        .valueOrNull;
    // Editable only during a nomination window (or when opened as the forced
    // pre-campaign event); otherwise the squad is locked between windows.
    final locked = widget.eventKind == null && window != null && !window.open;
    // How many matches this squad has to cover — a player carrying a shorter
    // absence than that is still worth naming.
    final coverage = window?.matches.length ?? 1;

    // Restore a nomination the manager had already started. Resolved once the
    // window is known (it decides which draft this is), and applied once.
    if (_draftKey == null && (window != null || widget.eventKind != null)) {
      _draftKey = callUpDraftKey(
        eventKind: widget.eventKind,
        periodStart: window?.matches.firstOrNull,
      );
    }
    final draftAsync = _draftKey == null
        ? null
        : ref.watch(
            callUpDraftProvider((careerId: widget.careerId, key: _draftKey!)),
          );
    if (!_draftLoaded && draftAsync?.valueOrNull != null) {
      _draftLoaded = true;
      final saved = draftAsync!.valueOrNull!;
      if (saved.isNotEmpty) _selected = {...saved};
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(_exitRoute),
        ),
        title: Text(
          l.tacticsCallUpsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          // "Who's coming through?" is a question asked while picking a squad,
          // so the watchlist hangs off the call-up screen.
          IconButton(
            icon: const Icon(Icons.school_outlined, color: AppColors.primary),
            tooltip: l.tacticsYouth,
            onPressed: () =>
                context.push('${Routes.youth}?careerId=${widget.careerId}'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
        data: (data) {
          if (data == null) return Center(child: Text(l.tacticsNoSquad));
          final condition =
              ref.watch(squadConditionProvider(widget.careerId)).valueOrNull ??
              const <int, PlayerCondition>{};
          final outlooks =
              ref.watch(absenceOutlookProvider(widget.careerId)).valueOrNull ??
              const <int, AbsenceOutlook>{};
          final selected = _selected ??= _initialSquad(data.pool, data.callUps);
          final count = selected.length;
          // Banned/injured players may be named, but a squad still has to be
          // able to put eleven fit players on the pitch.
          final fit = selected
              .where((id) => data.absences[id]?.isAvailable ?? true)
              .length;
          final ok =
              count >= kMinSquadSize &&
              count <= kMaxSquadSize &&
              fit >= kMinFitPlayers;

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
                // Both halves ellipsize: a translated "you need eleven fit
                // players, you have nine" is long enough to run the count off
                // the right-hand edge of a phone, which is what it did.
                child: Row(
                  children: [
                    Text(
                      l.tacticsSquadCount(count, kMaxSquadSize),
                      maxLines: 1,
                      softWrap: false,
                      style: AppTypography.labelMedium.copyWith(
                        color: ok ? AppColors.onSurface : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        // Once the size is right, the remaining constraint
                        // worth stating is how many of them can actually play.
                        count >= kMinSquadSize &&
                                count <= kMaxSquadSize &&
                                fit < kMinFitPlayers
                            ? l.tacticsNeedFitPlayers(kMinFitPlayers, fit)
                            : l.tacticsMinMax(kMinSquadSize, kMaxSquadSize),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: ok
                              ? AppColors.onSurfaceVariant
                              : AppColors.error,
                        ),
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
                          onPressed: () => _edit((s) {
                            s
                              ..clear()
                              ..addAll(
                                _bestQuality(
                                  data.pool,
                                  data.absences,
                                  coverage,
                                ),
                              );
                          }),
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(l.tacticsBestQuality),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          // Nothing to restore before a squad has been named.
                          onPressed: !data.hasPreviousSquad
                              ? null
                              : () => _edit((s) {
                                  s
                                    ..clear()
                                    ..addAll(
                                      _previousSquad(
                                        data.pool,
                                        data.callUps,
                                        data.absences,
                                        coverage,
                                      ),
                                    );
                                }),
                          icon: const Icon(Icons.history, size: 16),
                          label: Text(l.tacticsPreviousSquad),
                        ),
                      ),
                    ],
                  ),
                ),
              // One line at a time. A full pool is sixty-odd names, and as one
              // list the manager had to scroll past every keeper and defender
              // to find out whether he had enough forwards. The tabs are a view
              // over one squad — selection lives on the state, not the tab.
              Expanded(
                child: DefaultTabController(
                  length: _order.length,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: false,
                        labelPadding: EdgeInsets.zero,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.onSurfaceVariant,
                        indicatorColor: AppColors.primary,
                        tabs: [
                          for (final category in _order)
                            Tab(
                              height: 44,
                              child: _LineTab(
                                label: _shortHeading(l, category),
                                // How many of this line are in the squad —
                                // the number the manager is actually
                                // balancing.
                                count: data.pool
                                    .where(
                                      (p) =>
                                          p.position.category == category &&
                                          selected.contains(p.id),
                                    )
                                    .length,
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            for (final category in _order)
                              ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.marginMobile,
                                ),
                                children: [
                                  ..._section(
                                    category,
                                    data.pool,
                                    selected,
                                    data.absences,
                                    outlooks,
                                    condition,
                                    locked: locked,
                                    saveSeed: saveSeed,
                                  ),
                                  const SizedBox(height: AppSpacing.xl),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: locked
                      ? OutlinedButton.icon(
                          onPressed: () => context.go(_exitRoute),
                          icon: const Icon(Icons.lock_outline, size: 18),
                          label: Text(l.tacticsSquadLockedBack),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onSurfaceVariant,
                            side: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                        )
                      : PrimaryButton(
                          label: l.tacticsConfirmSquad,
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
    Map<int, AbsenceOutlook> outlooks,
    Map<int, PlayerCondition> condition, {
    bool locked = false,
    int saveSeed = 0,
  }) {
    final l = AppLocalizations.of(context);
    final players = pool.where((p) => p.position.category == category).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    if (players.isEmpty) {
      return [
        const SizedBox(height: AppSpacing.lg),
        Text(
          l.tacticsNoSquad,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ];
    }
    return [
      const SizedBox(height: AppSpacing.sm),
      // No heading: the tab above already names the line.
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final p in players)
              _PlayerToggle(
                player: p,
                selected: selected.contains(p.id),
                absence: absences[p.id],
                outlook: outlooks[p.id],
                condition: condition[p.id],
                saveSeed: saveSeed,
                // A banned or injured player CAN be named in the squad — real
                // managers call up someone serving a one-game ban or returning
                // from a knock, they just can't field them until they're clear.
                // The badge says why, the XI picker keeps them out, and the
                // engine still refuses to play them; nomination itself is the
                // manager's call, not the game's.
                onChanged: locked
                    ? null
                    : (on) {
                        if (on && selected.length >= kMaxSquadSize) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  l.tacticsSquadFullMax(kMaxSquadSize),
                                ),
                              ),
                            );
                          return;
                        }
                        _edit((s) {
                          if (on) {
                            s.add(p.id);
                          } else {
                            s.remove(p.id);
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
/// One line's tab: its short name, and how many of that line are in the squad.
class _LineTab extends StatelessWidget {
  const _LineTab({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium,
        ),
      ),
      if (count > 0) ...[
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$count',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    ],
  );
}

class _CoverageBanner extends StatelessWidget {
  const _CoverageBanner({required this.window, required this.locked});

  final NominationWindow window;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = locked ? AppColors.onSurfaceVariant : AppColors.positive;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        0,
      ),
      // A plain card — the open/locked state reads from the small icon and
      // label colour, not a full green fill and border (which was too loud).
      child: AppCard(
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
                    locked ? l.tacticsSquadLocked : l.tacticsNominationOpen,
                    style: AppTypography.labelSmall.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              locked ? l.tacticsSquadFixedBlurb : l.tacticsSquadWillPlayBlurb,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final f in window.matches.take(6)) _matchLine(l, f),
          ],
        ),
      ),
    );
  }

  Widget _matchLine(AppLocalizations l, Fixture f) {
    final oppId = f.homeNationId == window.playerNationId
        ? f.awayNationId
        : f.homeNationId;
    final opp = window.nations[oppId];
    final home = f.homeNationId == window.playerNationId;
    // Two lines: the opponent gets the full width up top (no more squeezing it
    // to an ellipsis to fit the competition), and the stage sits underneath.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            home ? 'v ' : '@ ',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          FlagDisc(opp?.code ?? '??', size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opp?.name ?? l.tacticsUnknown,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall,
                ),
                Text(
                  MatchStage.label(l, f),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
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

/// What a club standing reads as on a call-up row.
String clubStandingLabel(AppLocalizations l, ClubStanding s) => switch (s) {
  ClubStanding.firstChoice => l.clubFirstChoice,
  ClubStanding.rotation => l.clubRotation,
  ClubStanding.fringe => l.clubFringe,
  ClubStanding.frozenOut => l.clubFrozenOut,
};

class _PlayerToggle extends StatelessWidget {
  const _PlayerToggle({
    required this.player,
    required this.selected,
    required this.onChanged,
    required this.onInfo,
    required this.saveSeed,
    this.absence,
    this.outlook,
    this.condition,
  });

  final Player player;
  final bool selected;

  /// Toggles the call-up; null when the squad is locked (between windows).
  final ValueChanged<bool>? onChanged;
  final VoidCallback onInfo;
  final PlayerAbsence? absence;

  /// How long the absence actually runs — in weeks and a return match, rather
  /// than the raw game count on [absence].
  final AbsenceOutlook? outlook;
  final PlayerCondition? condition;

  /// The save seed, so the derived traits match the rest of the save.
  final int saveSeed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final out = outlook;
    final reason = out != null ? absenceLabel(l, out) : absence?.reason;
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
          // A boy still in the youth pyramid wears his level, so naming him is
          // never something that happens by accident.
          if (YouthLevel.forAge(player.age) case final level?) ...[
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.16),
                borderRadius: AppRadii.smAll,
              ),
              child: Text(
                level.label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
          if (condition != null) ...[
            const SizedBox(width: AppSpacing.xs),
            _FormDot(form: condition!.form),
          ],
          // What this player is known for, as a compact glyph strip — the
          // thing that makes one 74-rated midfielder different from the next.
          PlayerTraitGlyphs(player: player, saveSeed: saveSeed),
        ],
      ),
      // The absence badge lives on the subtitle line, not beside the name: in
      // the title it crowded the name into an ellipsis on a phone, so it read
      // as if the badge were covering it.
      subtitle: Row(
        children: [
          // Position is already shown by the leading chip — no role text.
          // Flexible because the tile's trailing controls leave this line
          // little more than a hundred pixels on a phone: age and value give
          // way to the badges, rather than running off the edge of the row.
          Flexible(
            child: Text(
              l.tacticsAgeValue(player.age, _money(player.value)),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (reason != null) ...[
            const SizedBox(width: AppSpacing.sm),
            _AbsenceBadge(reason: reason, isInjury: isInjury),
          ],
          // Only when it is worth saying: a rotation player is the norm and a
          // badge on every row would say nothing at all.
          if (condition?.clubStanding case final s?)
            if (s != ClubStanding.rotation) ...[
              const SizedBox(width: AppSpacing.sm),
              // The one thing on this line that can be long ("Plays every
              // week"), so it is the one thing that gives way. Unconstrained it
              // pushed the fatigue tag off the row and read as overlapping it.
              Flexible(
                child: Text(
                  clubStandingLabel(l, s),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: s == ClubStanding.firstChoice
                        ? AppColors.positive
                        : AppColors.warning,
                  ),
                ),
              ),
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
    final l = AppLocalizations.of(context);
    final (color, label) = switch (state) {
      FatigueState.exhausted => (
        const Color(0xFFD64545),
        l.tacticsFatigueExhausted,
      ),
      FatigueState.tired => (const Color(0xFFEFC94C), l.tacticsFatigueTired),
      FatigueState.ready => (
        AppColors.onSurfaceVariant,
        l.tacticsFatigueMatchLegs,
      ),
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
