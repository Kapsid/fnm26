import 'package:fnm/domain/entities/fixture.dart';

/// The round codes each finals tournament is played over.
///
/// This is the SHARED definition, not yet the only one. Besides
/// [contestsFinals]'s own users, three files read it directly: the timeline
/// (`lib/features/hub/hub_event.dart`), the press room
/// (`lib/features/press/press_providers.dart`) and the season service
/// (`lib/features/hub/hub_providers.dart`, whose two round gates read it
/// rather than literals of their own).
/// Everything else still carries a private copy of the same literals, so a
/// caller with its own copy CAN disagree with this one — a round code added
/// here reaches those callers and nowhere else, and that silent divergence is
/// the hazard this comment exists to warn about.
///
/// The copies still out there, named by symbol rather than by line: a symbol
/// survives an edit above it, a line number does not. Exact duplicates of
/// [worldChampionship]:
///
///  * `lib/features/achievements/challenge_providers.dart` (`_wcFinalsRounds`)
///  * `lib/features/federation/federation_service.dart` (`_wcFinalsRounds`)
///  * `lib/features/match/match_preview_screen.dart` (`_wcFinalsRounds`)
///  * `lib/features/match/match_providers.dart` (`wcFinalsRounds`, a
///    provider-local const)
///  * `lib/features/squad/training_camp_providers.dart` (`_wcFinalsRounds`)
///  * `lib/features/tournaments/tournaments_providers.dart` (`wcFinalsRounds`
///    and `wcRounds`, two provider-local consts)
///  * `lib/domain/services/match/venue.dart` (`_wcFinalsRounds`)
///  * `lib/domain/services/press/y_feed.dart` (`finalsRounds`)
///
/// Exact duplicates of [continental]:
///
///  * `lib/features/federation/federation_service.dart` (`_contFinalsRounds`)
///  * `lib/features/squad/training_camp_providers.dart` (`_contFinalsRounds`)
///  * `lib/features/tournaments/tournaments_providers.dart`
///    (`contFinalsRounds`)
///  * `lib/domain/services/match/venue.dart` (`_continentalFinalsRounds`)
///
/// …and one copy that has ALREADY diverged:
/// `lib/features/match/match_preview_screen.dart` (`_continentalFinalsRounds`)
/// carries the same codes plus 'CR32'. Whether that round exists is a question
/// this class has not been asked yet; whoever migrates that file has to settle
/// it rather than assume the two sets agree.
///
/// Copies of a UNION of these sets: `lib/features/stats/stats_providers.dart`
/// (`_finalsRounds`, the same three families as [all]).
///
/// NOT duplicates, and not candidates for this class — they name some of the
/// same codes for a different question, and folding them in would lose the
/// distinction: `venue.dart` (`_showpieceRounds`, the finals and third-place
/// matches only), `y_feed.dart` (`hypeRounds`, the last four), a knockout
/// set in `match_providers.dart` that also carries 'CR32' and no group round,
/// `manager_history_providers.dart` (`_wcRounds`, an ORDERED list read for
/// how far a run went), the code-to-label maps in `round_popup.dart` and the
/// continental bracket screens, and the many files that mention one code at a
/// time to weight a match or to look a fixture up.
///
/// Migrating those is a deliberate cleanup with its own tests, not something
/// to bolt onto whatever change brought you here.
abstract final class FinalsRounds {
  /// The World Championship finals, group stage through the final.
  static const Set<String> worldChampionship = {
    'GROUP',
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  };

  /// A continental championship's finals, group stage through the final.
  static const Set<String> continental = {
    'CGROUP',
    'CR16',
    'CQF',
    'CSF',
    'C3RD',
    'CFINAL',
  };

  /// The Nations Cup's Finals Four.
  static const Set<String> nationsCup = {'NSF', 'NFINAL'};

  /// Every finals round of every tournament.
  static const Set<String> all = {
    ...worldChampionship,
    ...continental,
    ...nationsCup,
  };

  /// The tournament [round] is played in, or null when it is not a finals
  /// round at all — qualifying carries no code and a friendly carries its own.
  static Set<String>? familyOf(String? round) {
    if (round == null) return null;
    for (final family in [worldChampionship, continental, nationsCup]) {
      if (family.contains(round)) return family;
    }
    return null;
  }
}

/// Whether a nation is contesting the tournament played over [rounds], read
/// from [fixtures] — that nation's own fixture list.
///
/// It reads the WHOLE list rather than the next match on it, and that is the
/// whole point. A host fills the weeks before its own tournament with
/// friendlies, so "the next fixture is a finals match" is false for exactly
/// the sides most certainly in it: the naive check routed a host to WATCH its
/// own semi-final instead of playing it. Anything else that asks the same
/// question walks into the same trap, so it asks here instead.
///
/// [unplayedOnly] narrows it to a tournament still to come — what the timeline
/// wants, since a side whose campaign is over is no longer contesting
/// anything. Left false it answers the historical question: did this side take
/// part at all?
bool contestsFinals(
  Iterable<Fixture> fixtures,
  Set<String> rounds, {
  bool unplayedOnly = false,
}) => fixtures.any(
  (f) => rounds.contains(f.round) && (!unplayedOnly || !f.hasResult),
);
