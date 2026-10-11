import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/squad_legend_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The Squad destination on a tablet: every eligible player in a sortable,
/// full-width table with four views of the same rows. A row opens the
/// player's own page, and back returns here.
class SquadTabletLayout extends ConsumerStatefulWidget {
  const SquadTabletLayout({required this.careerId, super.key});

  static const Key layoutKey = Key('squad.tabletLayout');

  final int careerId;

  @override
  ConsumerState<SquadTabletLayout> createState() => _SquadTabletLayoutState();
}

class _SquadTabletLayoutState extends ConsumerState<SquadTabletLayout> {
  PositionCategory? _line;

  static const List<PositionCategory> _lines = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  // The grid caches its sort against list identity: keep the same lists
  // until their inputs change.
  NationSquadData? _rowsData;
  PositionCategory? _rowsLine;
  List<NationSquadRow> _rows = const [];

  List<NationSquadRow> _rowsFor(NationSquadData data) {
    if (!identical(_rowsData, data) || _rowsLine != _line) {
      _rowsData = data;
      _rowsLine = _line;
      _rows = [
        for (final r in data.rows)
          if (_line == null || r.player.category == _line) r,
      ];
    }
    return _rows;
  }

  AppLocalizations? _setsL;
  NationSquadData? _setsData;
  Map<int, AbsenceOutlook>? _setsOutlooks;
  List<GridColumnSet<NationSquadRow>> _sets = const [];

  List<GridColumnSet<NationSquadRow>> _setsFor(
    AppLocalizations l,
    NationSquadData data,
    Map<int, AbsenceOutlook> outlooks,
  ) {
    if (_setsL != l ||
        !identical(_setsData, data) ||
        !identical(_setsOutlooks, outlooks)) {
      _setsL = l;
      _setsData = data;
      _setsOutlooks = outlooks;
      _sets = squadColumnSets(l, outlooks: outlooks, saveSeed: data.saveSeed);
    }
    return _sets;
  }

  String _lineLabel(AppLocalizations l, PositionCategory c) => switch (c) {
    PositionCategory.goalkeeper => l.squadLineKeepers,
    PositionCategory.defender => l.squadLineDefenders,
    PositionCategory.midfielder => l.squadLineMidfielders,
    PositionCategory.forward => l.squadLineForwards,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(nationSquadProvider(widget.careerId));
    final outlooks =
        ref.watch(absenceOutlookProvider(widget.careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};
    return Scaffold(
      key: SquadTabletLayout.layoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
        data: (data) {
          if (data == null) return Center(child: Text(l.tacticsNoSquad));
          final rows = _rowsFor(data);
          final sets = _setsFor(l, data, outlooks);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PanelBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
                    child: Row(
                      children: [
                        Text(l.sideSquad, style: TabletText.screenTitle),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l.squadShowingOf(rows.length, data.size),
                            style: TabletText.barMeta,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => showSquadLegend(context),
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            size: 15,
                          ),
                          label: Text(
                            l.squadLegendTitle,
                            style: TabletText.panelLink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        ChoiceChip(
                          label: Text(l.squadLineAll.toUpperCase()),
                          visualDensity: VisualDensity.compact,
                          selected: _line == null,
                          onSelected: (_) => setState(() => _line = null),
                        ),
                        for (final c in _lines)
                          ChoiceChip(
                            label: Text(_lineLabel(l, c)),
                            visualDensity: VisualDensity.compact,
                            selected: _line == c,
                            onSelected: (_) =>
                                setState(() => _line = _line == c ? null : c),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DataGrid<NationSquadRow>(
                      rows: rows,
                      columnSets: sets,
                      // His own page, pushed over the squad: back returns
                      // here with the view, sort and filter as they were.
                      onSelect: (r) => unawaited(
                        context.push(
                          '${Routes.player}?careerId=${widget.careerId}'
                          '&playerId=${r.player.id}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The squad table's four views of the same rows: who they are, what they
/// are made of, how they are going, and what they have done for the country.
List<GridColumnSet<NationSquadRow>> squadColumnSets(
  AppLocalizations l, {
  required Map<int, AbsenceOutlook> outlooks,
  required int saveSeed,
}) {
  // Every header in capitals: the strings arrive in mixed case ("POS" and
  // "CLUB" beside "Name" and "Age"), and the table reads as one only when
  // they agree.
  String h(String label) => label.toUpperCase();
  GridColumn<NationSquadRow> pos() => GridColumn(
    id: 'pos',
    label: h(l.squadDevPosition),
    width: 52,
    sortKey: (r) => r.player.position.index,
    cell: (r) => TacticalChip(r.player.position.label),
  );
  GridColumn<NationSquadRow> name() => GridColumn(
    id: 'name',
    label: h(l.squadSortName),
    // The widest share: a name is what the row is for, and it must read
    // whole at 1080 wide.
    flex: 4,
    sortKey: (r) => r.player.name,
    cell: (r) => Row(
      children: [
        // In the XI, then merely in the squad: the two states a manager
        // scans this list for.
        if (r.starting)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(Icons.star_rounded, size: 13, color: AppColors.primary),
          )
        else if (r.calledUp)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.check_circle,
              size: 12,
              color: AppColors.positive,
            ),
          ),
        // The name takes most of the room, the marks what is left: an even
        // split cut names short beside an empty half.
        Flexible(flex: 4, child: Text(r.player.name)),
        // Shrinks rather than overflows when the name column is squeezed.
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: PlayerTraitGlyphs(player: r.player, saveSeed: saveSeed),
          ),
        ),
      ],
    ),
  );
  GridColumn<NationSquadRow> number(
    String id,
    String label,
    int Function(NationSquadRow r) value, {
    double width = 64,
    bool bold = false,
  }) => GridColumn(
    id: id,
    label: h(label),
    width: width,
    numeric: true,
    sortKey: value,
    cell: (r) => Text(
      '${value(r)}',
      style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
    ),
  );
  GridColumn<NationSquadRow> attr(
    String id,
    String label,
    int Function(PlayerAttributes a) value,
  ) => number(id, label, (r) => value(r.player.attributes), width: 64);
  final overall = number(
    'ovr',
    l.teamOverall,
    (r) => r.player.overall,
    width: 72,
    bold: true,
  );
  final age = number('age', l.playerAge, (r) => r.player.age, width: 52);
  final caps = number('caps', l.squadSortCaps, (r) => r.caps, width: 60);
  final goals = number('goals', l.squadSortGoals, (r) => r.goals, width: 60);
  // Set off from the age before it (a right-aligned number), with the
  // club's flag, so "30" and "Udine" never read as one word.
  final club = GridColumn<NationSquadRow>(
    id: 'club',
    label: h(l.playerClub),
    flex: 4,
    gapBefore: 20,
    sortKey: (r) => r.player.club,
    cell: (r) => Row(
      children: [
        if (r.player.clubCountry.isNotEmpty) ...[
          FlagDisc(r.player.clubCountry, size: 16),
          const SizedBox(width: 6),
        ],
        Flexible(child: Text(r.player.club)),
      ],
    ),
  );
  final status = GridColumn<NationSquadRow>(
    id: 'status',
    label: h(l.gridColStatus),
    gapBefore: 12,
    flex: 2,
    sortKey: (r) => (r.absence?.isAvailable ?? true) ? 1 : 0,
    cell: (r) {
      if (r.absence?.isAvailable ?? true) return const SizedBox.shrink();
      final injured = (r.absence?.injuryMatches ?? 0) > 0;
      return Text(
        switch (outlooks[r.player.id]) {
          final o? => absenceLabel(l, o),
          _ => absenceShortLabel(l, r.absence) ?? l.tacticsOut,
        },
        style: TextStyle(color: injured ? AppColors.warning : AppColors.error),
      );
    },
  );
  final form = GridColumn<NationSquadRow>(
    id: 'form',
    label: h(l.playerStatForm),
    width: 64,
    numeric: true,
    sortKey: (r) => r.condition?.formRating ?? 0,
    cell: (r) {
      final rating = r.condition?.formRating ?? 0;
      return Text(rating > 0 ? rating.toStringAsFixed(1) : '-');
    },
  );
  final condition = GridColumn<NationSquadRow>(
    id: 'cond',
    label: h(l.gridColCondition),
    flex: 2,
    gapBefore: 20,
    sortKey: (r) => r.condition?.fatigueState.index ?? 0,
    cell: (r) => Text(switch (r.condition?.fatigueState) {
      FatigueState.exhausted => l.tacticsFatigueExhausted,
      FatigueState.tired => l.tacticsFatigueTired,
      FatigueState.ready => l.tacticsFatigueMatchLegs,
      FatigueState.fresh || null => '',
    }),
  );
  return [
    GridColumnSet(
      id: 'overview',
      label: l.gridViewOverview,
      columns: [pos(), name(), age, club, overall, caps, goals, status],
    ),
    GridColumnSet(
      id: 'attributes',
      label: l.playerAttributes,
      columns: [
        pos(),
        name(),
        age,
        attr('phy', l.playerAttrPhysical, (a) => a.physical),
        attr('tec', l.playerAttrTechnical, (a) => a.technical),
        attr('sta', l.playerAttrStamina, (a) => a.stamina),
        overall,
      ],
    ),
    GridColumnSet(
      id: 'form',
      label: l.playerStatForm,
      columns: [pos(), name(), form, condition, overall, status],
    ),
    GridColumnSet(
      id: 'career',
      label: l.sideCareer,
      columns: [pos(), name(), age, caps, goals, club],
    ),
  ];
}
