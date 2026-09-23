import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';
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

/// The badge for an absence when the outlook has nothing to say about it — the
/// same two facts in the manager's own language, read off the very
/// [PlayerAbsence] the selection rules are using.
///
/// The outlook is a SECOND read of the absence table, taken a moment after the
/// one the screen is drawing from, and the two can disagree. When they did, the
/// row used to fall back to a hard-coded English string built from the first
/// read ("Injured · 4g"), so a Czech save printed English and printed it about
/// a player the rest of the game had already cleared to play. Null when [a] is
/// available, so a badge can never outlive the absence it describes.
String? absenceShortLabel(AppLocalizations l, PlayerAbsence? a) {
  if (a == null || a.isAvailable) return null;
  final what = a.injuryMatches > 0 ? l.absenceInjured : l.absenceSuspended;
  return '$what · ${l.absenceGames(SquadSelection.matchesMissed(a))}';
}
