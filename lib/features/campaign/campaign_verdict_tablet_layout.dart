part of 'campaign_verdict_screen.dart';

/// The verdict on a landscape tablet: the stamp beside the run in numbers,
/// Continue under both. An event page, so no back arrow.
class _CampaignVerdictTabletLayout extends StatelessWidget {
  const _CampaignVerdictTabletLayout({
    required this.title,
    required this.verdict,
    required this.numbers,
    required this.action,
  });

  final String title;
  final Widget verdict;
  final Widget numbers;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return TabletPage(
      scaffoldKey: CampaignVerdictScreen.tabletLayoutKey,
      title: title,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SingleChildScrollView(child: verdict)),
                const SizedBox(width: AppSpacing.xl),
                Expanded(child: SingleChildScrollView(child: numbers)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: action,
            ),
          ),
        ],
      ),
    );
  }
}
