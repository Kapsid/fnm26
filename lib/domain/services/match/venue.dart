import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';

/// Where a match is played.
///
/// [neutral] says nobody gets a home crowd by default; [hostId] is the one of
/// the two teams that is hosting the tournament (0 when neither is), and so
/// keeps its crowd; [tournamentHostIds] is the whole host candidature — the
/// countries whose grounds the tournament is actually played in, primary host
/// first.
///
/// The last of these is the important one for anything that names a stadium. A
/// neutral finals is played in the HOST country whether or not the host is on
/// the pitch; keying the ground off the nominal home side put every cup final
/// in the beaten finalist's own back garden.
typedef MatchVenue = ({bool neutral, int hostId, List<int> tournamentHostIds});

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

/// The Continental Clash: the one-off meeting of the European and South
/// American champions. It belongs to neither continent, so it is played at a
/// neutral ground in a third country — as the real fixture is.
const _clashRound = 'FFINAL';

/// The showpiece rounds, played at the tournament's marquee ground (the primary
/// host's largest stadium) rather than moving around the country.
const _showpieceRounds = {'FINAL', 'CFINAL', '3RD', 'C3RD', _clashRound};

/// Whether [round] is a finals round played at a neutral host (World Cup or
/// continental finals, or the Continental Clash), as opposed to a home-and-away
/// game.
bool isNeutralFinalsRound(String? round) =>
    round != null &&
    (round == _clashRound ||
        _wcFinalsRounds.contains(round) ||
        _continentalFinalsRounds.contains(round));

/// The third country that stages a Continental Clash: a well-supported nation
/// that is NOT one of the two champions, picked deterministically per fixture
/// so the same edition is always played at the same ground, and so consecutive
/// editions move around the world rather than settling in one place.
///
/// Drawn from the strongest nations by seed ranking — the Clash is a showpiece
/// and goes to a country that can fill a big stadium.
int _clashHost({
  required Fixture fixture,
  required List<Nation> nations,
  required int seed,
}) {
  final candidates =
      [
        for (final n in nations)
          if (n.id != fixture.homeNationId && n.id != fixture.awayNationId) n,
      ]..sort((a, b) {
        final byRank = a.ranking.compareTo(b.ranking);
        return byRank != 0 ? byRank : a.id.compareTo(b.id);
      });
  if (candidates.isEmpty) return 0;
  final pool = candidates.take(24).toList();
  var h = (fixture.id ^ seed ^ 0x3C1A5) & 0x7fffffff;
  h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
  return pool[(h ^ (h >> 16)) % pool.length].id;
}

/// Whether [round] is played at the tournament's showpiece ground.
bool isShowpieceRound(String? round) =>
    round != null && _showpieceRounds.contains(round);

/// Decides where a fixture is played: a normal home-and-away game (the listed
/// home side enjoys home advantage), or a neutral finals match at the host
/// nation's grounds (nobody enjoys home advantage, unless the host is one of
/// the two teams).
MatchVenue venueForFixture({
  required Fixture fixture,
  required List<Nation> nations,
  required int seed,
  required int cycle,
}) {
  final round = fixture.round;
  const homeAndAway = (
    neutral: false,
    hostId: 0,
    tournamentHostIds: <int>[],
  );
  if (round == null) return homeAndAway; // WC qualifying

  // The Continental Clash: neither champion is at home and neither's continent
  // stages it. It used to fall through to home-and-away, which handed the
  // European champion (always the nominal home side) a home crowd in what is
  // meant to be an even meeting of two continents.
  if (round == _clashRound) {
    final host = _clashHost(fixture: fixture, nations: nations, seed: seed);
    return (
      neutral: true,
      hostId: 0,
      tournamentHostIds: host == 0 ? const <int>[] : <int>[host],
    );
  }

  final isWc = _wcFinalsRounds.contains(round);
  final isCont = _continentalFinalsRounds.contains(round);
  if (!isWc && !isCont) {
    // Nations Cup groups and friendlies are genuine home-and-away games.
    return homeAndAway;
  }

  List<int> hosts;
  if (isWc) {
    hosts = WorldCupHosts.hostsFor(
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
        ? const []
        : WorldCupHosts.continentalHostsFor(
            confederation: conf,
            cycle: cycle,
            seed: seed,
            nations: nations,
          );
  }

  final playingHost = hosts.contains(fixture.homeNationId)
      ? fixture.homeNationId
      : hosts.contains(fixture.awayNationId)
      ? fixture.awayNationId
      : 0;
  return (neutral: true, hostId: playingHost, tournamentHostIds: hosts);
}
