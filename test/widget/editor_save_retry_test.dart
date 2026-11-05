import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/save_failure_listener.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// A repository whose first [failures] saves throw.
class _FlakyPacks extends WorldPackRepository {
  _FlakyPacks(super.db, this.failures);

  int failures;
  int saves = 0;

  @override
  Future<void> save(int id, WorldPack p) async {
    saves++;
    if (failures > 0) {
      failures--;
      throw StateError('disk full');
    }
    await super.save(id, p);
  }
}

void main() {
  testWidgets('a failed save is tried again, and the second failure in a '
      'row is said in a snackbar', (tester) async {
    late _FlakyPacks packs;
    final c = await editorContainer(
      tester,
      overrides: [
        worldPackRepositoryProvider.overrideWith(
          (ref) => packs = _FlakyPacks(ref.watch(appDatabaseProvider), 0),
        ),
      ],
    );
    final id = await insertPack(tester, c, testPack('Before'));
    tester.view.physicalSize = kPhoneSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = c.read(routerProvider)..go('${Routes.editorPack}?id=$id');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) => PackSaveFailureListener(child: child!),
        ),
      ),
    );
    await settle(tester);

    packs.failures = 2;
    c
        .read(packEditorProvider(id).notifier)
        .update((p) => p.copyWith(name: 'After'));

    // The first failure is tried again quietly.
    await tester.pump(PackEditor.saveDelay + const Duration(milliseconds: 50));
    expect(packs.saves, 1);
    expect(find.text(enL.editorSaveFailed), findsNothing);

    // The second, a moment later, is said.
    await tester.pump(PackEditor.saveDelay + const Duration(milliseconds: 50));
    expect(packs.saves, 2);
    await tester.pump();
    expect(find.text(enL.editorSaveFailed), findsOneWidget);

    // And the edit is still not lost: the third try goes through.
    await tester.pump(PackEditor.saveDelay * 2 + const Duration(seconds: 1));
    expect(packs.saves, 3);
    String? stored;
    for (var i = 0; i < 20 && stored != 'After'; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        stored = (await packs.load(id))?.name;
      });
      await tester.pump();
    }
    expect(stored, 'After');
    // Let the snackbar go before the tree is torn down.
    await tester.pump(const Duration(seconds: 5));
  });
}
