import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/campaign/campaign_brief_sheet.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The hub card of a campaign career: the goal, and where the run stands
/// against it. Qualifying place first, the rival's place under it for a
/// Grudge, then how far the finals have got. A campaign of rivals to beat
/// lists each rival with a tick once beaten, and its continental
/// championship cycle by cycle. Nothing at all (not even a gap) for a normal
/// career, so its hub is untouched.
///
/// Folded by default to one row (the title and the one line that matters
/// now); a tap anywhere on that row opens the goal and every progress line.
/// The choice is kept per campaign on the device. An info button beside the
/// fold opens the campaign's full brief, read only (see
/// [showCampaignBriefSheet]). Plain rows with an
/// intrinsic height, so it can sit in a tablet dashboard tile as well as in
/// the phone's column.
class CampaignHubCard extends ConsumerStatefulWidget {
  const CampaignHubCard({
    required this.careerId,
    this.gapAbove = false,
    super.key,
  });

  final int careerId;

  /// Adds the phone column's spacing above the card, only when it shows.
  final bool gapAbove;

  static const Key cardKey = Key('campaign.hubCard');
  static const Key qualifyingKey = Key('campaign.hubCard.qualifying');
  static const Key rivalKey = Key('campaign.hubCard.rival');
  static const Key headerKey = Key('campaign.hubCard.header');
  static const Key summaryKey = Key('campaign.hubCard.summary');
  static const Key finalsKey = Key('campaign.hubCard.finals');

  /// Opens the campaign's full brief (see [showCampaignBriefSheet]).
  static const Key briefKey = Key('campaign.hubCard.brief');

  /// The row of one rival to beat, ticked once beaten.
  static Key rivalToBeatKey(int nationId) =>
      Key('campaign.hubCard.rivalToBeat.$nationId');

  /// The continental championship of one cycle (0-based).
  static Key cupCycleKey(int cycle) => Key('campaign.hubCard.cup.$cycle');

  /// One cycle's World Championship line, for a goal that reads it.
  static Key worldCycleKey(int cycle) => Key('campaign.hubCard.world.$cycle');

  /// The Nations Cup line, for a goal that reads it.
  static const Key nationsCupKey = Key('campaign.hubCard.nationsCup');

  /// Prefs key of one campaign's open/closed choice (outside the save).
  static String prefsKey(String campaignId) =>
      'campaign_card_open_v1:$campaignId';

  @override
  ConsumerState<CampaignHubCard> createState() => _CampaignHubCardState();
}

class _CampaignHubCardState extends ConsumerState<CampaignHubCard> {
  bool _open = false;
  bool _touched = false;
  String? _loadedFor;

  Future<void> _load(String id) async {
    _loadedFor = id;
    try {
      final prefs = await SharedPreferences.getInstance();
      final open = prefs.getBool(CampaignHubCard.prefsKey(id)) ?? false;
      if (mounted && !_touched && open != _open) setState(() => _open = open);
    } on Object {
      // Closed stays the default when prefs are unavailable.
    }
  }

  Future<void> _toggle(String id) async {
    setState(() {
      _touched = true;
      _open = !_open;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CampaignHubCard.prefsKey(id), _open);
    } on Object {
      // Not remembered this time.
    }
  }

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final gapAbove = widget.gapAbove;
    final progress = ref.watch(campaignProgressProvider(careerId)).valueOrNull;
    if (progress == null) return const SizedBox.shrink();
    if (_loadedFor != progress.def.id) unawaited(_load(progress.def.id));
    final l = AppLocalizations.of(context);
    final words = campaignWords(l, progress.def);
    final rivalId = progress.def.rivalNationId;
    final rival = rivalId == null
        ? null
        : ref.watch(nationByIdProvider(rivalId)).valueOrNull;
    final myPosition = progress.myPosition;
    final rivalPosition = progress.rivalPosition;
    Widget line(Key key, String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(text, key: key, style: AppTypography.bodyMedium),
    );
    final goal = progress.def.goal;
    // Both championships, cycle by cycle, for the goals that read both.
    final titles =
        goal == CampaignGoal.qualifyWorldThenTitles ||
        goal == CampaignGoal.qualifyBothThenTitle ||
        goal == CampaignGoal.titleTreble;
    // A goal judged across its cycles lists each cycle's championship.
    final perCycle = titles || goal == CampaignGoal.beatRivalsThenContinental;
    final cups = perCycle ? _cupTexts(l, progress) : const <String>[];
    final worlds = titles ? _worldTexts(l, progress) : const <String>[];
    // The Nations Cup comes between the two championships of the cycle.
    final nationsCup = _nationsCupText(l, progress);
    final nationsCupOver = progress.nationsCupRun?.over ?? true;
    final finals = progress.ordinal >= 2 && !perCycle
        ? l.campaignProgressFinals(
            objectiveFinishText(
              l,
              TournamentTier.continental,
              progress.ordinal,
            ),
          )
        : null;
    // The championship of the moment: this cycle's continental one until it
    // is over for the nation, then its World Championship.
    final summary =
        nationsCup != null && progress.cycleRuns.last.over && !nationsCupOver
        ? nationsCup
        : worlds.isNotEmpty && progress.cycleRuns.last.over
        ? worlds.last
        : cups.isNotEmpty
        ? cups.last
        : finals ??
              (myPosition != null
                  ? l.campaignProgressQualifying(
                      campaignPlaceText(l, myPosition),
                    )
                  : words.goal);
    final title = words.title.capsIn(l.localeName);
    final card = AppCard(
      key: CampaignHubCard.cardKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  expanded: _open,
                  excludeSemantics: true,
                  label: '$title, $summary',
                  onTap: () => _toggle(progress.def.id),
                  child: InkWell(
                    key: CampaignHubCard.headerKey,
                    onTap: () => _toggle(progress.def.id),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              if (!_open)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppSpacing.xs,
                                  ),
                                  child: Text(
                                    summary,
                                    key: CampaignHubCard.summaryKey,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _open ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.expand_more_rounded,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // The full brief, with every star and whether it is earned so
              // far: its own tap target and its own label, outside the
              // fold's merged semantics.
              IconButton(
                key: CampaignHubCard.briefKey,
                tooltip: l.campaignFullBrief,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () => showCampaignBriefSheet(context, careerId),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: !_open
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      Text(words.goal, style: AppTypography.titleMedium),
                      if (myPosition != null)
                        line(
                          CampaignHubCard.qualifyingKey,
                          l.campaignProgressQualifying(
                            campaignPlaceText(l, myPosition),
                          ),
                        ),
                      if (rival != null && rivalPosition != null)
                        line(
                          CampaignHubCard.rivalKey,
                          l.campaignProgressRival(
                            rival.name,
                            campaignPlaceText(l, rivalPosition),
                          ),
                        ),
                      if (titles)
                        for (var c = 0; c < cups.length; c++) ...[
                          line(CampaignHubCard.cupCycleKey(c), cups[c]),
                          if (nationsCup != null && c == cups.length - 1)
                            line(CampaignHubCard.nationsCupKey, nationsCup),
                          if (c < worlds.length)
                            line(CampaignHubCard.worldCycleKey(c), worlds[c]),
                        ]
                      else if (perCycle)
                        ..._rivalsAndCups(ref, cups, progress, line)
                      else if (finals != null)
                        line(CampaignHubCard.finalsKey, finals),
                    ],
                  ),
          ),
        ],
      ),
    );
    if (!gapAbove) return card;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: card,
    );
  }

  /// Each rival to beat, ticked once beaten, then the continental
  /// championship of every cycle played so far: how far it went, no place in
  /// it, or still to be decided.
  List<Widget> _rivalsAndCups(
    WidgetRef ref,
    List<String> cups,
    CampaignProgress progress,
    Widget Function(Key key, String text) line,
  ) {
    return [
      for (final id in progress.def.rivalNationIds)
        Padding(
          key: CampaignHubCard.rivalToBeatKey(id),
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Row(
            children: [
              Icon(
                progress.rivalsBeaten.contains(id)
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: progress.rivalsBeaten.contains(id)
                    ? AppColors.positive
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  ref.watch(nationByIdProvider(id)).valueOrNull?.name ?? '',
                  style: AppTypography.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      for (var c = 0; c < cups.length; c++)
        line(CampaignHubCard.cupCycleKey(c), cups[c]),
    ];
  }

  /// This cycle's Nations Cup, for a goal that reads it: how far it went once
  /// that is known, else still to be decided. Null for every other goal.
  String? _nationsCupText(AppLocalizations l, CampaignProgress progress) {
    final run = progress.nationsCupRun;
    if (run == null) return null;
    final conf = ref
        .watch(nationByIdProvider(progress.def.nationId))
        .valueOrNull
        ?.confederation;
    final cup = conf == null ? null : NationsCups.forConfederation(conf);
    if (cup == null) return null;
    final cycle = progress.cycleRuns.length - 1;
    return l.campaignProgressCup(
      competitionLabel(l, cup.name),
      '${CareerService.continentalFinalsYear(cycle)}',
      run.ordinal >= 5 || (run.over && run.ordinal > 0)
          ? objectiveFinishText(
              l,
              TournamentTier.nationsCup,
              run.ordinal,
              competition: cup.name,
            )
          : run.over
          ? l.campaignCupNotQualified
          : l.campaignCupOpen,
    );
  }

  /// The World Championship of every cycle played so far, one line each.
  List<String> _worldTexts(AppLocalizations l, CampaignProgress progress) => [
    for (var c = 0; c < progress.worldRuns.length; c++)
      l.campaignProgressCup(
        l.compWorldCup,
        '${CareerService.worldCupYear(c)}',
        switch (progress.worldRuns[c]) {
          (ordinal: >= 2, over: _) => objectiveFinishText(
            l,
            TournamentTier.world,
            progress.worldRuns[c].ordinal,
          ),
          (ordinal: _, over: true) => l.campaignCupNotQualified,
          _ => l.campaignCupOpen,
        },
      ),
  ];

  /// The continental championship of every cycle played so far, one line each.
  List<String> _cupTexts(AppLocalizations l, CampaignProgress progress) {
    final conf = ref
        .watch(nationByIdProvider(progress.def.nationId))
        .valueOrNull
        ?.confederation;
    if (conf == null) return const [];
    return [
      for (var c = 0; c < progress.cycleRuns.length; c++)
        l.campaignProgressCup(
          continentalCupLabel(l, conf),
          '${CareerService.continentalFinalsYear(c)}',
          switch (progress.cycleRuns[c]) {
            (ordinal: >= 2, over: _) => objectiveFinishText(
              l,
              TournamentTier.continental,
              progress.cycleRuns[c].ordinal,
            ),
            (ordinal: _, over: true) => l.campaignCupNotQualified,
            _ => l.campaignCupOpen,
          },
        ),
    ];
  }
}
