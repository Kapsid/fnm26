import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/federation/stadium_map/nation_geo.dart';
import 'package:fnm/features/federation/stadium_map/stadium_map.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The nation's national stadiums: each ground's seats, level (its capacity
/// band) and income, an enlargement or a downsizing for each (one work a
/// cycle), and a new stadium in a city of the manager's choosing. Works are
/// ordered at the opening of a cycle, before the budget is set, out of the
/// same free funds; at any other time the screen is a record. See
/// [NationalStadiums] for every number.
///
/// It opens on a map of the country ([StadiumMap]): a marker per ground,
/// tapped for the same card and works as the list, and the free cities as
/// dots while a new stadium is placed. A toggle switches to the list.
///
/// On a tablet it fills the shell's content area: the map beside a side
/// panel, the list held to a readable column.
class NationalStadiumsScreen extends ConsumerStatefulWidget {
  const NationalStadiumsScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('stadiums.tabletLayout');
  static const Key buildKey = Key('stadiums.build');
  static const Key cityKey = Key('stadiums.city');
  static Key upgradeKey(int index) => Key('stadiums.upgrade.$index');
  static Key downsizeKey(int index) => Key('stadiums.downsize.$index');
  static const Key viewToggleKey = Key('stadiums.viewToggle');
  static const Key mapBuildKey = Key('stadiums.mapBuild');
  static const Key mapCancelKey = Key('stadiums.mapCancel');
  static const Key sheetKey = Key('stadiums.sheet');
  static const Key nameFieldKey = Key('stadiums.nameField');
  static Key renameKey(int index) => Key('stadiums.rename.$index');

  final int careerId;

  @override
  ConsumerState<NationalStadiumsScreen> createState() =>
      _NationalStadiumsScreenState();
}

class _NationalStadiumsScreenState
    extends ConsumerState<NationalStadiumsScreen> {
  bool _busy = false;
  String? _city;

  /// Map (the default) or list.
  bool _map = true;

  /// Placing a new stadium on the map: the free cities show as dots.
  bool _picking = false;

  void _leave(GoRouter router) {
    if (router.canPop()) {
      router.pop();
    } else {
      router.go('${Routes.finances}?careerId=${widget.careerId}');
    }
  }

  /// Asks, then runs [work]. The service re-reads everything and charges at
  /// most once, so a stale screen or a double tap never pays twice. Returns
  /// whether the order was confirmed (not whether it went through).
  /// A null [question] means it was already asked (the build dialog).
  Future<bool> _order(String? question, Future<bool> Function() work) async {
    if (_busy) return false;
    final l = AppLocalizations.of(context);
    final ok = question == null
        ? true
        : await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(question),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l.stadiumsCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l.stadiumsConfirm),
                ),
              ],
            ),
          );
    if (ok != true || !mounted) return false;
    setState(() => _busy = true);
    final container = ProviderScope.containerOf(context, listen: false);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final done = await work();
    container.invalidate(hubDataProvider(widget.careerId));
    // Refused (the funds moved, the budget was set elsewhere, another work
    // got there first): say so rather than closing on nothing.
    if (!done) {
      messenger?.showSnackBar(SnackBar(content: Text(l.stadiumsRefused)));
    }
    if (mounted) setState(() => _busy = false);
    return true;
  }

  void _upgrade(AppLocalizations l, NationalStadiumsView view, int i) {
    final s = view.stadiums[i];
    final cost = NationalStadiums.enlargeCost(s.capacity);
    if (cost == null) return;
    unawaited(
      _order(
        l.stadiumsConfirmUpgrade(s.name, s.level + 1, formatEuros(cost)),
        () => ref
            .read(nationalStadiumServiceProvider)
            .upgrade(widget.careerId, s.ref),
      ),
    );
  }

  void _downsize(AppLocalizations l, NationalStadiumsView view, int i) {
    final s = view.stadiums[i];
    final to = StadiumLevels.downsizedTo(s.capacity);
    if (to == null) return;
    final seats = NumberFormat.decimalPattern(l.localeName);
    unawaited(
      _order(
        l.stadiumsConfirmDownsize(s.name, seats.format(to), s.level - 1),
        () => ref
            .read(nationalStadiumServiceProvider)
            .downsize(widget.careerId, s.ref),
      ),
    );
  }

  /// Asks, with the new ground's name in a field (prefilled with the
  /// generated one), then orders it. Returns whether the order was confirmed.
  Future<bool> _build(
    AppLocalizations l,
    NationalStadiumsView view,
    String city,
  ) async {
    if (_busy) return false;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _StadiumNameDialog(
        question: l.stadiumsConfirmBuild(city, formatEuros(view.buildCost)),
        initial: NationalStadiums.newStadiumName(city),
      ),
    );
    if (name == null || !mounted) return false;
    return _order(
      null,
      () => ref
          .read(nationalStadiumServiceProvider)
          .build(widget.careerId, city, name: name),
    );
  }

  /// Renames a ground the federation built: free, no confirmation beyond the
  /// field's own.
  Future<void> _rename(AppLocalizations l, NationalStadium s) async {
    if (_busy || !s.built) return;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _StadiumNameDialog(initial: s.name),
    );
    if (name == null || !mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final done = await ref
        .read(nationalStadiumServiceProvider)
        .rename(widget.careerId, s.city, name);
    if (!done) {
      messenger?.showSnackBar(SnackBar(content: Text(l.stadiumsRefused)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(nationalStadiumsViewProvider(widget.careerId));
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
      data: (view) => view == null
          ? Center(child: Text(l.federationSaveNotFound))
          : _body(l, view),
    );
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: NationalStadiumsScreen.tabletLayoutKey,
        title: l.stadiumsTitle,
        onBack: () => _leave(GoRouter.of(context)),
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => _leave(GoRouter.of(context)),
        ),
        title: Text(
          l.stadiumsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _body(AppLocalizations l, NationalStadiumsView view) {
    Widget list() => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: _content(l, view),
      ),
    );
    if (!_map) return list();
    return ref
        .watch(nationGeoProvider(view.nationId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          // No map for the nation: the list says everything.
          error: (_, _) => list(),
          data: (geo) => geo == null ? list() : _mapView(l, view, geo),
        );
  }

  Widget _toggle(AppLocalizations l) => SegmentedButton<bool>(
    key: NationalStadiumsScreen.viewToggleKey,
    showSelectedIcon: false,
    segments: [
      ButtonSegment(
        value: true,
        icon: const Icon(Icons.map_outlined),
        label: Text(l.stadiumsViewMap),
      ),
      ButtonSegment(
        value: false,
        icon: const Icon(Icons.view_list_rounded),
        label: Text(l.stadiumsViewList),
      ),
    ],
    selected: {_map},
    onSelectionChanged: (v) => setState(() {
      _map = v.first;
      _picking = false;
    }),
  );

  /// The map: the country with a marker per ground, the money above it,
  /// the level key and the way to build below it (beside it on a tablet).
  Widget _mapView(
    AppLocalizations l,
    NationalStadiumsView view,
    NationGeo geo,
  ) {
    final pins = [
      for (var i = 0; i < view.stadiums.length; i++)
        StadiumPin(
          index: i,
          city: view.stadiums[i].city,
          capacity: view.stadiums[i].capacity,
          level: view.stadiums[i].level,
          building: !view.stadiums[i].openIn(view.cycle),
        ),
    ];
    final map = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.mdAll,
        child: StadiumMap(
          geo: geo,
          pins: pins,
          candidates: view.cities,
          picking: _picking,
          fitTooltip: l.stadiumsMapFit,
          onPin: (p) => _openPin(l, view, p.index),
          onCandidate: (city) async {
            if (await _build(l, view, city) && mounted) {
              setState(() => _picking = false);
            }
          },
        ),
      ),
    );
    return LayoutBuilder(
      builder: (context, box) {
        const pad = AppSpacing.marginMobile;
        if (box.maxWidth >= 680) {
          return Padding(
            padding: const EdgeInsets.all(pad),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: map),
                const SizedBox(width: AppSpacing.lg),
                SizedBox(
                  width: 320,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _toggle(l),
                        const SizedBox(height: AppSpacing.md),
                        _summary(l, view),
                        const SizedBox(height: AppSpacing.md),
                        _legend(l),
                        const SizedBox(height: AppSpacing.md),
                        _buildBar(l, view),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        // A short window (a phone on its side): everything scrolls, the map
        // at a fixed height.
        if (box.maxHeight < 560) {
          return ListView(
            padding: const EdgeInsets.all(pad),
            children: [
              _toggle(l),
              const SizedBox(height: AppSpacing.sm),
              _summary(l, view),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(height: 320, child: map),
              const SizedBox(height: AppSpacing.sm),
              _legend(l),
              const SizedBox(height: AppSpacing.sm),
              _buildBar(l, view),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(pad, pad, pad, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _toggle(l),
              const SizedBox(height: AppSpacing.sm),
              _summary(l, view),
              const SizedBox(height: AppSpacing.sm),
              Expanded(child: map),
              const SizedBox(height: AppSpacing.sm),
              _legend(l),
              const SizedBox(height: AppSpacing.sm),
              SafeArea(top: false, child: _buildBar(l, view)),
            ],
          ),
        );
      },
    );
  }

  /// The money, in brief: income, reputation and free funds; and whether
  /// works may be ordered now.
  Widget _summary(AppLocalizations l, NationalStadiumsView view) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: AppSpacing.md,
        runSpacing: 2,
        children: [
          Text(
            l.stadiumsIncome(formatEuros(view.income)),
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.positive,
            ),
          ),
          Text(
            l.stadiumsReputation(view.reputation),
            style: AppTypography.labelMedium,
          ),
          Text(
            l.hostBidFreeFunds(formatEuros(view.freeFunds)),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      if (!view.window) ...[
        const SizedBox(height: 2),
        Text(
          l.stadiumsClosed,
          style: AppTypography.labelSmall.copyWith(color: AppColors.warning),
        ),
      ],
    ],
  );

  /// The level key: one marker colour per level.
  Widget _legend(AppLocalizations l) => Wrap(
    spacing: AppSpacing.md,
    runSpacing: AppSpacing.xs,
    alignment: WrapAlignment.center,
    children: [
      for (var level = 1; level <= NationalStadiums.maxLevel; level++)
        Semantics(
          label: l.stadiumsLevel(level, NationalStadiums.maxLevel),
          excludeSemantics: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: stadiumLevelColor(level),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l.stadiumsLevel(level, NationalStadiums.maxLevel),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  /// Under the map: the button that starts placing a new stadium, or, while
  /// placing, the hint and a way out.
  Widget _buildBar(AppLocalizations l, NationalStadiumsView view) {
    final block = view.buildBlock;
    if (_picking) {
      return Row(
        children: [
          const Icon(Icons.touch_app_rounded, color: AppColors.positive),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(l.stadiumsMapPickCity, style: AppTypography.bodySmall),
          ),
          TextButton(
            key: NationalStadiumsScreen.mapCancelKey,
            onPressed: () => setState(() => _picking = false),
            style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
            child: Text(l.stadiumsCancel),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          key: NationalStadiumsScreen.mapBuildKey,
          onPressed: block != null || _busy
              ? null
              : () => setState(() => _picking = true),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          icon: const Icon(Icons.add_location_alt_rounded),
          label: Text(
            l.stadiumsBuildButton(formatEuros(view.buildCost)),
            textAlign: TextAlign.center,
          ),
        ),
        if (block == StadiumBlock.underConstruction ||
            block == StadiumBlock.noCity) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            block == StadiumBlock.underConstruction
                ? l.stadiumsBuilding
                : l.stadiumsNoCity,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// A ground's card, as in the list, in a sheet: its seats, level, income
  /// and works. An order closes the sheet before it asks.
  void _openPin(AppLocalizations l, NationalStadiumsView view, int i) {
    final seats = NumberFormat.decimalPattern(l.localeName);
    final s = view.stadiums[i];
    unawaited(
      showAdaptiveSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.surfaceContainerLow,
        builder: (sheetContext) => SafeArea(
          child: SingleChildScrollView(
            key: NationalStadiumsScreen.sheetKey,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              0,
              AppSpacing.marginMobile,
              AppSpacing.marginMobile,
            ),
            child: _StadiumCard(
              index: i,
              stadium: s,
              seats: seats,
              block: view.upgradeBlock(s),
              downsizeBlock: view.downsizeBlock(s),
              income: view.incomeOf(s),
              busy: _busy,
              onUpgrade: () {
                Navigator.of(sheetContext).pop();
                _upgrade(l, view, i);
              },
              onDownsize: () {
                Navigator.of(sheetContext).pop();
                _downsize(l, view, i);
              },
              onRename: () {
                Navigator.of(sheetContext).pop();
                unawaited(_rename(l, s));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(AppLocalizations l, NationalStadiumsView view) {
    final seats = NumberFormat.decimalPattern(l.localeName);
    final cities = view.cities;
    final city = cities.contains(_city)
        ? _city
        : (cities.isEmpty ? null : cities.first);
    final buildBlock = view.buildBlock;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _toggle(l),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.stadiumsBlurb,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.stadiumsIncome(formatEuros(view.income)),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.positive,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l.stadiumsReputation(view.reputation),
                style: AppTypography.labelMedium,
              ),
              const SizedBox(height: 2),
              Text(
                l.hostBidFreeFunds(formatEuros(view.freeFunds)),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (!view.window) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.stadiumsClosed,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < view.stadiums.length; i++) ...[
          _StadiumCard(
            index: i,
            stadium: view.stadiums[i],
            seats: seats,
            block: view.upgradeBlock(view.stadiums[i]),
            downsizeBlock: view.downsizeBlock(view.stadiums[i]),
            income: view.incomeOf(view.stadiums[i]),
            busy: _busy,
            onUpgrade: () => _upgrade(l, view, i),
            onDownsize: () => _downsize(l, view, i),
            onRename: () => unawaited(_rename(l, view.stadiums[i])),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.construction_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l.stadiumsBuildTitle,
                      style: AppTypography.labelLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.stadiumsBuildBody,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.stadiumsCapacity(seats.format(view.newCapacity)),
                style: AppTypography.labelMedium,
              ),
              if (cities.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  key: NationalStadiumsScreen.cityKey,
                  initialValue: city,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l.stadiumsBuildCity,
                  ),
                  items: [
                    for (final c in cities)
                      DropdownMenuItem(
                        value: c,
                        child: Text(c, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: _busy ? null : (c) => setState(() => _city = c),
                ),
              ],
              if (buildBlock == StadiumBlock.underConstruction ||
                  buildBlock == StadiumBlock.noCity) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  buildBlock == StadiumBlock.underConstruction
                      ? l.stadiumsBuilding
                      : l.stadiumsNoCity,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                key: NationalStadiumsScreen.buildKey,
                onPressed: buildBlock != null || _busy || city == null
                    ? null
                    : () => _build(l, view, city),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: const Icon(Icons.stadium_rounded),
                label: Text(
                  l.stadiumsBuildButton(formatEuros(view.buildCost)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// One ground: its name and city, seats, level and income, and its two
/// works (or why there are none).
class _StadiumCard extends StatelessWidget {
  const _StadiumCard({
    required this.index,
    required this.stadium,
    required this.seats,
    required this.block,
    required this.downsizeBlock,
    required this.income,
    required this.busy,
    required this.onUpgrade,
    required this.onDownsize,
    required this.onRename,
  });

  final int index;
  final NationalStadium stadium;
  final NumberFormat seats;
  final StadiumBlock? block;
  final StadiumBlock? downsizeBlock;

  /// What it earns at the next cycle start.
  final int income;
  final bool busy;
  final VoidCallback onUpgrade;
  final VoidCallback onDownsize;

  /// Renames it; offered only on a ground the federation built.
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = stadium;
    final status = switch (block) {
      StadiumBlock.underConstruction => l.stadiumsOpens(
        CareerService.cycleOpens(s.opensCycle ?? 0).year,
      ),
      StadiumBlock.topLevel => l.stadiumsTopLevel,
      StadiumBlock.doneThisCycle => l.stadiumsResizedThisCycle,
      _ => null,
    };
    // Closed or short of funds: the button stays, disabled, so the price is
    // there to read.
    final offered =
        block == null ||
        block == StadiumBlock.closed ||
        block == StadiumBlock.funds;
    final cost = NationalStadiums.enlargeCost(s.capacity);
    final canShrink =
        downsizeBlock == null || downsizeBlock == StadiumBlock.closed;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                s.built ? Icons.fiber_new_rounded : Icons.stadium_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: AppTypography.labelLarge),
                    Text(
                      s.city,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (s.built)
                IconButton(
                  key: NationalStadiumsScreen.renameKey(index),
                  onPressed: busy ? null : onRename,
                  tooltip: l.stadiumsRename,
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  color: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l.stadiumsCapacity(seats.format(s.capacity)),
                style: AppTypography.bodySmall,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.stadiumsLevel(s.level, NationalStadiums.maxLevel),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  for (var i = 0; i < NationalStadiums.maxLevel; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        i < s.level
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: i < s.level
                            ? AppColors.warning
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l.stadiumsGroundIncome(formatEuros(income)),
            style: AppTypography.labelSmall.copyWith(
              color: income > 0
                  ? AppColors.positive
                  : AppColors.onSurfaceVariant,
            ),
          ),
          if (status != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              status,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          if ((offered && cost != null) || canShrink) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (offered && cost != null)
                  OutlinedButton(
                    key: NationalStadiumsScreen.upgradeKey(index),
                    onPressed: block == null && !busy ? onUpgrade : null,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: Text(
                      l.stadiumsUpgrade(formatEuros(cost)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (canShrink)
                  TextButton(
                    key: NationalStadiumsScreen.downsizeKey(index),
                    onPressed: downsizeBlock == null && !busy
                        ? onDownsize
                        : null,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: Text(
                      l.stadiumsDownsize,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The name of a new or built stadium: a field prefilled with [initial],
/// under [question] when the dialog also confirms an order. Pops the text as
/// typed (the service cleans it, and a blank keeps the generated name), or
/// null on cancel.
class _StadiumNameDialog extends StatefulWidget {
  const _StadiumNameDialog({required this.initial, this.question});

  final String initial;
  final String? question;

  @override
  State<_StadiumNameDialog> createState() => _StadiumNameDialogState();
}

class _StadiumNameDialogState extends State<_StadiumNameDialog> {
  late final TextEditingController _name = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _done() => Navigator.of(context).pop(_name.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final question = widget.question;
    return AlertDialog(
      title: question == null ? Text(l.stadiumsRename) : null,
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (question != null) ...[
            Text(question),
            const SizedBox(height: AppSpacing.md),
          ],
          TextField(
            key: NationalStadiumsScreen.nameFieldKey,
            controller: _name,
            autofocus: question == null,
            maxLength: StadiumName.maxLength,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _done(),
            decoration: InputDecoration(
              labelText: l.stadiumsNameLabel,
              helperText: l.stadiumsNameHint,
              helperMaxLines: 3,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.stadiumsCancel),
        ),
        TextButton(onPressed: _done, child: Text(l.stadiumsConfirm)),
      ],
    );
  }
}

/// The way in to the national stadiums: on the budget screen beside the host
/// bids, and on the finances page, where it stays once the budget is set (the
/// app bar's bare icon there was the only way in, and a tester never found
/// it).
class NationalStadiumsEntry extends ConsumerWidget {
  const NationalStadiumsEntry({required this.careerId, super.key});

  static const Key entryKey = Key('stadiums.entry');

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // Once the budget is set the works window is shut: the row still opens
    // the grounds, and says when works can be ordered again rather than
    // promising an upgrade the page will refuse.
    final closed =
        ref.watch(nationalStadiumsViewProvider(careerId)).valueOrNull?.window ==
        false;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          key: entryKey,
          borderRadius: AppRadii.baseAll,
          onTap: () =>
              unawaited(context.push('${Routes.stadiums}?careerId=$careerId')),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.location_city_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.stadiumsTitle, style: AppTypography.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        closed ? l.stadiumsEntrySubClosed : l.stadiumsEntrySub,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
