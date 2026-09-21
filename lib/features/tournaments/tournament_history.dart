import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart'
    show AllTimeScorer;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The height a tournament screen's TabBar occupies.
///
/// Taller than the tabs themselves (Flutter's default is ~46), so the labels
/// aren't jammed against the content below them.
const double kTournamentTabBarHeight = 60;

/// A placeholder for a tab whose content doesn't exist yet.
class TournamentSoon extends StatelessWidget {
  const TournamentSoon({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, color: AppColors.outline),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A competition's scorer chart, best first.
class TournamentScorers extends StatefulWidget {
  const TournamentScorers({
    required this.scorers,
    required this.playerNames,
    required this.code,
    this.allTime = const [],
    this.emptyMessage = 'No goals scored yet.',
    super.key,
  });

  final List<ScorerTally> scorers;
  final Map<int, String> playerNames;
  final String Function(int) code;

  /// The competition's all-time scorers across every cycle (with names and an
  /// active flag). When non-empty a "This edition / All-time" toggle appears.
  final List<AllTimeScorer> allTime;
  final String emptyMessage;

  @override
  State<TournamentScorers> createState() => _TournamentScorersState();
}

class _TournamentScorersState extends State<TournamentScorers> {
  bool _allTime = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasAllTime = widget.allTime.isNotEmpty;
    final showingAllTime = _allTime && hasAllTime;
    final count = showingAllTime
        ? widget.allTime.length
        : widget.scorers.length;
    if (count == 0 && !hasAllTime) {
      return TournamentSoon(message: widget.emptyMessage);
    }
    return Column(
      children: [
        if (hasAllTime)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.marginMobile,
              AppSpacing.marginMobile,
              0,
            ),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(l.tourSharedThisEdition),
                ),
                ButtonSegment(value: true, label: Text(l.tourSharedAllTime)),
              ],
              selected: {_allTime},
              onSelectionChanged: (s) => setState(() => _allTime = s.first),
            ),
          ),
        Expanded(
          child: count == 0
              ? TournamentSoon(message: widget.emptyMessage)
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  itemCount: count,
                  itemBuilder: (context, i) => showingAllTime
                      ? _allTimeRow(i, widget.allTime[i])
                      : _editionRow(i, widget.scorers[i]),
                ),
        ),
      ],
    );
  }

  Widget _editionRow(int i, ScorerTally s) => _row(
    rank: i + 1,
    nationId: s.nationId,
    name: widget.playerNames[s.playerId] ?? 'Unknown',
    goals: s.goals,
    active: false,
  );

  Widget _allTimeRow(int i, AllTimeScorer s) => _row(
    rank: i + 1,
    nationId: s.nationId,
    name: s.name,
    goals: s.goals,
    active: s.active,
  );

  Widget _row({
    required int rank,
    required int nationId,
    required String name,
    required int goals,
    required bool active,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            FlagDisc(widget.code(nationId), size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              // The scorer's name, and an ellipsis is not an option: the row
              // shares its width with a rank, a flag, an ACTIVE badge and the
              // goal count, which left "Bartholomew Vanderberghe" reading
              // "Bartholomew Vanderb..." at 400 points. It gives up its
              // forename first, and only then a little of its size.
              child: WholeText(
                name,
                maxLines: 1,
                shortText: initialledName(name),
                style: AppTypography.bodyMedium,
              ),
            ),
            // The one mark every all-time chart uses for a man still playing
            // (and the edition chart never needs, since everyone on it is).
            if (active) ...[
              const ActiveBadge(),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              '$goals',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A competition's roll of honour: the all-time medal table, then every past
/// edition with its host and final scoreline.
///
/// Shared by every tournament screen, so a competition's history reads the same
/// wherever it is shown.
class TournamentHistory extends StatelessWidget {
  const TournamentHistory({
    required this.honours,
    required this.name,
    required this.code,
    this.emptyMessage = 'No past winners yet.',
    this.header,
    super.key,
  });

  final List<Honour> honours;
  final String Function(int) name;
  final String Function(int) code;
  final String emptyMessage;

  /// An optional note above the medal table (e.g. when the cup is out of
  /// season).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    if (honours.isEmpty) {
      return TournamentSoon(message: emptyMessage);
    }

    final gold = <int, int>{};
    final silver = <int, int>{};
    final bronze = <int, int>{};
    for (final h in honours) {
      gold[h.championId] = (gold[h.championId] ?? 0) + 1;
      silver[h.runnerUpId] = (silver[h.runnerUpId] ?? 0) + 1;
      // Both bronze slots count — a no-third-place cup shares bronze between
      // its two beaten semi-finalists (thirdId + thirdId2).
      if (h.thirdId != null) {
        bronze[h.thirdId!] = (bronze[h.thirdId!] ?? 0) + 1;
      }
      if (h.thirdId2 != null) {
        bronze[h.thirdId2!] = (bronze[h.thirdId2!] ?? 0) + 1;
      }
    }
    final medalNations = {...gold.keys, ...silver.keys, ...bronze.keys}.toList()
      ..sort((a, b) {
        final g = (gold[b] ?? 0).compareTo(gold[a] ?? 0);
        if (g != 0) return g;
        final s = (silver[b] ?? 0).compareTo(silver[a] ?? 0);
        if (s != 0) return s;
        return (bronze[b] ?? 0).compareTo(bronze[a] ?? 0);
      });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (header != null) ...[
          header!,
          const SizedBox(height: AppSpacing.md),
        ],
        Text(
          AppLocalizations.of(context).tourMedalTable,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: [
              for (final id in medalNations.take(10))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      FlagDisc(code(id), size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          name(id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      _medalCount('🥇', gold[id] ?? 0),
                      _medalCount('🥈', silver[id] ?? 0),
                      _medalCount('🥉', bronze[id] ?? 0),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppLocalizations.of(context).tourSharedPastWinners,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final h in honours) _editionCard(AppLocalizations.of(context), h),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _medalCount(String emoji, int n) => SizedBox(
    width: 34,
    child: Text(
      '$emoji$n',
      textAlign: TextAlign.center,
      style: AppTypography.labelSmall,
    ),
  );

  /// Every host of [h], falling back to the lone `Honour.hostId` for a row
  /// written before co-hosts were tracked as a list.
  List<int> _hostsOf(Honour h) =>
      h.hostIds.isNotEmpty ? h.hostIds : [if (h.hostId != null) h.hostId!];

  /// One edition's full podium.
  ///
  /// Every tournament records its runner-up, its third place and the final's
  /// scoreline — but this card used to name only the champion and reduce the
  /// runner-up to an unlabelled flag, with third place not shown at all. For a
  /// competition simulated in the background, this card *is* the result.
  Widget _editionCard(AppLocalizations l, Honour h) {
    final scored = h.finalHomeScore != null && h.finalAwayScore != null;
    final pens = scored && h.finalHomeScore == h.finalAwayScore;
    final score = !scored
        ? ''
        : '${h.finalHomeScore}–${h.finalAwayScore}${pens ? ' (pens)' : ''}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${h.year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                if (_hostsOf(h).isNotEmpty)
                  Expanded(
                    child: Text(
                      _hostsOf(h).length == 1
                          ? l.tourHostLine(name(_hostsOf(h).single))
                          : l.tourHostLineMulti(
                              _hostsOf(h).map(code).join(' · '),
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // The final, as a result rather than a winner: both sides named,
            // with the scoreline between them.
            Row(
              children: [
                Expanded(
                  child: _podiumSide(h.championId, champion: true),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    score.isEmpty ? 'beat' : score,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: _podiumSide(h.runnerUpId, champion: false),
                ),
              ],
            ),
            // Both bronze medallists — a no-third-place cup lists its two
            // beaten semi-finalists, so the whole podium shows.
            for (final b in [h.thirdId, h.thirdId2])
              if (b != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const SizedBox(width: 2),
                    const Text('🥉', style: AppTypography.labelSmall),
                    const SizedBox(width: AppSpacing.sm),
                    FlagDisc(code(b), size: 16),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        name(b),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget _podiumSide(int nationId, {required bool champion}) => Row(
    children: [
      if (champion) ...[
        const Icon(Icons.emoji_events, color: AppColors.primary, size: 16),
        const SizedBox(width: 4),
      ],
      FlagDisc(code(nationId), size: champion ? 22 : 18),
      const SizedBox(width: AppSpacing.sm),
      Flexible(
        child: Text(
          name(nationId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: champion ? FontWeight.w700 : FontWeight.w400,
            color: champion ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
