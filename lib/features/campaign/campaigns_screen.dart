import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'campaigns_tablet_layout.dart';

/// The campaigns the list offers, in the order it shows them. A provider so a
/// test can stand in a catalogue of any size.
final Provider<List<CampaignDef>> campaignCatalogProvider = Provider(
  (ref) => Campaigns.all,
);

/// How long a campaign runs: the list's sections.
enum CampaignLength { oneCycle, short, long }

/// One cycle; two to four; five or more.
CampaignLength campaignLength(CampaignDef def) => def.cycles <= 1
    ? CampaignLength.oneCycle
    : def.cycles <= 4
    ? CampaignLength.short
    : CampaignLength.long;

/// The list's filter: every campaign, the ones never touched, the ones with a
/// run going, the ones finished at least once (conquered or failed).
enum CampaignFilter { all, notPlayed, inProgress, completed }

/// The list's filter, kept for the app session: opening a brief and coming
/// back finds the list as it was left.
final StateProvider<CampaignFilter> campaignFilterProvider = StateProvider(
  (ref) => CampaignFilter.all,
);

/// Where the list was scrolled to, kept beside [campaignFilterProvider].
final StateProvider<double> campaignListOffsetProvider = StateProvider(
  (ref) => 0,
);

/// Whether a campaign with a run going ([hasRun]) and this [best] record
/// passes [filter].
/// A campaign finished once and being played again is both in progress and
/// completed.
bool campaignPasses(
  CampaignFilter filter, {
  required bool hasRun,
  required int? best,
}) => switch (filter) {
  CampaignFilter.all => true,
  CampaignFilter.notPlayed => !hasRun && best == null,
  CampaignFilter.inProgress => hasRun,
  CampaignFilter.completed => best != null,
};

/// The hand-built scenarios, as compact tiles in sections by length, with a
/// filter by completion on top. A tile opens the campaign's brief, which holds
/// the story, the star goals and the way into a run (start, resume, move,
/// abandon). Built to stay readable with twenty campaigns and more.
class CampaignsScreen extends ConsumerWidget {
  const CampaignsScreen({super.key});

  static const Key tabletLayoutKey = Key('campaigns.tabletLayout');
  static const Key emptyKey = Key('campaigns.empty');
  static const Key introKey = Key('campaigns.intro');

  static Key filterKey(CampaignFilter f) => Key('campaigns.filter.${f.name}');

  static Key sectionKey(CampaignLength s) => Key('campaigns.section.${s.name}');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const body = CampaignList();
    if (useTabletLayout(context, ref)) {
      return const _CampaignsTabletLayout(body: body);
    }
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          l.campaignsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(top: false, child: body),
    );
  }
}

/// The filter chips, then each length's section of tiles: one column on a
/// phone, as many as fit on a tablet. A section the filter empties is left
/// out; a filter that empties them all says so. The filter and the scroll
/// position live in providers, so they survive a visit to a brief.
class CampaignList extends ConsumerStatefulWidget {
  const CampaignList({super.key});

  /// The narrowest a tile gets before the grid drops a column.
  static const double minTileWidth = 320;

  @override
  ConsumerState<CampaignList> createState() => _CampaignListState();
}

class _CampaignListState extends ConsumerState<CampaignList> {
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: ref.read(campaignListOffsetProvider),
  )..addListener(_keepOffset);

  void _keepOffset() {
    if (!_scroll.hasClients) return;
    ref.read(campaignListOffsetProvider.notifier).state = _scroll.offset;
  }

  void _onFilter(CampaignFilter f) {
    ref.read(campaignFilterProvider.notifier).state = f;
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final filter = ref.watch(campaignFilterProvider);
    final catalog = ref.watch(campaignCatalogProvider);
    final runs = ref.watch(campaignRunsProvider).valueOrNull ?? const {};
    final sections = <CampaignLength, List<CampaignDef>>{};
    for (final def in catalog) {
      final best = ref.watch(campaignBestProvider(def.id)).valueOrNull;
      if (!campaignPasses(
        filter,
        hasRun: runs.containsKey(def.id),
        best: best,
      )) {
        continue;
      }
      (sections[campaignLength(def)] ??= []).add(def);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = AppSpacing.marginMobile;
        const gap = AppSpacing.md;
        final inner = constraints.maxWidth - 2 * pad;
        final columns = (inner / CampaignList.minTileWidth).floor().clamp(
          1,
          3,
        );
        final tileWidth = (inner - gap * (columns - 1)) / columns;
        return ListView(
          controller: _scroll,
          padding: const EdgeInsets.all(pad),
          children: [
            Padding(
              key: CampaignsScreen.introKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                l.campaignsIntro,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final f in CampaignFilter.values)
                  ChoiceChip(
                    key: CampaignsScreen.filterKey(f),
                    label: Text(_filterLabel(l, f)),
                    visualDensity: VisualDensity.compact,
                    selected: f == filter,
                    onSelected: (_) => _onFilter(f),
                  ),
              ],
            ),
            if (sections.isEmpty)
              Padding(
                key: CampaignsScreen.emptyKey,
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: Text(
                  l.campaignFilterEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            for (final length in CampaignLength.values)
              if (sections[length] case final defs?) ...[
                Padding(
                  key: CampaignsScreen.sectionKey(length),
                  padding: const EdgeInsets.only(
                    top: AppSpacing.lg,
                    bottom: AppSpacing.sm,
                  ),
                  child: Text(
                    '${_sectionLabel(l, length)} · ${defs.length}'.capsIn(
                      l.localeName,
                    ),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Wrap(
                  spacing: gap,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final def in defs)
                      SizedBox(
                        width: tileWidth,
                        child: CampaignTile(def: def),
                      ),
                  ],
                ),
              ],
          ],
        );
      },
    );
  }

  static String _filterLabel(AppLocalizations l, CampaignFilter f) =>
      switch (f) {
        CampaignFilter.all => l.campaignFilterAll,
        CampaignFilter.notPlayed => l.campaignFilterNew,
        CampaignFilter.inProgress => l.campaignFilterInProgress,
        CampaignFilter.completed => l.campaignFilterDone,
      };

  static String _sectionLabel(AppLocalizations l, CampaignLength s) =>
      switch (s) {
        CampaignLength.oneCycle => l.campaignSectionOneCycle,
        CampaignLength.short => l.campaignSectionShort,
        CampaignLength.long => l.campaignSectionLong,
      };
}

/// One campaign, compact: flag, title, length, difficulty, the Free or Pro
/// badge, a run in progress, and the stars of its best finished run. A tap
/// opens the brief, for every campaign: a Pro one shows its story to a
/// manager without Pro too, and only the brief's Start asks him to pay.
class CampaignTile extends ConsumerWidget {
  const CampaignTile({required this.def, super.key});

  final CampaignDef def;

  static Key keyFor(String id) => Key('campaign.tile.$id');
  static const Key proBadgeKey = Key('campaign.proBadge');
  static const Key inProgressKey = Key('campaign.tile.inProgress');
  static const Key starsKey = Key('campaign.tile.stars');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final words = campaignWords(l, def);
    final difficulty = campaignDifficulty(l, def);
    final nation = ref.watch(nationByIdProvider(def.nationId)).valueOrNull;
    final best = ref.watch(campaignBestProvider(def.id)).valueOrNull;
    final running =
        ref.watch(campaignRunsProvider).valueOrNull?.containsKey(def.id) ??
        false;
    return AppCard(
      key: keyFor(def.id),
      padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
      onTap: () => context.go('${Routes.campaignBrief}?id=${def.id}'),
      child: Row(
        children: [
          if (nation != null) ...[
            FlagDisc(nation.code, size: 40),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  words.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    CampaignBadge(
                      label: l.campaignCycles(def.cycles),
                      color: AppColors.onSurfaceVariant,
                    ),
                    CampaignBadge(
                      label: difficulty.label,
                      color: difficulty.color,
                    ),
                    if (def.needsPro)
                      // A lock, not the word: it marks a Pro campaign for
                      // everyone; the word is its screen-reader label.
                      CampaignBadge(
                        key: proBadgeKey,
                        label: l.campaignPro,
                        color: AppColors.warning,
                        icon: Icons.lock,
                      )
                    else
                      CampaignBadge(
                        label: l.campaignFree,
                        color: AppColors.positive,
                      ),
                    if (running)
                      CampaignBadge(
                        key: inProgressKey,
                        label: l.campaignFilterInProgress,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (best != null) ...[
            const SizedBox(width: AppSpacing.sm),
            CampaignEarnedStars(key: starsKey, best: best),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// A tile's record: three stars, the earned ones filled, or a cross for a
/// campaign only ever failed. Read as one label by a screen reader.
class CampaignEarnedStars extends StatelessWidget {
  const CampaignEarnedStars({required this.best, super.key});

  /// 0 failed, 1..3 conquered with that many stars.
  final int best;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stars = best.clamp(0, 3);
    return Semantics(
      label: stars == 0
          ? l.campaignStampFailed
          : '${l.campaignStampConquered}, ${l.campaignStarsEarned(stars)}',
      excludeSemantics: true,
      child: stars == 0
          ? const Icon(Icons.close_rounded, size: 18, color: AppColors.error)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Icon(
                    i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 16,
                    color: i < stars
                        ? AppColors.warning
                        : AppColors.onSurfaceVariant,
                  ),
              ],
            ),
    );
  }
}

/// The three star conditions, one star per line.
///
/// With [earned] (a run under way, or settled), each line also says whether
/// its star is in hand: a tick and gold stars for one earned so far, an empty
/// circle and grey outlines for one still to earn. Null (a campaign with no
/// run) shows the rules alone, every star in gold.
class CampaignStarRules extends StatelessWidget {
  const CampaignStarRules({required this.stars, this.earned, super.key});

  final List<String> stars;

  /// How many stars the run has earned so far, or null for no run.
  final int? earned;

  /// The row of the [index]th star (0-based), for tests.
  static Key rowKey(int index) => Key('campaign.starRule.$index');

  /// The tick of a star earned so far.
  static Key earnedKey(int index) => Key('campaign.starRule.$index.earned');

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final earned = this.earned;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stars.length; i++)
          () {
            final got = earned == null || earned > i;
            return Semantics(
              key: rowKey(i),
              label: earned == null
                  ? null
                  : got
                  ? l.campaignStarEarned
                  : l.campaignStarNotYet,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (earned != null) ...[
                      Icon(
                        got
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        key: got ? earnedKey(i) : null,
                        size: 14,
                        color: got
                            ? AppColors.positive
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    SizedBox(
                      width: 54,
                      child: Row(
                        children: [
                          for (var s = 0; s <= i; s++)
                            Icon(
                              got
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 14,
                              color: got
                                  ? AppColors.warning
                                  : AppColors.onSurfaceVariant,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(stars[i], style: AppTypography.bodySmall),
                    ),
                  ],
                ),
              ),
            );
          }(),
      ],
    );
  }
}

/// A small outlined badge: a word, or an icon labelled by the word.
class CampaignBadge extends StatelessWidget {
  const CampaignBadge({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;

  /// Shown instead of [label], which then only labels it for a screen reader.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color),
      ),
      child: icon == null
          ? Text(label, style: AppTypography.labelSmall.copyWith(color: color))
          : Semantics(
              label: label,
              excludeSemantics: true,
              child: Icon(icon, size: 14, color: color),
            ),
    );
  }
}
