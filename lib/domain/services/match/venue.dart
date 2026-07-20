import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';

/// Whether a match is played on neutral ground and, if so, which nation (if
/// either of the two) is the tournament host and so keeps a home crowd.
typedef MatchVenue = ({bool neutral, int hostId});

/// The World Cup finals round codes (bare) and the continental finals codes
/// (C-prefixed) — the matches played at a neutral host, unlike qualifiers,
/// friendlies and the home-and-away Nations Cup league.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
const _continentalFinalsRounds = {
  'CGROUP',
  'CR16',
  'CQF',
  'CSF',
  'C3RD',
  'CFINAL',
};

/// Whether [round] is a finals round played at a neutral host (World Cup or
/// continental finals), as opposed to a home-and-away game.
bool isNeutralFinalsRound(String? round) =>
    round != null &&
    (_wcFinalsRounds.contains(round) ||
        _continentalFinalsRounds.contains(round));

/// Decides where a fixture is played: a normal home-and-away game (the listed
/// home side enjoys home advantage), or a neutral finals match (nobody does,
/// unless the tournament host is one of the two teams).
MatchVenue venueForFixture({
  required Fixture fixture,
  required List<Nation> nations,
  required int seed,
  required int cycle,
}) {
  final round = fixture.round;
  if (round == null) return (neutral: false, hostId: 0); // WC qualifying

  final isWc = _wcFinalsRounds.contains(round);
  final isCont = _continentalFinalsRounds.contains(round);
  if (!isWc && !isCont) {
    // Nations Cup groups and friendlies are genuine home-and-away games.
    return (neutral: false, hostId: 0);
  }

  Set<int> hosts;
  if (isWc) {
    hosts = WorldCupHosts.worldCupHostIds(
      year: fixture.date.year,
      nations: nations,
      seed: seed,
    );
  } else {
    // A continental finals: both teams share the confederation.
    Confederation? conf;
    for (final n in nations) {
      if (n.id == fixture.homeNationId) {
        conf = n.confederation;
        break;
      }
    }
    hosts = conf == null
        ? const {}
        : WorldCupHosts.continentalHostsFor(
            confederation: conf,
            cycle: cycle,
            seed: seed,
            nations: nations,
          ).toSet();
  }

  final host = hosts.contains(fixture.homeNationId)
      ? fixture.homeNationId
      : hosts.contains(fixture.awayNationId)
          ? fixture.awayNationId
          : 0;
  return (neutral: true, hostId: host);
}
