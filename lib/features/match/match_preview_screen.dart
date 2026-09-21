import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/strength_factors.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/features/match/strength_panel.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The World Cup finals rounds — a match on one of these is host-themed once
/// the tournament has kicked off.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};

/// The continental championship's finals rounds, which get the same host
/// re-skin as the World Cup ones.
const _continentalFinalsRounds = {
  'CGROUP',
  'CR32',
  'CR16',
  'CQF',
  'CSF',
  'C3RD',
  'CFINAL',
};

/// Shown before a match kicks off: the fixture, your starting XI (with each
/// player's slot and any out-of-position flag), and the chance to adjust the
/// lineup before playing. "Kick off" starts the live match.
class MatchPreviewScreen extends ConsumerWidget {
  const MatchPreviewScreen({required this.careerId, super.key});

  final int careerId;

  Future<void> _openTactics(BuildContext context, WidgetRef ref) async {
    // Push (don't replace) so returning lands back on the preview, then refresh
    // it to pick up the new lineup.
    await context.push('${Routes.tactics}?careerId=$careerId');
    ref.invalidate(matchPreviewProvider(careerId));
    // And the strength panel with it: a familiarity reading taken before the
    // manager changed his shape is the one failure this panel cannot have, as
    // the whole point of it is to show him that changing his shape matters.
    ref.invalidate(strengthFactorsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final previewAsync = ref.watch(matchPreviewProvider(careerId));
    final wcHost = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final contHost = ref
        .watch(continentalHostThemeProvider(careerId))
        .valueOrNull;
    // Whichever finals is live re-skins this screen; the World Cup wins if both
    // somehow are. [themedRounds] is that tournament's own set of rounds, so
    // the banner only appears on a match actually being played in it.
    final activeWc = wcHost?.active ?? false;
    final host = activeWc
        ? wcHost
        : (contHost?.active ?? false)
        ? contHost
        : null;
    final themedRounds = activeWc ? _wcFinalsRounds : _continentalFinalsRounds;
    final accent = host?.accent ?? AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l10n.matchPreviewTitle,
          style: AppTypography.labelMedium.copyWith(color: accent),
        ),
        centerTitle: true,
      ),
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.matchCouldNotLoad('$e'))),
        data: (preview) {
          if (preview == null) {
            return Center(child: Text(l10n.matchNoUpcoming));
          }
          final f = preview.fixture;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) =>
              preview.nations[id]?.name ?? l10n.matchUnknownNation;
          final team = preview.playerIsHome
              ? preview.homeTeam
              : preview.awayTeam;
          final positions = team.formation.positions;
          final myNationId = preview.playerIsHome
              ? f.homeNationId
              : f.awayNationId;
          final oppNationId = preview.playerIsHome
              ? f.awayNationId
              : f.homeNationId;
          final hosted = host != null && themedRounds.contains(f.round);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              if (hosted) ...[
                WcHostBanner(theme: host, code: code),
                const SizedBox(height: AppSpacing.md),
              ],
              Center(
                child: Text(
                  MatchStage.label(l10n, f),
                  style: AppTypography.labelSmall.copyWith(
                    color: hosted ? accent : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Both the armband and the set-piece takers default to "let the
              // engine decide", which is fine to play with and terrible to
              // never be told about.
              SquadSetupWarning(careerId: careerId),
              MatchHeadline(
                homeCode: code(f.homeNationId),
                homeOverall: squadOverall(preview.homeTeam.xi),
                awayCode: code(f.awayNationId),
                awayOverall: squadOverall(preview.awayTeam.xi),
                date: f.date,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Head-to-head and the scouting report share one card as two
              // tabs — they were stacked, which pushed the starting XI (the
              // thing the manager is actually here to check) below the fold.
              _OpponentTabs(
                careerId: careerId,
                myNationId: myNationId,
                oppNationId: oppNationId,
                oppName: name(oppNationId),
                oppCode: code(oppNationId),
                keyMen: _keyMen(
                  preview.playerIsHome
                      ? preview.awayTeam.xi
                      : preview.homeTeam.xi,
                ),
                saveSeed: preview.saveSeed,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.matchGroundTitle,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GroundCard(
                ground: preview.ground,
                neutral: preview.neutralVenue,
                groundNationCode: code(preview.ground.groundNationId),
              ),
              const SizedBox(height: AppSpacing.lg),
              // What is helping and what is hurting, before he picks. Every
              // line of it already moved the result and none of it was ever
              // said out loud.
              StrengthPanel(
                careerId: careerId,
                formation: team.formation,
                sideRating: team.xi.isEmpty
                    ? StrengthFactors.defaultSideRating
                    : squadOverall(team.xi),
              ),
              Row(
                children: [
                  Text(
                    l10n.matchYourXi,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    team.formation.label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < team.xi.length; i++)
                      _XiRow(
                        player: team.xi[i],
                        slot: i < positions.length
                            ? positions[i]
                            : team.xi[i].position,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: l10n.matchKickOff,
                  icon: Icons.sports_soccer,
                  onPressed: () =>
                      context.go('${Routes.match}?careerId=$careerId'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openTactics(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.matchTactics),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The opponent briefing: head-to-head and the scouting report as two tabs of
/// one card, head-to-head open by default.
class _OpponentTabs extends StatefulWidget {
  const _OpponentTabs({
    required this.careerId,
    required this.myNationId,
    required this.oppNationId,
    required this.oppName,
    required this.oppCode,
    required this.keyMen,
    required this.saveSeed,
  });

  final int careerId;
  final int myNationId;
  final int oppNationId;
  final String oppName;
  final String oppCode;
  final List<Player> keyMen;
  final int saveSeed;

  @override
  State<_OpponentTabs> createState() => _OpponentTabsState();
}

class _OpponentTabsState extends State<_OpponentTabs> {
  /// 0 = head-to-head (the default), 1 = the scouting report.
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _tabButton(
                  label: l.matchHeadToHead,
                  icon: Icons.compare_arrows,
                  index: 0,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _tabButton(
                  label: l.matchDossierTitle,
                  icon: Icons.assignment_rounded,
                  index: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_tab == 0)
            _H2HBody(
              careerId: widget.careerId,
              myNationId: widget.myNationId,
              oppNationId: widget.oppNationId,
              oppName: widget.oppName,
            )
          else
            _DossierBody(
              careerId: widget.careerId,
              oppNationId: widget.oppNationId,
              oppName: widget.oppName,
              oppCode: widget.oppCode,
              keyMen: widget.keyMen,
              saveSeed: widget.saveSeed,
            ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSmall.copyWith(
                  color: active
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _H2HBody extends ConsumerWidget {
  const _H2HBody({
    required this.careerId,
    required this.myNationId,
    required this.oppNationId,
    required this.oppName,
  });

  final int careerId;
  final int myNationId;
  final int oppNationId;
  final String oppName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      headToHeadProvider(
        (careerId: careerId, nationA: myNationId, nationB: oppNationId),
      ),
    );
    return async.when(
      loading: () => const SizedBox(height: 72),
      error: (_, _) => const SizedBox.shrink(),
      data: (h) {
        final edge = h.played == 0
            ? l.matchH2hFirstMeeting
            : h.winsA > h.winsB
            ? l.matchH2hYouLead
            : h.winsA < h.winsB
            ? l.matchH2hOppEdge(oppName)
            : l.matchH2hEven;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              h.played == 0 ? '—' : l.matchH2hMet(h.played),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            if (h.played > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Tally(
                    value: h.winsA,
                    label: l.matchH2hWon,
                    color: AppColors.positive,
                  ),
                  _Tally(
                    value: h.draws,
                    label: l.matchH2hDrawn,
                    color: AppColors.onSurfaceVariant,
                  ),
                  _Tally(
                    value: h.winsB,
                    label: l.matchH2hLost,
                    color: AppColors.error,
                  ),
                  _Tally(
                    value: h.goalsA,
                    label: 'GF',
                    color: AppColors.onSurface,
                  ),
                  _Tally(
                    value: h.goalsB,
                    label: 'GA',
                    color: AppColors.onSurface,
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    edge,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (h.played > 0)
                  // The card is no longer tappable as a whole (its tabs are),
                  // so the way through to every past meeting is explicit.
                  TextButton(
                    onPressed: () => context.push(
                      '${Routes.h2hMeetings}?careerId=$careerId'
                      '&a=$myNationId&b=$oppNationId',
                    ),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                    child: Text(l.recordsMeetings),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// The opponent's three highest-rated players — the "key men" of the dossier.
List<Player> _keyMen(List<Player> xi) {
  final sorted = [...xi]..sort((a, b) => b.overall.compareTo(a.overall));
  return sorted.take(3).toList();
}

/// A pre-match scouting report on the opponent: their recent form (a W/D/L
/// strip), a morale read, and their danger men — everything derived from data
/// already recorded, so it costs nothing to keep.
class _DossierBody extends ConsumerWidget {
  const _DossierBody({
    required this.careerId,
    required this.oppNationId,
    required this.oppName,
    required this.oppCode,
    required this.keyMen,
    required this.saveSeed,
  });

  final int careerId;
  final int oppNationId;
  final String oppName;
  final String oppCode;
  final List<Player> keyMen;
  final int saveSeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationFormProvider((careerId: careerId, nationId: oppNationId)),
    );
    final form = async.valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FlagDisc(oppCode, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                oppName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text(
              l.matchDossierForm,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (form == null || form.results.isEmpty)
              Text(
                l.matchDossierNoGames,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              for (final r in form.results.reversed) ...[
                _FormPip(result: r),
                const SizedBox(width: 4),
              ],
            const Spacer(),
            if (form != null)
              Text(
                Condition.moraleLabel(form.morale),
                style: AppTypography.labelSmall.copyWith(
                  color: form.morale >= 60
                      ? AppColors.positive
                      : form.morale >= 42
                      ? AppColors.onSurfaceVariant
                      : AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        if (keyMen.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.matchDossierKeyMen,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final p in keyMen) _KeyManRow(player: p, saveSeed: saveSeed),
        ],
      ],
    );
  }
}

/// One W/D/L result as a small coloured pip in the form strip.
class _FormPip extends StatelessWidget {
  const _FormPip({required this.result});

  /// +1 win, 0 draw, −1 loss.
  final int result;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (result) {
      > 0 => ('W', AppColors.positive),
      < 0 => ('L', AppColors.error),
      _ => ('D', AppColors.onSurfaceVariant),
    };
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// One danger man: their best position, name and overall rating.
class _KeyManRow extends StatelessWidget {
  const _KeyManRow({required this.player, required this.saveSeed});

  final Player player;
  final int saveSeed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              player.position.label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
          // What to watch for in him — the scouting report's whole job.
          PlayerTraitGlyphs(player: player, saveSeed: saveSeed),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${player.overall}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Tally extends StatelessWidget {
  const _Tally({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTypography.titleMedium.copyWith(color: color),
        ),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// The fixture's headline: both squads' strength either side of the kick-off.
///
/// Its own widget so the width guard can pump the one row on this screen that
/// is genuinely tight — three columns laid out `spaceEvenly` with no [Expanded]
/// anywhere, so every one of them takes the width its longest word asks for
/// and the row bursts rather than ellipsising when they do not fit. Czech asks
/// for more of that width than English at every point: a longer word for the
/// squad's overall, and a date that carries a full stop the English one does
/// not.
class MatchHeadline extends StatelessWidget {
  const MatchHeadline({
    required this.homeCode,
    required this.homeOverall,
    required this.awayCode,
    required this.awayOverall,
    required this.date,
    super.key,
  });

  final String homeCode;
  final int homeOverall;
  final String awayCode;
  final int awayOverall;

  /// When the match kicks off, written for the manager by [AppDate].
  final DateTime date;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Flexible, all three: every child here used to take the width its
      // longest word asked for, so two overalls plus the date came to more
      // than a 360pt phone has and the row painted outside its own card.
      //
      // The share of the width is only half the fix. The Czech label read
      // "Celkový přehled" — fifteen characters against the English seven —
      // and a share it could be held to still cut the NUMBER off the end,
      // which is the one thing on this card the manager came to read. So the
      // label gave way instead: "Celkově" says the same thing in seven.
      Flexible(
        child: _Side(code: homeCode, overall: homeOverall),
      ),
      Flexible(
        child: Column(
          children: [
            const Text('VS', style: AppTypography.labelLarge),
            const SizedBox(height: 2),
            Text(
              AppDate.weekdayDayMonthCaps(context, date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      Flexible(
        child: _Side(code: awayCode, overall: awayOverall),
      ),
    ],
  );
}

class _Side extends StatelessWidget {
  const _Side({required this.code, required this.overall});
  final String code;

  /// The side's team overall, so the two numbers sit either side of the "VS"
  /// and the manager can read the gap before kick-off.
  final int overall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        FlagDisc(code, size: 48),
        const SizedBox(height: AppSpacing.xs),
        Text(code, maxLines: 1, style: AppTypography.labelMedium),
        const SizedBox(height: 2),
        Text(
          '${l10n.teamOverall} $overall',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// One starting-XI row: the slot the player fills, their name and rating, with
/// a colour cue when they're fielded out of position.
class _XiRow extends StatelessWidget {
  const _XiRow({required this.player, required this.slot});

  final Player player;
  final PlayerPosition slot;

  @override
  Widget build(BuildContext context) {
    final Color fit;
    if (player.position == slot) {
      fit = AppColors.positive;
    } else if (player.category == slot.category) {
      fit = AppColors.primary;
    } else {
      fit = AppColors.error;
    }
    // The player's overall is shown as-is — the same number the squad screen
    // and the live match show. Only the positional dock is annotated, so a
    // footballer never appears to be rated differently on different screens.
    final effective = PositionFit.effectiveOverall(player, slot);
    final penalised = effective < player.overall;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              slot.label,
              style: AppTypography.labelSmall.copyWith(
                color: fit,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
          Text(
            '${player.overall}',
            style: AppTypography.labelMedium.copyWith(
              color: penalised ? AppColors.error : AppColors.primary,
            ),
          ),
          if (penalised)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                '→$effective',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
