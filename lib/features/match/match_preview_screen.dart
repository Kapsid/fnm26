import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart' show MatchTeam;
import 'package:fnm/domain/services/match/strength_factors.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/match/conditions_note.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/scout_report_view.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/features/match/strength_panel.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'match_preview_tablet_layout.dart';

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

  static const Key tabletLayoutKey = Key('matchPreview.tabletLayout');

  /// Height of both buttons in the bottom bar, the outlined button's own
  /// minimum, so Kick-off and Tactics read as a matched pair.
  static const double _barButtonHeight = 48;

  Future<void> _openTactics(BuildContext context, WidgetRef ref) async {
    // Push (don't replace) so returning lands back on the preview, then refresh
    // it to pick up the new lineup.
    await context.push('${Routes.tactics}?careerId=$careerId');
    // The preview may have been left while tactics was open.
    if (!context.mounted) return;
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
    if (TabletShellScope.isActive(context)) {
      return _MatchPreviewTabletLayout(
        screen: this,
        host: host,
        themedRounds: themedRounds,
        accent: accent,
      );
    }

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
        // Back from tactics, show the refresh rather than the old teamsheet
        // with a Kick off button under it.
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.matchCouldNotLoad('$e'))),
        data: (preview) {
          if (preview == null) {
            return Center(child: Text(l10n.matchNoUpcoming));
          }
          final p = _PreviewParts(
            preview: preview,
            careerId: careerId,
            l10n: l10n,
            host: host,
            themedRounds: themedRounds,
          );
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              if (p.hosted) ...[
                WcHostBanner(theme: host!, code: p.code),
                const SizedBox(height: AppSpacing.md),
              ],
              Center(
                child: Text(
                  MatchStage.label(l10n, p.fixture),
                  style: AppTypography.labelSmall.copyWith(
                    color: p.hosted ? accent : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Both the armband and the set-piece takers default to "let the
              // engine decide", which is fine to play with and terrible to
              // never be told about.
              SquadSetupWarning(careerId: careerId),
              p.headline(),
              const SizedBox(height: AppSpacing.lg),
              p.briefing(),
              const SizedBox(height: AppSpacing.lg),
              p.groundTitle(),
              const SizedBox(height: AppSpacing.sm),
              p.ground(),
              const SizedBox(height: AppSpacing.lg),
              p.strength(),
              p.xiHeader(),
              const SizedBox(height: AppSpacing.sm),
              p.xiCard(),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          // Two equal halves, one height.
          //
          // Kick-off used to take two thirds of the bar at the primary
          // button's full 52, which left Tactics a third: on a 412-wide phone
          // with the system font turned up, the outlined button's own 24-a-side
          // padding and its icon ate most of that and "Taktika" broke over two
          // lines inside a button built for one. Kick-off is a short word in
          // both languages and scales itself down if it ever is not, so it
          // gives up the width and the extra height; Tactics gets half the bar,
          // tighter padding, and a label that shrinks rather than wraps.
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: l10n.matchKickOff,
                  icon: Icons.sports_soccer,
                  height: _barButtonHeight,
                  onPressed: () =>
                      context.go('${Routes.match}?careerId=$careerId'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openTactics(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.matchTactics,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(_barButtonHeight),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
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

/// Everything both preview layouts read off one [MatchPreview], worked out
/// once, and the pieces both draw. The phone stacks them in one list; the
/// tablet splits them over two columns.
class _PreviewParts {
  _PreviewParts({
    required this.preview,
    required this.careerId,
    required this.l10n,
    required WcHostTheme? host,
    required Set<String> themedRounds,
  }) : hosted = host != null && themedRounds.contains(preview.fixture.round);

  final MatchPreview preview;
  final int careerId;
  final AppLocalizations l10n;

  /// Whether this match is played in the live finals, under its host's skin.
  final bool hosted;

  Fixture get fixture => preview.fixture;

  MatchTeam get team =>
      preview.playerIsHome ? preview.homeTeam : preview.awayTeam;

  int get myNationId =>
      preview.playerIsHome ? fixture.homeNationId : fixture.awayNationId;

  int get oppNationId =>
      preview.playerIsHome ? fixture.awayNationId : fixture.homeNationId;

  String code(int id) => preview.nations[id]?.code ?? '??';

  String name(int id) => preview.nations[id]?.name ?? l10n.matchUnknownNation;

  Widget headline() => MatchHeadline(
    homeCode: code(fixture.homeNationId),
    homeOverall: squadOverall(preview.homeTeam.xi),
    awayCode: code(fixture.awayNationId),
    awayOverall: squadOverall(preview.awayTeam.xi),
    date: fixture.date,
    careerId: careerId,
    homeNationId: fixture.homeNationId,
    awayNationId: fixture.awayNationId,
  );

  // Head-to-head and the scouting report share one card as two tabs: they
  // were stacked, which pushed the starting XI (the thing the manager is
  // actually here to check) below the fold.
  Widget briefing({bool capitals = false}) => OpponentBriefing(
    capitals: capitals,
    careerId: careerId,
    myNationId: myNationId,
    oppNationId: oppNationId,
    oppName: name(oppNationId),
    oppCode: code(oppNationId),
    keyMen: _keyMen(
      preview.playerIsHome ? preview.awayTeam.xi : preview.homeTeam.xi,
    ),
    saveSeed: preview.saveSeed,
  );

  Widget groundTitle() => Text(
    l10n.matchGroundTitle,
    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
  );

  // The ground, and under it what its altitude and heat will do to the legs.
  Widget ground() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GroundCard(
        ground: preview.ground,
        neutral: preview.neutralVenue,
        groundNationCode: code(preview.ground.groundNationId),
        fans: preview.homeFans,
      ),
      ConditionsNote(
        conditions: preview.conditions,
        playerIsHome: preview.playerIsHome,
      ),
    ],
  );

  // What is helping and what is hurting, before he picks. Every line of it
  // already moved the result and none of it was ever said out loud.
  Widget strength() => StrengthPanel(
    careerId: careerId,
    formation: team.formation,
    sideRating: team.xi.isEmpty
        ? StrengthFactors.defaultSideRating
        : squadOverall(team.xi),
  );

  Widget xiHeader() => Row(
    children: [
      Text(
        l10n.matchYourXi,
        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      ),
      const SizedBox(width: AppSpacing.sm),
      Text(
        team.formation.label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ],
  );

  Widget xiCard() {
    final xi = team.xi;
    final positions = team.formation.positions;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          for (var i = 0; i < xi.length; i++)
            _XiRow(
              player: xi[i],
              slot: i < positions.length ? positions[i] : xi[i].position,
            ),
        ],
      ),
    );
  }
}

/// The opponent briefing: head to head and the scouting report as two tabs of
/// one card, head to head open by default. Shared by the preview and the
/// tablet Tactics screen's Opposition tab.
class OpponentBriefing extends StatefulWidget {
  const OpponentBriefing({
    required this.careerId,
    required this.myNationId,
    required this.oppNationId,
    required this.oppName,
    required this.oppCode,
    required this.keyMen,
    required this.saveSeed,
    this.capitals = false,
    super.key,
  });

  final int careerId;
  final int myNationId;
  final int oppNationId;
  final String oppName;
  final String oppCode;
  final List<Player> keyMen;
  final int saveSeed;

  /// Writes the two tab labels in capitals, as the tablet writes its tabs.
  /// The copy has one in capitals and one not; the phone keeps them as they
  /// are.
  final bool capitals;

  @override
  State<OpponentBriefing> createState() => _OpponentBriefingState();
}

class _OpponentBriefingState extends State<OpponentBriefing> {
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
                widget.capitals
                    ? label.capsIn(Localizations.localeOf(context).languageCode)
                    : label,
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
                  //
                  // It did not LOOK explicit. This was the app bar's own
                  // "MEETINGS" in a bare TextButton, so a heading's word in a
                  // heading's case with no icon and no border, sitting under
                  // two outlined tabs that did look like controls. A tester
                  // reported it as not looking like a button, which it did
                  // not. Sentence case and a chevron, in the accent colour
                  // everything else tappable uses.
                  TextButton.icon(
                    onPressed: () => context.push(
                      '${Routes.h2hMeetings}?careerId=$careerId'
                      '&a=$myNationId&b=$oppNationId',
                    ),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.chevron_right_rounded, size: 18),
                    label: Text(
                      l.matchPreviewAllMeetings,
                      maxLines: 1,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
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

/// The three best-rated players in [nationId]'s pool: the danger men for the
/// tablet Tactics screen's scouting dossier.
///
/// The preview reads them off the opponent's named XI. Tactics cannot: the
/// one provider holding that XI ([matchPreviewProvider]) also pre-simulates
/// the match, and keeping it alive while the manager changes his line-up
/// would hand the preview a result simulated with the old one. Barring an
/// injury the pool's best three are the XI's best three.
final AutoDisposeFutureProviderFamily<
  List<Player>,
  ({int careerId, int nationId})
>
opponentKeyMenProvider = FutureProvider.autoDispose
    .family<List<Player>, ({int careerId, int nationId})>((ref, key) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return const <Player>[];
      // As the world fields them (see [careerPoolOf]), the same pool the match
      // preview picks their eleven from.
      final pool = await careerPoolOf(ref, career, key.nationId);
      return _keyMen(pool);
    });

/// A pre-match scouting report on the opponent: their recent form (a W/D/L
/// strip), a morale read, their world ranking and how they play (as deep as
/// the scout allows, [ScoutReportSection]), and their danger men. Everything
/// derived from data already recorded, so it costs nothing to keep.
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
        NationTap(
          careerId: careerId,
          nationId: oppNationId,
          child: Row(
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
                moraleLabel(l, form.morale),
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
        // The world ranking and how they play: as much as the scout in the
        // job can tell, which with nobody in it is very little.
        const SizedBox(height: AppSpacing.md),
        ScoutReportSection(
          careerId: careerId,
          nationId: oppNationId,
          seed: saveSeed ^ oppNationId,
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
          label.capsIn(Localizations.localeOf(context).languageCode),
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
    this.careerId,
    this.homeNationId,
    this.awayNationId,
    super.key,
  });

  final String homeCode;
  final int homeOverall;
  final String awayCode;
  final int awayOverall;

  /// When the match kicks off, written for the manager by [AppDate].
  final DateTime date;

  /// When all three are given, each side's block opens that nation's page.
  final int? careerId;
  final int? homeNationId;
  final int? awayNationId;

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
        child: _Side(
          code: homeCode,
          overall: homeOverall,
          careerId: careerId,
          nationId: homeNationId,
        ),
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
        child: _Side(
          code: awayCode,
          overall: awayOverall,
          careerId: careerId,
          nationId: awayNationId,
        ),
      ),
    ],
  );
}

class _Side extends StatelessWidget {
  const _Side({
    required this.code,
    required this.overall,
    this.careerId,
    this.nationId,
  });
  final String code;
  final int? careerId;
  final int? nationId;

  /// The side's team overall, so the two numbers sit either side of the "VS"
  /// and the manager can read the gap before kick-off.
  final int overall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final block = Column(
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
    final id = nationId;
    if (id == null) return block;
    return NationTap.maybe(careerId: careerId, nationId: id, child: block);
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
