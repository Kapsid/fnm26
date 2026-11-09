import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/world_managers/manager_profile_sheet.dart';
import 'package:fnm/features/world_managers/managers_list_providers.dart';
import 'package:fnm/features/world_managers/managers_screen.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';

import '../../helpers/seeded_save.dart';

const _tall = Size(900, 4000);

Future<void> _open(WidgetTester tester, SeededSave save) async {
  await pumpRoute(
    tester,
    save,
    '${Routes.managers}?careerId=${save.careerId}',
    size: _tall,
  );
  await settle(tester);
}

Future<List<ManagerListRow>> _rows(WidgetTester tester, SeededSave save) async {
  final rows = await tester.runAsync(
    () => save.container.read(managersListProvider(save.careerId).future),
  );
  return rows!;
}

String _firstRowName(WidgetTester tester) {
  final texts = find.descendant(
    of: find.byKey(ManagersScreen.rowKey).first,
    matching: find.byType(Text),
  );
  return (tester.widget(texts.first) as Text).data!;
}

void main() {
  testWidgets("current lists every AI nation's manager once", (tester) async {
    final save = await seedSave(tester);
    await _open(tester, save);
    final rows = await _rows(tester, save);
    final ids = rows.map((r) => r.m.managerId).toSet();
    expect(ids.length, rows.length);
    expect(rows.map((r) => r.nationId).toSet().length, rows.length);
    expect(rows.any((r) => r.nationId == save.nationId), isFalse);
    expect(rows.length, save.nations.length - 1);
    expect(find.byKey(ManagersScreen.rowKey), findsWidgets);
    expect(find.text(rows.first.m.name), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter by confederation', (tester) async {
    final save = await seedSave(tester);
    await _open(tester, save);
    final rows = await _rows(tester, save);
    final byConf = <Confederation, int>{};
    for (final r in rows) {
      byConf[r.conf] = (byConf[r.conf] ?? 0) + 1;
    }
    final conf =
        (byConf.entries.toList()..sort((a, b) => a.value.compareTo(b.value)))
            .first
            .key;
    await tester.tap(find.byKey(Key('managers.conf.${conf.name}')));
    await settle(tester);
    expect(find.byKey(ManagersScreen.rowKey), findsNWidgets(byConf[conf]!));
    await tester.tap(find.text(enL.mgrListFilterAll));
    await settle(tester);
    // The list is lazy: the top of it is back, whatever the filter hid.
    final top = ([
      ...rows,
    ]..sort((a, b) => b.reputation.compareTo(a.reputation))).first;
    expect(find.text(top.m.name), findsOneWidget);
  });

  testWidgets('sort by reputation, then by name', (tester) async {
    final save = await seedSave(tester);
    await _open(tester, save);
    final rows = await _rows(tester, save);
    final byRep = [...rows]
      ..sort((a, b) {
        final c = b.reputation.compareTo(a.reputation);
        return c != 0 ? c : a.m.name.compareTo(b.m.name);
      });
    expect(_firstRowName(tester), byRep.first.m.name);
    await tester.tap(find.byKey(ManagersScreen.sortNameKey));
    await settle(tester);
    final byName = rows.map((r) => r.m.name).toList()..sort();
    expect(_firstRowName(tester), byName.first);
    await tester.tap(find.byKey(ManagersScreen.sortReputationKey));
    await settle(tester);
    expect(_firstRowName(tester), byRep.first.m.name);
  });

  testWidgets('tapping a row opens the profile', (tester) async {
    final save = await seedSave(tester);
    await _open(tester, save);
    await tester.tap(find.byKey(ManagersScreen.rowKey).first);
    await settle(tester);
    expect(find.byType(ManagerProfileSheet), findsOneWidget);
  });

  testWidgets('recent moves shows the last two years', (tester) async {
    final save = await seedSave(tester);
    final rows = await _rows(tester, save);
    final career = (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))!;
    final today = career.inGameDate;
    final before = await tester.runAsync(
      () => save.container.read(recentMovesProvider(save.careerId).future),
    );
    await tester.runAsync(() async {
      final repo = save.container.read(worldManagerRepositoryProvider);
      final world = await repo.load(save.careerId);
      var mid = world.managers.fold(
        0,
        (a, m) => m.managerId > a ? m.managerId : a,
      );
      var sno = world.spells.fold(0, (a, s) => s.spellNo > a ? s.spellNo : a);
      final added = <WorldManager>[];
      final opened = <ManagerSpell>[];
      final closed = <ManagerSpell>[];
      void swap(ManagerSpell s, DateTime on, SpellEnd why) {
        mid++;
        sno++;
        added.add(
          WorldManager(
            managerId: mid,
            name: 'Test Mover $mid',
            nationality: 'ENG',
            birthYear: 1970,
            style: 'balanced',
            origin: ManagerOrigin.fresh,
            enteredAt: on,
          ),
        );
        closed.add(s.close(on, why));
        opened.add(
          ManagerSpell(
            spellNo: sno,
            managerId: mid,
            nationId: s.nationId,
            fromDate: on,
            contractUntil: DateTime(on.year + 4, on.month, on.day),
          ),
        );
      }

      swap(
        world.spells.firstWhere(
          (s) => s.nationId == rows[0].nationId && s.current,
        ),
        today.subtract(const Duration(days: 30)),
        SpellEnd.sacked,
      );
      swap(
        world.spells.firstWhere(
          (s) => s.nationId == rows[1].nationId && s.current,
        ),
        DateTime(today.year - 3, today.month, today.day),
        SpellEnd.resigned,
      );
      await repo.apply(
        save.careerId,
        ManagerChanges(added: added, opened: opened, closed: closed),
      );
    });
    save.container.invalidate(recentMovesProvider(save.careerId));
    save.container.invalidate(managersListProvider(save.careerId));
    await _open(tester, save);
    await tester.tap(find.byKey(ManagersScreen.movesTabKey));
    await settle(tester);
    // The recent swap is in; the three-year-old one is out of the window.
    final after = await tester.runAsync(
      () => save.container.read(recentMovesProvider(save.careerId).future),
    );
    expect(after!.length, before!.length + 1);
    expect(
      after.any(
        (m) => m.nationId == rows[0].nationId && m.why == SpellEnd.sacked,
      ),
      isTrue,
    );
    expect(
      after.any(
        (m) => m.nationId == rows[1].nationId && m.why == SpellEnd.resigned,
      ),
      isFalse,
    );
    expect(find.text(enL.mgrListEmptyMoves), findsNothing);
    // The names come from the one world read.
    expect(find.textContaining('Test Mover'), findsWidgets);
  });

  testWidgets('recent moves says so when the names cannot be read', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [
        recentMovesProvider.overrideWith(
          (ref, careerId) async => [
            (
              nationId: 1,
              outgoingId: 1,
              why: SpellEnd.sacked,
              incomingId: 2,
              date: DateTime(2027),
            ),
          ],
        ),
        recentMoveManagersProvider.overrideWith(
          (ref, careerId) async => throw StateError('no names'),
        ),
      ],
    );
    await _open(tester, save);
    await tester.tap(find.byKey(ManagersScreen.movesTabKey));
    await settle(tester);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(enL.commonSomethingWentWrong), findsOneWidget);
  });

  testWidgets('recent moves is empty when nothing has happened', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [
        recentMovesProvider.overrideWith(
          (ref, careerId) async => <ManagerMove>[],
        ),
      ],
    );
    await _open(tester, save);
    await tester.tap(find.byKey(ManagersScreen.movesTabKey));
    await settle(tester);
    expect(find.byKey(ManagersScreen.moveKey), findsNothing);
    expect(find.text(enL.mgrListEmptyMoves), findsOneWidget);
  });

  testWidgets('an unmarked cycle shows the empty state and seeds nothing', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container.read(appDatabaseProvider).customStatement(
        'DELETE FROM draws_watched WHERE career_id = ? AND kind = ?',
        [save.careerId, worldManagersKind],
      ),
    );
    await _open(tester, save);
    expect(find.text(enL.mgrListEmptyCurrent), findsOneWidget);
    expect(find.byKey(ManagersScreen.rowKey), findsNothing);
    final seeded = await tester.runAsync(
      () => save.container
          .read(worldManagerRepositoryProvider)
          .hasManagers(save.careerId),
    );
    expect(seeded, isFalse);
  });

  testWidgets('ranking action opens it', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    await tester.tap(find.byIcon(Icons.badge_outlined));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.managers,
    );
    expect(find.text(enL.mgrListTitle), findsWidgets);
  });
}
