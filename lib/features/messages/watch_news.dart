import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// How far a marked boy must beat HIS OWN AGE CURVE by, in a year, before the
/// inbox says so.
///
/// Not the raw year's gain, which is what the youth screen's breakout tag reads
/// and which would file a message about almost every boy every year: a
/// thirteen-year-old adds five or six rating points a season simply by growing
/// up, and a seventeen-year-old three. Those are the numbers every player of
/// that age carries, and a scout who reported them would be reporting the
/// calendar. What is worth hearing is the part that is about the FOOTBALLER —
/// the gain over and above the curve, which is where a superstar's lift, a late
/// bloom, or the minutes he has been given show up.
///
/// A boy who was ALWAYS going to be good does not clear this bar, and should
/// not: the wonderkid's ceiling spares him most of the youth markdown from the
/// day he comes in, so he arrives already rated highly rather than jumping
/// later. The shortlist shows him for what he is; the inbox saves its breath
/// for the boy who changed.
///
/// Three points of it. Reading a rating off three attributes rounds, and the
/// expected figure below is a plain mean where the rating is position-weighted,
/// so a point either way is measurement noise; three is outside it and, in a
/// pyramid of thirty-five boys, lands on one or two of them in a good year.
const int kWatchJumpPoints = 3;

/// What a player of [age] is expected to add by his next birthday, in overall
/// points, from the age curve alone.
///
/// Read off [PlayerAging.peakOffset] rather than restated, so it cannot drift
/// the day the curve is retuned — the same reason `peakOffset` itself reads the
/// yearly deltas rather than listing them.
int expectedYearGain(int age) =>
    (PlayerAging.peakOffset(age) - PlayerAging.peakOffset(age + 1)).round();

/// The year's news about the boys the manager is following, as ONE message.
///
/// One message a year, not one per boy per year: the press batch showed that a
/// message per player per year is noise, and this is the same shape of mistake
/// waiting to happen — a manager following eight boys would get eight posts
/// every rollover. A digest is also the truth about the pyramid, which moves
/// once a year and not otherwise.
///
/// [now] and [before] are the youth pool this year and last, by player id;
/// [marked] the boys on the watchlist BEFORE this year began, so marking a boy
/// today never backfills a report about the years he was not being watched.
/// Null when nobody the manager is watching did anything.
({MsgPart title, MsgPart body})? watchlistDigest({
  required Set<int> marked,
  required Map<int, Player> now,
  required Map<int, Player> before,
  required int year,
}) {
  final movers = <({Player player, int gain, int excess, YouthLevel? band})>[];
  for (final id in marked) {
    final player = now[id];
    // Gone from the pyramid: released, or through to the seniors. The shortlist
    // says which; the inbox does not report an absence as a development.
    if (player == null) continue;
    final was = before[id];
    // No reading to compare against — he came in with this year's intake.
    if (was == null) continue;
    final gain = player.overall - was.overall;
    final excess = gain - expectedYearGain(was.age);
    final from = YouthLevel.forAge(was.age);
    final to = YouthLevel.forAge(player.age);
    final band = to != null && to != from ? to : null;
    if (excess < kWatchJumpPoints && band == null) continue;
    movers.add((player: player, gain: gain, excess: excess, band: band));
  }
  if (movers.isEmpty) return null;
  // Biggest step forward first, and fully ordered rather than left to the
  // sort's whim: a message is written once into a save and must read the same
  // for whoever opens it.
  movers.sort((a, b) {
    final byExcess = b.excess.compareTo(a.excess);
    if (byExcess != 0) return byExcess;
    final byRating = b.player.overall.compareTo(a.player.overall);
    if (byRating != 0) return byRating;
    return a.player.id.compareTo(b.player.id);
  });
  final lines = <MsgPart>[
    for (final m in movers) ...[
      if (m.excess >= kWatchJumpPoints)
        MsgText(MsgKey.newsWatchJump, [
          m.player.name,
          m.player.overall,
          m.gain,
        ]),
      if (m.band case final YouthLevel band)
        MsgText(MsgKey.newsWatchBand, [m.player.name, band.label]),
    ],
  ];
  return (
    title: MsgText(MsgKey.newsWatchTitle, [year]),
    body: MsgJoin(lines, separator: ' '),
  );
}

/// A marked boy who has won his first senior cap.
///
/// His own message, not a line in the digest: a debut happens once in a career
/// and it happens on a match day rather than at a rollover. Only boys still in
/// the pyramid are reported — a marked player who has already aged out and is
/// capped at twenty-two is ordinary squad news, and the squad report covers him.
List<({int playerId, MsgPart title, MsgPart body})> watchlistDebuts({
  required Set<int> marked,
  required Map<int, Player> pool,
  required Map<int, int> capsByPlayer,
}) {
  final out = <({int playerId, MsgPart title, MsgPart body})>[];
  for (final id in marked) {
    final player = pool[id];
    if (player == null) continue;
    if ((capsByPlayer[id] ?? 0) < 1) continue;
    out.add((
      playerId: id,
      title: MsgText(MsgKey.newsWatchDebutTitle, [player.name]),
      body: MsgText(MsgKey.newsWatchDebutBody, [
        player.name,
        player.age,
        player.overall,
      ]),
    ));
  }
  out.sort((a, b) => a.playerId.compareTo(b.playerId));
  return out;
}
