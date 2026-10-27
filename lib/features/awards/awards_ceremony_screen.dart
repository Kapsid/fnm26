import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The hub event's two ways in: watch the ceremony, or go straight to the
/// list. Either one takes the ceremony (see [AwardService.takeCeremony]).
class AwardsCeremonyChoiceSheet extends StatelessWidget {
  const AwardsCeremonyChoiceSheet({
    required this.year,
    required this.onChoose,
    super.key,
  });

  final int year;

  /// Called with true to watch, false to skip to the list.
  final ValueChanged<bool> onChoose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.medalGold,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.newsPotyTitle(year),
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.hubEventAwardsCeremonySub,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              key: const Key('poty.watch'),
              label: l.potyCeremonyWatch,
              icon: Icons.play_arrow_rounded,
              onPressed: () => onChoose(true),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              key: const Key('poty.skipToList'),
              onPressed: () => onChoose(false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.minHitArea),
              ),
              child: Text(
                l.potyCeremonySkipToList,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The yearly Player of the Year ceremony, and the top-five list it ends on.
///
/// [watch] plays the reveal: fifth place to first, the winner after a pause
/// and under a spotlight, then the young award. Without it (or with reduced
/// motion asked for) the screen is the list straight away. "Skip" is always
/// on screen during the reveal and jumps to the list.
class AwardsCeremonyScreen extends ConsumerWidget {
  const AwardsCeremonyScreen({
    required this.careerId,
    required this.year,
    this.watch = false,
    super.key,
  });

  final int careerId;
  final int year;
  final bool watch;

  static const Key tabletLayoutKey = Key('awardsCeremony.tablet');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final vote = ref.watch(potyVoteProvider((careerId: careerId, year: year)));
    final nations = ref.watch(careerNationsByIdProvider(careerId));
    void leave() => context.go('${Routes.hub}?careerId=$careerId');
    final body = switch ((vote, nations)) {
      (AsyncData(value: final v?), AsyncData(value: final n)) => _Ceremony(
        vote: v,
        nations: n,
        watch: watch && !MediaQuery.of(context).disableAnimations,
        onDone: leave,
      ),
      (AsyncData(value: null), _) ||
      (AsyncError(), _) ||
      (_, AsyncError()) => Center(
        child: SizedBox(
          width: 320,
          child: PrimaryButton(
            label: l.federationContinue,
            onPressed: leave,
          ),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
    final title = l.hubEventAwardsCeremony(year);
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: tabletLayoutKey,
        title: title,
        onBack: leave,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: body,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: leave,
        ),
        title: Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: AppTypography.labelMedium,
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }
}

/// One step of the reveal.
enum _BeatKind { intro, place, suspense, young }

typedef _Beat = ({_BeatKind kind, PotyPlace? place, Duration hold});

class _Ceremony extends StatefulWidget {
  const _Ceremony({
    required this.vote,
    required this.nations,
    required this.watch,
    required this.onDone,
  });

  final PotyVote vote;
  final Map<int, Nation> nations;
  final bool watch;
  final VoidCallback onDone;

  @override
  State<_Ceremony> createState() => _CeremonyState();
}

class _CeremonyState extends State<_Ceremony> {
  late final List<_Beat> _beats = _plan(widget.vote);
  int _beat = 0;
  late bool _listing = !widget.watch || _beats.isEmpty;
  Timer? _timer;

  /// How long each beat holds. The winner waits behind a pause of its own
  /// and stays longest.
  static const Duration intro = Duration(milliseconds: 1800);
  static const Duration place = Duration(milliseconds: 2600);
  static const Duration suspense = Duration(milliseconds: 2000);
  static const Duration winner = Duration(milliseconds: 4200);
  static const Duration youngHold = Duration(milliseconds: 3200);

  static List<_Beat> _plan(PotyVote vote) {
    final best = vote.best;
    return [
      (kind: _BeatKind.intro, place: null, hold: intro),
      for (final p in best.reversed)
        if (p.rank != 1) (kind: _BeatKind.place, place: p, hold: place),
      if (best.isNotEmpty) ...[
        (kind: _BeatKind.suspense, place: null, hold: suspense),
        (kind: _BeatKind.place, place: best.first, hold: winner),
      ],
      if (vote.young.isNotEmpty)
        (kind: _BeatKind.young, place: vote.young.first, hold: youngHold),
    ];
  }

  @override
  void initState() {
    super.initState();
    if (!_listing) _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(_beats[_beat].hold, () {
      if (!mounted) return;
      setState(() {
        if (_beat + 1 < _beats.length) {
          _beat++;
        } else {
          _listing = true;
        }
      });
      if (!_listing) _schedule();
    });
  }

  void _skip() {
    _timer?.cancel();
    setState(() => _listing = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_listing) {
      return PotyTopList(
        vote: widget.vote,
        nations: widget.nations,
        onContinue: widget.onDone,
      );
    }
    final l = AppLocalizations.of(context);
    final beat = _beats[_beat];
    // Who is already on the board, best place first.
    final revealed = [
      for (var i = 0; i < _beat; i++)
        if (_beats[i].kind == _BeatKind.place) _beats[i].place!,
    ]..sort((a, b) => a.rank.compareTo(b.rank));
    return Column(
      key: const Key('poty.ceremony'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 650),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    ).animate(animation),
                    child: ScaleTransition(
                      scale: Tween(begin: 0.94, end: 1.0).animate(animation),
                      child: child,
                    ),
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_beat),
                  child: _stage(l, beat),
                ),
              ),
            ),
          ),
        ),
        if (revealed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final p in revealed) _BoardRow(place: p),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Align(
            child: TextButton.icon(
              key: const Key('poty.skip'),
              onPressed: _skip,
              icon: const Icon(Icons.skip_next_rounded),
              label: Text(l.potyCeremonySkip),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stage(AppLocalizations l, _Beat beat) {
    switch (beat.kind) {
      case _BeatKind.intro:
        return Column(
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.medalGold,
              size: 72,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.potyCeremonyIntro,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium,
            ),
          ],
        );
      case _BeatKind.suspense:
        return _Suspense(text: l.potyCeremonyWinnerIs);
      case _BeatKind.place:
        final p = beat.place!;
        return _Reveal(
          heading: l.potyCeremonyPlace(p.rank),
          place: p,
          nation: widget.nations[p.nationId],
          winner: p.rank == 1,
        );
      case _BeatKind.young:
        final p = beat.place!;
        return _Reveal(
          heading: l.potyLabelYoung,
          place: p,
          nation: widget.nations[p.nationId],
          winner: false,
        );
    }
  }
}

/// The pause before the winner: the line breathes while the room waits.
class _Suspense extends StatelessWidget {
  const _Suspense({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _CeremonyState.suspense,
      builder: (context, t, child) => Opacity(
        opacity: 0.55 + 0.45 * (1 - (2 * t - 1).abs()),
        child: child,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            color: AppColors.medalGold,
            size: 56,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
    );
  }
}

/// One place revealed, large: the nation's colours behind the flag, the
/// name, and his year.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.heading,
    required this.place,
    required this.nation,
    required this.winner,
  });

  final String heading;
  final PotyPlace place;
  final Nation? nation;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    final colours = nation == null
        ? const [AppColors.surfaceContainerHigh, AppColors.surfaceContainer]
        : KitColors.discFill(nation!.primaryColor, nation!.secondaryColor);
    final flag = Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colours.length > 1 ? colours : [colours.first, colours.first],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FlagDisc(place.nationCode, size: winner ? 88 : 72),
    );
    final card = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: AppTypography.labelMedium.copyWith(
            color: winner ? AppColors.medalGold : AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (winner)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (context, s, child) =>
                Transform.scale(scale: s, child: child),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.medalGold,
              size: 48,
            ),
          ),
        if (winner) const SizedBox(height: AppSpacing.sm),
        flag,
        const SizedBox(height: AppSpacing.md),
        PotyPlaceText(
          place: place,
          nation: nation,
          centred: true,
          large: true,
        ),
      ],
    );
    if (!winner) return card;
    // The spotlight: a gold glow that opens up behind the winner.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, t, child) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.4 + 0.5 * t,
            colors: [
              AppColors.medalGold.withValues(alpha: 0.28 * t),
              AppColors.medalGold.withValues(alpha: 0),
            ],
          ),
        ),
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: card,
      ),
    );
  }
}

/// A place already revealed, on the board under the stage.
class _BoardRow extends StatelessWidget {
  const _BoardRow({required this.place});

  final PotyPlace place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          _RankBadge(rank: place.rank, size: 24),
          const SizedBox(width: AppSpacing.sm),
          FlagDisc(place.nationCode, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              place.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: place.own ? AppColors.positive : null,
                fontWeight: place.own ? FontWeight.w700 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The year's vote as a list: the top five, then the young award's top three.
class PotyTopList extends StatelessWidget {
  const PotyTopList({
    required this.vote,
    required this.nations,
    this.onContinue,
    super.key,
  });

  final PotyVote vote;
  final Map<int, Nation> nations;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        text,
        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      ),
    );
    return ListView(
      key: const Key('poty.list'),
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        heading(l.potyTop5Heading),
        for (final p in vote.best)
          PotyPlaceCard(place: p, nation: nations[p.nationId]),
        if (vote.young.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          heading(l.potyYoungTop3Heading),
          for (final p in vote.young)
            PotyPlaceCard(place: p, nation: nations[p.nationId]),
        ],
        if (onContinue != null) ...[
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            key: const Key('poty.continue'),
            label: l.federationContinue,
            onPressed: onContinue,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// One place on the list: rank, flag in the nation's colours, who he is and
/// his year. The manager's own men are picked out.
class PotyPlaceCard extends StatelessWidget {
  const PotyPlaceCard({required this.place, this.nation, super.key});

  final PotyPlace place;
  final Nation? nation;

  @override
  Widget build(BuildContext context) {
    final accent = nation == null
        ? AppColors.outlineVariant
        : KitColors.accent(nation!.primaryColor, nation!.secondaryColor);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        key: ValueKey('poty.place.${place.playerId}'),
        padding: const EdgeInsets.all(AppSpacing.sm),
        border: place.own
            ? Border.all(color: AppColors.positive, width: 2)
            : Border(left: BorderSide(color: accent, width: 4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RankBadge(rank: place.rank, size: 30),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
              child: FlagDisc(place.nationCode, size: 36),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PotyPlaceText(place: place, nation: nation),
            ),
          ],
        ),
      ),
    );
  }
}

/// Who he is and what his year was: name, nation, position and age, then
/// the key line (caps, goals or clean sheets, mean mark).
class PotyPlaceText extends StatelessWidget {
  const PotyPlaceText({
    required this.place,
    this.nation,
    this.centred = false,
    this.large = false,
    super.key,
  });

  final PotyPlace place;

  /// His nation, for its name in the language being read now.
  final Nation? nation;
  final bool centred;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final align = centred ? TextAlign.center : TextAlign.start;
    final cross = centred
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final atTheBack =
        place.position.category == PositionCategory.goalkeeper ||
        place.position.category == PositionCategory.defender;
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: cross,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (place.own)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              l.potyYourPlayer,
              key: const Key('poty.own'),
              textAlign: align,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.positive,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        // A [WholeText]: a long name gives up its forename rather than its
        // ending, which is what identifies a footballer.
        WholeText(
          place.name,
          shortText: initialledName(place.name),
          maxLines: 1,
          textAlign: align,
          style: large
              ? AppTypography.headlineMedium
              : AppTypography.titleMedium,
        ),
        Text(
          nation?.name ?? place.nationName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          style: muted,
        ),
        Text(
          '${positionName(l, place.position)} · ${l.squadAgeShort(place.age)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          style: muted,
        ),
        const SizedBox(height: AppSpacing.xs),
        // A WRAP, so the figures go to a second line rather than being cut.
        Wrap(
          alignment: centred ? WrapAlignment.center : WrapAlignment.start,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _Figure(l.msgTallyCaps(place.apps)),
            if (atTheBack)
              _Figure(l.potyTallyCleanSheets(place.cleanSheets))
            else
              _Figure(l.msgTallyGoals(place.goals)),
            _Figure(
              l.potyRatingValue(place.meanRating.toStringAsFixed(2)),
              color: AppColors.ratingColor(place.meanRating),
            ),
          ],
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        text,
        // Two lines: "6 kapott gól nélküli meccs" at a large text size is
        // wider than the card, and a figure must never be cut.
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: color ?? AppColors.onSurfaceVariant,
          fontWeight: color == null ? null : FontWeight.w800,
        ),
      ),
    );
  }
}

/// A place number, in medal colours for the podium.
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.size});

  final int rank;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colour = switch (rank) {
      1 => AppColors.medalGold,
      2 => AppColors.medalSilver,
      3 => AppColors.medalBronze,
      _ => AppColors.surfaceContainerHighest,
    };
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colour),
      child: Text(
        '$rank',
        style: AppTypography.labelMedium.copyWith(
          color: rank <= 3 ? AppColors.onSecondaryFixed : AppColors.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
