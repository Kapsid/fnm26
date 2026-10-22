import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../helpers/seeded_save.dart';

/// A called-up fifteen- or sixteen-year-old is a boy the manager can field:
/// he must be offered where the XI is picked, not only in the call-up list.
/// The XI is left as the save made it, so he starts on the bench.
void main() {
  /// Names a U-17 outfield player plus a full senior squad, and returns the
  /// boy with his name resolved through the repository for this career.
  Future<Player> callUpBoy(WidgetTester tester, SeededSave save) async {
    late Player boy;
    await tester.runAsync(() async {
      final c = save.container;
      final squad = (await c.read(squadDataProvider(save.careerId).future))!;
      final picked = squad.pool.firstWhere(
        (p) =>
            p.age < PlayerLifecycle.seniorMinAge &&
            p.position.category != PositionCategory.goalkeeper,
        orElse: () => fail('the call-up pool must offer an outfield U-17'),
      );
      // Resolved by id with the career, as the screens' own names are.
      boy = (await c
          .read(playerRepositoryProvider)
          .byId(
            picked.id,
            saveSeed: save.career.rngSeed,
            careerId: save.careerId,
          ))!;
      final seniors = squad.pool
          .where((p) => p.age >= PlayerLifecycle.seniorMinAge)
          .take(kMaxSquadSize - 1)
          .map((p) => p.id);
      expect(
        await c.read(squadServiceProvider).setCallUps(save.careerId, {
          ...seniors,
          boy.id,
        }),
        isTrue,
      );
      final tactic = (await c
          .read(tacticsRepositoryProvider)
          .tacticForCareer(save.careerId))!;
      expect(
        tactic.lineup,
        isNot(contains(boy.id)),
        reason: 'he is a substitute, not a starter',
      );
      // setCallUps invalidates these and the screens here watch none of them.
      // Test-only, no app change: in riverpod 2.6.1 an invalidated
      // FutureProvider element never rebuilt before the container is disposed
      // has its future completed twice ("Bad state: Future already
      // completed"), so each is built again here.
      await c.read(squadDataProvider(save.careerId).future);
      await c.read(nextEventProvider(save.careerId).future);
    });
    return boy;
  }

  testWidgets('a called-up 15-year-old is offered in the slot picker', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final boy = await callUpBoy(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
    );
    expect(find.text(boy.name), findsNothing, reason: 'not in the XI');

    // Slot 0 is the keeper; slot 5 is an outfield disc.
    await tester.tap(find.byKey(const ValueKey('pitchDisc5')));
    await settle(tester);
    // The sheet is a lazy list and he is a boy, so he sorts low: scroll to him.
    await tester.scrollUntilVisible(
      find.text(boy.name),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text(boy.name), findsOneWidget);
    // Close the sheet, so no picker is open when the container goes.
    await tester.tapAt(const Offset(5, 5));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a called-up 15-year-old is a bench chip on the tablet', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final boy = await callUpBoy(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(
      find.descendant(
        of: find.byType(BenchChip),
        matching: find.text(surnameOf(boy.name)),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
