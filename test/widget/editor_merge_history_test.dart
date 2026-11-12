import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_merge.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/history/pack_history_providers.dart';
import 'package:fnm/features/editor/history/pack_history_screen.dart';
import 'package:fnm/features/editor/merge/merge_flow.dart';
import 'package:fnm/features/editor/merge/merge_review_screen.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/pack_name_dialog.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/app_segmented_tabs.dart';

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

/// [_theirs], with whole new squads for [squads] and a sponsor renamed.
WorldPack _bigTheirs(List<int> squads) =>
    testPack(
      'Tom',
      squads: {
        for (final (i, n) in squads.indexed)
          n: [
            for (final p in testSquad())
              PackPlayer(
                id: p.id + 100 * i,
                name: '${p.name} $i',
                age: p.age,
                position: p.position,
                attributes: p.attributes,
                potential: p.potential,
              ),
          ],
      },
    ).copyWith(
      uuid: 'uuid-tom',
      clubs: const {'Old FC': 'Tom FC'},
      competitions: const {'Gold Cup': 'Tom Cup'},
      sponsors: const {'agrofart': 'Tom Farm'},
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

/// Taps [f] in [area]'s tab, scrolling its list to it first.
Future<void> _tapIn(WidgetTester tester, MergeArea area, Finder f) async {
  if (f.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      f,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(MergeReviewScreen.listKey(area)),
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await tester.pump();
}

/// Opens a tab by its key.
Future<void> _tab(WidgetTester tester, Key key) async {
  // The strip slides its selected tab into view; let it.
  await tester.pump(const Duration(milliseconds: 400));
  await tester.ensureVisible(find.byKey(key));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.tap(find.byKey(key));
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _toTab(WidgetTester tester, MergeArea area) =>
    _tab(tester, MergeReviewScreen.tabKey(area));

bool _ticked(WidgetTester tester, String key) => tester
    .widget<Checkbox>(
      find.descendant(
        of: find.byKey(MergeReviewScreen.itemKey(key)),
        matching: find.byType(Checkbox),
      ),
    )
    .value!;

/// The tick of section [id], back at the top of the open tab's list if
/// its header has scrolled away.
Future<bool?> _sectionTick(WidgetTester tester, String id) async {
  final f = find.byKey(MergeReviewScreen.sectionTickKey(id));
  if (f.evaluate().isEmpty) {
    for (final s in tester.stateList<ScrollableState>(
      find.byType(Scrollable),
    )) {
      if (s.position.axis == Axis.vertical) s.position.jumpTo(0);
    }
    await tester.pump();
  }
  return tester.widget<Checkbox>(f).value;
}

/// The count badge on [area]'s tab.
Finder _badge(MergeArea area, String text) => find.descendant(
  of: find.byKey(MergeReviewScreen.tabKey(area)),
  matching: find.text(text),
);

SegmentTab _segment(WidgetTester tester, MergeArea area) => tester
    .widget<AppTabSegment>(
      find.ancestor(
        of: find.byKey(MergeReviewScreen.tabKey(area)),
        matching: find.byType(AppTabSegment),
      ),
    )
    .tab;

/// Opens the merge of [theirs] (Tom's database) into [mine], up to its
/// review.
Future<({ProviderContainer c, int mine})> _openReview(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  Size size = kPhoneSize,
  Locale locale = const Locale('en'),
  WorldPack? mine,
  WorldPack? theirs,
}) async {
  final c = await editorContainer(tester, formFactor: formFactor);
  final mineId = await insertPack(tester, c, mine ?? _mine());
  final theirsId = await insertPack(tester, c, theirs ?? _theirs());
  await pumpEditorRoute(
    tester,
    c,
    '${Routes.editorPack}?id=$mineId',
    size: size,
    locale: locale,
  );
  await _tap(tester, find.byKey(PackHomeScreen.mergeKey));
  await pumpUntilFound(tester, find.byKey(MergeFlowKeys.packKey(theirsId)));
  await tester.tap(find.byKey(MergeFlowKeys.packKey(theirsId)));
  await pumpUntilFound(tester, find.byKey(MergeReviewScreen.applyKey));
  return (c: c, mine: mineId);
}

MergePlan _plan(WidgetTester tester) =>
    tester.widget<MergeReviewScreen>(find.byType(MergeReviewScreen)).plan;

void main() {
  // The name pools are read through rootBundle, which keeps the loaded
  // asset's future across tests; awaited from a later test, that future
  // answers in the earlier test's fake clock and never arrives. Start each
  // test with an empty cache.
  setUp(rootBundle.clear);

  testWidgets('merge: overview and a tab per area; new changes ticked, '
      'conflicts not; filter, section tick, apply and undo', (tester) async {
    final (:c, :mine) = await _openReview(tester);

    // Only the areas with changes get a tab: here, the names.
    expect(find.byKey(MergeReviewScreen.overviewTabKey), findsOneWidget);
    expect(
      find.byKey(MergeReviewScreen.tabKey(MergeArea.names)),
      findsOneWidget,
    );
    for (final a in MergeArea.values.where((a) => a != MergeArea.names)) {
      expect(find.byKey(MergeReviewScreen.tabKey(a)), findsNothing);
    }
    expect(_badge(MergeArea.names, '2'), findsOneWidget);
    expect(_segment(tester, MergeArea.names).marker, isNotNull);
    // The Overview: the totals, and a tile per area.
    expect(find.text(enL.editorMergeFound(2)), findsOneWidget);
    expect(find.text(enL.editorMergeTake(1)), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(MergeReviewScreen.tileKey(MergeArea.names)),
        matching: find.text(
          '${enL.editorMergeNewCount(1)} · ${enL.editorMergeConflicts(1)}',
        ),
      ),
      findsOneWidget,
    );
    expect(find.byKey(MergeReviewScreen.itemKey('club:Old FC')), findsNothing);

    // A tile opens its tab.
    await _tap(
      tester,
      find.byKey(MergeReviewScreen.tileKey(MergeArea.names)),
    );
    expect(
      find.byKey(MergeReviewScreen.listKey(MergeArea.names)),
      findsOneWidget,
    );

    // A change only they made is ticked; a conflict keeps mine.
    expect(_ticked(tester, 'club:Old FC'), isTrue);
    expect(_ticked(tester, 'competition:Gold Cup'), isFalse);
    expect(find.text('Mine Cup'), findsOneWidget);
    expect(find.text('Tom Cup'), findsOneWidget);

    // The clubs' section tick, off and on.
    expect(await _sectionTick(tester, 'clubs'), isTrue);
    expect(await _sectionTick(tester, 'competitions'), isFalse);
    await _tapIn(
      tester,
      MergeArea.names,
      find.byKey(MergeReviewScreen.sectionTickKey('clubs')),
    );
    expect(_ticked(tester, 'club:Old FC'), isFalse);
    expect(find.text(enL.editorMergeTake(0)), findsOneWidget);
    await _tapIn(
      tester,
      MergeArea.names,
      find.byKey(MergeReviewScreen.sectionTickKey('clubs')),
    );
    expect(_ticked(tester, 'club:Old FC'), isTrue);

    // Conflicts only, set on the Overview, holds in the tab.
    await _tab(tester, MergeReviewScreen.overviewTabKey);
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));
    expect(_badge(MergeArea.names, '1'), findsOneWidget);
    await _toTab(tester, MergeArea.names);
    expect(find.byKey(MergeReviewScreen.itemKey('club:Old FC')), findsNothing);
    expect(find.byKey(MergeReviewScreen.sectionKey('clubs')), findsNothing);
    expect(
      find.byKey(MergeReviewScreen.itemKey('competition:Gold Cup')),
      findsOneWidget,
    );
    await _tab(tester, MergeReviewScreen.overviewTabKey);
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));

    // Every change at once, on the Overview.
    await _tap(tester, find.byKey(MergeReviewScreen.allKey));
    expect(find.text(enL.editorMergeTake(2)), findsOneWidget);
    await _tap(tester, find.byKey(MergeReviewScreen.noneKey));
    expect(find.text(enL.editorMergeTake(0)), findsOneWidget);

    // Back to the tab: tick the club and take theirs on the conflict too.
    await _toTab(tester, MergeArea.names);
    expect(_ticked(tester, 'club:Old FC'), isFalse);
    await _tapIn(
      tester,
      MergeArea.names,
      find.byKey(MergeReviewScreen.itemKey('club:Old FC')),
    );
    await _tapIn(
      tester,
      MergeArea.names,
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

  testWidgets('merge: players by nation, folded, a tri-state tick, the '
      'ticks kept across tabs, and Apply takes exactly those', (tester) async {
    final cze = nationIdOf('CZE');
    final svk = nationIdOf('SVK');
    final (:c, :mine) = await _openReview(
      tester,
      theirs: _bigTheirs([cze, svk]),
    );
    final plan = _plan(tester);
    int inArea(MergeArea a) =>
        plan.items.where((i) => mergeAreaOf(i.section) == a).length;
    final ofCze = [
      for (final i in plan.items)
        if (i.section == MergeSection.players && i.nationId == cze) i,
    ];
    final ofSvk = [
      for (final i in plan.items)
        if (i.section == MergeSection.players && i.nationId == svk) i,
    ];
    expect(ofCze.length, greaterThan(MergeReviewScreen.foldOver));
    expect(ofSvk.length, greaterThan(MergeReviewScreen.foldOver));
    expect(plan.conflicts, 1);

    // A tab for each area with changes, its count on it, and a mark on the
    // one with a conflict.
    for (final a in MergeArea.values) {
      final has = const [
        MergeArea.players,
        MergeArea.names,
        MergeArea.sponsors,
      ].contains(a);
      expect(
        find.byKey(MergeReviewScreen.tabKey(a)),
        has ? findsOneWidget : findsNothing,
        reason: '$a',
      );
      if (has) {
        expect(_badge(a, '${inArea(a)}'), findsOneWidget, reason: '$a');
      }
    }
    expect(_segment(tester, MergeArea.names).marker, isNotNull);
    expect(_segment(tester, MergeArea.players).marker, isNull);

    // The Players tile opens Players: both nations folded, being large.
    await _tap(
      tester,
      find.byKey(MergeReviewScreen.tileKey(MergeArea.players)),
    );
    expect(
      find.byKey(MergeReviewScreen.listKey(MergeArea.players)),
      findsOneWidget,
    );
    final first = ofCze.first.key;
    expect(find.byKey(MergeReviewScreen.sectionKey('nation$cze')), findsOne);
    expect(find.byKey(MergeReviewScreen.sectionKey('nation$svk')), findsOne);
    expect(find.byKey(MergeReviewScreen.itemKey(first)), findsNothing);

    // Opened, it lists its players, built as they scroll in.
    await _tapIn(
      tester,
      MergeArea.players,
      find.byKey(MergeReviewScreen.sectionKey('nation$cze')),
    );
    expect(find.byKey(MergeReviewScreen.itemKey(first)), findsOneWidget);
    expect(
      find.byType(Checkbox).evaluate().length,
      lessThan(ofCze.length + 2),
    );

    // The section's tick: full, a dash once one is unticked, then all,
    // then none.
    final all = plan.preselected.length;
    expect(await _sectionTick(tester, 'nation$cze'), isTrue);
    await _tapIn(
      tester,
      MergeArea.players,
      find.byKey(MergeReviewScreen.itemKey(first)),
    );
    expect(await _sectionTick(tester, 'nation$cze'), isNull);
    expect(find.text(enL.editorMergeTake(all - 1)), findsOneWidget);
    await _tapIn(
      tester,
      MergeArea.players,
      find.byKey(MergeReviewScreen.sectionTickKey('nation$cze')),
    );
    expect(await _sectionTick(tester, 'nation$cze'), isTrue);
    await _tapIn(
      tester,
      MergeArea.players,
      find.byKey(MergeReviewScreen.sectionTickKey('nation$cze')),
    );
    expect(await _sectionTick(tester, 'nation$cze'), isFalse);
    expect(_ticked(tester, first), isFalse);
    final taken = all - ofCze.length;
    expect(find.text(enL.editorMergeTake(taken)), findsOneWidget);

    // Folded again.
    await _tapIn(
      tester,
      MergeArea.players,
      find.byKey(MergeReviewScreen.sectionKey('nation$cze')),
    );
    expect(find.byKey(MergeReviewScreen.itemKey(first)), findsNothing);

    // The ticks stay as they were across tabs.
    await _toTab(tester, MergeArea.names);
    expect(_ticked(tester, 'club:Old FC'), isTrue);
    await _toTab(tester, MergeArea.sponsors);
    expect(_ticked(tester, 'sponsor:agrofart'), isTrue);
    await _toTab(tester, MergeArea.players);
    expect(await _sectionTick(tester, 'nation$cze'), isFalse);
    expect(await _sectionTick(tester, 'nation$svk'), isTrue);
    expect(find.text(enL.editorMergeTake(taken)), findsOneWidget);
    // The Overview tile counts them too.
    await _tab(tester, MergeReviewScreen.overviewTabKey);
    expect(
      find.descendant(
        of: find.byKey(MergeReviewScreen.tileKey(MergeArea.players)),
        matching: find.text(
          '${inArea(MergeArea.players) - ofCze.length} / '
          '${inArea(MergeArea.players)}',
        ),
      ),
      findsOneWidget,
    );

    // Conflicts only, in every tab.
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));
    expect(_badge(MergeArea.players, '0'), findsOneWidget);
    expect(_badge(MergeArea.names, '1'), findsOneWidget);
    await _toTab(tester, MergeArea.players);
    expect(find.text(enL.editorMergeNoConflicts), findsOneWidget);
    expect(
      find.byKey(MergeReviewScreen.sectionKey('nation$cze')),
      findsNothing,
    );
    await _toTab(tester, MergeArea.names);
    expect(find.byKey(MergeReviewScreen.itemKey('club:Old FC')), findsNothing);
    expect(
      find.byKey(MergeReviewScreen.itemKey('competition:Gold Cup')),
      findsOneWidget,
    );
    await _tab(tester, MergeReviewScreen.overviewTabKey);
    await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));
    // The filter only hides: nothing was unticked by it.
    expect(find.text(enL.editorMergeTake(taken)), findsOneWidget);

    // Apply takes exactly the ticked: Slovakia's squad, not Czechia's; the
    // club and the sponsor; the conflict keeps mine.
    await _tap(tester, find.byKey(MergeReviewScreen.applyKey));
    await pumpUntilFound(tester, find.text(enL.editorMerged(taken)));
    final pack = c.read(packEditorProvider(mine)).value!;
    expect(pack.squads.containsKey(cze), isFalse);
    expect(
      pack.squads[svk]!.map((p) => p.name).toSet(),
      {for (final p in testSquad()) '${p.name} 1'},
    );
    expect(pack.clubs, {'Old FC': 'Tom FC'});
    expect(pack.sponsors, {'agrofart': 'Tom Farm'});
    expect(pack.competitions, {'Gold Cup': 'Mine Cup'});
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
    final plan = _plan(tester);
    final news = plan.items.where((i) => i.key.startsWith('newPlayer'));
    final outs = plan.items.where((i) => i.key.startsWith('place'));
    expect(news, hasLength(23));
    expect(outs, isNotEmpty);
    expect(plan.conflicts, 0);
    // Only Players has changes; its one nation is open, large as it is.
    expect(
      find.byKey(MergeReviewScreen.tabKey(MergeArea.names)),
      findsNothing,
    );
    await _toTab(tester, MergeArea.players);
    expect(
      find.byKey(MergeReviewScreen.itemKey(plan.items.first.key)),
      findsOneWidget,
    );
    // Built as they scroll in, not all at once.
    expect(
      find.byType(Checkbox).evaluate().length,
      lessThan(plan.items.length),
    );

    await _tap(tester, find.byKey(MergeReviewScreen.applyKey));
    await pumpUntilFound(
      tester,
      find.text(enL.editorMerged(plan.items.length)),
    );
    final squad = c.read(packEditorProvider(mine)).value!.squads[cze]!;
    expect(
      squad.map((p) => p.id).toSet(),
      testSquad().map((p) => p.id).toSet(),
    );
    await tester.pump(const Duration(seconds: 5));
  });

  for (final (name, formFactor, size) in [
    ('phone 320', FormFactor.phone, const Size(320, 640)),
    ('tablet', FormFactor.tablet, kTabletSizes.first),
  ]) {
    for (final code in ['en', 'cs', 'de']) {
      testWidgets('review fits at the largest text, $name, $code', (
        tester,
      ) async {
        tester.platformDispatcher.textScaleFactorTestValue = kMaxAppTextScale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final locale = Locale(code);
        final l = lookupAppLocalizations(locale);
        final (:c, :mine) = await _openReview(
          tester,
          formFactor: formFactor,
          size: size,
          locale: locale,
          theirs: _bigTheirs([nationIdOf('CZE')]),
        );
        expect(
          find.byKey(MergeReviewScreen.tabletLayoutKey),
          formFactor == FormFactor.tablet ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
        final taken = _plan(tester).preselected.length;
        expect(find.text(l.editorMergeTake(taken)), findsOneWidget);
        for (final a in [
          MergeArea.players,
          MergeArea.names,
          MergeArea.sponsors,
        ]) {
          await _toTab(tester, a);
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull, reason: '$a');
          if (a == MergeArea.names) {
            expect(find.text(l.editorMergeConflict), findsOneWidget);
          }
        }
        await _tab(tester, MergeReviewScreen.overviewTabKey);
        await _tap(tester, find.byKey(MergeReviewScreen.conflictsOnlyKey));
        expect(tester.takeException(), isNull);

        if (code != 'cs') return;
        // And the history after it, in Czech.
        await tester.tap(find.byKey(MergeReviewScreen.applyKey));
        await pumpUntilFound(tester, find.text(l.editorMerged(taken)));
        await _tap(tester, find.byKey(PackHomeScreen.historyKey));
        await pumpUntilFound(
          tester,
          find.text(l.editorHistoryBeforeMerge('Tom')),
        );
        expect(tester.takeException(), isNull);
        expect(c.read(packEditorProvider(mine)).value!.clubs, {
          'Old FC': 'Tom FC',
        });
        await tester.pump(const Duration(seconds: 5));
      });
    }
  }
}
