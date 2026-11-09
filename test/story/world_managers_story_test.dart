import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/scout_report_providers.dart';
import 'package:fnm/features/world_managers/managers_list_providers.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

import 'driver.dart';

typedef _Read = ({int careerId, int nationId, DateTime date, NationStyle? s});

/// The real service, noting every style it is asked for and what it gave.
class _Recording extends WorldManagerService {
  // ignore: matching_super_parameters, the service keeps its ref private.
  _Recording(super.ref);

  final reads = <_Read>[];

  @override
  Future<NationStyle?> styleOn(
    int careerId,
    int nationId,
    DateTime date,
  ) async {
    final s = await super.styleOn(careerId, nationId, date);
    reads.add((careerId: careerId, nationId: nationId, date: date, s: s));
    return s;
  }
}

const int _czechia = 12;
const int _seed = 42;

/// The world managers end to end (spec section 10, checks 1, 3, 4, 5, 6 and
/// 7): one career, seed 42, Czechia, played through the hub to its first
/// rollover, where it takes an offer. The tests share the career and run in
/// order.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late ProviderContainer c;
  late _Recording service;
  late StoryDriver d;

  /// A second career at the same seed, for the identity check and the skip.
  late StoryDriver twin;

  setUpAll(() async {
    AppLog.debugUse(null);
    db = storyDb();
    c = storyContainer(db, 0, [
      worldManagerServiceProvider.overrideWith(_Recording.new),
    ]);
    service = c.read(worldManagerServiceProvider) as _Recording;
    d = await StoryDriver.start(c, _seed, nationId: _czechia);
  });
  tearDownAll(() async {
    c.dispose();
    await db.close();
  });

  Future<T> read<T>(AutoDisposeFutureProvider<T> p) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  Future<ManagerWorld> world(int careerId) =>
      c.read(worldManagerRepositoryProvider).load(careerId);

  /// The style of the man in charge of [nationId] on [date], read from the
  /// tables themselves.
  Future<NationStyle?> styleInCharge(
    int careerId,
    int nationId,
    DateTime date,
  ) async {
    final w = await world(careerId);
    final spell = w.inChargeOn(nationId, date);
    if (spell == null) return null;
    final m = w.managers.firstWhere((m) => m.managerId == spell.managerId);
    return NationStyle.values.byName(m.style);
  }

  Future<void> everyNationPageHasAManager(int careerId) async {
    final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
    final nations = await c.read(nationRepositoryProvider).forCareer(careerId);
    expect(nations, isNotEmpty);
    for (final n in nations) {
      final view = await read(
        nationManagerProvider((careerId: careerId, nationId: n.id)),
      );
      if (n.id == career.nationId) {
        expect(view, isNull, reason: 'the player runs ${n.name}');
      } else {
        expect(view, isNotNull, reason: '${n.name} has no manager');
        expect(view!.m.name.trim(), isNotEmpty, reason: n.name);
      }
    }
  }

  /// Every manager news key, grouped by its decision point: the key is
  /// `mgr:<point>:<nationId>`.
  Future<Map<String, int>> newsByPoint(int careerId) async {
    final out = <String, int>{};
    for (final k
        in await c.read(competitionRepositoryProvider).messageKeys(careerId)) {
      if (!k.startsWith('mgr:')) continue;
      final point = k.substring(0, k.lastIndexOf(':'));
      out[point] = (out[point] ?? 0) + 1;
    }
    return out;
  }

  test('day one: every nation page has a manager', () async {
    await everyNationPageHasAManager(d.careerId);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'a second career at the same seed has identical managers',
    () async {
      twin = await StoryDriver.start(c, _seed, nationId: _czechia);
      await service.ensureSeeded(d.careerId);
      await service.ensureSeeded(twin.careerId);
      final a = await world(d.careerId);
      final b = await world(twin.careerId);
      List<String> managers(ManagerWorld w) => [
        for (final m in [
          ...w.managers,
        ]..sort((x, y) => x.managerId.compareTo(y.managerId)))
          [
            m.managerId,
            m.name,
            m.nationality,
            m.birthYear,
            m.style,
            m.origin.name,
            m.enteredAt,
            m.retiredAt,
            m.sourceId,
          ].join(' '),
      ];
      List<String> spells(ManagerWorld w) => [
        for (final s in [
          ...w.spells,
        ]..sort((x, y) => x.spellNo.compareTo(y.spellNo)))
          [
            s.spellNo,
            s.managerId,
            s.nationId,
            s.fromDate,
            s.toDate,
            s.contractUntil,
            s.endReason,
          ].join(' '),
      ];
      expect(managers(a), isNotEmpty);
      expect(managers(b), managers(a));
      expect(spells(b), spells(a));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'replacing the assistant puts him in the pool as a protege',
    () async {
      // A career of its own: a hire leaves invalidated futures that a
      // container shared across tests cannot dispose cleanly.
      final adb = storyDb();
      final ac = storyContainer(adb, 0);
      addTearDown(() async {
        ac.dispose();
        await adb.close();
      });
      final id = (await StoryDriver.start(
        ac,
        _seed,
        nationId: _czechia,
      )).careerId;
      Future<StaffRoom> room() async {
        ac.invalidate(staffRoomProvider(id));
        final r = await ac.read(staffRoomProvider(id).future);
        return r!;
      }

      final applicants = (await room()).applicants[StaffRole.assistant]!;
      expect(applicants.length, greaterThanOrEqualTo(2));
      final first = applicants[0];
      final manager = ac.read(managerServiceProvider);
      await manager.hire(id, StaffRole.assistant, first.id);
      final second = (await room()).applicants[StaffRole.assistant]!.firstWhere(
        (a) => a.id != first.id,
      );
      await manager.hire(id, StaffRole.assistant, second.id);
      await manager.assistantWorkDone;

      final repo = ac.read(worldManagerRepositoryProvider);
      final w = await repo.load(id);
      final left = w.managers
          .where(
            (m) =>
                m.origin == ManagerOrigin.exAssistant && m.sourceId == first.id,
          )
          .toList();
      expect(left, hasLength(1), reason: 'the first assistant is in the pool');
      expect(left.single.name, first.name);
      final career = (await ac.read(careerRepositoryProvider).byId(id))!;
      expect(
        w.free(career.inGameDate).map((m) => m.managerId),
        contains(left.single.managerId),
      );
      final ties = (await repo.ties(
        id,
      )).where((t) => t.managerId == left.single.managerId).toList();
      expect(ties, hasLength(1));
      expect(ties.single.kind, TieKind.protege);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    "a skipped fixture reads the manager its live twin's preview names",
    () async {
      // The first match of the career, from its preview.
      final held = c.listen(matchPreviewProvider(d.careerId), (_, _) {});
      addTearDown(held.close);
      final p = (await c.read(matchPreviewProvider(d.careerId).future))!;
      final f = p.fixture;
      final oppId = f.homeNationId == p.playerNationId
          ? f.awayNationId
          : f.homeNationId;
      final expected = await styleInCharge(d.careerId, oppId, f.date);
      expect(expected, isNotNull, reason: 'cycle 0 is run by managers');
      final line = await read(
        opponentManagerProvider((
          careerId: d.careerId,
          nationId: oppId,
          date: f.date,
        )),
      );
      expect(line?.m.style, expected!.name, reason: 'the preview line');

      // The twin skips the same fixture.
      service.reads.clear();
      Fixture? played;
      for (var i = 0; i < 40 && played == null; i++) {
        await c.read(seasonServiceProvider).advance(twin.careerId);
        played =
            (await c
                    .read(competitionRepositoryProvider)
                    .fixturesForNation(twin.careerId, _czechia))
                .where(
                  (x) =>
                      x.hasResult &&
                      x.date.isAtSameMomentAs(f.date) &&
                      {x.homeNationId, x.awayNationId}.contains(oppId),
                )
                .firstOrNull;
      }
      expect(played, isNotNull, reason: 'the twin never skipped it');
      final skipped = service.reads.where(
        (r) =>
            r.careerId == twin.careerId &&
            r.nationId == oppId &&
            r.date.isAtSameMomentAs(f.date),
      );
      expect(
        skipped.map((r) => r.s),
        allOf(isNotEmpty, everyElement(expected)),
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'to the rollover: live and scout meet the manager of the day, and no '
    'decision point files more than 3 news items',
    () async {
      final id = d.careerId;
      var matches = 0;
      var scouted = 0;
      NationStyle? expected;
      int? oppId;
      DateTime? date;
      bool forF(_Read r) =>
          r.careerId == id &&
          r.nationId == oppId &&
          r.date.isAtSameMomentAs(date!);

      d
        ..beforeMatch = (p) async {
          final f = p.fixture;
          oppId = f.homeNationId == p.playerNationId
              ? f.awayNationId
              : f.homeNationId;
          date = f.date;
          expected = await styleInCharge(id, oppId!, f.date);
          final line = await read(
            opponentManagerProvider((
              careerId: id,
              nationId: oppId!,
              date: f.date,
            )),
          );
          expect(line?.m.style, expected?.name, reason: 'preview, $f');
        }
        ..afterMatch = (f) async {
          matches++;
          final live = service.reads.where(forF).map((r) => r.s).toList();
          expect(
            live,
            allOf(isNotEmpty, everyElement(expected)),
            reason: 'live, $f',
          );
          service.reads.clear();
          // The scout's report replays this fixture with its own day's man.
          if (scouted < 3) {
            scouted++;
            await read(scoutReportProvider((careerId: id, nationId: oppId!)));
            expect(
              service.reads.where(forF).map((r) => r.s),
              allOf(isNotEmpty, everyElement(expected)),
              reason: 'scout, $f',
            );
            service.reads.clear();
          }
        };
      service.reads.clear();
      while (await d.step(stopAtRollover: true)) {}
      d
        ..beforeMatch = null
        ..afterMatch = null;
      expect(matches, greaterThan(5));
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);

      final news = await newsByPoint(id);
      expect(news.keys, isNotEmpty, reason: 'the finals points filed news');
      for (final MapEntry(key: point, value: n) in news.entries) {
        expect(n, lessThanOrEqualTo(3), reason: point);
      }
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );

  test(
    'taking an offer: the incumbent bears a grudge and the nation left '
    'names a successor in the same advance',
    () async {
      final id = d.careerId;
      final v = await read(rolloverVerdictProvider(id));
      expect(v, isNotNull);
      expect(v!.offers, isNotEmpty, reason: 'seed 42 Czechia gets an offer');
      final to = v.offers.first.nation.id;
      final opens = CareerService.cycleOpens(1);
      final incumbent = (await world(id)).inChargeOn(to, opens);
      expect(incumbent, isNotNull);

      await c
          .read(seasonServiceProvider)
          .startNextCycle(
            id,
            switchToNationId: to,
            boardTitle: v.headline,
            boardBody: v.detail,
          );

      expect((await c.read(careerRepositoryProvider).byId(id))!.nationId, to);
      final w = await world(id);
      expect(
        w.spells.firstWhere((s) => s.spellNo == incumbent!.spellNo).endReason,
        SpellEnd.replacedByPlayer,
      );
      expect(w.currentAt(to), isNull, reason: 'the player runs it now');
      final successor = w.currentAt(_czechia);
      expect(successor, isNotNull, reason: 'Czechia hires in the same pass');
      expect(successor!.fromDate, opens);
      final ties = await c.read(worldManagerRepositoryProvider).ties(id);
      expect(
        ties.where(
          (t) =>
              t.managerId == incumbent!.managerId && t.kind == TieKind.grudge,
        ),
        hasLength(1),
      );
      expect(
        ties.where(
          (t) =>
              t.managerId == successor.managerId && t.kind == TieKind.successor,
        ),
        hasLength(1),
      );
      final relation = await read(
        managerRelationProvider((
          careerId: id,
          managerId: incumbent!.managerId,
        )),
      );
      expect(relation.label, TieLabel.grudge);
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(id, 1, mgrRolloverKind),
        isTrue,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'the year after the World Championship: Recent moves lists at least 15% '
    'of nations and no point moves more than the cap, every nation page has '
    'a manager, and the rollover filed at most 3 news items',
    () async {
      final id = d.careerId;
      final moves = await read(recentMovesProvider(id));
      final nations = await c.read(nationRepositoryProvider).forCareer(id);
      final moved = {for (final m in moves) m.nationId};
      final share = moved.length / nations.length;
      // The measured share, for the progress ledger.
      // ignore: avoid_print, the story reports the figure it pins.
      print(
        'recent moves: ${moved.length} of ${nations.length} nations '
        '(${(share * 100).toStringAsFixed(1)}%)',
      );
      // The spec's check 3 reads 15 to 30% for the year. The per-point cap
      // was raised to 30% (ManagerDecisions.capShare, owner ruling
      // 2026-11-09, heavier post-WC churn accepted), so the World
      // Championship's point alone may reach 30% and the rollover adds to
      // it: the year is held to at least 15%, and each point to the cap.
      expect(share, greaterThanOrEqualTo(0.15));
      final byPoint = <DateTime, Set<int>>{};
      for (final m in moves) {
        (byPoint[m.date] ??= {}).add(m.nationId);
      }
      expect(byPoint.length, greaterThanOrEqualTo(2), reason: 'WC + rollover');
      for (final MapEntry(key: day, value: ids) in byPoint.entries) {
        expect(
          ids.length,
          lessThanOrEqualTo(
            (nations.length * ManagerDecisions.capShare).ceil(),
          ),
          reason: 'the point of $day',
        );
      }

      await everyNationPageHasAManager(id);
      for (final MapEntry(key: point, value: n) in (await newsByPoint(
        id,
      )).entries) {
        expect(n, lessThanOrEqualTo(3), reason: point);
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
