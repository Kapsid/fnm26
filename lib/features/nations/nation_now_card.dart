import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A nation by id, for the opponents named in the "now" block.
final AutoDisposeFutureProviderFamily<Nation?, int> _nationProvider =
    FutureProvider.autoDispose.family<Nation?, int>(
      (ref, id) => ref.watch(nationRepositoryProvider).byId(id),
    );

/// The nation the manager leads, whose side the "against you" link reads from.
final AutoDisposeFutureProviderFamily<int?, int> _ownNationIdProvider =
    FutureProvider.autoDispose.family<int?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      return career?.nationId;
    });

/// The top of a nation's team page: where it stands in the world, how its last
/// five went, who it meets next, how strong its squad is today and, on another
/// nation's page, how the manager's side has fared against it.
class NationNowCard extends ConsumerWidget {
  const NationNowCard({
    required this.careerId,
    required this.nationId,
    super.key,
  });

  final int careerId;
  final int nationId;

  static const Key rankingKey = Key('nationNow.ranking');
  static const Key formKey = Key('nationNow.form');
  static const Key nextKey = Key('nationNow.next');
  static const Key squadKey = Key('nationNow.squad');
  static const Key againstYouKey = Key('nationNow.againstYou');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = ref
        .watch(
          nationNowProvider((careerId: careerId, nationId: nationId)),
        )
        .valueOrNull;
    if (now == null) return const SizedBox.shrink();
    const divider = Divider(height: AppSpacing.lg);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            key: rankingKey,
            label: l.nationNowRanking,
            onTap: () => context.push('${Routes.ranking}?careerId=$careerId'),
            child: _rankingValue(l, now),
          ),
          divider,
          _Section(
            key: formKey,
            label: l.nationNowForm,
            child: now.form.isEmpty
                ? _muted(l.nationNowNoForm)
                : Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final chip in now.form) _FormChipView(chip),
                    ],
                  ),
          ),
          divider,
          _Section(
            key: nextKey,
            label: l.nationNowNext,
            child: now.next == null
                ? _muted(l.nationNowNoNext)
                : _NextMatch(
                    careerId: careerId,
                    nationId: nationId,
                    fixture: now.next!,
                  ),
          ),
          divider,
          _Section(
            key: squadKey,
            label: l.nationNowSquad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (now.overall != null)
                  Text(
                    l.nationNowOverall(now.overall!),
                    style: AppTypography.headlineMedium,
                  ),
                for (final p in now.topPlayers)
                  InkWell(
                    onTap: () => openPlayer(
                      context,
                      careerId: careerId,
                      playerId: p.id,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 38,
                            child: TacticalChip(p.position.label),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          Text(
                            '${p.overall}',
                            style: AppTypography.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (now.againstYou case final against?) ...[
            divider,
            Consumer(
              builder: (context, ref, _) {
                final own = ref
                    .watch(_ownNationIdProvider(careerId))
                    .valueOrNull;
                return _Section(
                  key: againstYouKey,
                  label: l.nationNowAgainstYou,
                  onTap: own == null
                      ? null
                      : () => context.push(
                          '${Routes.h2hMeetings}?careerId=$careerId'
                          '&a=$own&b=$nationId',
                        ),
                  child: _againstValue(context, l, against),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _rankingValue(AppLocalizations l, NationNow now) {
    final conf = _muted(confederationLabel(l, now.confederation));
    if (now.rank == null) return conf;
    final move = now.movement;
    return Row(
      children: [
        Text('#${now.rank}', style: AppTypography.headlineMedium),
        if (now.points != null) ...[
          const SizedBox(width: AppSpacing.sm),
          _muted('${now.points}'),
        ],
        if (move != 0) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(
            move > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: move > 0 ? AppColors.positive : AppColors.error,
          ),
          Text(
            '${move.abs()}',
            style: AppTypography.labelMedium.copyWith(
              color: move > 0 ? AppColors.positive : AppColors.error,
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: conf),
      ],
    );
  }

  Widget _againstValue(
    BuildContext context,
    AppLocalizations l,
    ({HeadToHead record, Fixture? last}) against,
  ) {
    final r = against.record;
    final last = against.last;
    // From the manager's side: this page's nation is the opponent.
    final mine = last == null
        ? null
        : (last.homeNationId == nationId ? last.awayScore : last.homeScore);
    final theirs = last == null
        ? null
        : (last.homeNationId == nationId ? last.homeScore : last.awayScore);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.nationNowRecord(r.winsA, r.draws, r.winsB),
          style: AppTypography.titleMedium,
        ),
        if (last != null)
          _muted(
            '${l.nationNowLastMeeting}: $mine-$theirs'
            ' · ${AppDate.dayMonthYear(context, last.date)}',
          ),
      ],
    );
  }
}

Widget _muted(String text) => Text(
  text,
  style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
);

/// A labelled row of the block, tappable when it leads somewhere.
class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.child,
    this.onTap,
    super.key,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
    return SizedBox(
      width: double.infinity,
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
  }
}

/// One W/D/L result as a small coloured pip.
class _FormPip extends StatelessWidget {
  const _FormPip(this.outcome);
  final String outcome;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = switch (outcome) {
      'W' => AppColors.positive,
      'L' => AppColors.error,
      _ => AppColors.onSurfaceVariant,
    };
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        switch (outcome) {
          'W' => l.careerStatWonShort,
          'L' => l.careerStatLostShort,
          _ => l.careerStatDrawnShort,
        },
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// One recent result: the pip, the score from the nation's side and the
/// opponent's code.
class _FormChipView extends ConsumerWidget {
  const _FormChipView(this.chip);
  final FormChip chip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opp = ref.watch(_nationProvider(chip.opponentId)).valueOrNull;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FormPip(chip.outcome),
        const SizedBox(width: 4),
        Text(
          '${chip.goalsFor}-${chip.goalsAgainst} ${opp?.code ?? ''}',
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }
}

/// The next fixture: the opponent (a tap to its page), the competition and
/// the date.
class _NextMatch extends ConsumerWidget {
  const _NextMatch({
    required this.careerId,
    required this.nationId,
    required this.fixture,
  });

  final int careerId;
  final int nationId;
  final Fixture fixture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oppId = fixture.homeNationId == nationId
        ? fixture.awayNationId
        : fixture.homeNationId;
    final opp = ref.watch(_nationProvider(oppId)).valueOrNull;
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: () => openNation(context, careerId: careerId, nationId: oppId),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (opp != null) ...[
                FlagDisc(opp.code, size: 24),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  opp?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
              ),
              _muted(AppDate.dayMonthYear(context, fixture.date)),
            ],
          ),
          _muted(MatchStage.label(l, fixture)),
        ],
      ),
    );
  }
}
