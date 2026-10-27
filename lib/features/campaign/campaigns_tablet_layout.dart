part of 'campaigns_screen.dart';

/// The campaigns on a landscape tablet: the phone's list under the tablet
/// header. The list lays its tiles out in as many columns as fit.
class _CampaignsTabletLayout extends StatelessWidget {
  const _CampaignsTabletLayout({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: CampaignsScreen.tabletLayoutKey,
      title: l.campaignsTitle,
      onBack: () => context.go(Routes.home),
      child: body,
    );
  }
}
