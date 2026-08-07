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
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Arrange up to three friendlies in the gap before the next competitive block.
/// Pick an opponent for each window (or leave it free); confirming schedules
/// the games and clears the hub's "arrange friendlies" prompt.
class FriendliesScreen extends ConsumerStatefulWidget {
  const FriendliesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<FriendliesScreen> createState() => _FriendliesScreenState();
}

class _FriendliesScreenState extends ConsumerState<FriendliesScreen> {
  // window date → chosen opponent id (absent = no game that window).
  final Map<DateTime, int> _picks = {};
  bool _saving = false;

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
  /// offers a different (already seed-shuffled) set rather than the same list.
  List<Nation> _opponentsFor(List<Nation> pool, int index, int windowCount) {
    if (pool.isEmpty) return pool;
    final per = (pool.length ~/ windowCount).clamp(6, 12);
    final start = (index * per) % pool.length;
    return [for (var k = 0; k < per; k++) pool[(start + k) % pool.length]];
  }

  Future<void> _confirm(FriendliesPlan plan) async {
    setState(() => _saving = true);
    await ref.read(friendliesServiceProvider).arrange(
          widget.careerId,
          nationId: plan.playerNationId,
          cycle: plan.cycle,
          picks: _picks,
          allWindows: plan.windows,
        );
    if (mounted) context.go('${Routes.hub}?careerId=${widget.careerId}');
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  children: [
                    for (var i = 0; i < plan.windows.length; i++)
                      _WindowCard(
                        label: _label(l, plan.windows[i]),
                        home: friendlyIsHome(plan.windows[i]),
                        opponents: _opponentsFor(
                          plan.opponents,
                          i,
                          plan.windows.length,
                        ),
                        selected: _picks[plan.windows[i]],
                        code: (id) => plan.nations[id]?.code ?? '??',
                        name: (id) => plan.nations[id]?.name ?? '—',
                        onPick: (id) => setState(() {
                          final w = plan.windows[i];
                          if (_picks[w] == id) {
                            _picks.remove(w);
                          } else {
                            _picks[w] = id;
                          }
                        }),
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

class _WindowCard extends StatelessWidget {
  const _WindowCard({
    required this.label,
    required this.home,
    required this.opponents,
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
                const Spacer(),
                if (selected != null)
                  Row(
                    children: [
                      FlagDisc(code(selected!), size: 18, highlighted: true),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        name(selected!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    AppLocalizations.of(context).friendliesFree,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
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
    required this.onTap,
  });

  final String code;
  final bool selected;
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
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagDisc(code, size: 16, highlighted: selected),
            const SizedBox(width: 4),
            Text(
              code,
              style: AppTypography.labelSmall.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
