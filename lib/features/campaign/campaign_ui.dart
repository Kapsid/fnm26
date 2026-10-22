import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The words a campaign wears on screen. The registry is pure domain and
/// speaks no language, so the title, twist, intro, goal and the three star
/// conditions are looked up here by campaign id.
typedef CampaignWords = ({
  String title,
  String twist,
  String intro,
  String goal,
  List<String> stars,
});

CampaignWords campaignWords(AppLocalizations l, CampaignDef def) =>
    switch (def.id) {
      'grudge' => (
        title: l.campaignGrudgeTitle,
        twist: l.campaignGrudgeTwist,
        intro: l.campaignGrudgeIntro,
        goal: l.campaignGrudgeGoal,
        stars: [
          l.campaignStars1Grudge,
          l.campaignStars2Grudge,
          l.campaignStars3Grudge,
        ],
      ),
      'guineas' => (
        title: l.campaignGuineasTitle,
        twist: l.campaignGuineasTwist,
        intro: l.campaignGuineasIntro,
        goal: l.campaignGuineasGoal,
        stars: [
          l.campaignStars1Guineas,
          l.campaignStars2Guineas,
          l.campaignStars3Guineas,
        ],
      ),
      'youngFinns' => (
        title: l.campaignYoungFinnsTitle,
        twist: l.campaignYoungFinnsTwist,
        intro: l.campaignYoungFinnsIntro,
        goal: l.campaignYoungFinnsGoal,
        stars: [
          l.campaignStars1YoungFinns,
          l.campaignStars2YoungFinns,
          l.campaignStars3YoungFinns,
        ],
      ),
      _ => (
        title: l.campaignTransplantTitle,
        twist: l.campaignTransplantTwist,
        intro: l.campaignTransplantIntro,
        goal: l.campaignTransplantGoal,
        stars: [
          l.campaignStars1Transplant,
          l.campaignStars2Transplant,
          l.campaignStars3Transplant,
        ],
      ),
    };

/// Whether starting [def] must open the paywall instead: a Pro campaign, and
/// a manager without Pro. The run would be refused below the UI anyway (see
/// `CampaignService.start`); this is where he is offered the way in.
bool campaignNeedsPaywall(WidgetRef ref, CampaignDef def) =>
    def.needsPro && !ref.read(premiumUnlockedProvider);

/// A campaign's difficulty badge: its label and colour, both read from
/// [CampaignDef.difficulty] so the two can never disagree.
({String label, Color color}) campaignDifficulty(
  AppLocalizations l,
  CampaignDef def,
) => switch (def.difficulty) {
  CampaignDifficulty.hard => (
    label: l.campaignDifficultyHard,
    color: AppColors.warning,
  ),
  CampaignDifficulty.medium => (
    label: l.campaignDifficultyMedium,
    color: AppColors.primary,
  ),
};

/// Asks, in the app, before a run is thrown away. True when confirmed.
Future<bool> confirmAbandonCampaign(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    // Popped with the dialog's own context: on a tablet it is a root dialog.
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surfaceContainer,
      title: Text(l.campaignAbandon),
      content: Text(l.campaignAbandonConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l.careerCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l.campaignAbandon),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// A 1-based group place as the manager reads it ("3rd"). The arb's select
/// picks the wording for the first three; the rest carry the number.
String campaignPlaceText(AppLocalizations l, int place) => l.campaignPlace(
  switch (place) {
    1 => 'first',
    2 => 'second',
    3 => 'third',
    _ => 'other',
  },
  place,
);
