import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_tactic_library_repository.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/tactics/tactic_library_providers.dart';
import 'package:fnm/features/tactics/tactic_library_sheet.dart';
import 'package:fnm/features/tactics/tactic_preset_tile.dart';
import 'package:fnm/features/tactics/tactics_screen.dart' show playstyleLabel;
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';
import '../helpers/test_database.dart';

/// The tactics library from the tactics screen: save under a default name,
/// load into a different career, and rename or delete from the list.
void main() {
  Future<void> tapAndSettle(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester, rounds: 10);
  }

  testWidgets('save from one career, load into another (phone, text 1.4)', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final save = await seedSave(
      tester,
      overrides: [
        tacticLibraryServiceProvider.overrideWith(_RecordingService.new),
      ],
    );
    final c = save.container;
    final service = c.read(tacticLibraryServiceProvider) as _RecordingService;
    late Tactic mine;
    await tester.runAsync(() async {
      // Straight to the repository: the service's invalidations would start
      // providers outside the widget tree's clock.
      final repo = c.read(tacticsRepositoryProvider);
      final t = (await repo.tacticForCareer(save.careerId))!;
      mine = t.copyWith(
        formation: Formation.f352,
        playstyle: Playstyle.counter,
        instructions: Playstyle.counter.instructions!,
      );
      await repo.saveTactic(save.careerId, mine);
    });
    final expectedName = defaultLibraryName(
      mine.formation,
      mine.playstyle,
      (s) => playstyleLabel(enL, s),
    );
    expect(expectedName, '3-5-2 ${enL.playstyleCounter}');

    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
    );
    await tapAndSettle(tester, find.byTooltip(enL.tacticsTooltipPresets));
    expect(find.byKey(TacticLibraryKeys.saveButton), findsOneWidget);
    expect(find.byKey(TacticLibraryKeys.loadButton), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'no overflow at 1.4');

    await tapAndSettle(tester, find.byKey(TacticLibraryKeys.saveButton));
    final field = tester.widget<TextField>(
      find.byKey(TacticLibraryKeys.nameField),
    );
    expect(field.controller!.text, expectedName, reason: 'default name');
    await tapAndSettle(tester, find.text(enL.tacticsSave));
    expect(find.text(enL.tacticsLibrarySaved(expectedName)), findsOneWidget);
    ScaffoldMessenger.of(
      tester.element(find.byKey(TacticLibraryKeys.saveButton)),
    ).clearSnackBars();
    // Close the presets sheet before leaving the screen.
    Navigator.of(
      tester.element(find.byKey(TacticLibraryKeys.saveButton)),
    ).pop();
    await settle(tester, rounds: 5);

    late List<LibraryTactic> library;
    late int other;
    await tester.runAsync(() async {
      library = await c.read(tacticLibraryRepositoryProvider).all();
      final otherNation = save.nations
          .firstWhere((n) => n.id != save.nationId && n.code == 'BRA')
          .id;
      other =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: otherNation, managerName: 'N', rngSeed: 3))
              .valueOrNull!
              .id;
      // As seedSave does: read the welcome news so it does not pop over.
      await c.read(messageInboxProvider(other).future);
      await c.read(competitionRepositoryProvider).markMessagesRead(other);
    });
    c
      ..invalidate(messageInboxProvider(other))
      ..invalidate(unreadMessagesProvider(other));
    expect(library.single.name, expectedName);
    expect(library.single.formation, Formation.f352);

    // A different career, opened fresh: the library is the same list.
    await pumpRoute(tester, save, '${Routes.tactics}?careerId=$other');
    await tapAndSettle(tester, find.byTooltip(enL.tacticsTooltipPresets));
    await tapAndSettle(tester, find.byKey(TacticLibraryKeys.loadButton));
    expect(find.text(enL.tacticsLibraryTitle), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'no overflow at 1.4');
    await tapAndSettle(tester, find.text(expectedName));

    // Applying a library tactic for real is the unit test's job (it needs
    // the whole pre-match chain); here the sheet hands the right entry to the
    // right career and reports what did not fit.
    expect(service.applied, [(other, expectedName)]);
    expect(find.text(enL.tacticsLibraryTitle), findsNothing, reason: 'closed');
    expect(
      find.text(
        '${enL.tacticsLibraryLoaded(expectedName)}\n'
        '${enL.tacticsLibraryNotFitted(2)}',
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  group('the library list', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDatabase();
    });
    tearDown(() => db.close());

    Future<void> openLibrary(WidgetTester tester, Size size) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.runAsync(() async {
        final repo = DriftTacticLibraryRepository(db);
        for (final name in [
          'A long tactic name that runs on a bit',
          'Park the bus',
        ]) {
          await repo.save(
            LibraryTactic(
              name: name,
              formation: Formation.f541,
              instructions: Playstyle.lowBlock.instructions!,
              playstyle: Playstyle.lowBlock,
            ),
          );
        }
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: TextButton(
                    onPressed: () => showTacticLibrary(
                      context,
                      careerId: 1,
                      styleLabel: (s) => playstyleLabel(enL, s),
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester, rounds: 10);
    }

    Future<List<String>> names() async => (await DriftTacticLibraryRepository(
      db,
    ).all()).map((t) => t.name).toList();

    for (final (label, size) in [
      ('phone', kPhoneSize),
      ('tablet', kTabletSize),
    ]) {
      testWidgets('rename, then delete only after confirming ($label)', (
        tester,
      ) async {
        tester.platformDispatcher.textScaleFactorTestValue = 1.4;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openLibrary(tester, size);
        expect(find.text('Park the bus'), findsOneWidget);
        expect(find.text('5-4-1 · ${enL.playstyleLowBlock}'), findsNWidgets(2));
        expect(tester.takeException(), isNull, reason: 'no overflow');

        late int id;
        await tester.runAsync(() async {
          id = (await DriftTacticLibraryRepository(
            db,
          ).all()).firstWhere((t) => t.name == 'Park the bus').id!;
        });
        await tester.tap(find.byKey(TacticLibraryKeys.menu(id)));
        await settle(tester, rounds: 5);
        await tester.tap(find.text(enL.tacticsLibraryRename));
        await settle(tester, rounds: 5);
        expect(find.text(enL.tacticsLibraryRenameTitle), findsOneWidget);
        await tester.enterText(
          find.byKey(TacticLibraryKeys.nameField),
          'Deep and narrow',
        );
        await tester.tap(find.text(enL.tacticsSave));
        await settle(tester, rounds: 10);
        expect(find.text('Deep and narrow'), findsOneWidget);
        await tester.runAsync(() async {
          expect(await names(), contains('Deep and narrow'));
        });

        // Delete asks first; cancelling keeps it.
        await tester.tap(find.byKey(TacticLibraryKeys.menu(id)));
        await settle(tester, rounds: 5);
        await tester.tap(find.text(enL.tacticsLibraryDelete));
        await settle(tester, rounds: 5);
        expect(
          find.text(enL.tacticsLibraryDeleteTitle('Deep and narrow')),
          findsOneWidget,
        );
        await tester.tap(find.text(enL.tacticsCancel));
        await settle(tester, rounds: 5);
        await tester.runAsync(() async {
          expect(await names(), contains('Deep and narrow'));
        });

        await tester.tap(find.byKey(TacticLibraryKeys.menu(id)));
        await settle(tester, rounds: 5);
        await tester.tap(find.text(enL.tacticsLibraryDelete));
        await settle(tester, rounds: 5);
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text(enL.tacticsLibraryDelete),
          ),
        );
        await settle(tester, rounds: 10);
        expect(find.text('Deep and narrow'), findsNothing);
        await tester.runAsync(() async {
          expect(await names(), isNot(contains('Deep and narrow')));
        });
        await tester.pumpWidget(const SizedBox());
      });
    }

    testWidgets('a renamed clash is refused with a message', (tester) async {
      await openLibrary(tester, kPhoneSize);
      late int id;
      await tester.runAsync(() async {
        id = (await DriftTacticLibraryRepository(
          db,
        ).all()).firstWhere((t) => t.name == 'Park the bus').id!;
      });
      await tester.tap(find.byKey(TacticLibraryKeys.menu(id)));
      await settle(tester, rounds: 5);
      await tester.tap(find.text(enL.tacticsLibraryRename));
      await settle(tester, rounds: 5);
      await tester.enterText(
        find.byKey(TacticLibraryKeys.nameField),
        'a long tactic name that runs on a bit',
      );
      await tester.tap(find.text(enL.tacticsSave));
      await settle(tester, rounds: 10);
      expect(find.text(enL.tacticsLibraryNameTaken), findsOneWidget);
      await tester.runAsync(() async {
        expect(await names(), contains('Park the bus'));
      });
      await tester.pumpWidget(const SizedBox());
    });
  });

  testWidgets('a preset row offers to copy it into the library', (
    tester,
  ) async {
    var copied = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TacticPresetTile(
            preset: const TacticPreset(
              name: 'Chase it',
              formation: Formation.f424,
              instructions: TacticalInstructions(),
            ),
            onApply: () {},
            onDelete: () {},
            onSaveToLibrary: () => copied = true,
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip(enL.tacticsSaveToLibrary));
    expect(copied, isTrue);
  });
}

/// Records what the library sheet asks to load instead of loading it.
class _RecordingService extends TacticLibraryService {
  _RecordingService(super._ref);

  final List<(int, String)> applied = [];

  @override
  Future<LibraryFit?> apply(int careerId, LibraryTactic tactic) async {
    applied.add((careerId, tactic.name));
    return const LibraryFit(
      roles: {},
      penaltyTaker: null,
      deadBallTaker: null,
      skipped: 2,
    );
  }
}
