import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/job_dossier.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A job on the table at the end of a cycle, scouted: the nation, where it
/// stands in the world, and its squad read as [JobDossierRead] reads it.
typedef JobDossier = ({Nation nation, int worldRank, JobDossierRead squad});

/// The dossier on `nationId`'s job for the manager of `careerId`.
///
/// The pool is the one the world fields ([careerPoolOf]: the save's seed,
/// aging years and naturalisations), the same read an opponent's dossier
/// takes, so the side scouted here is the side he would inherit. Read when a
/// dossier is opened, never for every offer up front.
final AutoDisposeFutureProviderFamily<
  JobDossier?,
  ({int careerId, int nationId})
>
jobDossierProvider = FutureProvider.autoDispose
    .family<JobDossier?, ({int careerId, int nationId})>((ref, key) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return null;
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(key.careerId);
      final nation = nations.where((n) => n.id == key.nationId).firstOrNull;
      if (nation == null) return null;
      final ranking = await ref.watch(
        worldRankingProvider(key.careerId).future,
      );
      final pool = await careerPoolOf(ref, career, key.nationId);
      return (
        nation: nation,
        worldRank: ranking?.position[key.nationId] ?? nation.ranking,
        squad: JobDossierRead.of(pool),
      );
    });

/// The words for one line of the scout's read.
String jobDossierNoteText(
  AppLocalizations l,
  JobDossierNote n,
  Player? star,
) => switch (n) {
  JobDossierNote.strongAttack => l.jobDossierStrongAttack,
  JobDossierNote.bluntAttack => l.jobDossierBluntAttack,
  JobDossierNote.strongMidfield => l.jobDossierStrongMidfield,
  JobDossierNote.weakMidfield => l.jobDossierWeakMidfield,
  JobDossierNote.strongDefence => l.jobDossierStrongDefence,
  JobDossierNote.thinDefence => l.jobDossierThinDefence,
  JobDossierNote.safeKeeper => l.jobDossierSafeKeeper,
  JobDossierNote.shakyKeeper => l.jobDossierShakyKeeper,
  JobDossierNote.oldSquad => l.jobDossierOldSquad,
  JobDossierNote.youngCore => l.jobDossierYoungCore,
  JobDossierNote.oneStar => l.jobDossierOneStar(star?.name ?? ''),
  JobDossierNote.deepSquad => l.jobDossierDeepSquad,
  JobDossierNote.thinSquad => l.jobDossierThinSquad,
};

/// Opens the dossier on [nationId] in a sheet (a dialog on a narrow tablet
/// window). Answers true when the manager took the job from it.
Future<bool> showJobDossierSheet(
  BuildContext context, {
  required int careerId,
  required int nationId,
  required String takeLabel,
}) async {
  final taken = await showAdaptiveSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    builder: (sheetContext) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: JobDossierBody(
            careerId: careerId,
            nationId: nationId,
            takeLabel: takeLabel,
            onTake: () => Navigator.of(sheetContext).pop(true),
          ),
        ),
      ),
    ),
  );
  return taken ?? false;
}

/// The dossier on one job: who they are, how strong, their mood and form,
/// their best men, the scout's read, what the job is for next, and the
/// button that takes it.
class JobDossierBody extends ConsumerWidget {
  const JobDossierBody({
    required this.careerId,
    required this.nationId,
    required this.takeLabel,
    required this.onTake,
    super.key,
  });

  final int careerId;
  final int nationId;
  final String takeLabel;
  final VoidCallback onTake;

  static const Key ratingKey = Key('jobDossier.rating');
  static const Key formKey = Key('jobDossier.form');
  static const Key reportKey = Key('jobDossier.report');
  static const Key takeKey = Key('jobDossier.take');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final key = (careerId: careerId, nationId: nationId);
    final dossier = ref.watch(jobDossierProvider(key));
    final form = ref.watch(nationFormProvider(key)).valueOrNull;
    final label = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
      letterSpacing: 1,
    );
    return dossier.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text(l.hubCouldNotLoad('$e')),
      data: (d) {
        if (d == null) return const SizedBox.shrink();
        final squad = d.squad;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FlagDisc(d.nation.code, size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.nation.name, style: AppTypography.headlineMedium),
                      Text(
                        confederationLabel(l, d.nation.confederation),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Stat(
                  key: ratingKey,
                  label: l.jobDossierRating.capsIn(lang),
                  value: '${squad.rating}',
                ),
                _Stat(
                  label: l.hubWorldRankLabel.capsIn(lang),
                  value: l.hubWorldRank(d.worldRank),
                ),
                if (form != null)
                  _Stat(
                    label: l.jobDossierMood.capsIn(lang),
                    value: moraleLabel(l, form.morale),
                    color: form.morale >= 60
                        ? AppColors.positive
                        : form.morale >= 42
                        ? AppColors.onSurface
                        : AppColors.error,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              key: formKey,
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Text(l.matchDossierForm, style: label),
                ),
                if (form == null || form.results.isEmpty)
                  Text(
                    l.matchDossierNoGames,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  )
                else
                  for (final r in form.results.reversed) _FormPip(result: r),
              ],
            ),
            if (squad.top.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(l.jobDossierTopPlayers.capsIn(lang), style: label),
              const SizedBox(height: AppSpacing.xs),
              for (final p in squad.top) _PlayerRow(player: p),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(l.jobDossierReport.capsIn(lang), style: label),
            const SizedBox(height: AppSpacing.xs),
            Text(
              squad.notes.isEmpty
                  ? l.jobDossierBalanced
                  : [
                      for (final n in squad.notes)
                        jobDossierNoteText(l, n, squad.star),
                    ].join(' '),
              key: reportKey,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.jobDossierNextTargetLabel.capsIn(lang), style: label),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.jobDossierNextTarget(
                continentalCupLabel(l, d.nation.confederation),
              ),
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              key: takeKey,
              label: takeLabel,
              icon: Icons.arrow_forward_rounded,
              onPressed: onTake,
            ),
          ],
        );
      },
    );
  }
}

/// One figure of the dossier's head: a small heading over its value.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.color,
    super.key,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}

/// One of the best men: position, name, age and rating.
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              player.position.label,
              style: muted.copyWith(fontWeight: FontWeight.w700),
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
          const SizedBox(width: AppSpacing.sm),
          Text(l.jobDossierPlayerAge(player.age), style: muted),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${player.overall}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

/// One W/D/L result as a small coloured pip, as in the match preview's
/// dossier.
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
