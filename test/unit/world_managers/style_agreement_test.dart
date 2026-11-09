import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/scout_report_providers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

import '../../helpers/save_fixtures.dart';
import '../../story/driver.dart';

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

/// A style as far from [s] as the table allows, so blending it in moves the
/// AI's instructions for sure.
NationStyle _farFrom(NationStyle s) =>
    s == NationStyle.defensive ? NationStyle.highPress : NationStyle.defensive;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  late AppDatabase db;
  late ProviderContainer c;
  late _Recording service;

  Future<StoryDriver> start(int seed) async {
    db = storyDb();
    c = storyContainer(db, 0, [
      worldManagerServiceProvider.overrideWith(_Recording.new),
    ]);
    service = c.read(worldManagerServiceProvider) as _Recording;
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    return StoryDriver.start(c, seed);
  }

  /// A second container on the same save, with manager style switched off.
  ProviderContainer styleOff() {
    final off = storyContainer(db, 0, [
      worldManagerStyleEnabledProvider.overrideWithValue(false),
    ]);
    addTearDown(off.dispose);
    return off;
  }

  /// Hands [nationId] to a new manager of [style] on [on]: the incumbent's
  /// spell closes that day and the newcomer's opens.
  Future<NationStyle> swap(
    int careerId,
    int nationId,
    DateTime on,
    NationStyle style,
  ) async {
    final repo = c.read(worldManagerRepositoryProvider);
    final world = await repo.load(careerId);
    final old = world.currentAt(nationId)!;
    expect(old.fromDate.isBefore(on), isTrue, reason: 'swap after he came');
    final oldStyle = NationStyle.values.byName(
      world.managers.firstWhere((m) => m.managerId == old.managerId).style,
    );
    final id = world.nextManagerId;
    await repo.apply(
      careerId,
      ManagerChanges(
        added: [
          WorldManager(
            managerId: id,
            name: 'Test Newcomer',
            nationality: 'ENG',
            birthYear: 1975,
            style: style.name,
            origin: ManagerOrigin.fresh,
            enteredAt: on,
          ),
        ],
        closed: [old.close(on, SpellEnd.sacked)],
        opened: [
          ManagerSpell(
            spellNo: world.nextSpellNo,
            managerId: id,
            nationId: nationId,
            fromDate: on,
            contractUntil: DateTime(on.year + 4, on.month, on.day),
          ),
        ],
      ),
    );
    return oldStyle;
  }

  testWidgets(
    'live, skip, scout and replay setups agree for the same fixture',
    (
      tester,
    ) async {
      await tester.runAsync(() async {
        final d = await start(42);
        final id = d.careerId;
        final held = c.listen(matchPreviewProvider(id), (_, _) {});
        addTearDown(held.close);
        final first = (await c.read(matchPreviewProvider(id).future))!;
        final f = first.fixture;
        final playerId = first.playerNationId;
        final oppId = f.homeNationId == playerId
            ? f.awayNationId
            : f.homeNationId;
        final nationStyle = NationIdentity.styleOf(first.nations[oppId]!.code);
        final managerStyle = _farFrom(nationStyle);
        await service.ensureSeeded(id);
        await swap(
          id,
          oppId,
          f.date.subtract(const Duration(days: 1)),
          managerStyle,
        );

        bool forF(_Read r) =>
            r.careerId == id &&
            r.nationId == oppId &&
            r.date.isAtSameMomentAs(f.date);

        // Live: the preview reads the manager in charge on the fixture's day,
        // and his style moves the AI's instructions.
        service.reads.clear();
        c.invalidate(matchPreviewProvider(id));
        final live = (await c.read(matchPreviewProvider(id).future))!;
        expect(live.fixture.id, f.id);
        expect(
          service.reads.where(forF).map((r) => r.s),
          allOf(isNotEmpty, everyElement(managerStyle)),
        );
        final opp = live.playerIsHome ? live.awayTeam : live.homeTeam;
        // The same fixture with manager style switched off reads the nation.
        final off = styleOff();
        final offHeld = off.listen(matchPreviewProvider(id), (_, _) {});
        addTearDown(offHeld.close);
        final plain = (await off.read(matchPreviewProvider(id).future))!;
        expect(plain.fixture.id, f.id);
        final plainOpp = plain.playerIsHome ? plain.awayTeam : plain.homeTeam;
        expect(
          opp.instructions == plainOpp.instructions,
          isFalse,
          reason: 'a $managerStyle manager must move a $nationStyle side',
        );

        // Skip: the same fixture, skipped, reads the same manager.
        service.reads.clear();
        Fixture? played;
        for (var i = 0; i < 30 && played == null; i++) {
          await c.read(seasonServiceProvider).advance(id);
          played =
              (await c
                      .read(competitionRepositoryProvider)
                      .fixturesForNation(id, playerId))
                  .where((x) => x.id == f.id && x.hasResult)
                  .firstOrNull;
        }
        expect(played, isNotNull, reason: 'the fixture was never skipped');
        expect(
          service.reads.where(forF).map((r) => r.s),
          allOf(isNotEmpty, everyElement(managerStyle)),
        );

        // Scout and replay: the report on the opponent replays the fixture
        // with the manager of its day, and the typical setups read today's.
        service.reads.clear();
        final career = (await c.read(careerRepositoryProvider).byId(id))!;
        final key = (careerId: id, nationId: oppId);
        final scout = c.listen(scoutReportProvider(key), (_, _) {});
        addTearDown(scout.close);
        await c.read(scoutReportProvider(key).future);
        expect(
          service.reads.where(forF).map((r) => r.s),
          allOf(isNotEmpty, everyElement(managerStyle)),
        );
        expect(
          service.reads.where(
            (r) =>
                r.nationId == oppId &&
                r.date.isAtSameMomentAs(career.inGameDate),
          ),
          isNotEmpty,
          reason: 'the typical setups read the manager in charge today',
        );
        for (final r in service.reads) {
          expect(r.nationId, oppId, reason: 'only the scouted side is read');
        }
      });
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  testWidgets('a fixture before the change reads the old manager, one after '
      'reads the new', (tester) async {
    await tester.runAsync(() async {
      final d = await start(43);
      final id = d.careerId;
      await service.ensureSeeded(id);
      // Any AI nation with a manager in charge.
      final playerNation =
          (await c.read(careerRepositoryProvider).byId(id))!.nationId;
      final nationId = (await c.read(worldManagerRepositoryProvider).load(id))
          .spells
          .firstWhere((s) => s.current && s.nationId != playerNation)
          .nationId;
      final on = DateTime(2027, 3, 10);
      final nationStyle = NationIdentity.styleOf(
        (await c.read(nationRepositoryProvider).forCareer(id))
            .firstWhere((n) => n.id == nationId)
            .code,
      );
      final newStyle = _farFrom(nationStyle);
      final oldStyle = await swap(id, nationId, on, newStyle);
      expect(oldStyle, isNot(newStyle), reason: 'pick a real change');
      expect(
        await service.styleOn(
          id,
          nationId,
          on.subtract(const Duration(days: 1)),
        ),
        oldStyle,
      );
      // The day itself is the newcomer's.
      expect(await service.styleOn(id, nationId, on), newStyle);
      expect(
        await service.styleOn(id, nationId, on.add(const Duration(days: 30))),
        newStyle,
      );
      // Switched off, nobody is read.
      final off = styleOff();
      expect(
        await off
            .read(worldManagerServiceProvider)
            .styleOn(id, nationId, on.add(const Duration(days: 30))),
        isNull,
      );
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('a fixture in a cycle without the marker reads NationIdentity', (
    tester,
  ) async {
    await tester.runAsync(() async {
      // A new career's next cycle is not marked until its rollover.
      final d = await start(44);
      await service.ensureSeeded(d.careerId);
      expect(
        await service.styleOn(d.careerId, 1, DateTime(2031, 3, 1)),
        isNull,
      );

      // A save from before world managers: every opponent of its cycle
      // reads its own style, and nothing is seeded for asking.
      final file = await unpackFixture('v110_37', 'mid_cycle');
      final old = AppDatabase.forTesting(NativeDatabase(file));
      final oc = storyContainer(old);
      addTearDown(() async {
        oc.dispose();
        await old.close();
      });
      await oc.read(seedLoaderProvider).ensureSeeded();
      final careerId = (await oc.read(savesProvider.future)).first.id;
      final career = (await oc.read(careerRepositoryProvider).byId(careerId))!;
      final fixtures = await oc
          .read(competitionRepositoryProvider)
          .fixturesForNation(careerId, career.nationId);
      final svc = oc.read(worldManagerServiceProvider);
      var read = 0;
      for (final f in fixtures) {
        final opp = f.homeNationId == career.nationId
            ? f.awayNationId
            : f.homeNationId;
        expect(await svc.styleOn(careerId, opp, f.date), isNull);
        read++;
      }
      expect(read, greaterThan(0));
      expect(
        await oc.read(worldManagerRepositoryProvider).hasManagers(careerId),
        isFalse,
      );
    });
  }, timeout: const Timeout(Duration(minutes: 5)));
}
