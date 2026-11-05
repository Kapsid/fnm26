import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/match_baseline.dart';
import '../../helpers/match_goldens.dart';

/// Task 3 of the pitch view: the engine records set pieces, fouls, offsides
/// and subs, all on the detail stream, without changing any outcome (the
/// goldens pin that). Penalties and direct free kicks, which do change
/// outcomes, came with Task 4 (match_play_pass_test.dart).
void main() {
  const engine = MatchEngine();

  // A spread of matches: flat sides, long throws on both sides, and level
  // knockouts that go to extra time.
  final matches = <MatchResult>[
    for (var i = 0; i < 60; i++)
      engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x5E70, i),
      ),
    for (var i = 0; i < 40; i++)
      engine.play(
        home: longThrowTeam(1, 80),
        away: longThrowTeam(2, 72),
        rng: SeededRng.forFixture(0x5E71, i),
      ),
    for (var i = 0; i < 40; i++)
      engine.play(
        home: ratedTeam(1, 75),
        away: ratedTeam(2, 75),
        rng: SeededRng.forFixture(0x5E72, i),
        neutralVenue: true,
        extraTimeIfLevel: true,
      ),
  ];

  int sideOf(int playerId) => playerId ~/ 100;

  test('every card follows a foul by the carded player', () {
    var cards = 0;
    for (final r in matches) {
      final fouls = r.moments.whereType<FoulMoment>().toList();
      for (var i = 0; i < r.events.length; i++) {
        final e = r.events[i];
        if (e.type != MatchEventType.yellowCard &&
            e.type != MatchEventType.redCard) {
          continue;
        }
        cards++;
        final foul = fouls.where((f) => f.cardEventIndex == i).toList();
        expect(foul, hasLength(1), reason: 'card $i');
        final f = foul.single;
        expect(f.foulerId, e.playerId);
        expect(f.minute, e.minute);
        expect(f.stoppage, e.stoppage);
        // The foul belongs to the side fouled.
        expect(f.teamNationId, isNot(e.teamNationId));
        expect(sideOf(f.fouledId), f.teamNationId);
        expect(f.advantage, isFalse);
      }
      // No foul points at anything but a card.
      for (final f in fouls) {
        if (f.cardEventIndex case final i?) {
          expect(
            r.events[i].type,
            isIn([
              MatchEventType.yellowCard,
              MatchEventType.redCard,
            ]),
          );
        }
      }
    }
    expect(cards, greaterThan(50));
  });

  test('every set-piece goal follows its corner or free kick with the '
      'assister as taker', () {
    var goals = 0;
    final kinds = <SetPieceKind>{};
    for (final r in matches) {
      final ms = r.moments;
      for (var k = 0; k < ms.length; k++) {
        final s = ms[k];
        if (s is! ShotMoment || !s.header) continue;
        final before = ms[k - 1];
        expect(before, isA<SetPieceMoment>(), reason: '$s');
        final sp = before as SetPieceMoment;
        expect(sp.kind, switch (s.origin) {
          ShotOrigin.corner => SetPieceKind.corner,
          ShotOrigin.freeKickCross => SetPieceKind.freeKick,
          ShotOrigin.longThrow => SetPieceKind.longThrow,
          _ => throw StateError('header from ${s.origin}'),
        });
        kinds.add(sp.kind);
        expect(sp.teamNationId, s.teamNationId);
        expect((sp.minute, sp.stoppage), (s.minute, s.stoppage));
        expect(sp.routine, isFalse);
        if (s.assistId case final a?) expect(sp.takerId, a);
        if (s.outcome == ShotOutcome.goal) {
          goals++;
          final e = r.events[s.goalEventIndex!];
          expect(e.setPiece, isTrue);
          if (e.assistPlayerId case final a?) expect(sp.takerId, a);
        }
        // A crossed free kick was won by a foul, recorded right before it.
        if (sp.kind == SetPieceKind.freeKick) {
          final foul = ms[k - 2];
          expect(foul, isA<FoulMoment>());
          expect((foul as FoulMoment).teamNationId, s.teamNationId);
          expect(foul.zone, sp.zone);
        }
      }
    }
    expect(goals, greaterThan(20));
    expect(kinds, {
      SetPieceKind.corner,
      SetPieceKind.freeKick,
      SetPieceKind.longThrow,
    });
  });

  test('every set-piece goal event has a header shot behind it', () {
    for (final r in matches) {
      final idx = {
        for (final s in r.moments.whereType<ShotMoment>())
          if (s.goalEventIndex case final i?) i: s,
      };
      for (var i = 0; i < r.events.length; i++) {
        final e = r.events[i];
        if (e.type != MatchEventType.goal || !e.setPiece) continue;
        expect(idx[i]!.header, isTrue);
        expect(
          idx[i]!.origin == ShotOrigin.longThrow,
          e.longThrow,
        );
      }
    }
  });

  test('a foul in a dangerous place gives a staged free kick, others a '
      'routine one, advantage none', () {
    var dangerous = 0, routine = 0, advantage = 0;
    for (final r in matches) {
      final ms = r.moments;
      for (var k = 0; k < ms.length; k++) {
        final f = ms[k];
        if (f is! FoulMoment) continue;
        final next = k + 1 < ms.length ? ms[k + 1] : null;
        if (f.advantage) {
          // Waved on: no free kick follows.
          advantage++;
          expect(f.zone, PitchZone.midfield);
          expect(f.cardEventIndex, isNull);
          expect(
            next is SetPieceMoment && next.kind == SetPieceKind.freeKick,
            isFalse,
            reason: '$f then $next',
          );
          continue;
        }
        // A foul in the box is a penalty (match_play_pass_test.dart).
        if (const [
          PitchZone.boxCentre,
          PitchZone.boxLeft,
          PitchZone.boxRight,
        ].contains(f.zone)) {
          expect(next, isA<ShotMoment>(), reason: '$f');
          expect((next! as ShotMoment).origin, ShotOrigin.penalty);
          continue;
        }
        expect(next, isA<SetPieceMoment>(), reason: '$f');
        final sp = next! as SetPieceMoment;
        expect(sp.kind, SetPieceKind.freeKick);
        expect(sp.teamNationId, f.teamNationId);
        expect(sp.zone, f.zone);
        final staged = const [
          PitchZone.edgeOfBox,
          PitchZone.wideLeft,
          PitchZone.wideRight,
        ].contains(f.zone);
        expect(sp.routine, !staged);
        if (staged) {
          dangerous++;
        } else {
          routine++;
          expect(sp.takerId, f.fouledId);
        }
      }
    }
    expect(dangerous, greaterThan(100));
    expect(routine, greaterThan(100));
    expect(advantage, greaterThan(10));
  });

  test('rates: corners 8-12, fouls 18-28, offsides 2-6 per match over 600 '
      'matches', () {
    const n = 600;
    var corners = 0, freeKicks = 0, fouls = 0, offsides = 0;
    var killed = 0, restarts = 0;
    for (var i = 0; i < n; i++) {
      final r = engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x5E73, i),
      );
      for (final m in r.moments) {
        switch (m) {
          case SetPieceMoment(kind: SetPieceKind.corner):
            corners++;
          case SetPieceMoment(kind: SetPieceKind.freeKick, routine: false):
            freeKicks++;
          case FoulMoment():
            fouls++;
          case OffsideMoment(:final endsAttack):
            offsides++;
            if (endsAttack) killed++;
          default:
            break;
        }
      }
      expect(r.routineRestarts, hasLength(91));
      expect(r.routineRestarts.first, 0);
      restarts += r.routineRestarts.fold(0, (a, b) => a + b);
    }
    // ignore: avoid_print
    print(
      'per match: corners ${corners / n}, staged free kicks ${freeKicks / n}, '
      'fouls ${fouls / n}, offsides ${offsides / n} '
      '(${(killed / offsides * 100).round()}% end an attack), '
      'routine restarts ${restarts / n}',
    );
    expect(corners / n, inInclusiveRange(8, 12));
    expect(fouls / n, inInclusiveRange(18, 28));
    expect(offsides / n, inInclusiveRange(2, 6));
    expect(killed / offsides, closeTo(0.8, 0.05));
    expect(restarts / n, inInclusiveRange(40, 80));
  });

  test('staged free kicks: 3-4.5 per match, attacking-third fouls only', () {
    const n = 600;
    var staged = 0;
    for (var i = 0; i < n; i++) {
      final r = engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x5E77, i),
      );
      for (final m in r.moments) {
        if (m is SetPieceMoment &&
            m.kind == SetPieceKind.freeKick &&
            !m.routine) {
          staged++;
          expect(
            m.zone,
            isIn(const [
              PitchZone.edgeOfBox,
              PitchZone.wideLeft,
              PitchZone.wideRight,
            ]),
          );
        }
      }
    }
    // ignore: avoid_print
    print('staged free kicks per match: ${staged / n}');
    expect(staged / n, inInclusiveRange(3, 4.5));
  });

  test('open-play shot zones spread: 2.5+ distinct zones a side a match, '
      'about 30% box, 35% edge, 35% long range', () {
    const n = 600;
    const box = [
      PitchZone.sixYard,
      PitchZone.boxCentre,
      PitchZone.boxLeft,
      PitchZone.boxRight,
    ];
    var distinct = 0, inBox = 0, edge = 0, long = 0, total = 0;
    var hiBox = 0, hiTotal = 0, loBox = 0, loTotal = 0;
    for (var i = 0; i < n; i++) {
      final r = engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x5E78, i),
      );
      for (final side in [1, 2]) {
        final zones = <PitchZone>{};
        for (final s in r.moments.whereType<ShotMoment>()) {
          if (s.teamNationId != side || s.origin != ShotOrigin.openPlay) {
            continue;
          }
          zones.add(s.zone);
          total++;
          final b = box.contains(s.zone);
          if (b) inBox++;
          if (s.zone == PitchZone.edgeOfBox) edge++;
          if (s.zone == PitchZone.longRange) long++;
          if (s.xg >= 0.16) {
            hiTotal++;
            if (b) hiBox++;
          } else {
            loTotal++;
            if (b) loBox++;
          }
        }
        distinct += zones.length;
      }
    }
    // ignore: avoid_print
    print(
      'distinct zones a side a match ${distinct / (2 * n)}; box '
      '${inBox / total}, edge ${edge / total}, long ${long / total}; box '
      'share xg>=0.16 ${hiBox / hiTotal}, below ${loBox / loTotal}',
    );
    expect(distinct / (2 * n), greaterThanOrEqualTo(2.5));
    expect(inBox / total, closeTo(0.30, 0.05));
    expect(edge / total, closeTo(0.35, 0.05));
    expect(long / total, closeTo(0.35, 0.05));
    expect(hiBox / hiTotal, greaterThan(loBox / loTotal + 0.05));
  });

  test('sub moments carry the off player id', () {
    final home = ratedTeam(1, 78);
    final away = ratedTeam(2, 74);
    final benchHome = player(
      id: 150,
      nationId: 1,
      position: PlayerPosition.st,
      attributes: flatAttributes(78),
    );
    final benchAway = player(
      id: 250,
      nationId: 2,
      position: PlayerPosition.cm,
      attributes: flatAttributes(74),
    );
    var named = 0;
    for (var i = 0; i < 10; i++) {
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(0x5E74, i),
        subs: [
          Substitution(
            teamNationId: 1,
            minute: 60,
            offId: home.xi[10].id,
            on: benchHome,
          ),
        ],
        changes: [
          TacticalChange(
            teamNationId: 2,
            minute: 70,
            formation: Formation.f433,
            instructions: away.instructions,
            xi: [...away.xi.take(6), benchAway, ...away.xi.skip(7)],
          ),
        ],
      );
      final subs = r.moments.whereType<SubMoment>().toList();
      final subEvents = [
        for (var k = 0; k < r.events.length; k++)
          if (r.events[k].type == MatchEventType.substitution) k,
      ];
      expect(subs.length, subEvents.length);
      expect(subs.map((s) => s.eventIndex).toSet(), subEvents.toSet());
      for (final s in subs) {
        final e = r.events[s.eventIndex];
        expect(s.onId, e.playerId);
        expect(s.offId, e.secondaryPlayerId);
        expect(s.teamNationId, e.teamNationId);
        expect(s.minute, e.minute);
        expect(s.stoppage, e.stoppage);
      }
      // The named man goes off, unless he had already left the pitch (sent
      // off or hurt): then the newcomer fills an empty place.
      for (final s in subs) {
        if (s.onId == 150) expect(s.offId, home.xi[10].id);
        if (s.onId == 250) expect(s.offId, anyOf(isNull, away.xi[6].id));
        if (s.offId != null) named++;
        final e = r.events[s.eventIndex];
        expect(
          e.secondaryName,
          s.offId == null ? isNull : 'Player ${s.offId}',
        );
      }
    }
    expect(named, greaterThan(15));
  });

  test('every fouled and offside player is on the pitch at the time, and no '
      'offside player is a keeper', () {
    // Plus matches with a planned sub and a live change, so men come on
    // and go off.
    final home = ratedTeam(1, 78);
    final away = ratedTeam(2, 74);
    final withSubs = [
      for (var i = 0; i < 40; i++)
        engine.play(
          home: home,
          away: away,
          rng: SeededRng.forFixture(0x5E79, i),
          subs: [
            Substitution(
              teamNationId: 1,
              minute: 60,
              offId: home.xi[10].id,
              on: player(
                id: 150,
                nationId: 1,
                position: PlayerPosition.st,
                attributes: flatAttributes(78),
              ),
            ),
          ],
          changes: [
            TacticalChange(
              teamNationId: 2,
              minute: 70,
              formation: Formation.f433,
              instructions: away.instructions,
              xi: [
                ...away.xi.take(6),
                player(
                  id: 250,
                  nationId: 2,
                  position: PlayerPosition.cm,
                  attributes: flatAttributes(74),
                ),
                ...away.xi.skip(7),
              ],
            ),
          ],
        ),
    ];
    var checked = 0, subbed = 0;
    for (final r in [...matches, ...withSubs]) {
      // Who was on the pitch, rebuilt from the events: (minute, stoppage)
      // each man came on (0 for a starter) and went off (sub, red, injury).
      final on = <int, (int, int)>{
        for (var n = 1; n <= 2; n++)
          for (var i = 0; i < 11; i++) n * 100 + i: (0, 0),
      };
      final off = <int, (int, int)>{};
      final offBySub = <int>{};
      for (final e in r.events) {
        final at = (e.minute, e.stoppage);
        switch (e.type) {
          case MatchEventType.substitution:
            on[e.playerId] = at;
            subbed++;
            if (e.secondaryPlayerId case final id?) {
              off[id] = at;
              offBySub.add(id);
            }
          case MatchEventType.redCard:
          case MatchEventType.injury:
            off[e.playerId] = at;
          case MatchEventType.goal:
          case MatchEventType.yellowCard:
            break;
        }
      }
      bool before((int, int) a, (int, int) b) =>
          a.$1 < b.$1 || (a.$1 == b.$1 && a.$2 < b.$2);
      // Subs come first in a minute, so a man subbed on is on for all of
      // it and a man subbed off for none. A red or a knock comes later in
      // the minute than the moments before it, so he still counts as on
      // in the minute he left.
      void expectOn(int id, MatchMoment m) {
        final at = (m.minute, m.stoppage);
        final came = on[id];
        expect(came, isNotNull, reason: '$id never played: $m');
        expect(before(at, came!), isFalse, reason: '$id not on yet: $m');
        if (off[id] case final left?) {
          final gone = offBySub.contains(id)
              ? !before(at, left)
              : before(left, at);
          expect(gone, isFalse, reason: '$id already off: $m');
        }
        checked++;
      }

      for (final m in r.moments) {
        switch (m) {
          case FoulMoment(:final fouledId, :final foulerId):
            expectOn(fouledId, m);
            expectOn(foulerId, m);
          case OffsideMoment(:final playerId):
            expectOn(playerId, m);
            expect(playerId % 100, isNot(0), reason: 'keeper offside: $m');
          default:
            break;
        }
      }
    }
    expect(checked, greaterThan(1000));
    expect(subbed, greaterThan(40));
  });

  test('a keeper sent off with no keeper to replace him leaves later shots '
      'with no keeper', () {
    final home = ratedTeam(1, 80);
    final base = ratedTeam(2, 74);
    final keeperId = base.xi.first.id;
    expect(base.xi.first.category, PositionCategory.goalkeeper);
    // A hothead keeper, so a red for him turns up within a few hundred games.
    final away = MatchTeam(
      nationId: 2,
      instructions: base.instructions,
      xi: base.xi,
      traitsByPlayer: {
        keeperId: const [PlayerTrait.hothead],
      },
    );
    MatchResult? found;
    late int redAt;
    for (var i = 0; i < 4000 && found == null; i++) {
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(0x5E75, i),
      );
      final red = r.events.where(
        (e) =>
            e.type == MatchEventType.redCard &&
            e.playerId == keeperId &&
            e.minute < 80,
      );
      if (red.isNotEmpty) {
        found = r;
        redAt = r.events.indexOf(red.first);
      }
    }
    expect(found, isNotNull, reason: 'no keeper red in 4000 games');
    final r = found!;
    final red = r.events[redAt];
    final shots = r.moments
        .whereType<ShotMoment>()
        .where((s) => s.teamNationId == 1)
        .toList();
    // The red's foul: its place in the minute. Discipline comes last in a
    // minute, but a penalty foul's card is shown before the kick.
    final redFoul = r.moments.whereType<FoulMoment>().singleWhere(
      (f) => f.cardEventIndex == redAt,
    );
    // Every shot before the red had a keeper to face, every one after none.
    bool after(ShotMoment s) =>
        s.minute > red.minute ||
        (s.minute == red.minute && s.stoppage > red.stoppage) ||
        (s.minute == red.minute &&
            s.stoppage == red.stoppage &&
            s.seq > redFoul.seq);
    expect(shots.where(after), isNotEmpty);
    for (final s in shots) {
      expect(s.keeperId, after(s) ? isNull : keeperId, reason: '$s');
    }
  });

  test('every moment kind keeps (minute, stoppage, seq) order', () {
    final kinds = <Type>{};
    for (final r in matches) {
      final ms = r.moments;
      for (var i = 1; i < ms.length; i++) {
        final a = ms[i - 1];
        final b = ms[i];
        kinds.add(b.runtimeType);
        if ((a.minute, a.stoppage) == (b.minute, b.stoppage)) {
          expect(b.seq, a.seq + 1);
        } else {
          expect(b.seq, 0);
        }
      }
      expect(
        r.routineRestarts,
        hasLength(r.extraTime == null ? 91 : 121),
      );
    }
    expect(
      kinds,
      containsAll([
        ShotMoment,
        SetPieceMoment,
        FoulMoment,
        OffsideMoment,
      ]),
    );
  });

  test('headers land in the box', () {
    for (final r in matches) {
      for (final s in r.moments.whereType<ShotMoment>()) {
        if (!s.header) continue;
        expect(
          s.zone,
          isIn(const [
            PitchZone.sixYard,
            PitchZone.boxCentre,
            PitchZone.boxLeft,
            PitchZone.boxRight,
          ]),
        );
      }
    }
  });

  test('the same match records the same moments and restarts', () {
    MatchResult once() => engine.play(
      home: longThrowTeam(1, 78),
      away: ratedTeam(2, 74),
      rng: SeededRng.forFixture(0x5E76, 3),
    );
    expect(once().moments, once().moments);
    expect(once().routineRestarts, once().routineRestarts);
  });

  test('the goldens still hold', expectMatchGoldens);
}
