part of 'manager_detail_screen.dart';

/// A manager's page on a tablet, pushed over the screen he was picked from,
/// as the player's page is: who he is (the headline card, his record, you
/// and him) on the left, his career spell by spell on the right. The same
/// sections the phone stacks in one column ([_sections]).
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
        builder: (context, sections) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ListView(
                key: ManagerDetailScreen.profileKey,
                children: sections.profile,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 6,
              child: ListView(
                // The career heading's top gap is for the one column; side
                // by side it would sit lower than the card beside it.
                children: sections.career.skip(1).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
