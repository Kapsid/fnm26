import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';
import 'package:go_router/go_router.dart';

/// Finals rounds are played on neutral ground, so they carry no H/A marker.
bool _neutral(String? round) =>
    FinalsRounds.worldChampionship.contains(round) ||
    FinalsRounds.continental.contains(round);

/// One fixture of the player's nation: opponent, stage, date, H/A and score.
///
/// Plain `Row`/`Column` with no list inside, so the tablet dashboard tile that
/// reuses it keeps an intrinsic height. An opponent whose draw is unwatched is
/// never named: the row says [AppLocalizations.topBarDrawPending] beside a
/// blank disc, whatever [opponent] holds.
class ScheduleFixtureRow extends StatelessWidget {
  const ScheduleFixtureRow({
    required this.fixture,
    required this.nationId,
    required this.opponent,
    required this.opponentKnown,
    this.onTap,
    super.key,
  });

  final Fixture fixture;

  /// The player's nation, to tell home from away.
  final int nationId;
  final Nation? opponent;
  final bool opponentKnown;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = fixture;
    final home = f.homeNationId == nationId;
    final named = opponentKnown ? opponent : null;
    final marker = _neutral(f.round)
        ? null
        : home
        ? l.scheduleHomeShort
        : l.scheduleAwayShort;
    final settled = f.hasResult && f.wentToShootout
        ? l.recordsOnPenalties(
            home ? f.homePenalties! : f.awayPenalties!,
            home ? f.awayPenalties! : f.homePenalties!,
          )
        : f.hasResult && f.afterExtraTime
        ? l.recordsAfterExtraTime
        : null;
    final dateStyle = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: _dateColumnWidth(context, dateStyle),
              child: Text(
                AppDate.dayMonth(context, f.date),
                maxLines: 1,
                style: dateStyle,
              ),
            ),
            if (named != null)
              FlagDisc(named.code, size: 28)
            else
              const SizedBox(width: 28, height: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    named?.name ?? l.topBarDrawPending,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: named == null
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                    ),
                  ),
                  // Compact and on up to two lines: the full qualifying
                  // banner ("CONTINENTAL CUP QUALIFYING · MD 1") was cut to an
                  // ellipsis on every row of a 390 phone, in English too.
                  Text(
                    MatchStage.labelCompact(l, f),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (marker != null) ...[
              Text(
                marker,
                maxLines: 1,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            if (f.hasResult)
              // Capped, so a long shootout note ("5–4 nos pênaltis") wraps
              // under the score instead of squeezing the opponent to a word.
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _scoreColumnMax),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      // Own score first, like the penalties: a neutral finals
                      // row has no H/A marker to say which side is which.
                      home
                          ? '${f.homeScore}–${f.awayScore}'
                          : '${f.awayScore}–${f.homeScore}',
                      maxLines: 1,
                      style: AppTypography.labelLarge,
                    ),
                    if (settled != null)
                      Text(
                        settled,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The widest the score column may grow: "10–10", or a shootout note set
/// under it on up to two lines.
const double _scoreColumnMax = 72;

/// The width of the date column: the widest `d MMM` this locale can print,
/// and never under the 52 the English layout was drawn at.
///
/// A fixed 52 held only English. The mono face sets about 7.8px a character,
/// so "28. Sept." (German) or "28 janv." (French) wanted up to 70 and broke
/// onto a second line beside every fixture from the 10th of a month on. One
/// width for every row keeps the discs in a column; it is measured, not
/// guessed, so a new language or a larger text scale cannot reopen the gap.
double _dateColumnWidth(BuildContext context, TextStyle style) {
  final scaler = MediaQuery.textScalerOf(context);
  final locale = Localizations.localeOf(context).languageCode;
  return _dateWidths.putIfAbsent('$locale@${scaler.scale(100)}', () {
    var widest = 52.0;
    for (var month = 1; month <= 12; month++) {
      final painter = TextPainter(
        text: TextSpan(
          text: AppDate.dayMonth(context, DateTime(2030, month, 28)),
          style: style,
        ),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      // Rounded up: a fractional width would wrap the last glyph.
      widest = widest < painter.width ? painter.width.ceilToDouble() : widest;
      painter.dispose();
    }
    return widest;
  });
}

final Map<String, double> _dateWidths = {};

/// The row for a stage that exists in the cycle but is not drawn yet.
class SchedulePendingRow extends StatelessWidget {
  const SchedulePendingRow({required this.pending, super.key});

  final SchedulePending pending;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
      fontStyle: FontStyle.italic,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              pending.knockoutStage
                  ? l.scheduleKnockoutPending
                  : l.scheduleNextRoundPending,
              style: style,
            ),
          ),
          Text(
            l.scheduleFromDate(AppDate.dayMonth(context, pending.from)),
            maxLines: 1,
            style: style,
          ),
        ],
      ),
    );
  }
}

/// The one tap rule for a schedule row, or null when the row is not tappable.
///
/// An undrawn opponent is never tappable. The next match opens its preview
/// only when it really is the hub's next step ([HubEventKind.match]); while a
/// draw, call-up or injury cover is still pending, tapping it must not skip
/// that step, so it behaves like any other row and opens the opponent.
VoidCallback? scheduleRowTap(
  BuildContext context, {
  required int careerId,
  required ScheduleData data,
  required Fixture fixture,
  required HubEvent? next,
}) {
  if (!opponentKnown(data, fixture)) return null;
  final idx = data.currentIndex;
  final firstUnplayed = idx < 0
      ? null
      : data.blocks[idx].fixtures.where((f) => !f.hasResult).firstOrNull;
  final route = next?.route;
  if (next?.kind == HubEventKind.match &&
      route != null &&
      firstUnplayed?.id == fixture.id) {
    return () => context.go(route);
  }
  final opponentId = fixture.homeNationId == data.nationId
      ? fixture.awayNationId
      : fixture.homeNationId;
  return () => openNation(context, careerId: careerId, nationId: opponentId);
}

/// The rows of the block the nation is on: the current window's matches
/// still to be played (or one tournament stage) and the stage still to be
/// drawn after them, or one line when the cycle has nothing left. Shared by
/// the phone's Upcoming card and the tablet's next-match panel.
///
/// Plain `Column`, no list or `LayoutBuilder`, so the tablet dashboard tile
/// keeps an intrinsic height. Draw gating and taps come from the shared row
/// rules, so an undrawn opponent is never named or tappable here either.
class UpcomingRows extends ConsumerWidget {
  const UpcomingRows({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final data = ref.watch(scheduleProvider(careerId)).valueOrNull;
    final next = ref.watch(nextEventProvider(careerId)).valueOrNull;
    // A schedule that failed to load reads as nothing left, not an empty card.
    if (data == null) {
      return ref.watch(scheduleProvider(careerId)).isLoading
          ? const SizedBox.shrink()
          : _noMore(l);
    }
    final current = data.currentIndex;
    // With nothing current, a stage that is still to be drawn (a group stage
    // played out, a knockout won) is what comes next, not "no more fixtures".
    final pending = current >= 0
        ? data.blocks[current].pending
        : data.blocks.lastOrNull?.pending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Only what is still to be played: the current window can hold a
        // match already played (the first of a double header, a friendly
        // before the qualifiers), and a result has no place under UPCOMING.
        if (current >= 0)
          for (final f in data.blocks[current].fixtures)
            if (!f.hasResult)
              ScheduleFixtureRow(
                fixture: f,
                nationId: data.nationId,
                opponent:
                    data.nations[f.homeNationId == data.nationId
                        ? f.awayNationId
                        : f.homeNationId],
                opponentKnown: opponentKnown(data, f),
                onTap: scheduleRowTap(
                  context,
                  careerId: careerId,
                  data: data,
                  fixture: f,
                  next: next,
                ),
              ),
        if (pending != null)
          SchedulePendingRow(pending: pending)
        else if (current < 0)
          _noMore(l),
      ],
    );
  }

  Widget _noMore(AppLocalizations l) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Text(
      l.hubNoMoreFixtures,
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );
}
