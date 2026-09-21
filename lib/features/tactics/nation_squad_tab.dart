import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// How the pool is ordered.
enum _SquadSort { rating, caps, goals, age, name }

/// Which slice of the pool is shown.
enum _SquadFilter { all, squad, uncapped, unavailable }

/// The nation's whole playing pool: every eligible player, what they have done
/// for the country, and where they stand for selection.
///
/// This replaced a list of the bench. Listing only the players already called
/// up answered a question the manager had already answered themselves; the
/// pool, with caps, goals, club, age and form on every line, answers the one
/// they actually have — who is out there, and who is coming.
class NationSquadTab extends ConsumerStatefulWidget {
  const NationSquadTab({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<NationSquadTab> createState() => _NationSquadTabState();
}

class _NationSquadTabState extends ConsumerState<NationSquadTab> {
  _SquadSort _sort = _SquadSort.rating;
  _SquadFilter _filter = _SquadFilter.all;
  PositionCategory? _line;
  String _query = '';

  static const _lines = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  List<NationSquadRow> _visible(NationSquadData data) {
    final q = _query.trim().toLowerCase();
    final rows = [
      for (final r in data.rows)
        if (_line == null || r.player.category == _line)
          if (switch (_filter) {
            _SquadFilter.all => true,
            _SquadFilter.squad => r.calledUp,
            _SquadFilter.uncapped => r.caps == 0,
            _SquadFilter.unavailable => !(r.absence?.isAvailable ?? true),
          })
            if (q.isEmpty ||
                r.player.name.toLowerCase().contains(q) ||
                r.player.club.toLowerCase().contains(q))
              r,
    ];
    rows.sort(
      (a, b) => switch (_sort) {
        _SquadSort.rating => b.player.overall.compareTo(a.player.overall),
        _SquadSort.caps => b.caps.compareTo(a.caps),
        _SquadSort.goals => b.goals.compareTo(a.goals),
        _SquadSort.age => a.player.age.compareTo(b.player.age),
        _SquadSort.name => a.player.name.compareTo(b.player.name),
      },
    );
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(nationSquadProvider(widget.careerId));
    final outlooks =
        ref.watch(absenceOutlookProvider(widget.careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
      data: (data) {
        if (data == null) return Center(child: Text(l.tacticsNoSquad));
        final rows = _visible(data);
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            _PoolSummary(data: data, careerId: widget.careerId),
            const SizedBox(height: AppSpacing.sm),
            // The controls used to be four stacked blocks — a search box, then
            // a row of slice chips, then a row of line chips, then a labelled
            // row of sort chips — which pushed the pool itself off the first
            // screen. Search and sort now share one line (sort is a menu, since
            // only one can ever be on), and the two chip rows are one strip
            // with the lines split off by a rule.
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: l.squadSearchHint,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _SortButton(
                  label: _sortLabel(l, _sort),
                  onSelected: (s) => setState(() => _sort = s),
                  labelFor: (s) => _sortLabel(l, s),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in _SquadFilter.values)
                    _Chip(
                      label: _filterLabel(l, f),
                      on: _filter == f,
                      onTap: () => setState(() => _filter = f),
                    ),
                  const _ChipDivider(),
                  _Chip(
                    label: l.squadLineAll,
                    on: _line == null,
                    onTap: () => setState(() => _line = null),
                  ),
                  for (final c in _lines)
                    _Chip(
                      label: _lineLabel(l, c),
                      on: _line == c,
                      onTap: () => setState(
                        () => _line = _line == c ? null : c,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.squadShowingOf(rows.length, data.size),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (rows.isEmpty)
              AppCard(
                child: Text(
                  l.squadNobodyMatches,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              )
            else
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final r in rows)
                      _PlayerRow(
                        row: r,
                        outlook: outlooks[r.player.id],
                        saveSeed: data.saveSeed,
                        onOpen: () => context.push(
                          '${Routes.player}?careerId=${widget.careerId}'
                          '&playerId=${r.player.id}',
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  String _filterLabel(AppLocalizations l, _SquadFilter f) => switch (f) {
    _SquadFilter.all => l.squadFilterAll,
    _SquadFilter.squad => l.squadFilterInSquad,
    _SquadFilter.uncapped => l.squadFilterUncapped,
    _SquadFilter.unavailable => l.squadFilterUnavailable,
  };

  String _lineLabel(AppLocalizations l, PositionCategory c) => switch (c) {
    PositionCategory.goalkeeper => l.squadLineKeepers,
    PositionCategory.defender => l.squadLineDefenders,
    PositionCategory.midfielder => l.squadLineMidfielders,
    PositionCategory.forward => l.squadLineForwards,
  };

  String _sortLabel(AppLocalizations l, _SquadSort s) => switch (s) {
    _SquadSort.rating => l.squadSortRating,
    _SquadSort.caps => l.squadSortCaps,
    _SquadSort.goals => l.squadSortGoals,
    _SquadSort.age => l.squadSortAge,
    _SquadSort.name => l.squadSortName,
  };
}

/// The shape of the pool: how big it is, how much of it is in the squad, how
/// old it is, and who its landmark players are.
class _PoolSummary extends ConsumerWidget {
  const _PoolSummary({required this.data, required this.careerId});

  final NationSquadData data;
  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final capped = data.mostCapped;
    final scorer = data.topScorer;
    final captain = ref.watch(captainProvider(careerId)).valueOrNull;
    final captainMorale =
        ref.watch(captainMoraleProvider(careerId)).valueOrNull ?? 0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Stat(value: '${data.size}', label: l.squadStatPool),
              _Stat(value: '${data.calledUp}', label: l.squadStatInSquad),
              _Stat(
                value: data.averageAge.toStringAsFixed(1),
                label: l.squadStatAvgAge,
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          // Who leads the side out, and what it is worth — the armband is
          // named on the call-up screen, so this is where its effect shows.
          _Landmark(
            icon: Icons.workspace_premium_outlined,
            label: l.squadCaptain,
            value: captain == null
                ? l.captainNone
                : captainMorale > 0
                ? '${captain.name} · ${l.captainMoraleBoost(captainMorale)}'
                : captain.name,
          ),
          if (capped != null || scorer != null) ...[
            if (capped != null)
              _Landmark(
                icon: Icons.military_tech_outlined,
                label: l.squadMostCapped,
                value: l.squadCapsValue(capped.player.name, capped.caps),
              ),
            if (scorer != null)
              _Landmark(
                icon: Icons.sports_soccer,
                label: l.squadTopScorer,
                value: l.squadGoalsValue(scorer.player.name, scorer.goals),
              ),
          ],
        ],
      ),
    );
  }
}

class _Landmark extends StatelessWidget {
  const _Landmark({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(icon, size: 15, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Flexible(
          // These rows carry NAMES — the captain, the most-capped, the top
          // scorer — so they get the same promise the squad list does.
          child: WholeText(
            value,
            maxLines: 1,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall,
          ),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        FittedBox(
          child: Text(value, style: AppTypography.headlineMedium),
        ),
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// A filter chip. Selection FILLS the chip rather than only recolouring its
/// border: a strip of eight outlined chips with one tinted outline reads as
/// eight identical chips, so the active slice was invisible.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: on ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: on ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: on ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

/// The rule between the slice chips and the line chips — two groups on one
/// strip, so it has to be clear they answer different questions.
class _ChipDivider extends StatelessWidget {
  const _ChipDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 16,
    margin: const EdgeInsets.only(right: 4, left: 2),
    color: AppColors.outlineVariant,
  );
}

/// The pool's sort order, as a menu — only one can be on at a time, so five
/// chips taking a row of their own was a row wasted.
class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.label,
    required this.onSelected,
    required this.labelFor,
  });

  final String label;
  final ValueChanged<_SquadSort> onSelected;
  final String Function(_SquadSort) labelFor;

  @override
  Widget build(BuildContext context) => PopupMenuButton<_SquadSort>(
    onSelected: onSelected,
    position: PopupMenuPosition.under,
    itemBuilder: (_) => [
      for (final s in _SquadSort.values)
        PopupMenuItem(
          value: s,
          height: 38,
          child: Text(labelFor(s), style: AppTypography.bodySmall),
        ),
    ],
    child: Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.swap_vert_rounded,
            size: 15,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

/// One player of the pool: who they are, their club and age, their international
/// record, and their rating — with selection and availability flagged.
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.row,
    required this.outlook,
    required this.saveSeed,
    required this.onOpen,
  });

  final NationSquadRow row;
  final AbsenceOutlook? outlook;
  final int saveSeed;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = row.player;
    final out = !(row.absence?.isAvailable ?? true);
    final injured = (row.absence?.injuryMatches ?? 0) > 0;
    final c = row.condition;
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            SizedBox(width: 38, child: TacticalChip(p.position.label)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // In the XI, then merely in the squad — the two states a
                      // manager scans this list for.
                      if (row.starting)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: AppColors.primary,
                          ),
                        )
                      else if (row.calledUp)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.check_circle,
                            size: 12,
                            color: AppColors.positive,
                          ),
                        ),
                      Flexible(
                        // Never ellipsised: a surname that ends in "…" is not
                        // a name, and this list is how the manager knows who
                        // is in his squad.
                        child: WholeText(
                          p.name,
                          maxLines: 1,
                          // Squeezed for room, the forename goes first: a
                          // surname is what names a footballer.
                          shortText: initialledName(p.name),
                          style: AppTypography.bodyMedium.copyWith(
                            color: out ? AppColors.onSurfaceVariant : null,
                          ),
                        ),
                      ),
                      if (c != null && c.overallDelta != 0)
                        Icon(
                          c.overallDelta > 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 13,
                          color: c.overallDelta > 0
                              ? AppColors.positive
                              : AppColors.error,
                        ),
                      PlayerTraitGlyphs(player: p, saveSeed: saveSeed),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          l.squadAgeClub(p.age, p.club),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (out) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          injured ? Icons.personal_injury : Icons.gavel_rounded,
                          size: 11,
                          color: injured ? AppColors.warning : AppColors.error,
                        ),
                        const SizedBox(width: 2),
                        // Flexible: an absence reads "Out 6 weeks · back for
                        // the semi-final", which on a narrow phone is wider
                        // than the room left beside the age and club.
                        Flexible(
                          child: Text(
                            switch (outlook) {
                              final o? => absenceLabel(l, o),
                              _ =>
                                absenceShortLabel(l, row.absence) ??
                                    l.tacticsOut,
                            },
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: injured
                                  ? AppColors.warning
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // The international record, which is the thing this screen exists
            // to show and the thing the old one never did.
            _Tally(label: l.squadCapsShort, value: row.caps),
            const SizedBox(width: AppSpacing.sm),
            _Tally(label: l.squadGoalsShort, value: row.goals),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 26,
              child: Text(
                '${p.overall}',
                textAlign: TextAlign.end,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small two-line tally (caps or goals).
class _Tally extends StatelessWidget {
  const _Tally({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 26,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 9,
          ),
        ),
        Text(
          '$value',
          style: AppTypography.labelMedium.copyWith(
            color: value == 0 ? AppColors.onSurfaceVariant : null,
          ),
        ),
      ],
    ),
  );
}
