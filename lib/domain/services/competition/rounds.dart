/// The round codes stored on a fixture, and what they mean.
///
/// A round is a bare string on a fixture, and the same question — "is this a
/// knockout tie?" — is asked by the simulator (does a level score go to a
/// shootout?), the repository, the match screen and the result rows. It used to
/// be answered by four private copies of the same suffix list plus one that
/// tried to infer it by *excluding* group codes; the odd one out treated
/// continental qualifying ('CQ') and friendlies as knockouts, and rendered a
/// penalties marker on games that never went to penalties.
///
/// One answer, so the display can't disagree with the engine.
abstract final class Rounds {
  /// Continental competitions prefix their rounds with `C`, the Nations Cup
  /// with `N`, and the World Cup uses the bare codes — so a knockout is
  /// identified by its *suffix*.
  static const List<String> knockoutSuffixes = [
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  ];

  /// A friendly international.
  static const String friendly = 'FRIENDLY';

  /// Whether [round] is a knockout tie, and so can be settled on penalties.
  ///
  /// Everything else is not: the group stages ('GROUP', 'CGROUP', 'NGROUP'),
  /// continental qualifying ('CQ'), friendlies, and World Cup qualifying (which
  /// carries no round code at all — null).
  static bool isKnockout(String? round) =>
      round != null && knockoutSuffixes.any(round.endsWith);
}
