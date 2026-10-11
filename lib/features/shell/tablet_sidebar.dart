import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/current_competition.dart';
import 'package:fnm/features/shell/shell_destinations.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:go_router/go_router.dart';

/// The tablet's left-hand navigation: every area of the game, grouped the way
/// a desktop manager game groups them, one tap apart.
class TabletSidebar extends StatelessWidget {
  const TabletSidebar({
    required this.careerId,
    required this.location,
    super.key,
  });

  static const double width = 208;

  /// The bottom item that leaves for the main menu.
  static const Key mainMenuKey = ValueKey('sidebar.mainMenu');

  /// The quick link to the competition the nation is in right now.
  static const Key currentCompetitionKey = ValueKey('sidebar.current');

  final int careerId;
  final Uri location;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final active = activeDestination(location);
    return Container(
      width: width,
      color: AppColors.surfaceContainerLowest,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md - 4,
              ),
              children: [
                for (final section in ShellSection.values) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: Text(
                      shellSectionTitle(l, section).toUpperCase(),
                      style: TabletText.sectionLabel,
                    ),
                  ),
                  for (final d in shellDestinations.where(
                    (d) => d.section == section,
                  ))
                    // A stable slot around the item: its own key changes with
                    // the active state, and the tour's GlobalKey must move
                    // between the old and new item under one updating parent.
                    KeyedSubtree(
                      key: ValueKey('sidebar.slot.${d.id.name}'),
                      child: _Item(
                        key: ValueKey(
                          d.id == active
                              ? 'sidebar.${d.id.name}.active'
                              : 'sidebar.${d.id.name}',
                        ),
                        icon: d.icon,
                        label: shellDestinationLabel(l, d.id),
                        active: d.id == active,
                        // The tour's Squad step points here on a tablet, where
                        // the phone's Squad tab does not exist.
                        tourKey: d.id == ShellDestinationId.squad
                            ? TourKeys.squadTab
                            : null,
                        onTap: () => context.go(d.location(careerId)),
                      ),
                    ),
                  if (section == ShellSection.competitions)
                    _CurrentCompetition(careerId: careerId),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                _Item(
                  icon: Icons.settings_outlined,
                  label: l.homeSettings,
                  active: false,
                  // Pushed, as from the hub, so its back arrow returns here.
                  onTap: () => context.push(Routes.settings),
                ),
                // The way out of the career, as the phone hub's back arrow:
                // gone to, not pushed, so nothing of the shell stays behind.
                _Item(
                  key: mainMenuKey,
                  icon: Icons.home_outlined,
                  label: l.sideMainMenu,
                  active: false,
                  onTap: () => context.go(Routes.home),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The competition of the nation's next fixture, as a tinted pill under the
/// competition items: a quick link, not another section. Absent when there is
/// no such competition (a friendly next, the cycle over).
class _CurrentCompetition extends ConsumerWidget {
  const _CurrentCompetition({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentCompetitionProvider(careerId)).valueOrNull;
    if (current == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Material(
        key: TabletSidebar.currentCompetitionKey,
        color: AppColors.primaryContainer.withValues(alpha: 0.16),
        shape: StadiumBorder(
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => context.go(current.location),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minHitArea - 8,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: AppColors.medalGold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      competitionLabel(l, current.name),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TabletText.navItem.copyWith(
                        color: AppColors.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.tourKey,
    super.key,
  });

  final GlobalKey? tourKey;
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.onSurface : AppColors.onSurfaceVariant;
    return Material(
      key: tourKey,
      color: active ? AppColors.surfaceContainerHighest : Colors.transparent,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        borderRadius: AppRadii.baseAll,
        onTap: onTap,
        child: SizedBox(
          height: AppSpacing.minHitArea - 8,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.navItem.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
