import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'friendlies_tablet_layout.dart';

/// Arrange up to three friendlies in the gap before the next competitive block.
/// Pick an opponent for each window (or leave it free); confirming schedules
/// the games and clears the hub's "arrange friendlies" prompt.
class FriendliesScreen extends ConsumerStatefulWidget {
  const FriendliesScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('friendlies.tabletLayout');
  static const Key confirmKey = Key('friendlies.confirm');

  @override
  ConsumerState<FriendliesScreen> createState() => _FriendliesScreenState();
}

class _FriendliesScreenState extends ConsumerState<FriendliesScreen> {
  // window date → chosen opponent id (absent = no game that window).
  final Map<DateTime, int> _picks = {};
  bool _saving = false;

  /// Picks [nationId] for [window], or clears it when he is already the
  /// pick: a second tap on the same side leaves the window free.
  void _pick(DateTime window, int nationId) => setState(() {
    if (_picks[window] == nationId) {
      _picks.remove(window);
    } else {
      _picks[window] = nationId;
    }
  });

  Future<void> _confirm(FriendliesPlan plan) async {
    // A second tap landing before the button has redrawn disabled would
    // book every pick twice.
    if (_saving) return;
    setState(() => _saving = true);
    // Taken before the await: on a tablet the sidebar is always there, and
    // a resize swaps the layout under this State; the games are saved
    // whatever happens, and only a manager still on this page is taken on
    // to the hub. `router.state` is the top-most route, pushed ones too.
    final router = GoRouter.of(context);
    final careerId = widget.careerId;
    final service = ref.read(friendliesServiceProvider);
    try {
      await service.arrange(
        careerId,
        nationId: plan.playerNationId,
        cycle: plan.cycle,
        picks: _picks,
        allWindows: plan.windows,
      );
      if (router.state.uri.path == Routes.friendlies) {
        router.go('${Routes.hub}?careerId=$careerId');
      }
    } finally {
      // A write that fails leaves Confirm working, so he can try again.
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On a tablet the top bar's Continue runs the sim while this page is on
    // show, and the step refreshes the plan: a window the calendar has moved
    // past drops out of it. Its pick goes with it, before Confirm can book a
    // game on a date already gone. No rebuild is asked for: both layouts
    // watch the plan, so the change that called this redraws them.
    ref.listen(friendliesPlanProvider(widget.careerId), (_, next) {
      if (next.isLoading || next.hasError) return;
      final windows = next.requireValue?.windows ?? const <DateTime>[];
      _picks.removeWhere((window, _) => !windows.contains(window));
    });
    if (TabletShellScope.isActive(context)) {
      return _FriendliesTabletLayout(state: this);
    }
    final async = ref.watch(friendliesPlanProvider(widget.careerId));
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.friendliesTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.friendliesLoadError(e.toString()))),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: l.friendliesContinue,
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=${widget.careerId}'),
                ),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Text(
                  l.friendliesArrangeIntro(plan.windows.length),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              // Always says WHY these names are at the top — see [_reasonFor].
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  0,
                  AppSpacing.marginMobile,
                  AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        _reasonFor(l, plan),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
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
                    for (final (i, offered) in [
                      for (var i = 0; i < plan.windows.length; i++)
                        (
                          i,
                          _opponentsFor(plan.opponents, i, plan.windows.length),
                        ),
                    ])
                      _WindowCard(
                        label: _label(l, plan.windows[i]),
                        home: friendlyIsHome(plan.windows[i]),
                        opponents: offered,
                        // The head of this window's own deal: the sides the
                        // line above is talking about.
                        marked: offered
                            .take(_markedPerWindow)
                            .map((n) => n.id)
                            .toSet(),
                        selected: _picks[plan.windows[i]],
                        code: (id) => plan.nations[id]?.code ?? '??',
                        name: (id) => plan.nations[id]?.name ?? '—',
                        onPick: (id) => _pick(plan.windows[i], id),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: _picks.isEmpty
                        ? l.friendliesNoneThisWindow
                        : l.friendliesConfirmCount(_picks.length),
                    icon: Icons.check_rounded,
                    onPressed: _saving ? null : () => unawaited(_confirm(plan)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _monthAbbr(AppLocalizations l, int m) {
  switch (m) {
    case 1:
      return l.friendliesMonthJan;
    case 2:
      return l.friendliesMonthFeb;
    case 3:
      return l.friendliesMonthMar;
    case 4:
      return l.friendliesMonthApr;
    case 5:
      return l.friendliesMonthMay;
    case 6:
      return l.friendliesMonthJun;
    case 7:
      return l.friendliesMonthJul;
    case 8:
      return l.friendliesMonthAug;
    case 9:
      return l.friendliesMonthSep;
    case 10:
      return l.friendliesMonthOct;
    case 11:
      return l.friendliesMonthNov;
    default:
      return l.friendliesMonthDec;
  }
}

String _label(AppLocalizations l, DateTime d) =>
    '${_monthAbbr(l, d.month)} ${d.year}';

/// A distinct block of suggested opponents for window [index], so each window
/// offers a different set rather than the same list.
///
/// DEALT round-robin, not sliced. The pool is ordered by how closely a side
/// resembles who the manager is preparing for, and handing window 0 the first
/// block gave it every good suggestion and left the later windows the tail —
/// so the shortlist only meant anything for the first game. Dealing one card
/// at a time round the table gives every window a share off the top.
List<Nation> _opponentsFor(List<Nation> pool, int index, int windowCount) {
  if (pool.isEmpty) return pool;
  final per = (pool.length ~/ windowCount).clamp(6, 12);
  return [
    for (var k = 0; k < per; k++) pool[(k * windowCount + index) % pool.length],
  ];
}

/// How many of a window's opponents carry the recommended mark. The list is
/// dealt best-first, so these are the closest matches for that window.
const int _markedPerWindow = 3;

/// What the mark on those chips MEANS. A shortlist reordered silently is just
/// a different shortlist, and "suggested first" was the whole of the hint —
/// which told the manager nothing he could see, because the chips were all
/// drawn identically and he had no way of knowing where "first" ended. The
/// line now names what is marked, and the marks are on the chips.
String _reasonFor(AppLocalizations l, FriendliesPlan plan) {
  final names = plan.rivals.map((n) => n.name).join(', ');
  return switch (plan.reason) {
    FriendlyReason.finalsGroup => l.friendliesLikeYourGroup(names),
    FriendlyReason.qualifyingGroup => l.friendliesLikeYourCampaign(names),
    FriendlyReason.ranking => l.friendliesCloseToYou,
  };
}

class _WindowCard extends StatelessWidget {
  const _WindowCard({
    required this.label,
    required this.home,
    required this.opponents,
    required this.marked,
    required this.selected,
    required this.code,
    required this.name,
    required this.onPick,
  });

  final String label;

  /// Whether the manager's side hosts this window's game — fixed by the window,
  /// so it's worth showing before an opponent is picked (it decides whether the
  /// home advantage is yours or theirs).
  final bool home;
  final List<Nation> opponents;

  /// The opponents the hint at the top of the screen is recommending, drawn
  /// with the same lightbulb it carries so the two read as one thing.
  final Set<int> marked;
  final int? selected;
  final String Function(int) code;
  final String Function(int) name;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label, style: AppTypography.labelMedium),
                const SizedBox(width: AppSpacing.sm),
                _VenueBadge(home: home),
                // The picked side's name gives way (ellipsis) rather than
                // running off the card: a long name, a narrow column or a
                // larger text size all used to overflow here.
                if (selected != null)
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlagDisc(
                            code(selected!),
                            size: 18,
                            highlighted: true,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              name(selected!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context).friendliesFree,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final o in opponents)
                  _OppChip(
                    code: code(o.id),
                    selected: selected == o.id,
                    recommended: marked.contains(o.id),
                    onTap: () => onPick(o.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A small HOME / AWAY badge for a friendly window, so the manager can see who
/// hosts before committing to an opponent.
class _VenueBadge extends StatelessWidget {
  const _VenueBadge({required this.home});

  final bool home;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = home ? AppColors.primary : AppColors.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            home ? Icons.home_rounded : Icons.flight_takeoff_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            home ? l.friendliesHome : l.friendliesAway,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _OppChip extends StatelessWidget {
  const _OppChip({
    required this.code,
    required this.selected,
    required this.recommended,
    required this.onTap,
  });

  final String code;
  final bool selected;

  /// One of the sides the hint at the top is pointing at.
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryContainer
              : recommended
              ? AppColors.primary.withValues(alpha: 0.10)
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : recommended
                ? AppColors.primary.withValues(alpha: 0.55)
                : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagDisc(code, size: 16, highlighted: selected || recommended),
            const SizedBox(width: 4),
            Text(
              code,
              style: AppTypography.labelSmall.copyWith(
                color: selected || recommended
                    ? AppColors.primary
                    : AppColors.onSurface,
                fontWeight: selected || recommended
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
            if (recommended && !selected) ...[
              const SizedBox(width: 3),
              const Icon(
                Icons.lightbulb_outline_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
