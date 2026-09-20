import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Every unavailable player's outlook (player id → how long they are out for),
/// read against the nation's own fixture list so a suspension or a knock is
/// stated in weeks and a return match rather than in bare game counts.
final AutoDisposeFutureProviderFamily<Map<int, AbsenceOutlook>, int>
absenceOutlookProvider = FutureProvider.autoDispose
    .family<Map<int, AbsenceOutlook>, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const {};
      final absences = await ref
          .watch(absenceRepositoryProvider)
          .forCareer(careerId);
      if (absences.isEmpty) return const {};
      final fixtures = await ref
          .watch(competitionRepositoryProvider)
          .fixturesForNation(careerId, career.nationId);
      final upcoming = [
        for (final f in fixtures)
          if (!f.hasResult) f,
      ];
      final out = <int, AbsenceOutlook>{};
      for (final e in absences.entries) {
        final o = AbsenceOutlooks.forAbsence(
          e.value,
          upcoming: upcoming,
          from: career.inGameDate,
          nationId: career.nationId,
        );
        if (o != null) out[e.key] = o;
      }
      return out;
    });

/// The compact badge text for an absence — "Injured · 3 weeks", falling back to
/// a game count when the calendar has nothing scheduled that far ahead.
///
/// A SUSPENSION is always stated in matches. A ban is served in games, not in
/// time: it does not tick down while the player sits at home, so "suspended for
/// three weeks" is both untrue and unactionable. Only a knock, which heals on a
/// calendar, is worth putting in weeks.
String absenceLabel(AppLocalizations l, AbsenceOutlook o) {
  final what = o.injured ? l.absenceInjured : l.absenceSuspended;
  final how = o.injured && o.weeks > 0
      ? l.absenceWeeks(o.weeks)
      : l.absenceGames(o.matches);
  return '$what · $how';
}
