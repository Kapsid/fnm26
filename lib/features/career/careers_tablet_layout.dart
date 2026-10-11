part of 'careers_screen.dart';

/// The Career page on a tablet: the phone's menu down the left, the
/// manager's career summary beside it. Every line goes where the phone's
/// does; the summary's link opens its full two-column page.
class _CareersTabletLayout extends StatelessWidget {
  const _CareersTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: CareersScreen.tabletLayoutKey,
      title: l.sideCareer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 340,
            child: Panel(
              title: l.sideGroupHistory,
              expand: true,
              padding: EdgeInsets.zero,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final (i, e) in _careerMenu(l, careerId).indexed) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    _MenuTile(
                      key: e.key,
                      icon: e.icon,
                      title: e.title,
                      subtitle: e.subtitle,
                      onTap: () => context.go(e.location),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Panel(
              title: l.careerSummaryTitle,
              expand: true,
              padding: EdgeInsets.zero,
              action: PanelLink(
                label: l.panelViewAll,
                onTap: () => context.go(
                  '${Routes.careerSummary}?careerId=$careerId',
                ),
              ),
              child: CareerSummaryView(
                careerId: careerId,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
