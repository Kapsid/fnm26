import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/squad/training_camp_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  TrainingCampPlan? plan,
  Completer<void>? gate,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (plan != null)
        trainingCampPlanProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => plan),
      if (gate != null)
        trainingCampServiceProvider.overrideWith(
          (ref) => _GatedService(ref, gate),
        ),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.trainingCamp}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

/// The real service, held back until [gate] opens: the window can then be
/// resized while the choice is still saving.
class _GatedService extends TrainingCampService {
  _GatedService(super._ref, this.gate);

  final Completer<void> gate;

  @override
  Future<void> choose(
    int careerId,
    TrainingCampPlan plan,
    CampOption option,
  ) async {
    await gate.future;
    return super.choose(careerId, plan, option);
  }
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

Future<({int hostId, int campIndex})?> _stored(
  WidgetTester tester,
  SeededSave save,
  TrainingCampPlan plan,
) async {
  ({int hostId, int campIndex})? out;
  await tester.runAsync(() async {
    out = await save.container
        .read(careerRepositoryProvider)
        .trainingCamp(save.careerId, plan.cycle, plan.tournament);
  });
  return out;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the host on top, the four camps two to a row, $size', (
      tester,
    ) async {
      final plan = fakeCampPlan(campHosts(1));
      await _open(tester, size, plan: plan);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text(enL.campBasedIn(plan.hostName)), findsOneWidget);
      final names = [for (final o in plan.options) o.camp.name];
      final first = tester.getRect(find.text(names[0]));
      final second = tester.getRect(find.text(names[1]));
      final third = tester.getRect(find.text(names[2]));
      expect(second.top, first.top);
      expect(second.left, greaterThan(first.right));
      expect(third.top, greaterThan(first.bottom));
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final size in kTabletSizes) {
    // Three to a row where the content area holds three 300 px tiles (1194
    // wide), two where it holds two.
    final columns = size.width >= 1194 ? 3 : 2;
    testWidgets('three co-hosts: their six camps $columns to a row, $size', (
      tester,
    ) async {
      final plan = fakeCampPlan(campHosts(3));
      await _open(tester, size, plan: plan);
      expect(tester.takeException(), isNull);
      final rects = [
        for (final o in plan.options) tester.getRect(find.text(o.camp.name)),
      ];
      expect(rects, hasLength(6));
      for (var i = 1; i < columns; i++) {
        expect(rects[i].top, rects[0].top);
      }
      expect(rects[columns].top, greaterThan(rects[0].bottom));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a tapped camp is the camp stored, then the hub', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(2));
    final save = await _open(tester, kTabletSize, plan: plan);
    expect(await _stored(tester, save, plan), isNull);
    // The second host's first camp: the country is part of the choice.
    final option = plan.options.firstWhere((o) => o.hostId != plan.hostId);
    await tester.tap(find.text(option.camp.name));
    await settle(tester);
    expect(_path(save), Routes.hub);
    final stored = await _stored(tester, save, plan);
    expect(stored?.hostId, option.hostId);
    expect(stored?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });

  // A resize across 1000 swaps the tablet layout for the phone one; the
  // camps on offer, and the tap that chooses one, carry across.
  testWidgets('a resize across 1000 and back keeps the decision', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(2));
    final save = await _open(tester, kTabletSize, plan: plan);
    final option = plan.options.last;
    tester.view.physicalSize = const Size(900, 834);
    await settle(tester);
    expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsNothing);
    expect(find.text(plan.options.first.camp.name), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsOneWidget);
    expect(await _stored(tester, save, plan), isNull);
    await tester.tap(find.text(option.camp.name));
    await settle(tester);
    expect(_path(save), Routes.hub);
    final stored = await _stored(tester, save, plan);
    expect(stored?.hostId, option.hostId);
    expect(stored?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });

  // The window crosses 1000 while the choice is still being written: the
  // card that was tapped is gone, but the camp is stored and the manager
  // still leaves for the hub.
  testWidgets('a resize while the choice is saving still lands on the hub', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(1));
    final gate = Completer<void>();
    final save = await _open(tester, kTabletSize, plan: plan, gate: gate);
    expect(await _stored(tester, save, plan), isNull);
    final option = plan.options[1];
    await tester.tap(find.text(option.camp.name));
    await tester.pump();
    tester.view.physicalSize = const Size(900, 834);
    await settle(tester);
    expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsNothing);
    expect(await _stored(tester, save, plan), isNull);
    expect(_path(save), Routes.trainingCamp);
    gate.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_path(save), Routes.hub);
    final stored = await _stored(tester, save, plan);
    expect(stored?.hostId, option.hostId);
    expect(stored?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });

  // The manager leaves the page while the choice is still saving: the camp
  // is stored, but they are not pulled back to the hub from where they went.
  testWidgets('leaving while the choice is saving stays where they went', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(1));
    final gate = Completer<void>();
    final save = await _open(tester, kTabletSize, plan: plan, gate: gate);
    expect(await _stored(tester, save, plan), isNull);
    final option = plan.options[2];
    await tester.tap(find.text(option.camp.name));
    await tester.pump();
    save.container
        .read(routerProvider)
        .go('${Routes.finances}?careerId=${save.careerId}');
    await settle(tester);
    expect(_path(save), Routes.finances);
    expect(await _stored(tester, save, plan), isNull);
    gate.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_path(save), Routes.finances);
    final stored = await _stored(tester, save, plan);
    expect(stored?.hostId, option.hostId);
    expect(stored?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });

  // A page pushed over the camps (Settings) while the choice is saving: a
  // push does not move the route information, so only the router's own
  // state says he is no longer on the camps. He stays where he went.
  testWidgets('a choice saved under a pushed page leaves him there', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(1));
    final gate = Completer<void>();
    final save = await _open(tester, kTabletSize, plan: plan, gate: gate);
    expect(await _stored(tester, save, plan), isNull);
    final option = plan.options[0];
    await tester.tap(find.text(option.camp.name));
    await tester.pump();
    final router = save.container.read(routerProvider);
    unawaited(router.push(Routes.settings));
    await settle(tester);
    expect(router.state.uri.path, Routes.settings);
    expect(_path(save), Routes.trainingCamp);
    expect(await _stored(tester, save, plan), isNull);
    gate.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(router.state.uri.path, Routes.settings);
    final stored = await _stored(tester, save, plan);
    expect(stored?.hostId, option.hostId);
    expect(stored?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nothing to decide: Continue to the hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsOneWidget);
    await tester.tap(find.text(enL.hubContinue).last);
    await settle(tester);
    expect(_path(save), Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });
}
