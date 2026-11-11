part of 'manager_detail_screen.dart';

/// A manager's page on a tablet, pushed over the screen he was picked from,
/// as the player's page is: the phone's header card over the Overview blocks
/// on the left, and on the right his record against you over his career,
/// spell by spell. Both are short enough to sit together, so the tablet
/// needs no tabs. The same sections the phone puts in tabs ([_sections]).
class _ManagerDetailTabletLayout extends StatelessWidget {
  const _ManagerDetailTabletLayout({
    required this.careerId,
    required this.managerId,
  });

  final int careerId;
  final int managerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: ManagerDetailScreen.tabletLayoutKey,
      title: l.mgrRowLabel,
      onBack: () => ManagerDetailScreen.leave(context, careerId),
      child: _ManagerDetailBody(
        careerId: careerId,
        managerId: managerId,
        builder: (context, s) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ListView(
                key: ManagerDetailScreen.profileKey,
                children: [
                  s.header,
                  ..._spaced(s.overview),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 6,
              child: ListView(
                children: [
                  ...s.vsYou,
                  ..._spaced(s.career),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
