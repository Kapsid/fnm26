import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/features/records/h2h_meetings_screen.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'head_to_head_tablet_layout.dart';

/// Head-to-head explorer: pick any two nations and see their all-time record
/// across every meeting in the save — friendlies, qualifiers and finals alike.
class HeadToHeadScreen extends ConsumerStatefulWidget {
  const HeadToHeadScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('headToHead.tabletLayout');

  final int careerId;

  @override
  ConsumerState<HeadToHeadScreen> createState() => _HeadToHeadScreenState();
}

class _HeadToHeadScreenState extends ConsumerState<HeadToHeadScreen> {
  int? _a;
  int? _b;
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The career's own world: the picker offers the nations it holds.
    final nationsAsync = ref.watch(careerNationsProvider(widget.careerId));
    // Default side A to the manager's own nation the first time.
    if (!_seeded) {
      final career = ref.watch(careerByIdProvider(widget.careerId)).valueOrNull;
      if (career != null) {
        _a = career.nationId;
        _seeded = true;
      }
    }

    if (TabletShellScope.isActive(context)) {
      return _HeadToHeadTabletLayout(state: this, nationsAsync: nationsAsync);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.records}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.recordsHeadToHead,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: nationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadNations(e.toString()))),
        data: (nations) {
          final byId = {for (final n in nations) n.id: n};
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _NationSlot(
                      careerId: widget.careerId,
                      label: l.recordsHome,
                      nation: _a == null ? null : byId[_a],
                      onTap: () =>
                          _pick(nations, (id) => setState(() => _a = id)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Text(
                      l.recordsVs,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _NationSlot(
                      careerId: widget.careerId,
                      label: l.recordsAway,
                      nation: _b == null ? null : byId[_b],
                      onTap: () =>
                          _pick(nations, (id) => setState(() => _b = id)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_a != null && _b != null && _a != _b)
                _Record(
                  careerId: widget.careerId,
                  a: byId[_a]!,
                  b: byId[_b]!,
                )
              else ...[
                if (_a == _b && _a != null)
                  _Hint(text: l.recordsPickTwoDifferent),
                // Your current team's record against everyone you've faced —
                // tap an opponent to see the full breakdown.
                _MyLedger(
                  careerId: widget.careerId,
                  onPick: (id) => setState(() => _b = id),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pick(List<Nation> nations, ValueChanged<int> onPick) async {
    final id = await showAdaptiveSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _NationPickerSheet(nations: nations),
    );
    if (id != null && mounted) onPick(id);
  }

  /// The home slot's picker; the tablet's slots call these, so both layouts
  /// set the pair the same way.
  void _pickA(List<Nation> nations) =>
      _pick(nations, (id) => setState(() => _a = id));

  void _pickB(List<Nation> nations) =>
      _pick(nations, (id) => setState(() => _b = id));

  /// An opponent picked off the manager's ledger, as the away side.
  void _chooseB(int id) => setState(() => _b = id);
}

class _NationSlot extends StatelessWidget {
  const _NationSlot({
    required this.careerId,
    required this.label,
    required this.nation,
    required this.onTap,
  });

  final int careerId;
  final String label;
  final Nation? nation;

  /// Opens the nation picker. The flag and name of a chosen nation open that
  /// nation's page instead; the label and the card's edge still pick.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          () {
            final chosen = nation;
            final identity = Column(
              children: [
                FlagDisc(chosen?.code ?? '??', size: 40),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  chosen?.name ?? l.recordsSelect,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: chosen == null ? AppColors.onSurfaceVariant : null,
                  ),
                ),
              ],
            );
            return chosen == null
                ? identity
                : NationTap(
                    careerId: careerId,
                    nationId: chosen.id,
                    child: identity,
                  );
          }(),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Your current team's head-to-head ledger against every opponent it has met.
class _MyLedger extends ConsumerWidget {
  const _MyLedger({required this.careerId, required this.onPick});

  final int careerId;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(myHeadToHeadsProvider(careerId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text(l.recordsCouldNotLoadYourRecord(e.toString())),
      data: (lines) {
        if (lines.isEmpty) {
          return _Hint(text: l.recordsPlayToBuildRecord);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.recordsYourRecord,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.recordsTapOpponent,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final line in lines)
                    InkWell(
                      onTap: () => onPick(line.opponentId),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            FlagDisc(line.opponentCode, size: 24),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.opponentName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodyMedium,
                                  ),
                                  Text(
                                    l.recordsPlayedScore(
                                      line.played,
                                      line.goalsFor,
                                      line.goalsAgainst,
                                    ),
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _WdlPill(
                              w: line.wins,
                              d: line.draws,
                              l: line.losses,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A compact W-D-L record chip.
class _WdlPill extends StatelessWidget {
  const _WdlPill({required this.w, required this.d, required this.l});

  final int w;
  final int d;
  final int l;

  @override
  Widget build(BuildContext context) {
    Widget seg(int v, Color c) => Text(
      '$v',
      style: AppTypography.labelMedium.copyWith(
        color: c,
        fontWeight: FontWeight.w700,
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        seg(w, AppColors.positive),
        Text(
          '-',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        seg(d, AppColors.onSurfaceVariant),
        Text(
          '-',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        seg(l, AppColors.error),
      ],
    );
  }
}

class _Record extends ConsumerWidget {
  const _Record({
    required this.careerId,
    required this.a,
    required this.b,
    this.showAllMeetings = true,
  });

  final int careerId;
  final Nation a;
  final Nation b;

  /// Whether to offer the full list of meetings. Not where that list is
  /// already on show under the record (the tablet's pane).
  final bool showAllMeetings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      headToHeadProvider(
        (careerId: careerId, nationA: a.id, nationB: b.id),
      ),
    );
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text(l.recordsCouldNotLoadRecord(e.toString())),
      data: (h) {
        if (h.played == 0) {
          return _Hint(text: l.recordsNeverMet(a.name, b.name));
        }
        return Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Tally(value: h.winsA, label: l.recordsCodeWins(a.code)),
                      _Tally(value: h.draws, label: l.recordsDraws),
                      _Tally(value: h.winsB, label: l.recordsCodeWins(b.code)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WinBar(winsA: h.winsA, draws: h.draws, winsB: h.winsB),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.recordsMeetingsCount(h.played),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  _statRow(l.recordsGoalsLabel, '${h.goalsA}', '${h.goalsB}'),
                  _statRow(
                    l.recordsBiggestWin,
                    h.biggestWinMarginA == 0 ? '—' : '+${h.biggestWinMarginA}',
                    h.biggestWinMarginB == 0 ? '—' : '+${h.biggestWinMarginB}',
                  ),
                ],
              ),
            ),
            if (showAllMeetings) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    '${Routes.h2hMeetings}?careerId=$careerId'
                    '&a=${a.id}&b=${b.id}',
                  ),
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(l.recordsSeeAllMeetings),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _statRow(String label, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              left,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) => Text(
                label.capsIn(Localizations.localeOf(context).languageCode),
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              right,
              textAlign: TextAlign.end,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tally extends StatelessWidget {
  const _Tally({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: AppTypography.headlineMedium),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _WinBar extends StatelessWidget {
  const _WinBar({
    required this.winsA,
    required this.draws,
    required this.winsB,
  });

  final int winsA;
  final int draws;
  final int winsB;

  @override
  Widget build(BuildContext context) {
    final total = (winsA + draws + winsB).clamp(1, 1 << 30);
    return ClipRRect(
      borderRadius: AppRadii.smAll,
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Expanded(
              flex: winsA,
              child: const ColoredBox(color: AppColors.positive),
            ),
            Expanded(
              flex: draws,
              child: const ColoredBox(color: AppColors.onSurfaceVariant),
            ),
            Expanded(
              flex: winsB,
              child: const ColoredBox(color: AppColors.error),
            ),
            // Guard against an all-zero row (never rendered, but safe).
            if (total == 0) const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _NationPickerSheet extends StatefulWidget {
  const _NationPickerSheet({required this.nations});

  final List<Nation> nations;

  @override
  State<_NationPickerSheet> createState() => _NationPickerSheetState();
}

class _NationPickerSheetState extends State<_NationPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.nations
        : widget.nations
              .where(
                (n) =>
                    n.name.toLowerCase().contains(q) ||
                    n.code.toLowerCase().contains(q),
              )
              .toList();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.onSurfaceVariant,
                borderRadius: AppRadii.smAll,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l.recordsSearchNation,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  border: const OutlineInputBorder(
                    borderRadius: AppRadii.baseAll,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final n = filtered[i];
                  return ListTile(
                    leading: FlagDisc(n.code, size: 28),
                    title: Text(n.name, style: AppTypography.bodyMedium),
                    onTap: () => Navigator.of(context).pop(n.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
