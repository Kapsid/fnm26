import 'package:fnm/domain/entities/fixture.dart';

/// The round codes each finals tournament is played over.
///
/// Every feature that has to answer "is this side IN that tournament?" was
/// carrying its own copy of these sets. One copy, so the press room and the
/// timeline can never disagree about which tournaments a manager attended.
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
