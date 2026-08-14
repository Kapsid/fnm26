import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Country selection — pick the national team to manage.
///
/// Free-demo nations are selectable; the rest are gated behind the premium
/// unlock (a placeholder until the paywall lands in M7).
class NationSelectScreen extends ConsumerWidget {
  const NationSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nationsAsync = ref.watch(nationsProvider);
    final stars = ref.watch(starPlayersProvider).valueOrNull ?? const {};
    final selectedConf = ref.watch(selectedConfederationProvider);
    final query = ref.watch(nationSearchProvider).trim().toLowerCase();
    final premium = ref.watch(premiumUnlockedProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
        ),
        title: Text(
          l.nationsSelectTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
      body: Column(
        children: [
          _Header(
            query: query,
            onSearch: (v) => ref.read(nationSearchProvider.notifier).state = v,
          ),
          // Two ways into a save that are not "scroll to the country you were
          // always going to pick": let the draw choose, or take whatever job an
          // out-of-work manager can get.
          _StartModes(
            onRandom: () => _startRandom(
              context,
              nationsAsync.valueOrNull,
              premium: premium,
            ),
            onBottom: () => context.go(Routes.startFromBottom),
          ),
          _ConfederationTabs(
            selected: selectedConf,
            onSelect: (c) =>
                ref.read(selectedConfederationProvider.notifier).state = c,
          ),
          Expanded(
            child: nationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  l.nationsCouldNotLoadNations(e.toString()),
                  textAlign: TextAlign.center,
                ),
              ),
              data: (nations) {
                // With a search query, look across every confederation (so a
                // nation is findable from any tab); otherwise show the selected
                // confederation.
                final filtered = nations
                    .where(
                      (n) => query.isEmpty
                          ? n.confederation == selectedConf
                          : n.name.toLowerCase().contains(query),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return Center(child: Text(l.nationsNoMatch));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    AppSpacing.sm,
                    AppSpacing.marginMobile,
                    AppSpacing.xl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm + 4),
                  itemBuilder: (context, i) {
                    final nation = filtered[i];
                    final selectable = nationSelectable(
                      nation,
                      premiumUnlocked: premium,
                    );
                    return _NationCard(
                      nation: nation,
                      star: stars[nation.id],
                      locked: !selectable,
                      onSelect: () =>
                          _onSelect(context, nation, selectable: selectable),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Picks a nation at random from everything this player may manage and goes
  /// straight to naming the manager.
  void _startRandom(
    BuildContext context,
    List<Nation>? nations, {
    required bool premium,
  }) {
    final pool = [
      for (final n in nations ?? const <Nation>[])
        if (nationSelectable(n, premiumUnlocked: premium)) n,
    ];
    if (pool.isEmpty) return;
    final pick = pool[Random().nextInt(pool.length)];
    context.go('${Routes.newGame}?nationId=${pick.id}');
  }

  void _onSelect(
    BuildContext context,
    Nation nation, {
    required bool selectable,
  }) {
    if (selectable) {
      context.go('${Routes.newGame}?nationId=${nation.id}');
    } else {
      // A locked nation opens the paywall; if the unlock completes, the card
      // rebuilds unlocked and the player selects it normally.
      unawaited(showPaywall(context));
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.query, required this.onSearch});

  final String query;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.nationsNationalLevel,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.nationsSelectHeading,
            style: AppTypography.headlineLargeMobile,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            onChanged: onSearch,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: l.nationsSearchHint,
              prefixIcon: const Icon(Icons.search, color: AppColors.outline),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfederationTabs extends StatelessWidget {
  const _ConfederationTabs({required this.selected, required this.onSelect});

  final Confederation selected;
  final ValueChanged<Confederation> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.marginMobile,
        ),
        itemCount: Confederation.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final conf = Confederation.values[i];
          final active = conf == selected;
          return GestureDetector(
            onTap: () => onSelect(conf),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceContainer,
                borderRadius: AppRadii.xlAll,
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.outlineVariant,
                ),
              ),
              child: Text(
                conf.label.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: active
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The two "don't pick for yourself" ways to start a career, as a pair of
/// buttons above the country list.
class _StartModes extends StatelessWidget {
  const _StartModes({required this.onRandom, required this.onBottom});

  final VoidCallback onRandom;
  final VoidCallback onBottom;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        0,
        AppSpacing.marginMobile,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              icon: Icons.casino_outlined,
              label: l.nationsRandomTeam,
              onTap: onRandom,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ModeButton(
              icon: Icons.trending_down_rounded,
              label: l.nationsFromTheBottom,
              onTap: onBottom,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmall,
    ),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      minimumSize: const Size.fromHeight(40),
    ),
  );
}

class _NationCard extends StatelessWidget {
  const _NationCard({
    required this.nation,
    required this.star,
    required this.locked,
    required this.onSelect,
  });

  final Nation nation;
  final Player? star;
  final bool locked;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: AppRadii.mdAll,
        boxShadow: [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Brushed gradient surface with a uniform 1px edge.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceContainerHigh,
                    AppColors.surfaceContainerLow,
                  ],
                ),
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.surfaceContainerHighest),
                ),
              ),
            ),
          ),
          // Left "active" accent bar for free-demo nations.
          if (nation.isFreeDemo)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: 4,
                child: ColoredBox(color: AppColors.primary),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm + 4),
            child: Row(
              children: [
                FlagDisc(nation.code, size: 60, highlighted: nation.isFreeDemo),
                const SizedBox(width: AppSpacing.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nation.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.outline,
                          ),
                          children: [
                            TextSpan(text: l.nationsRank),
                            TextSpan(
                              text: '#${nation.ranking}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SelectButton(locked: locked, onTap: onSelect),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  const _SelectButton({required this.locked, required this.onTap});

  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (locked) {
      return OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
          side: const BorderSide(color: AppColors.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.baseAll),
        ),
        icon: const Icon(Icons.lock, size: 16),
        label: Text(l.nationsPremium, style: AppTypography.labelSmall),
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.baseAll,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.baseAll,
            border: Border.all(color: AppColors.primaryFixed),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryFixed, AppColors.outline],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.nationsSelect,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.sports_soccer,
                label: l.nationsNavCareer,
                onTap: () => context.go(Routes.home),
              ),
              _NavItem(
                icon: Icons.dashboard_customize,
                label: l.nationsNavTactics,
              ),
              _NavItem(
                icon: Icons.public,
                label: l.nationsNavNations,
                active: true,
              ),
              _NavItem(icon: Icons.settings, label: l.nationsNavSettings),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.onSecondaryContainer
        : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xlAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: AppRadii.xlAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
