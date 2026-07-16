import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

/// The primary destinations reachable from the persistent bottom navigation.
enum AppTab { hub, squad, competitions, careers }

/// The app's persistent bottom navigation bar, shared across the primary
/// destinations so the four core areas are always one tap apart.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.careerId,
    required this.current,
    super.key,
  });

  final int careerId;
  final AppTab current;

  void _go(BuildContext context, String route) {
    context.go('$route?careerId=$careerId');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHighest,
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
                icon: Icons.grid_view,
                label: 'Hub',
                active: current == AppTab.hub,
                onTap: () => _go(context, Routes.hub),
              ),
              _NavItem(
                icon: Icons.groups,
                label: 'Squad',
                active: current == AppTab.squad,
                onTap: () => _go(context, Routes.tactics),
              ),
              _NavItem(
                icon: Icons.emoji_events,
                label: 'Trophy',
                active: current == AppTab.competitions,
                onTap: () => _go(context, Routes.tournaments),
              ),
              _NavItem(
                icon: Icons.account_circle,
                label: 'Careers',
                active: current == AppTab.careers,
                onTap: () => _go(context, Routes.careers),
              ),
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
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppColors.onSecondaryContainer : AppColors.onSurfaceVariant;
    return InkWell(
      // The active tab is already here — tapping it is a no-op.
      onTap: active ? null : onTap,
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
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
