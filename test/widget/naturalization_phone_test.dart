import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone's naturalisation decision: it now writes through a captured
/// container and leaves through a captured router, so pin what it does on a
/// phone.
Future<String> _status(
  WidgetTester tester,
  SeededSave save,
  int playerId,
) async {
  late String status;
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

/// Whether the "naturalised" message for [playerId] has been filed.
Future<bool> _filed(WidgetTester tester, SeededSave save, int playerId) async {
  final keys = (await tester.runAsync(
    () => save.container
        .read(competitionRepositoryProvider)
        .messageKeys(save.careerId),
  ))!;
  return keys.contains('natzdone:$playerId');
}

void main() {
  for (final accept in [true, false]) {
    testWidgets('the decision is stored, then the hub, accept: $accept', (
      tester,
    ) async {
      final save = await seedSave(tester);
      final offer = await offerNaturalization(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.naturalization}?careerId=${save.careerId}',
      );
      expect(await _status(tester, save, offer.playerId), 'pending');
      expect(await _filed(tester, save, offer.playerId), isFalse);
      await tester.tap(
        find.text(accept ? enL.federationNaturalise : enL.federationDecline),
      );
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(
        await _status(tester, save, offer.playerId),
        accept ? 'accepted' : 'declined',
      );
      expect(await _filed(tester, save, offer.playerId), accept);
      expect(save.container.read(routerProvider).state.uri.path, Routes.hub);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
