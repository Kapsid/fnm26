import 'package:fnm/features/onboarding/tour_keys.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/familiarity_providers.dart';
import 'package:fnm/features/tactics/nation_squad_tab.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Drops a designated set-piece taker who is no longer in the eleven, once
/// this frame is done — a build must not write to a provider.
///
/// The store is captured by the caller rather than read in here, so the write
/// still lands if the screen has been left in the meantime.
void _clearTakerAfterFrame(
  SetPieceTakersStore store,
  int careerId, {
  required bool penalty,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    store.set(careerId, penalty: penalty, playerId: null);
  });
}

/// Squad: a tactical pitch view of the starting XI with the substitutes list
/// and formation selector. Players can be tapped to pick, or dragged to swap
/// positions / bring a substitute on. Instructions live behind the tune action.
class TacticsScreen extends ConsumerWidget {
  const TacticsScreen({required this.careerId, this.initialTab = 0, super.key});

  final int careerId;

  /// Which tab to open on (0 lineup, 1 instructions, 2 roles & set pieces,
  /// 3 squad).
  ///
  /// The pre-match setup strip sends the manager here about the armband or the
  /// set-piece takers, both of which sit on tab 2, so it names it.
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(tacticDataProvider(careerId));
    final service = ref.read(tacticServiceProvider);
    // The manager's kit colours, giving the squad on the pitch a real team
    // identity. Resolved via the career's nation; null until loaded.
    final career = ref.watch(careerByIdProvider(careerId)).valueOrNull;
    final nation = career == null
        ? null
        : ref.watch(nationByIdProvider(career.nationId)).valueOrNull;
    final teamColors = nation == null
        ? null
        : KitColors.discFill(nation.primaryColor, nation.secondaryColor);
    // How long each absence really runs, in weeks and a return match.
    final outlooks =
        ref.watch(absenceOutlookProvider(careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};
    // Familiarity per shape, 0..1 — and only familiarity: what the opposition
    // has worked out is hidden by design and never leaves the data layer.
    final drilling =
        ref.watch(shapeDrillingProvider(careerId)).valueOrNull ??
        const <Formation, double>{};

    return DefaultTabController(
      length: 4,
      initialIndex: initialTab.clamp(0, 3),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            // Pop back to wherever we came from (e.g. the match preview); fall
            // back to the hub when opened as a root tab.
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go('${Routes.hub}?careerId=$careerId'),
          ),
          title: Text(
            l.tacticsSquad,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          // Left, beside the arrow. Centred, it sat in the middle of four
          // actions and read as one of them.
          centerTitle: false,
          titleSpacing: 0,
          // Split into sections so it's not one long scroll — the pitch, each
          // player's role, the set-piece takers, and the wider squad each get
          // their own tab.
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.onSurface,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: l.tacticsTabLineup),
              Tab(text: l.tacticsTabInstructions),
              Tab(text: l.tacticsTabRolesSetPieces),
              Tab(key: TourKeys.squadTab, text: l.tacticsSquad),
            ],
          ),
          // Squad, instructions, saving how they play, then who is coming
          // through: the order a manager works in.
          actions: [
            IconButton(
              icon: const Icon(Icons.groups, color: AppColors.primary),
              tooltip: l.tacticsTooltipCallUps,
              onPressed: () =>
                  context.go('${Routes.callUps}?careerId=$careerId'),
            ),
            // The instructions have a tab of their own now, and this still
            // goes to them — the icon is where a manager's hand already is,
            // and a shortcut to a tab is not a second version of it. The
            // Builder is what gives it a context below the tab controller.
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.tune, color: AppColors.primary),
                tooltip: l.tacticsTooltipInstructions,
                onPressed: () => DefaultTabController.of(context).animateTo(1),
              ),
            ),
            dataAsync.maybeWhen(
              data: (data) => IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  color: AppColors.primary,
                ),
                tooltip: l.tacticsTooltipPresets,
                onPressed: data == null
                    ? null
                    : () => _openPresets(context, ref, data.tactic),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            // The same watchlist the call-up screen carries, reachable from
            // here too: "who is coming through" is asked while looking at the
            // squad, not only while naming one.
            IconButton(
              icon: const Icon(Icons.school_outlined, color: AppColors.primary),
              tooltip: l.tacticsYouth,
              onPressed: () =>
                  context.push('${Routes.youth}?careerId=$careerId'),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          careerId: careerId,
          current: AppTab.squad,
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
          data: (data) {
            if (data == null) return Center(child: Text(l.tacticsNoTacticSet));
            final tactic = data.tactic;
            final roles =
                ref.watch(playerRolesProvider(careerId)).valueOrNull ??
                const <int, PlayerRole>{};
            final takers = ref
                .watch(setPieceTakersProvider(careerId))
                .valueOrNull;
            final absentIds = {for (final p in data.unavailable) p.id};
            // Injuries (orange) vs suspensions (red) — split so the pitch and the
            // lists can show the right badge for each.
            final injuredIds = {
              for (final p in data.unavailable)
                if ((data.absences[p.id]?.injuryMatches ?? 0) > 0) p.id,
            };
            final outStarters = data.unavailableStarters;
            // The eleven as named, for the set pieces. A designated taker who
            // is no longer in the side goes back to automatic: null already
            // means "let the engine pick", so the stale id is cleared rather
            // than kept as a second kind of empty.
            final xi = [
              for (final id in tactic.lineup.whereType<int>()) ?data.byId[id],
            ];
            final xiIds = {for (final p in xi) p.id};
            final namedPenalty = xiIds.contains(takers?.penalty)
                ? takers?.penalty
                : null;
            final namedDeadBall = xiIds.contains(takers?.deadBall)
                ? takers?.deadBall
                : null;
            if (takers != null && xi.isNotEmpty) {
              final store = ref.read(setPieceTakersStoreProvider);
              if (takers.penalty != null && namedPenalty == null) {
                _clearTakerAfterFrame(store, careerId, penalty: true);
              }
              if (takers.deadBall != null && namedDeadBall == null) {
                _clearTakerAfterFrame(store, careerId, penalty: false);
              }
            }
            // Who actually steps up: the manager's man where he has named one,
            // and otherwise the engine's own choice, shown rather than left
            // blank for him to guess at.
            final penaltyId = namedPenalty ?? SetPiecePicks.penalty(xi);
            final deadBallId = namedDeadBall ?? SetPiecePicks.deadBall(xi);

            return TabBarView(
              children: [
                // 1. LINEUP — the pitch and the formation, the everyday setup.
                ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  children: [
                    // Starters who are banned/injured block the next match: name
                    // them (with the reason) right here, or the forced "reshape
                    // your XI" event reads as an unexplained dead end.
                    if (outStarters.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.marginMobile,
                          AppSpacing.sm,
                          AppSpacing.marginMobile,
                          0,
                        ),
                        child: AppCard(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.personal_injury_outlined,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.tacticsReplaceStarters(
                                        outStarters.length,
                                      ),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    for (final p in outStarters)
                                      Text(
                                        l.tacticsPlayerOut(
                                          p.name,
                                          switch (outlooks[p.id]) {
                                            final o? => absenceLabel(l, o),
                                            _ =>
                                              absenceShortLabel(
                                                    l,
                                                    data.absences[p.id],
                                                  ) ??
                                                  l.tacticsOut,
                                          },
                                        ),
                                        style: AppTypography.bodySmall,
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l.tacticsTapSpotReplace,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: TacticsPitch(
                        injuredIds: injuredIds,
                        formation: tactic.formation,
                        instructions: tactic.instructions,
                        lineup: tactic.lineup,
                        byId: data.byId,
                        teamColors: teamColors,
                        absentIds: absentIds,
                        onTapSlot: (slot) =>
                            _pickPlayer(context, ref, data, slot),
                        onSwap: (a, b) =>
                            _dragBetweenSlots(service, tactic, a, b),
                        onBenchIn: (slot, playerId) =>
                            service.setSlot(careerId, slot, playerId),
                        onMoveToSpace: (slot, dropY) {
                          final outcome = resolveSpaceDrag(
                            tactic.formation,
                            tactic.instructions,
                            slot,
                            dropY,
                          );
                          if (outcome case ReshapeTo(:final formation)) {
                            unawaited(
                              service.reshapeFormation(careerId, formation),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.marginMobile),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The pitch scrolls, so a drag has to start with a
                          // hold — say so, or it just reads as the page moving.
                          Text(
                            l.tacticsTapOrDrag,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // One line, not the whole grid. Nineteen shapes at
                          // three across is seven rows — about 981 points, a
                          // screen and a half of formations sitting between
                          // the manager and his own pitch. The grid is worth a
                          // screen while he is choosing and worth a line the
                          // rest of the time.
                          FormationField(
                            key: TourKeys.tacticsFormation,
                            selected: tactic.formation,
                            // How well the side knows each shape. The drilling
                            // bonus was already in the engine and already
                            // moved results, with nothing on screen to say so,
                            // which makes a real effect read as imaginary.
                            drilling: drilling,
                            onSelected: (f) =>
                                service.setFormation(careerId, f),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // The side's way of playing, stated in words, with a
                          // tap through to change it. The shape is only half of
                          // a tactic and the other half used to be six unnamed
                          // sliders behind an icon.
                          Text(
                            l.tacticsPlaystyle,
                            style: AppTypography.labelMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          // The Builder is load-bearing: this screen's own
                          // context sits ABOVE the DefaultTabController it
                          // creates, so looking the controller up from it
                          // throws. Everything that moves tabs needs a context
                          // from underneath.
                          Builder(
                            builder: (context) => AppCard(
                              key: TourKeys.tacticsPlaystyle,
                              // Across to the instructions tab rather than up
                              // in a sheet: it is the next tab along, and a
                              // sheet over a screen that is already there reads
                              // as two different places for one decision.
                              onTap: () =>
                                  DefaultTabController.of(context).animateTo(1),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.auto_graph_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          playstyleLabel(l, tactic.playstyle),
                                          style: AppTypography.titleMedium,
                                        ),
                                        Text(
                                          playstyleBlurb(l, tactic.playstyle),
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // 2. INSTRUCTIONS — the playstyle and the six dials that trim
                //    it. Half of what a tactic is, and it used to live behind
                //    an icon in the app bar.
                _InstructionsTab(careerId: careerId, tactic: tactic),
                // 3. ROLES & SET PIECES — one row per starter: their job, plus
                //    the penalty and free-kick badges (tap to make them taker).
                //    The armband sits at the top of it: naming a captain is the
                //    same kind of decision as naming a penalty taker — one job,
                //    one man. It used to be an armband button on EVERY row of
                //    the call-up list, twenty-odd of them, which read as a
                //    multiple choice and buried the one name that mattered.
                ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    // The armband can go to a player nursing a knock — he is
                    // still the captain, he just isn't playing — so the squad
                    // offered here is the called-up group, not only the fit.
                    _CaptainCard(
                      careerId: careerId,
                      pool: [...data.pool, ...data.unavailable],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.tacticsRolesSetPiecesBlurb,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      child: SetPieceTakerSummary(
                        penaltyName: data.byId[penaltyId]?.name,
                        penaltyIsAuto: namedPenalty == null,
                        deadBallName: data.byId[deadBallId]?.name,
                        deadBallIsAuto: namedDeadBall == null,
                        // One tap makes the two men already named above the
                        // manager's own choice. The names do not change; what
                        // changes is that they are now his, which is also what
                        // settles the "set-piece takers are not set" strip
                        // before kick-off.
                        onQuickPick: () => ref
                            .read(setPieceTakersStoreProvider)
                            .setBoth(
                              careerId,
                              penalty: penaltyId,
                              deadBall: deadBallId,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final p in xi)
                      _PlayerTacticRow(
                        player: p,
                        role: roles[p.id] ?? PlayerRole.none,
                        isPenaltyTaker: namedPenalty == p.id,
                        isDeadBallTaker: namedDeadBall == p.id,
                        isAutoPenalty:
                            namedPenalty == null && penaltyId == p.id,
                        isAutoDeadBall:
                            namedDeadBall == null && deadBallId == p.id,
                        onRole: () => _pickRole(context, ref, p),
                        onTogglePenalty: () => ref
                            .read(setPieceTakersStoreProvider)
                            .set(
                              careerId,
                              penalty: true,
                              playerId: namedPenalty == p.id ? null : p.id,
                            ),
                        onToggleDeadBall: () => ref
                            .read(setPieceTakersStoreProvider)
                            .set(
                              careerId,
                              penalty: false,
                              playerId: namedDeadBall == p.id ? null : p.id,
                            ),
                      ),
                  ],
                ),
                // 4. SQUAD — the nation's whole pool: every eligible player,
                //    their club, age, form and international record, filterable
                //    and sortable. See [NationSquadTab] for why it is the pool
                //    rather than the bench.
                NationSquadTab(careerId: careerId),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Opens the role picker for [player] — only the roles that suit their
  /// position, plus "No role".
  Future<void> _pickRole(
    BuildContext context,
    WidgetRef ref,
    Player player,
  ) async {
    final options = [
      for (final r in PlayerRole.values)
        if (r == PlayerRole.none ||
            switch (player.category) {
              PositionCategory.forward => r.forForwards,
              PositionCategory.midfielder => r.forMidfielders,
              PositionCategory.defender => r.forDefenders,
              PositionCategory.goalkeeper => false,
            })
          r,
    ];
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<PlayerRole>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      // Scroll-controlled + bounded height so a long role list scrolls INSIDE
      // the sheet instead of overflowing the default half-screen cap and
      // pushing the header/handle off the top (which left it unclosable).
      isScrollControlled: true,
      builder: (_) {
        final maxHeight = MediaQuery.of(context).size.height * 0.7;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A grab handle so the panel reads as a draggable sheet.
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: AppRadii.smAll,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.tacticsRolePlayer(player.name),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    // An explicit close so the sheet is always dismissable even
                    // if the list is long.
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    children: [
                      for (final r in options)
                        ListTile(
                          title: Text(r.label, style: AppTypography.bodyMedium),
                          subtitle: Text(
                            r.blurb,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          onTap: () => Navigator.of(context).pop(r),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (picked != null) {
      await ref
          .read(playerRolesStoreProvider)
          .setRole(careerId, player.id, picked);
    }
  }

  Future<void> _pickPlayer(
    BuildContext context,
    WidgetRef ref,
    TacticData data,
    int slot,
  ) async {
    final position = data.tactic.formation.positions[slot];
    final isKeeperSlot = position.category == PositionCategory.goalkeeper;
    // A goalkeeping slot is keeper-only; any other slot can be filled by any
    // outfield player, carrying the out-of-position penalty shown per row.
    var candidates =
        data.pool
            .where(
              (p) => isKeeperSlot
                  ? p.position.category == PositionCategory.goalkeeper
                  : p.position.category != PositionCategory.goalkeeper,
            )
            .toList()
          ..sort(PositionFit.bySlotFit(position));
    // Nobody available for a keeper slot (both keepers out): fall back to the
    // whole pool rather than a dead-end empty sheet — someone must go in goal.
    if (candidates.isEmpty) {
      candidates = [...data.pool]..sort(PositionFit.bySlotFit(position));
    }

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
              final inXi = data.tactic.lineup.contains(p.id);
              final eff = PositionFit.effectiveOverall(p, position);
              return ListTile(
                dense: true,
                leading: TacticalChip(p.position.label),
                title: Text(
                  p.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: inXi ? AppColors.onSurfaceVariant : null,
                    fontWeight: inXi ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                // Age, and only age — the same row the in-match sheet shows.
                // The row ALREADY says he is out of position twice over: the
                // leading chip names the position he actually plays, and the
                // trailing rating is docked and amber with his real overall in
                // brackets behind it. Naming the position a third time in
                // words made the row shout, and the amber that matters — the
                // number the match is decided on — stopped standing out for
                // being one of three.
                subtitle: Text(
                  l.tacticsAgeOnly(p.age),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inXi) ...[
                      TacticalChip(l.tacticsInXi),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    // The rating in THIS slot leads — the number the match
                    // engine uses — in amber when it is docked, with the
                    // player's own overall behind it for the comparison.
                    Text(
                      '$eff',
                      style: AppTypography.labelMedium.copyWith(
                        color: eff < p.overall ? AppColors.warning : null,
                      ),
                    ),
                    if (eff < p.overall)
                      Text(
                        ' (${p.overall})',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () => context.push(
                        '${Routes.player}?careerId=$careerId&playerId=${p.id}',
                      ),
                    ),
                  ],
                ),
                selected: inXi,
                selectedTileColor: AppColors.surfaceContainerHigh,
                onTap: () => Navigator.of(context).pop(p.id),
              );
            }(),
        ],
      ),
    );
    if (picked != null) {
      await ref.read(tacticServiceProvider).setSlot(careerId, slot, picked);
    }
  }

  /// Handles a pitch drag from slot [a] onto slot [b] by persisting the
  /// resolved swap or reshape.
  void _dragBetweenSlots(TacticService service, Tactic tactic, int a, int b) {
    switch (resolveDrag(tactic.formation, a, b)) {
      case SwapSlots():
        unawaited(service.swapSlots(careerId, a, b));
      case ReshapeTo(:final formation):
        unawaited(service.reshapeFormation(careerId, formation));
    }
  }

  Future<void> _openPresets(
    BuildContext context,
    WidgetRef ref,
    Tactic tactic,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _PresetsSheet(careerId: careerId, tactic: tactic),
    );
  }
}

/// The manager-facing name of a playing style.
String playstyleLabel(AppLocalizations l, Playstyle s) => switch (s) {
  Playstyle.custom => l.playstyleCustom,
  Playstyle.balanced => l.playstyleBalanced,
  Playstyle.possession => l.playstylePossession,
  Playstyle.gegenpress => l.playstyleGegenpress,
  Playstyle.counter => l.playstyleCounter,
  Playstyle.direct => l.playstyleDirect,
  Playstyle.lowBlock => l.playstyleLowBlock,
  Playstyle.wingPlay => l.playstyleWingPlay,
};

/// One line on what a style actually asks the side to do.
String playstyleBlurb(AppLocalizations l, Playstyle s) => switch (s) {
  Playstyle.custom => l.tacticsPlaystyleCustom,
  Playstyle.balanced => l.playstyleBalancedBlurb,
  Playstyle.possession => l.playstylePossessionBlurb,
  Playstyle.gegenpress => l.playstyleGegenpressBlurb,
  Playstyle.counter => l.playstyleCounterBlurb,
  Playstyle.direct => l.playstyleDirectBlurb,
  Playstyle.lowBlock => l.playstyleLowBlockBlurb,
  Playstyle.wingPlay => l.playstyleWingPlayBlurb,
};

/// The side's way of playing: one named style, and the six dials that trim it.
///
/// This was a bottom sheet behind an icon, which is a poor home for half of
/// what a tactic IS — the shape got a whole screen and the instructions got a
/// button most managers never pressed. It is a tab now, beside the lineup.
class _InstructionsTab extends ConsumerStatefulWidget {
  const _InstructionsTab({required this.careerId, required this.tactic});

  final int careerId;
  final Tactic tactic;

  @override
  ConsumerState<_InstructionsTab> createState() => _InstructionsTabState();
}

class _InstructionsTabState extends ConsumerState<_InstructionsTab> {
  late TacticalInstructions _i = widget.tactic.instructions;
  late Playstyle _style = widget.tactic.playstyle;

  @override
  void didUpdateWidget(_InstructionsTab old) {
    super.didUpdateWidget(old);
    // A preset applied from the app bar rewrites the instructions underneath
    // this. As a sheet it was thrown away and rebuilt every time it opened, so
    // it never had to notice; a tab stays alive and would have gone on showing
    // the dials the preset replaced.
    if (widget.tactic.instructions != old.tactic.instructions) {
      setState(() {
        _i = widget.tactic.instructions;
        _style = widget.tactic.playstyle;
      });
    }
  }

  void _set(TacticalInstructions next) {
    setState(() {
      _i = next;
      // Moving a dial re-labels the tactic: it only keeps a style's name while
      // it still matches that style exactly.
      _style = PlaystyleX.matching(next);
    });
    unawaited(
      ref.read(tacticServiceProvider).setInstructions(widget.careerId, next),
    );
  }

  void _setStyle(Playstyle style) {
    final composed = style.instructions;
    if (composed == null) return;
    setState(() {
      _style = style;
      _i = composed;
    });
    unawaited(
      ref.read(tacticServiceProvider).setPlaystyle(widget.careerId, style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        Text(
          l.tacticsTeamInstructions,
          style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.tacticsTeamInstructionsBlurb,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // The style comes first: one decision that sets all six dials below,
        // which are then there to trim it. Managing a side by six unlabelled
        // sliders asked the manager to reverse-engineer a way of playing they
        // could simply have named.
        Text(l.tacticsPlaystyle, style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.tacticsPlaystyleBlurb,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final s in Playstyle.values)
              if (s != Playstyle.custom)
                GestureDetector(
                  onTap: () => _setStyle(s),
                  child: TacticalChip(
                    playstyleLabel(l, s),
                    emphasized: s == _style,
                  ),
                ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _style == Playstyle.custom
              ? l.tacticsPlaystyleCustom
              : playstyleBlurb(l, _style),
          style: AppTypography.labelSmall.copyWith(
            color: _style == Playstyle.custom
                ? AppColors.onSurfaceVariant
                : AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _slider(
          l.tacticsInstrMentality,
          l.tacticsInstrDefensive,
          l.tacticsInstrAttacking,
          _i.mentality,
          (v) => _set(_i.copyWith(mentality: v)),
        ),
        _slider(
          l.tacticsInstrPressing,
          l.tacticsInstrLowBlock,
          l.tacticsInstrHighPress,
          _i.pressing,
          (v) => _set(_i.copyWith(pressing: v)),
        ),
        _slider(
          l.tacticsInstrTempo,
          l.tacticsInstrPatient,
          l.tacticsInstrFast,
          _i.tempo,
          (v) => _set(_i.copyWith(tempo: v)),
        ),
        _slider(
          l.tacticsInstrWidth,
          l.tacticsInstrNarrow,
          l.tacticsInstrWide,
          _i.width,
          (v) => _set(_i.copyWith(width: v)),
        ),
        _slider(
          l.tacticsInstrDefensiveLine,
          l.tacticsInstrDeep,
          l.tacticsInstrHigh,
          _i.defensiveLine,
          (v) => _set(_i.copyWith(defensiveLine: v)),
        ),
        _slider(
          l.tacticsInstrDirectness,
          l.tacticsInstrPossession,
          l.tacticsInstrDirect,
          _i.directness,
          (v) => _set(_i.copyWith(directness: v)),
        ),
      ],
    );
  }

  Widget _slider(
    String label,
    String low,
    String high,
    int value,
    ValueChanged<int> onChanged,
  ) {
    // Each instruction sits in its own spaced-out block so the label, value and
    // end-points don't crowd the neighbouring dials.
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTypography.titleMedium),
              const Spacer(),
              Text(
                '$value',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
            ),
            child: Slider(
              value: value.toDouble(),
              max: 100,
              divisions: 20,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                low,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                high,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Save the current shape + instructions as a named preset, and apply or delete
/// any previously saved preset. Presets are reusable across every save.
class _PresetsSheet extends ConsumerStatefulWidget {
  const _PresetsSheet({required this.careerId, required this.tactic});

  final int careerId;
  final Tactic tactic;

  @override
  ConsumerState<_PresetsSheet> createState() => _PresetsSheetState();
}

class _PresetsSheetState extends ConsumerState<_PresetsSheet> {
  Future<void> _saveCurrent() async {
    // A dialog is the most reliable place to type on top of a bottom sheet —
    // the sheet's own text field kept losing the keyboard.
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _NamePresetDialog(),
    );
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(tacticPresetStoreProvider)
        .save(
          widget.careerId,
          TacticPreset(
            name: name.trim(),
            formation: widget.tactic.formation,
            instructions: widget.tactic.instructions,
          ),
        );
    if (mounted) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.tacticsSavedPreset(name.trim()))),
      );
    }
  }

  Future<void> _apply(TacticPreset preset) async {
    await ref
        .read(tacticServiceProvider)
        .applyPreset(
          widget.careerId,
          preset.formation,
          preset.instructions,
        );
    if (mounted) {
      final l = AppLocalizations.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.tacticsAppliedPreset(preset.name))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final presetsAsync = ref.watch(tacticPresetsProvider(widget.careerId));
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadii.smAll,
                ),
              ),
            ),
            Text(
              l.tacticsTacticPresets,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.tacticsPresetsBlurb,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveCurrent,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.tacticsSaveCurrentTactic),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: presetsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Text(l.tacticsCouldNotLoadPresets(e.toString())),
                data: (presets) {
                  if (presets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Text(
                        l.tacticsNoPresetsYet,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: presets.length,
                    itemBuilder: (context, i) {
                      final p = presets[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.bookmark,
                          color: AppColors.primary,
                        ),
                        title: Text(p.name, style: AppTypography.bodyMedium),
                        subtitle: Text(
                          p.formation.label,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.onSurfaceVariant,
                          ),
                          onPressed: () => ref
                              .read(tacticPresetStoreProvider)
                              .delete(widget.careerId, p.name),
                        ),
                        onTap: () => _apply(p),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small dialog to name a tactic preset — a plain dialog text field is the
/// most reliable place to type over a bottom sheet.
class _NamePresetDialog extends StatefulWidget {
  const _NamePresetDialog();

  @override
  State<_NamePresetDialog> createState() => _NamePresetDialogState();
}

class _NamePresetDialogState extends State<_NamePresetDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.tacticsNameThisTactic),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: l.tacticsNameHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.tacticsCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l.tacticsSave),
        ),
      ],
    );
  }
}

/// The armband, as one decision: who wears it, what it is worth, and a single
/// picker to change it.
///
/// A captain is one man, so this is one row — not a badge repeated down a list
/// of twenty-three call-ups, which is where it used to live and which made a
/// single-choice decision look like a set of toggles.
class _CaptainCard extends ConsumerWidget {
  const _CaptainCard({required this.careerId, required this.pool});

  final int careerId;

  /// The squad the armband can be given to.
  final List<Player> pool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final captain = ref.watch(captainProvider(careerId)).valueOrNull;
    final morale = ref.watch(captainMoraleProvider(careerId)).valueOrNull ?? 0;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        dense: true,
        leading: const Icon(
          Icons.military_tech_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          l.squadCaptain.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          captain == null
              ? l.captainNone
              : morale > 0
              ? '${captain.name} · ${l.captainMoraleBoost(morale)}'
              : captain.name,
          style: AppTypography.bodyMedium,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.onSurfaceVariant,
        ),
        onTap: () => _pick(context, ref, captain?.id),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref, int? current) async {
    final l = AppLocalizations.of(context);
    final career = ref.read(careerByIdProvider(careerId)).valueOrNull;
    final saveSeed = career?.rngSeed ?? 0;
    // Best first — the armband usually goes to a senior name, and the fit tag
    // says who actually carries it.
    final candidates = [...pool]
      ..sort((a, b) => b.overall.compareTo(a.overall));
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l.squadCaptain.toUpperCase(),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final p in candidates)
            ListTile(
              dense: true,
              leading: SizedBox(
                width: 40,
                child: TacticalChip(p.position.label),
              ),
              title: Text(p.name, style: AppTypography.bodyMedium),
              subtitle: Text(
                _fitLabel(l, Captaincy.fit(p, saveSeed: saveSeed)),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              trailing: p.id == current
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : Text('${p.overall}', style: AppTypography.labelMedium),
              // Tapping the current captain takes the armband back off him, so
              // "no captain" needs no row of its own.
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    );
    if (picked == null) return;
    await setCaptain(ref, careerId, picked == current ? null : picked);
  }

  static String _fitLabel(AppLocalizations l, CaptainFit fit) => switch (fit) {
    CaptainFit.born => l.captainFitBorn,
    CaptainFit.natural => l.captainFitNatural,
    CaptainFit.capable => l.captainFitCapable,
    CaptainFit.unproven => l.captainFitUnproven,
  };
}

/// One player's role row in the tactics screen: position, name, and the role
/// they've been given (tap to change).
/// One starter in the merged roles & set-pieces list: their position and name,
/// a tappable role, and penalty / free-kick badges that toggle them as the
/// taker — so a player's whole tactical brief is set in one place.
class _PlayerTacticRow extends StatelessWidget {
  const _PlayerTacticRow({
    required this.player,
    required this.role,
    required this.isPenaltyTaker,
    required this.isDeadBallTaker,
    required this.isAutoPenalty,
    required this.isAutoDeadBall,
    required this.onRole,
    required this.onTogglePenalty,
    required this.onToggleDeadBall,
  });

  final Player player;
  final PlayerRole role;
  final bool isPenaltyTaker;
  final bool isDeadBallTaker;

  /// Nobody has been named and this is the man the engine would pick.
  final bool isAutoPenalty;
  final bool isAutoDeadBall;

  final VoidCallback onRole;
  final VoidCallback onTogglePenalty;
  final VoidCallback onToggleDeadBall;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final assigned = role != PlayerRole.none;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onRole,
              borderRadius: AppRadii.smAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: TacticalChip(player.position.label),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            assigned ? role.label : l.tacticsTapToAssign,
                            style: AppTypography.labelSmall.copyWith(
                              color: assigned
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              fontWeight: assigned
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Technical ability — the quality that matters most for taking
          // penalties and dead balls, so it's on hand while assigning takers.
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.playerAttrTechnical.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
              Text(
                '${player.attributes.technical}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.ratingColor(
                    player.attributes.technical / 10,
                  ),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          SetPieceBadge(
            icon: Icons.sports_soccer,
            active: isPenaltyTaker,
            auto: isAutoPenalty,
            tooltip: l.tacticsPenalties,
            onTap: onTogglePenalty,
          ),
          const SizedBox(width: 6),
          SetPieceBadge(
            icon: Icons.flag_rounded,
            active: isDeadBallTaker,
            auto: isAutoDeadBall,
            tooltip: l.tacticsCornersFreeKicks,
            onTap: onToggleDeadBall,
          ),
        ],
      ),
    );
  }
}
