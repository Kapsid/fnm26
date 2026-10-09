import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
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
                    _Item(
                      key: ValueKey(
                        d.id == active
                            ? 'sidebar.${d.id.name}.active'
                            : 'sidebar.${d.id.name}',
                      ),
                      icon: d.icon,
                      label: shellDestinationLabel(l, d.id),
                      active: d.id == active,
                      onTap: () => context.go(d.location(careerId)),
                    ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: _Item(
              icon: Icons.settings_outlined,
              label: l.homeSettings,
              active: false,
              // Pushed, as from the hub, so its back arrow returns here.
              onTap: () => context.push(Routes.settings),
            ),
          ),
        ],
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
    super.key,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.onSurface : AppColors.onSurfaceVariant;
    return Material(
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
