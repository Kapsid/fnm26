import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/strength_factors.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/familiarity_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Which side is being read: whose career, the shape it is lining up in, and
/// what the fielded eleven is worth (a chemistry MULTIPLIER only becomes
/// rating points against some rating).
typedef StrengthPanelKey = ({
  int careerId,
  Formation formation,
  int sideRating,
});

/// What is making the manager's side stronger or weaker today, already on one
/// scale and ready to draw.
///
/// The figures come from [StrengthFactors], which reads each one off the seam
/// the engine itself applies — nothing here invents a number. What this
/// provider adds is the gathering (five separate providers hold the pieces)
/// and the scaling ([perNamedMan]).
final AutoDisposeFutureProviderFamily<List<StrengthFactor>, StrengthPanelKey>
strengthFactorsProvider = FutureProvider.autoDispose
    .family<List<StrengthFactor>, StrengthPanelKey>((ref, key) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return const [];
      final drilling = await ref.watch(
        shapeDrillingProvider(key.careerId).future,
      );
      final conditions = await ref.watch(
        squadConditionProvider(key.careerId).future,
      );
      final squad = await ref.watch(squadDataProvider(key.careerId).future);
      final morale = await ref.watch(moraleProvider(key.careerId).future);
      // Whether an armband is actually being worn, and what the man wearing it
      // is worth — `captainProvider` resolves a stored id that may belong to
      // somebody no longer in the squad, so it is the fact, not the intent.
      final captain = await ref.watch(captainProvider(key.careerId).future);
      final captainMorale = await ref.watch(
        captainMoraleProvider(key.careerId).future,
      );

      // Only the men the manager named. `squadConditionProvider` is keyed by
      // everyone who has played for the nation recently, and a tired reserve
      // left at home is not carrying anything into this match.
      final named = squad == null
          ? conditions
          : {
              for (final e in conditions.entries)
                if (squad.callUps.contains(e.key)) e.key: e.value,
            };
      // The divisor is the SQUAD, not the number of men with a reading: a man
      // with no recent rating is at neutral, and he still dilutes the average
      // the squad as a whole is carrying.
      final squadSize = squad == null || squad.callUps.isEmpty
          ? named.length
          : squad.callUps.length;

      return perNamedMan(
        StrengthFactors.of(
          familiarity: drilling[key.formation] ?? 0,
          conditionByPlayer: named,
          morale: morale,
          hasCaptain: captain != null,
          captainMoraleBonus: captainMorale,
          staff: {
            StaffRole.assistant: career.staffAssistant,
            StaffRole.scout: career.staffScout,
            StaffRole.fitnessCoach: career.staffFitnessCoach,
          },
          sideRating: key.sideRating,
          formationName: key.formation.label,
        ),
        squadSize,
      );
    });

/// [factors] with the squad-wide lines brought onto the side-level scale.
///
/// [StrengthFactors] reports fatigue and club form as SUMS over the named
/// squad — which is what the engine applies, each man's shift to that man —
/// while familiarity, the dressing room, the armband and the staff room are
/// already side-level figures. Drawn side by side those are two different
/// scales, and a twenty-three man squad a point off each would read as −23
/// beside a ±3 dressing room: the biggest number on the panel would be the one
/// the manager should worry about least. So the two squad lines are divided by
/// the squad, and every line on the panel then means the same thing: what this
/// is worth to the side.
///
/// A line that rounds to nothing is dropped exactly as a zero would be, and
/// the order is taken again afterwards — the scaling changes which factor is
/// biggest, which is the whole point of doing it.
List<StrengthFactor> perNamedMan(List<StrengthFactor> factors, int squadSize) {
  if (squadSize <= 0) return const [];
  const perSquad = {StrengthFactorKind.fatigue, StrengthFactorKind.clubForm};
  final scaled = <StrengthFactor>[];
  for (final f in factors) {
    final delta = perSquad.contains(f.kind)
        ? (f.delta / squadSize).round()
        : f.delta;
    if (delta != 0) {
      scaled.add((kind: f.kind, delta: delta, subject: f.subject));
    }
  }
  return scaled..sort((a, b) {
    final bySize = b.delta.abs().compareTo(a.delta.abs());
    // Ties fall back to the declared order, so the same side never reads in
    // a different order twice running (List.sort is not stable).
    return bySize != 0 ? bySize : a.kind.index.compareTo(b.kind.index);
  });
}

/// The pre-match reading of what is helping and what is hurting.
///
/// Four separate pieces of feedback said the same thing: tired players, the
/// shape, how drilled the side is and the staff room all read as doing
/// nothing, because every one of them moved the result invisibly. This is
/// where they become visible.
///
/// One thing is deliberately absent: predictability, what the opposition has
/// worked out about the side. The familiarity line is computed with it at zero
/// (see [StrengthFactors]), so it is neither shown here nor recoverable from
/// what is.
class StrengthPanel extends ConsumerWidget {
  const StrengthPanel({
    required this.careerId,
    required this.formation,
    required this.sideRating,
    super.key,
  });

  final int careerId;
  final Formation formation;

  /// The fielded eleven's average overall.
  final int sideRating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factors = ref
        .watch(
          strengthFactorsProvider((
            careerId: careerId,
            formation: formation,
            sideRating: sideRating,
          )),
        )
        .valueOrNull;
    return StrengthFactorList(factors: factors ?? const []);
  }
}

/// The panel itself: a heading and a line per factor.
///
/// Nothing at all when [factors] is empty — a side with a settled, rested,
/// contented squad is not told "nothing to report"; it is simply not
/// interrupted.
class StrengthFactorList extends StatelessWidget {
  const StrengthFactorList({required this.factors, super.key});

  final List<StrengthFactor> factors;

  @override
  Widget build(BuildContext context) {
    if (factors.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.matchStrengthTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          child: Column(
            children: [
              for (final f in factors) _FactorRow(factor: f),
            ],
          ),
        ),
        // The gap below belongs to the panel, not to the screen: spacing it
        // from the outside would leave a double gap on the days the panel is
        // not drawn at all.
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// One factor: which way it is pulling, on what, and by how much.
class _FactorRow extends StatelessWidget {
  const _FactorRow({required this.factor});

  final StrengthFactor factor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final up = factor.delta > 0;
    final colour = up ? AppColors.positive : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            up ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: colour,
          ),
          const SizedBox(width: AppSpacing.xs),
          // The label wraps rather than ellipsising: the shortest of these
          // names is the one that tells the manager what he is looking at, and
          // a cut one tells him nothing.
          Expanded(
            child: Text(
              _label(l10n, factor.kind),
              style: AppTypography.bodySmall,
            ),
          ),
          if (factor.subject != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              factor.subject!,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
          Text(
            signed(factor.delta),
            style: AppTypography.labelMedium.copyWith(color: colour),
          ),
        ],
      ),
    );
  }

  static String _label(AppLocalizations l10n, StrengthFactorKind kind) =>
      switch (kind) {
        StrengthFactorKind.familiarity => l10n.strengthFactorFamiliarity,
        StrengthFactorKind.fatigue => l10n.strengthFactorFatigue,
        StrengthFactorKind.clubForm => l10n.strengthFactorClubForm,
        StrengthFactorKind.morale => l10n.strengthFactorMorale,
        StrengthFactorKind.captain => l10n.strengthFactorCaptain,
        StrengthFactorKind.staff => l10n.strengthFactorStaff,
      };
}

/// Rating points with their sign always written out, so a plus is as loud as a
/// minus and neither depends on the colour alone.
String signed(int delta) => delta > 0 ? '+$delta' : '$delta';
