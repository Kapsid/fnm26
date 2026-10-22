part of 'campaigns_screen.dart';

/// The campaigns on a landscape tablet: the phone's cards side by side under
/// the tablet header, the same card and the same actions.
class _CampaignsTabletLayout extends StatelessWidget {
  const _CampaignsTabletLayout();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: CampaignsScreen.tabletLayoutKey,
      title: l.campaignsTitle,
      onBack: () => context.go(Routes.home),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = AppSpacing.md;
          final width = (constraints.maxWidth - gap) / 2;
          return SingleChildScrollView(
            child: Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final def in Campaigns.all)
                  SizedBox(width: width, child: CampaignCard(def: def)),
              ],
            ),
          );
        },
      ),
    );
  }
}
