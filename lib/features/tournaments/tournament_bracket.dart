import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One knockout round of a bracket: its stored round code and display label.
typedef BracketRound = (String round, String label);

/// A tournament's knockout stage, as a list of ties or an aligned visual
/// bracket.
///
/// Shared by every finals screen — the World Cup and the continental
/// championships run the same shape of knockout, and previously each screen
/// carried its own near-identical copy of the tie rows while only the World Cup
/// ever got the visual bracket.
///
/// [rounds] drives the list view and [ladder] the bracket columns; they differ
/// because the third-place play-off is a real round but hangs off the side of
/// the ladder rather than feeding it.
class TournamentBracket extends StatefulWidget {
  const TournamentBracket({
    required this.fixtures,
    required this.rounds,
    required this.ladder,
    required this.playerNationId,
    required this.code,
    required this.name,
    this.champion,
    this.championLabel = 'CHAMPIONS',
    this.runSummary,
    this.groupSeeds = const {},
    this.extraHeader,
    super.key,
  });

  final List<Fixture> fixtures;
  final List<BracketRound> rounds;
  final List<BracketRound> ladder;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  final int? champion;

  /// The banner over the champion (e.g. 'WORLD CHAMPIONS').
  final String championLabel;

  /// How the manager's nation fared, highlighted above the bracket.
  final String? runSummary;

  /// nation id → group seed label (e.g. "A2"), shown against each team.
  final Map<int, String> groupSeeds;

  /// An extra card between the champion banner and the view toggle — the World
  /// Cup shows its team of the tournament here.
  final Widget? extraHeader;

  @override
  State<TournamentBracket> createState() => _TournamentBracketState();
}

class _TournamentBracketState extends State<TournamentBracket> {
  bool _visual = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (widget.runSummary != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              color: AppColors.secondaryContainer,
              child: Row(
                children: [
                  const Icon(
                    Icons.flag_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'YOUR RUN',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.runSummary!,
                      textAlign: TextAlign.end,
                      style: AppTypography.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.champion != null)
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.championLabel,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        widget.name(widget.champion!),
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                ),
                FlagDisc(
                  widget.code(widget.champion!),
                  size: 40,
                  highlighted: true,
                ),
              ],
            ),
          ),
        if (widget.extraHeader != null) ...[
          const SizedBox(height: AppSpacing.md),
          widget.extraHeader!,
        ],
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: false, label: Text(l.tourSharedList)),
            ButtonSegment(value: true, label: Text(l.tourSharedBracket)),
          ],
          selected: {_visual},
          onSelectionChanged: (s) => setState(() => _visual = s.first),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_visual) _bracketView() else ..._listView(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  List<Fixture> _inRound(String round) =>
      widget.fixtures.where((f) => f.round == round).toList();

  List<Widget> _listView() => [
    for (final (round, label) in widget.rounds)
      () {
        final inRound = _inRound(round);
        if (inRound.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final f in inRound) _tie(f),
            ],
          ),
        );
      }(),
  ];

  /// Vertical room for one tie in the bracket columns. The widest round sets
  /// the bracket's height at this much per tie, and every other round spreads
  /// its ties across the same height — which is what keeps each tie sitting
  /// between its two feeders.
  static const double _tieSlot = 58;

  /// The bracket's height: tall enough for the round with the most ties.
  ///
  /// It used to be a flat 460, which is fine for a four-tie quarter-final and
  /// hopeless for a sixteen-tie Round of 32 — the column simply overflowed and
  /// was clipped, with no vertical scroll to reach the rest. The height now
  /// follows the content, and the page's own scroll does the reaching.
  double _bracketHeight() {
    var most = 0;
    for (final (round, _) in widget.ladder) {
      final n = _inRound(round).length;
      if (n > most) most = n;
    }
    return (most * _tieSlot).clamp(240.0, 4000.0);
  }

  /// A horizontal, aligned bracket: one column per round, ties spaced evenly so
  /// each next-round tie sits between its two feeders.
  Widget _bracketView() {
    final columns = <Widget>[];
    for (final (round, label) in widget.ladder) {
      final inRound = _inRound(round);
      if (inRound.isEmpty) continue;
      columns.add(
        SizedBox(
          width: 150,
          child: Column(
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [for (final f in inRound) _miniTie(f)],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: _bracketHeight(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < columns.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              columns[i],
            ],
          ],
        ),
      ),
    );
  }

  /// Whether the manager's nation is contesting this tie — the whole row is
  /// lifted when they are, not just their flag.
  bool _isMine(Fixture f) =>
      f.homeNationId == widget.playerNationId ||
      f.awayNationId == widget.playerNationId;

  Widget _miniTie(Fixture f) {
    final decided = f.hasResult;
    final homeWon = decided && f.homeScore! >= f.awayScore!;
    final mine = _isMine(f);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: mine
            ? AppColors.surfaceContainerHigh
            : AppColors.surfaceContainer,
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: mine ? AppColors.primary : AppColors.outlineVariant,
          width: mine ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _miniSide(f.homeNationId, decided && homeWon, f.homeScore),
          const Divider(height: 6),
          _miniSide(f.awayNationId, decided && !homeWon, f.awayScore),
        ],
      ),
    );
  }

  Widget _miniSide(int nationId, bool winner, int? score) {
    final isPlayer = nationId == widget.playerNationId;
    return Row(
      children: [
        FlagDisc(widget.code(nationId), size: 16, highlighted: isPlayer),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            widget.code(nationId),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              // The side that goes through, in the same green the tables use
              // for an advancing place; your own nation in the accent colour.
              color: winner
                  ? AppColors.positive
                  : isPlayer
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
              fontWeight: winner || isPlayer
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        ),
        if (score != null)
          Text(
            '$score',
            style: AppTypography.labelSmall.copyWith(
              color: winner ? AppColors.positive : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }

  Widget _tie(Fixture f) {
    final decided = f.hasResult;
    final homeWon = decided && f.homeScore! >= f.awayScore!;
    final mine = _isMine(f);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        // The manager's own tie is lifted as a whole row — fill, accent edge
        // and a left bar — rather than being signalled by a flag ring alone.
        color: mine ? AppColors.surfaceContainerHigh : null,
        border: mine
            ? const Border(
                left: BorderSide(color: AppColors.primary, width: 3),
                top: BorderSide(color: AppColors.primary),
                right: BorderSide(color: AppColors.primary),
                bottom: BorderSide(color: AppColors.primary),
              )
            : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(child: _side(f.homeNationId, decided && homeWon)),
            Text(
              decided ? _scoreLine(f) : 'vs',
              style: AppTypography.labelMedium,
            ),
            Expanded(
              child: _side(f.awayNationId, decided && !homeWon, end: true),
            ),
          ],
        ),
      ),
    );
  }

  /// The tie's scoreline, with how it was settled when it went past 90 minutes.
  String _scoreLine(Fixture f) {
    final base = '${f.homeScore} - ${f.awayScore}';
    if (f.wentToShootout) {
      return '$base (${f.homePenalties}-${f.awayPenalties} p)';
    }
    return f.afterExtraTime ? '$base a.e.t.' : base;
  }

  Widget _side(int nationId, bool winner, {bool end = false}) {
    final isPlayer = nationId == widget.playerNationId;
    final seed = widget.groupSeeds[nationId];
    final label = Flexible(
      child: Column(
        crossAxisAlignment: end
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            bracketName(widget.name(nationId), widget.code(nationId)),
            textAlign: end ? TextAlign.end : TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: winner || isPlayer
                  ? FontWeight.w700
                  : FontWeight.w400,
              // Going through is the whole story of a knockout tie, so say it
              // in colour; your own nation stands out in the accent colour even
              // when it isn't (yet) the one advancing.
              color: winner
                  ? AppColors.positive
                  : isPlayer
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
            ),
          ),
          if (seed != null)
            Text(
              'Group $seed',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
    final flag = FlagDisc(
      widget.code(nationId),
      size: 22,
      highlighted: isPlayer,
    );
    // A tick on the side that goes through.
    final through = Icon(
      Icons.check_circle_rounded,
      size: 13,
      color: winner ? AppColors.positive : Colors.transparent,
    );
    final children = end
        ? [
            label,
            const SizedBox(width: 4),
            through,
            const SizedBox(width: 4),
            flag,
          ]
        : [
            flag,
            const SizedBox(width: 4),
            through,
            const SizedBox(width: 4),
            label,
          ];
    return Row(
      mainAxisAlignment: end ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }
}

/// The longest nation name a bracket tie row can hold before the two sides and
/// the scoreline stop fitting on one line.
const int _bracketNameLimit = 14;

/// A bracket-safe label for a nation: its full name when it fits a tie row,
/// otherwise its three-letter code. "Bosnia and Herzegovina" and "United Arab
/// Emirates" used to squeeze the scoreline out of the row (or truncate to an
/// unreadable stub), so long names fall back to the code they're known by.
String bracketName(String name, String code) =>
    name.length <= _bracketNameLimit ? name : code.toUpperCase();

/// The round code without its competition prefix ('CQF' → 'QF'), so one set of
/// labels and orderings serves every tournament.
String baseRound(String round) =>
    round.length > 1 && round.startsWith('C') ? round.substring(1) : round;

const _runOrder = {'R32': 0, 'R16': 1, 'QF': 2, 'SF': 3, '3RD': 4, 'FINAL': 5};
const _runLabel = {
  'R32': 'Round of 32',
  'R16': 'Round of 16',
  'QF': 'Quarter-finals',
  'SF': 'Semi-finals',
  '3RD': 'third-place play-off',
  'FINAL': 'Final',
};

/// A short summary of how [playerNationId] fared, to highlight their run above
/// the bracket ("Knocked out in the Quarter-finals", "Champions!").
///
/// [championTitle] names the prize ('World Champions! 🏆'). Returns null when
/// the nation never reached the finals.
String? playerRunSummary({
  required int playerNationId,
  required int? champion,
  required List<Fixture> knockout,
  required List<FinalsGroupTable> groups,
  required String championTitle,
}) {
  if (champion == playerNationId) return championTitle;

  final own = knockout
      .where(
        (f) =>
            f.homeNationId == playerNationId ||
            f.awayNationId == playerNationId,
      )
      .toList();
  if (own.isEmpty) {
    final reached = groups.any(
      (g) => g.standings.any((s) => s.nationId == playerNationId),
    );
    if (!reached) return null;
    return knockout.isEmpty
        ? 'Contesting the group stage'
        : 'Eliminated in the group stage';
  }

  own.sort((a, b) {
    final ao = _runOrder[baseRound(a.round ?? '')] ?? 0;
    final bo = _runOrder[baseRound(b.round ?? '')] ?? 0;
    return ao.compareTo(bo);
  });
  final deepest = own.last;
  final round = baseRound(deepest.round ?? '');
  final label = _runLabel[round] ?? round;
  if (!deepest.hasResult) return 'Into the $label';

  final won = deepest.homeNationId == playerNationId
      ? deepest.homeScore! >= deepest.awayScore!
      : deepest.awayScore! >= deepest.homeScore!;
  if (round == 'FINAL') return won ? championTitle : 'Runners-up';
  if (round == '3RD') return won ? 'Third place' : 'Fourth place';
  return won ? 'Through from the $label' : 'Knocked out in the $label';
}

/// Group-stage seed for every finalist: nation id → e.g. "A2" (runner-up of
/// Group A), from the finals group tables (standings are ordered best-first).
Map<int, String> groupSeedsOf(List<FinalsGroupTable> groups) {
  final seeds = <int, String>{};
  for (final g in groups) {
    for (var i = 0; i < g.standings.length; i++) {
      seeds[g.standings[i].nationId] = '${g.name}${i + 1}';
    }
  }
  return seeds;
}
