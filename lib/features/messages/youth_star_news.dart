import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// Youth news: now and then, a word from the academy staff about one of the
/// manager's own boys who stood out for an age-group side.
///
/// Youth football is not simulated match by match: the pyramid is a derived
/// pool, and no U-21 fixture or scorer exists anywhere in the save. So the
/// performance is DERIVED, deterministically from the save seed and the
/// window, and is drawn only from what the game really knows about the boy:
/// his position (a keeper keeps clean sheets, a forward scores), his three
/// attributes (what the staff praise), and how far his rating sits from the
/// senior squad's (how close he is). The opponent is the side the SENIORS met
/// in the same window, which is how international age-group football is
/// scheduled; nothing else in the game reports a youth result, so nothing can
/// contradict the one told here.

/// How far back a finished window may be and still be reported, in days.
///
/// The inbox syncs on every read, and an existing save opened for the first
/// time on this build would otherwise file a report for every window of its
/// history. Four months covers the latest window or two and nothing older.
const int kYouthNewsLookbackDays = 120;

/// The share of windows that bring a youth report, in percent.
///
/// Roughly every other window: two or three a year. Enough to make the
/// academy feel alive, rare enough that it is news when it comes.
const int kYouthNewsChancePercent = 50;

/// Fixtures more than this many days apart belong to different windows.
const int _windowGapDays = 14;

/// Rounds the age-group sides plausibly play alongside: qualifiers,
/// friendlies and the Nations Cup league. A finals tournament is a summer of
/// its own and the youth sides are not in it.
bool _ordinaryRound(String? round) =>
    round == null ||
    round == 'CQ' ||
    round == 'FRIENDLY' ||
    round == 'NL' ||
    round == 'NGROUP';

/// One finished international window of the manager's nation.
typedef YouthWindow = ({String key, DateTime end, int opponentId});

/// The manager's finished ordinary windows that ended within
/// [lookbackDays] of [today], oldest first.
///
/// A window is a run of [nationId]'s fixtures no more than a fortnight apart.
/// It counts only once every fixture in it has been played and at least one
/// is an ordinary round; the opponent is the one met last in it.
List<YouthWindow> recentYouthWindows({
  required List<Fixture> fixtures,
  required int nationId,
  required DateTime today,
  int lookbackDays = kYouthNewsLookbackDays,
}) {
  final own = [
    for (final f in fixtures)
      if (f.homeNationId == nationId || f.awayNationId == nationId) f,
  ]..sort((a, b) => a.date.compareTo(b.date));
  final windows = <List<Fixture>>[];
  for (final f in own) {
    if (windows.isNotEmpty &&
        f.date.difference(windows.last.last.date).inDays <= _windowGapDays) {
      windows.last.add(f);
    } else {
      windows.add([f]);
    }
  }
  final out = <YouthWindow>[];
  final cutoff = today.subtract(Duration(days: lookbackDays));
  for (final w in windows) {
    if (w.any((f) => !f.played)) continue;
    final ordinary = w.where((f) => _ordinaryRound(f.round)).toList();
    if (ordinary.isEmpty) continue;
    final end = w.last.date;
    if (end.isAfter(today) || end.isBefore(cutoff)) continue;
    final last = ordinary.last;
    final first = w.first.date;
    out.add((
      key:
          '${first.year}${first.month.toString().padLeft(2, '0')}'
          '${first.day.toString().padLeft(2, '0')}',
      end: end,
      opponentId: last.homeNationId == nationId
          ? last.awayNationId
          : last.homeNationId,
    ));
  }
  return out;
}

/// The inbox key a window's report is filed under. The featured player rides
/// in the key so the next reports can steer clear of him.
String youthNewsKey(String windowKey, int playerId) =>
    'youthstar:$windowKey:$playerId';

/// Whether [windowKey] already has its report among [existing] keys.
bool youthNewsFiled(Set<String> existing, String windowKey) =>
    existing.any((k) => k.startsWith('youthstar:$windowKey:'));

/// The players featured in the two most recent reports among [existing], so
/// a boy is not the story three windows running.
Set<int> recentlyFeatured(Set<String> existing) {
  final filed = <(String, int)>[];
  for (final k in existing) {
    final parts = k.split(':');
    if (parts.length != 3 || parts[0] != 'youthstar') continue;
    final id = int.tryParse(parts[2]);
    if (id != null) filed.add((parts[1], id));
  }
  filed.sort((a, b) => b.$1.compareTo(a.$1));
  return {for (final f in filed.take(2)) f.$2};
}

/// Whether [windowKey] brings a youth report at all, for this save.
bool youthNewsFires(String windowKey, int saveSeed) =>
    varietySeed('youthstar:$windowKey:$saveSeed') % 100 <
    kYouthNewsChancePercent;

/// The senior squad's bar: the rating of the [squadSize]th best player in the
/// senior pool, or the weakest when the pool is smaller.
int seniorSquadBar(Iterable<Player> seniors, {int squadSize = 23}) {
  final ratings = [for (final p in seniors) p.overall]
    ..sort((a, b) => b.compareTo(a));
  if (ratings.isEmpty) return 99;
  return ratings[(squadSize - 1).clamp(0, ratings.length - 1)];
}

/// How far a boy is from the senior squad, as the staff put it.
enum YouthReadiness { ready, close, growing, raw }

/// [rating] against the senior squad's [bar].
YouthReadiness readinessOf(int rating, int bar) {
  final gap = bar - rating;
  if (gap <= 0) return YouthReadiness.ready;
  if (gap <= 4) return YouthReadiness.close;
  if (gap <= 10) return YouthReadiness.growing;
  return YouthReadiness.raw;
}

/// What a performance was, before it is put into words.
enum YouthFeat { goals, assists, cleanSheet, display }

/// One standout performance, ready for the inbox.
typedef YouthStandout = ({
  int playerId,
  YouthFeat feat,
  int count,
  YouthReadiness readiness,
  MsgPart title,
  MsgPart body,
});

/// The youngest age a report is written about: an under-17. Younger boys are
/// watched, not reported on.
const int kYouthNewsMinAge = 15;

/// The boy who stood out in [windowKey], and what he did, or null when the
/// pyramid has nobody to report on.
///
/// [youth] is the nation's pyramid now; [excluded] the boys already in the
/// senior picture (capped or called up), who are squad news rather than
/// academy news, plus the ones featured lately; [marked] the manager's
/// watchlist, whose boys are always in the running. [opponent] is the name of
/// the side met in the window, [squadBar] the senior squad's rating bar (see
/// [seniorSquadBar]).
YouthStandout? youthStandout({
  required String windowKey,
  required int saveSeed,
  required List<Player> youth,
  required int squadBar,
  required String opponent,
  Set<int> excluded = const {},
  Set<int> marked = const {},
}) {
  final pool = [
    for (final p in youth)
      if (p.age >= kYouthNewsMinAge &&
          YouthLevel.forAge(p.age) != null &&
          !excluded.contains(p.id))
        p,
  ];
  if (pool.isEmpty) return null;
  // Promise, not present level: where the boy is heading. A sixteen-year-old
  // who will be a star outranks a twenty-year-old who has stopped growing.
  double promise(Player p) => p.overall + PlayerAging.peakOffset(p.age);
  pool.sort((a, b) {
    final byPromise = promise(b).compareTo(promise(a));
    return byPromise != 0 ? byPromise : a.id.compareTo(b.id);
  });
  final candidates = [
    ...pool.take(5),
    for (final p in pool.skip(5).take(15))
      if (marked.contains(p.id)) p,
  ];
  final seed = varietySeed('youthstar:pick:$windowKey:$saveSeed');
  final player = candidates[seed % candidates.length];
  final level = YouthLevel.forAge(player.age)!.label;
  final roll = varietySeed('youthstar:feat:$windowKey:${player.id}') % 100;

  final (feat, count) = switch (player.category) {
    PositionCategory.goalkeeper =>
      roll < 70 ? (YouthFeat.cleanSheet, 0) : (YouthFeat.display, 0),
    PositionCategory.defender =>
      roll < 50
          ? (YouthFeat.cleanSheet, 0)
          : roll < 65
          ? (YouthFeat.goals, 1)
          : (YouthFeat.display, 0),
    PositionCategory.midfielder =>
      roll < 45
          ? (YouthFeat.assists, roll < 15 ? 2 : 1)
          : roll < 65
          ? (YouthFeat.goals, 1)
          : (YouthFeat.display, 0),
    PositionCategory.forward =>
      roll < 65
          ? (YouthFeat.goals, roll < 32 ? 1 : (roll < 55 ? 2 : 3))
          : roll < 75
          ? (YouthFeat.assists, 1)
          : (YouthFeat.display, 0),
  };
  final v = seed ~/ 7;
  final name = player.name;
  // A mark out of ten from the staff: eight, or nine for one in four.
  final mark = (seed ~/ 3) % 4 == 0 ? 9 : 8;
  final featLine = switch (feat) {
    YouthFeat.goals => MsgText(
      pickVariant(const [
        MsgKey.newsYouthGoals1,
        MsgKey.newsYouthGoals2,
        MsgKey.newsYouthGoals3,
      ], v),
      [name, level, opponent, count],
    ),
    YouthFeat.assists => MsgText(
      pickVariant(const [
        MsgKey.newsYouthAssists1,
        MsgKey.newsYouthAssists2,
      ], v),
      [name, level, opponent, count],
    ),
    YouthFeat.cleanSheet => MsgText(
      pickVariant(const [
        MsgKey.newsYouthCleanSheet1,
        MsgKey.newsYouthCleanSheet2,
      ], v),
      [name, level, opponent],
    ),
    YouthFeat.display => MsgText(
      pickVariant(const [
        MsgKey.newsYouthDisplay1,
        MsgKey.newsYouthDisplay2,
      ], v),
      [name, level, opponent, mark],
    ),
  };
  final readiness = readinessOf(player.overall, squadBar);
  final devKeys = switch (readiness) {
    YouthReadiness.ready => const [
      MsgKey.newsYouthDevReady1,
      MsgKey.newsYouthDevReady2,
    ],
    YouthReadiness.close => const [
      MsgKey.newsYouthDevClose1,
      MsgKey.newsYouthDevClose2,
    ],
    YouthReadiness.growing => const [
      MsgKey.newsYouthDevGrowing1,
      MsgKey.newsYouthDevGrowing2,
    ],
    YouthReadiness.raw => const [
      MsgKey.newsYouthDevRaw1,
      MsgKey.newsYouthDevRaw2,
    ],
  };
  final title = MsgText(
    pickVariant(const [
      MsgKey.newsYouthTitle1,
      MsgKey.newsYouthTitle2,
      MsgKey.newsYouthTitle3,
    ], seed ~/ 5),
    [name, level],
  );
  return (
    playerId: player.id,
    feat: feat,
    count: count,
    readiness: readiness,
    title: title,
    body: MsgJoin([
      featLine,
      MsgText(pickVariant(devKeys, seed ~/ 11)),
      MsgText(strengthKey(player)),
    ], separator: ' '),
  );
}

/// The quality a player is praised for: his best attribute, read through his
/// position. Ties go physical, technical, stamina, so the line never wavers.
MsgKey strengthKey(Player p) {
  final a = p.attributes;
  final best = a.physical >= a.technical && a.physical >= a.stamina
      ? 0
      : a.technical >= a.stamina
      ? 1
      : 2;
  return switch ((p.category, best)) {
    (PositionCategory.goalkeeper, 0) => MsgKey.newsYouthStrengthGkPhysical,
    (PositionCategory.goalkeeper, 1) => MsgKey.newsYouthStrengthGkTechnical,
    (PositionCategory.goalkeeper, _) => MsgKey.newsYouthStrengthGkStamina,
    (PositionCategory.defender, 0) => MsgKey.newsYouthStrengthDefPhysical,
    (PositionCategory.defender, 1) => MsgKey.newsYouthStrengthDefTechnical,
    (PositionCategory.defender, _) => MsgKey.newsYouthStrengthDefStamina,
    (PositionCategory.midfielder, 0) => MsgKey.newsYouthStrengthMidPhysical,
    (PositionCategory.midfielder, 1) => MsgKey.newsYouthStrengthMidTechnical,
    (PositionCategory.midfielder, _) => MsgKey.newsYouthStrengthMidStamina,
    (PositionCategory.forward, 0) => MsgKey.newsYouthStrengthFwdPhysical,
    (PositionCategory.forward, 1) => MsgKey.newsYouthStrengthFwdTechnical,
    (PositionCategory.forward, _) => MsgKey.newsYouthStrengthFwdStamina,
  };
}
