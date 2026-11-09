part of 'managers_screen.dart';

/// The managers on a tablet: the same two tabs under the tablet header; a
/// manager's profile opens as a dialog.
class _ManagersTabletLayout extends StatelessWidget {
  const _ManagersTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: ManagersScreen.tabletLayoutKey,
      title: l.mgrListTitle,
      onBack: () => ManagersScreen.leave(context, careerId),
      child: ManagersBody(careerId: careerId),
    );
  }
}
