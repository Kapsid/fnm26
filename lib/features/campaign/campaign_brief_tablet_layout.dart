part of 'campaign_brief_screen.dart';

/// The brief on a landscape tablet: the story on the left, the name and the
/// actions on the right. Both halves are the phone's own.
class _CampaignBriefTabletLayout extends StatelessWidget {
  const _CampaignBriefTabletLayout({required this.story, required this.form});

  final Widget story;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: CampaignBriefScreen.tabletLayoutKey,
      title: l.campaignsTitle,
      onBack: () => context.go(Routes.campaigns),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: SingleChildScrollView(child: story)),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: form,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
