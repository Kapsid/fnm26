import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/history/pack_history_providers.dart';
import 'package:fnm/features/editor/history/pack_history_screen.dart';
import 'package:fnm/features/editor/merge/merge_flow.dart';
import 'package:fnm/features/editor/merge/merge_review_screen.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/pack_name_dialog.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// Mine: one competition renamed. Theirs: a club renamed (new to me) and
/// the same competition renamed otherwise (a conflict).
WorldPack _mine() =>
    testPack('Mine').copyWith(competitions: const {'Gold Cup': 'Mine Cup'});

WorldPack _theirs() => testPack('Tom').copyWith(
  uuid: 'uuid-tom',
  clubs: const {'Old FC': 'Tom FC'},
  competitions: const {'Gold Cup': 'Tom Cup'},
);

Future<void> _tap(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      f,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await tester.pump();
}

bool _ticked(WidgetTester tester, String key) => tester
    .widget<Checkbox>(
      find.descendant(
        of: find.byKey(MergeReviewScreen.itemKey(key)),
        matching: find.byType(Checkbox),
      ),
    )
    .value!;

/// Opens the merge of Tom's database into mine, up to its review.
Future<({ProviderContainer c, int mine})> _openReview(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  Size size = kPhoneSize,
  Locale locale = const Locale('en'),
}) async {
  final c = await editorContainer(tester, formFactor: formFactor);
  final mine = await insertPack(tester, c, _mine());
  final theirs = await insertPack(tester, c, _theirs());
  await pumpEditorRoute(
    tester,
    c,
    '${Routes.editorPack}?id=$mine',
    size: size,
    locale: locale,
  );
  await _tap(tester, find.byKey(PackHomeScreen.mergeKey));
  await pumpUntilFound(tester, find.byKey(MergeFlowKeys.packKey(theirs)));
  await tester.tap(find.byKey(MergeFlowKeys.packKey(theirs)));
  await pumpUntilFound(tester, find.byKey(MergeReviewScreen.applyKey));
  return (c: c, mine: mine);
}

void main() {
  testWidgets('merge: new changes ticked, conflicts not, filter, all/none, '
      'apply and undo', (tester) async {
    final (:c, :mine) = await _openReview(tester);

    // A change only they made is ticked; a conflict keeps mine.
    expect(_ticked(tester, 'club:Old FC'), isTrue);
    expect(_ticked(tester, 'competition:Gold Cup'), isFalse);
    expect(find.text(enL.editorMergeTake(1)), findsOneWidget);
    expect(find.text('Mine Cup'), findsOneWidget);
    expect(find.text('Tom Cup'), findsOneWidget);

    // Conflicts only.
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));
    expect(find.byKey(MergeReviewScreen.itemKey('club:Old FC')), findsNothing);
    expect(
      find.byKey(MergeReviewScreen.itemKey('competition:Gold Cup')),
      findsOneWidget,
    );
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));

    // None, then All, for the clubs.
    await _tap(tester, find.byKey(MergeReviewScreen.noneKey('clubs')));
    expect(_ticked(tester, 'club:Old FC'), isFalse);
    expect(find.text(enL.editorMergeTake(0)), findsOneWidget);
    await _tap(tester, find.byKey(MergeReviewScreen.allKey('clubs')));
    expect(_ticked(tester, 'club:Old FC'), isTrue);

    // Take theirs on the conflict too.
    await _tap(
      tester,
      find.byKey(MergeReviewScreen.itemKey('competition:Gold Cup')),
    );
    expect(find.text(enL.editorMergeTake(2)), findsOneWidget);

    await _tap(tester, find.byKey(MergeReviewScreen.applyKey));
    await pumpUntilFound(tester, find.text(enL.editorMerged(2)));
    var pack = c.read(packEditorProvider(mine)).value!;
    expect(pack.clubs, {'Old FC': 'Tom FC'});
    expect(pack.competitions, {'Gold Cup': 'Tom Cup'});

    // A version of mine was saved first, and on the device it is merged.
    late List<PackVersionInfo> versions;
    late WorldPack? stored;
    await tester.runAsync(() async {
      versions = await c.read(packHistoryRepositoryProvider).list(mine);
      stored = await c.read(worldPackRepositoryProvider).load(mine);
    });
    expect(
      versions.where((v) => v.reason == PackVersionReason.beforeMerge),
      hasLength(1),
    );
    expect(versions.first.name, 'Tom');
    expect(stored!.competitions, {'Gold Cup': 'Tom Cup'});

    // Undo goes back to mine.
    await tester.tap(find.text(enL.editorUndo));
    for (var i = 0; i < 40; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump();
      pack = c.read(packEditorProvider(mine)).value!;
      if (pack.clubs.isEmpty) break;
    }
    expect(pack.clubs, isEmpty);
    expect(pack.competitions, {'Gold Cup': 'Mine Cup'});
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('merge: a database with nothing new says so', (tester) async {
    final c = await editorContainer(tester);
    final mine = await insertPack(tester, c, _mine());
    final same = await insertPack(
      tester,
      c,
      _mine().copyWith(uuid: 'uuid-same', name: 'Same'),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$mine');
    await _tap(tester, find.byKey(PackHomeScreen.mergeKey));
    await pumpUntilFound(tester, find.byKey(MergeFlowKeys.packKey(same)));
    await tester.tap(find.byKey(MergeFlowKeys.packKey(same)));
    await pumpUntilFound(tester, find.text(enL.editorMergeNothing));
    expect(find.byType(MergeReviewScreen), findsNothing);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('history: save, rename, restore, export, delete', (
    tester,
  ) async {
    Uint8List? exported;
    final c = await editorContainer(
      tester,
      overrides: [
        editorFileExporterProvider.overrideWithValue(
          (bytes, fileName, {required subject, origin}) async =>
              exported = bytes,
        ),
      ],
    );
    final id = await insertPack(tester, c, _mine());
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    await _tap(tester, find.byKey(PackHomeScreen.historyKey));
    await pumpUntilFound(tester, find.byType(PackHistoryScreen));
    // Opening a database with no versions keeps it as it was.
    await pumpUntilFound(tester, find.text(enL.editorHistorySession));

    // Save a version with a name.
    await tester.tap(find.byKey(PackHistoryScreen.saveKey));
    await tester.pump();
    await tester.enterText(find.byKey(PackNameDialog.fieldKey), 'Keep me');
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await pumpUntilFound(tester, find.text('Keep me'));

    late List<PackVersionInfo> versions;
    Future<void> read() => tester.runAsync(() async {
      versions = await c.read(packHistoryRepositoryProvider).list(id);
    });
    await read();
    final kept = versions.firstWhere((v) => v.name == 'Keep me');
    final auto = versions.firstWhere((v) => v.reason.automatic);

    // An automatic version has no Delete.
    await tester.tap(find.byKey(PackHistoryScreen.moreKey(auto.id)));
    await tester.pumpAndSettle();
    expect(find.text(enL.editorHistoryRestore), findsOneWidget);
    expect(find.text(enL.editorDelete), findsNothing);
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    // Rename.
    await tester.tap(find.byKey(PackHistoryScreen.moreKey(kept.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorRename));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(PackNameDialog.fieldKey), 'Renamed');
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await pumpUntilFound(tester, find.text('Renamed'));

    // Change the database, then restore the saved version.
    c
        .read(packEditorProvider(id).notifier)
        .update((p) => p.copyWith(competitions: const {}));
    await tester.pump();
    await tester.tap(find.byKey(PackHistoryScreen.moreKey(kept.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorHistoryRestore));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PackHistoryScreen.confirmKey));
    await pumpUntilFound(tester, find.text(enL.editorHistoryRestored));
    expect(
      c.read(packEditorProvider(id)).value!.competitions,
      {'Gold Cup': 'Mine Cup'},
    );
    await read();
    // The state it replaced was kept first.
    expect(
      versions.where((v) => v.reason == PackVersionReason.beforeRestore),
      hasLength(1),
    );

    // Export the version as a file.
    await tester.tap(find.byKey(PackHistoryScreen.moreKey(kept.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorExport));
    for (var i = 0; i < 40 && exported == null; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump();
    }
    expect(exported, isNotNull);
    late PackDecode decoded;
    await tester.runAsync(() async {
      decoded = await PackCodec.decode(exported!);
    });
    expect(
      (decoded as PackDecoded).pack.competitions,
      {'Gold Cup': 'Mine Cup'},
    );

    // Delete the saved version.
    await tester.tap(find.byKey(PackHistoryScreen.moreKey(kept.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorDelete));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PackHistoryScreen.confirmKey));
    for (var i = 0; i < 40; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump();
      if (find.text('Renamed').evaluate().isEmpty) break;
    }
    expect(find.text('Renamed'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('merge: a whole new squad lists player by player, lazily', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final mine = await insertPack(tester, c, testPack('Mine'));
    final theirs = await insertPack(
      tester,
      c,
      testPack('Tom', squads: {cze: testSquad()}).copyWith(uuid: 'uuid-tom'),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$mine');
    await _tap(tester, find.byKey(PackHomeScreen.mergeKey));
    await pumpUntilFound(tester, find.byKey(MergeFlowKeys.packKey(theirs)));
    await tester.tap(find.byKey(MergeFlowKeys.packKey(theirs)));
    await pumpUntilFound(tester, find.byKey(MergeReviewScreen.applyKey));

    // Their 23 new players, and the default players they left out.
    final screen = tester.widget<MergeReviewScreen>(
      find.byType(MergeReviewScreen),
    );
    final news = screen.plan.items.where((i) => i.key.startsWith('newPlayer'));
    final outs = screen.plan.items.where((i) => i.key.startsWith('place'));
    expect(news, hasLength(23));
    expect(outs, isNotEmpty);
    expect(screen.plan.conflicts, 0);
    // Built as they scroll in, not all at once.
    expect(
      find.byType(Checkbox).evaluate().length,
      lessThan(screen.plan.items.length),
    );

    await _tap(tester, find.byKey(MergeReviewScreen.applyKey));
    await pumpUntilFound(
      tester,
      find.text(enL.editorMerged(screen.plan.items.length)),
    );
    final squad = c.read(packEditorProvider(mine)).value!.squads[cze]!;
    expect(
      squad.map((p) => p.id).toSet(),
      testSquad().map((p) => p.id).toSet(),
    );
    await tester.pump(const Duration(seconds: 5));
  });

  for (final (name, formFactor, size) in [
    ('phone', FormFactor.phone, kPhoneSize),
    ('tablet', FormFactor.tablet, kTabletSizes.first),
  ]) {
    testWidgets('review and history fit at the largest text, $name, Czech', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = kMaxAppTextScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final (:c, :mine) = await _openReview(
        tester,
        formFactor: formFactor,
        size: size,
        locale: const Locale('cs'),
      );
      final cs = AppLocalizationsCs();
      expect(find.text(cs.editorMergeTake(1)), findsOneWidget);
      expect(find.text(cs.editorMergeConflict), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(MergeReviewScreen.applyKey));
      await pumpUntilFound(tester, find.text(cs.editorMerged(1)));
      await _tap(tester, find.byKey(PackHomeScreen.historyKey));
      await pumpUntilFound(
        tester,
        find.text(cs.editorHistoryBeforeMerge('Tom')),
      );
      expect(tester.takeException(), isNull);
      expect(c.read(packEditorProvider(mine)).value!.clubs, {
        'Old FC': 'Tom FC',
      });
      await tester.pump(const Duration(seconds: 5));
    });
  }
}
