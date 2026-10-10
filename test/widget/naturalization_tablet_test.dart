import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/features/federation/naturalization_screen.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<void> _pump(WidgetTester tester, SeededSave save, Size size) =>
    pumpRoute(
      tester,
      save,
      '${Routes.naturalization}?careerId=${save.careerId}',
      size: size,
    );

/// The real repository, holding the decision back until [gate] opens: the
/// window can then be resized while it is still being written.
class _GatedRepository extends DriftCareerRepository {
  _GatedRepository(super._db, this.gate);

  final Completer<void> gate;

  @override
  Future<void> setNaturalizationStatus(
    int careerId,
    int playerId,
    String status,
  ) async {
    await gate.future;
    return super.setNaturalizationStatus(careerId, playerId, status);
  }
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

Future<String?> _status(
  WidgetTester tester,
  SeededSave save,
  int playerId,
) async {
  late String? status;
  await tester.runAsync(() async {
    final repo = save.container.read(careerRepositoryProvider);
    final accepted = await repo.acceptedNaturalizations(save.careerId);
    final pending = await repo.pendingNaturalization(save.careerId);
    status = accepted.any((n) => n.playerId == playerId)
        ? 'accepted'
        : pending?.playerId == playerId
        ? 'pending'
        : 'declined';
  });
  return status;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the offer and the decision beside his card, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      final offer = await offerNaturalization(tester, save);
      await _pump(tester, save, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(NaturalizationScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final card = find.byType(PlayerView);
      expect(tester.widget<PlayerView>(card).playerId, offer.playerId);
      expect(
        tester.getCenter(find.text(enL.federationNaturalise)).dx,
        lessThan(tester.getRect(card).left),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('accepting stores it, and the top bar moves on', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final offer = await offerNaturalization(tester, save);
    // The budget comes first in the hub's order; with it set, the offer is
    // the next event.
    await markBudgetSet(tester, save);
    await _pump(tester, save, kTabletSize);
    expect(topBarContinue(tester).label, enL.hubEventNaturalization);
    await tester.tap(find.text(enL.federationNaturalise));
    await settle(tester);
    expect(_path(save), Routes.hub);
    expect(await _status(tester, save, offer.playerId), 'accepted');
    expect(topBarContinue(tester).label, isNot(enL.hubEventNaturalization));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('declining turns him away', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final offer = await offerNaturalization(tester, save);
    await markBudgetSet(tester, save);
    await _pump(tester, save, kTabletSize);
    await tester.tap(find.text(enL.federationDecline));
    await settle(tester);
    expect(_path(save), Routes.hub);
    expect(await _status(tester, save, offer.playerId), 'declined');
    expect(topBarContinue(tester).label, isNot(enL.hubEventNaturalization));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nothing to decide: Continue to the hub', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await _pump(tester, save, kTabletSize);
    expect(
      find.byKey(NaturalizationScreen.tabletLayoutKey),
      findsOneWidget,
    );
    await tester.tap(find.text(enL.federationContinue));
    await settle(tester);
    expect(_path(save), Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  // A resize across 1000 swaps the tablet layout for the phone one; the offer
  // and the answer that settles it carry across.
  testWidgets('a resize across 1000 and back keeps the decision', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final offer = await offerNaturalization(tester, save);
    await _pump(tester, save, kTabletSize);
    tester.view.physicalSize = const Size(900, 834);
    await settle(tester);
    expect(find.byKey(NaturalizationScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.federationNaturalise), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byKey(NaturalizationScreen.tabletLayoutKey), findsOneWidget);
    expect(await _status(tester, save, offer.playerId), 'pending');
    await tester.tap(find.text(enL.federationNaturalise));
    await settle(tester);
    expect(_path(save), Routes.hub);
    expect(await _status(tester, save, offer.playerId), 'accepted');
    await tester.pumpWidget(const SizedBox());
  });

  // The window crosses 1000 while the decision is still being written: the
  // layout that was tapped is gone, but the decision is stored, the hub's
  // data refreshed, and the manager still leaves for the hub.
  for (final accept in [true, false]) {
    testWidgets('a resize while the decision is saving still lands on the '
        'hub, accept: $accept', (tester) async {
      final gate = Completer<void>();
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          careerRepositoryProvider.overrideWith(
            (ref) => _GatedRepository(ref.watch(appDatabaseProvider), gate),
          ),
        ],
      );
      final offer = await offerNaturalization(tester, save);
      await _pump(tester, save, kTabletSize);
      expect(await _status(tester, save, offer.playerId), 'pending');
      await tester.tap(
        find.text(accept ? enL.federationNaturalise : enL.federationDecline),
      );
      await tester.pump();
      tester.view.physicalSize = const Size(900, 834);
      await settle(tester);
      expect(find.byKey(NaturalizationScreen.tabletLayoutKey), findsNothing);
      expect(_path(save), Routes.naturalization);
      expect(await _status(tester, save, offer.playerId), 'pending');
      gate.complete();
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(_path(save), Routes.hub);
      expect(
        await _status(tester, save, offer.playerId),
        accept ? 'accepted' : 'declined',
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
