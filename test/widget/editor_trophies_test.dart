import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/features/editor/trophy_crop_screen.dart';
import 'package:fnm/features/editor/trophy_section_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

final AppLocalizations _en = AppLocalizationsEn();

String _at(int id) => editorSectionLocation(EditorSection.trophies, id);

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

/// A [w]x[h] PNG: a red disc on a see-through background, or (with [opaque])
/// a solid red picture.
Future<Uint8List> _png(int w, int h, {bool opaque = false}) async {
  final rec = ui.PictureRecorder();
  final canvas = ui.Canvas(rec);
  final paint = ui.Paint()..color = const ui.Color(0xFFC81E1E);
  if (opaque) {
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), paint);
  } else {
    canvas.drawCircle(ui.Offset(w / 2, h / 2), w / 3, paint);
  }
  final image = await rec.endRecording().toImage(w, h);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

Future<ui.Size> _sizeOf(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  final f = await codec.getNextFrame();
  final size = ui.Size(f.image.width.toDouble(), f.image.height.toDouble());
  f.image.dispose();
  codec.dispose();
  return size;
}

/// Writes [bytes] to a temporary file and returns its path.
Future<String> _file(WidgetTester tester, Uint8List bytes, String name) async {
  late String path;
  await tester.runAsync(() async {
    final dir = await Directory.systemTemp.createTemp('trophy');
    addTearDown(() => dir.delete(recursive: true));
    final f = File('${dir.path}/$name');
    await f.writeAsBytes(bytes);
    path = f.path;
  });
  return path;
}

/// A container whose file picker hands over [path], and records the
/// extensions it was asked for in [asked].
Future<ProviderContainer> _container(
  WidgetTester tester,
  String? path, {
  FormFactor formFactor = FormFactor.phone,
  List<List<String>?>? asked,
}) => editorContainer(
  tester,
  formFactor: formFactor,
  overrides: [
    editorFilePickerProvider.overrideWithValue(({extensions}) async {
      asked?.add(extensions);
      return path;
    }),
  ],
);

/// Opens trophy [key], picks the file, frames it as it comes and previews
/// it.
Future<void> _pickAndPreview(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(TrophySectionScreen.tileKey(key)));
  await settle(tester);
  await tester.tap(find.byKey(TrophySectionScreen.chooseKey));
  await pumpUntilFound(tester, find.byKey(TrophyCropScreen.frameKey));
  await tester.tap(find.byKey(TrophyCropScreen.previewKey));
  await pumpUntilFound(tester, find.byKey(TrophyCropScreen.bannerKey));
}

/// Confirms the preview and waits for the grid to show [key]'s picture.
Future<void> _confirm(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(TrophyCropScreen.saveKey));
  await pumpUntilFound(tester, find.byKey(TrophySectionScreen.customKey(key)));
}

Future<Map<String, Uint8List>> _rows(
  WidgetTester tester,
  ProviderContainer c,
  int id,
) async {
  late Map<String, Uint8List> rows;
  await tester.runAsync(() async {
    rows = await c.read(worldPackRepositoryProvider).trophies(id);
  });
  return rows;
}

void main() {
  testWidgets('picking a PNG stores a 400x600 trophy and the grid shows it', (
    tester,
  ) async {
    late Uint8List png;
    await tester.runAsync(() async => png = await _png(900, 1200));
    final path = await _file(tester, png, 'cup.png');
    final asked = <List<String>?>[];
    final c = await _container(tester, path, asked: asked);
    final id = await insertPack(tester, c, testPack('Cups'));
    await pumpEditorRoute(tester, c, _at(id));
    expect(find.byType(TrophySectionScreen), findsOneWidget);
    // All nine trophies, none custom yet.
    for (final key in TrophySectionScreen.keys) {
      expect(find.byKey(TrophySectionScreen.tileKey(key)), findsOneWidget);
    }
    expect(find.byKey(TrophySectionScreen.customKey('europe')), findsNothing);

    // An edit before the picture, for undo to go back over below.
    c
        .read(packEditorProvider(id).notifier)
        .update((p) => p.copyWith(author: 'Me'));

    await _pickAndPreview(tester, 'europe');
    expect(asked.single, ['png', 'jpg', 'jpeg']);
    // A see-through picture: no warning.
    expect(find.byKey(TrophyCropScreen.warningKey), findsNothing);
    await _confirm(tester, 'europe');
    expect(find.byType(TrophyCropScreen), findsNothing);

    final rows = await _rows(tester, c, id);
    expect(rows.keys, ['europe']);
    late ui.Size size;
    await tester.runAsync(() async => size = await _sizeOf(rows['europe']!));
    expect(size, const ui.Size(400, 600));
    // The pack knows, at once, and the warning stays off the tile.
    expect(_pack(c, id).trophies, {'europe'});
    expect(find.byKey(TrophySectionScreen.warningKey('europe')), findsNothing);

    // Undo goes back over the edit, never over the picture.
    c.read(packEditorProvider(id).notifier).undo();
    expect(_pack(c, id).author, '');
    expect(_pack(c, id).trophies, {'europe'});
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an opaque picture shows the rectangle warning', (tester) async {
    late Uint8List png;
    await tester.runAsync(() async => png = await _png(800, 800, opaque: true));
    final path = await _file(tester, png, 'flat.png');
    final c = await _container(tester, path);
    final id = await insertPack(tester, c, testPack('Flat'));
    await pumpEditorRoute(tester, c, _at(id));

    await _pickAndPreview(tester, 'world');
    expect(find.byKey(TrophyCropScreen.warningKey), findsOneWidget);
    expect(find.text(_en.editorTrophyRectangle), findsOneWidget);
    await _confirm(tester, 'world');

    late ui.Size size;
    final rows = await _rows(tester, c, id);
    await tester.runAsync(() async => size = await _sizeOf(rows['world']!));
    expect(size, const ui.Size(400, 400));
    // Worked out again from the stored picture, the tile keeps the warning.
    await pumpUntilFound(
      tester,
      find.byKey(TrophySectionScreen.warningKey('world')),
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a picture that cannot be used says so', (tester) async {
    final path = await _file(
      tester,
      Uint8List.fromList(List.filled(64, 7)),
      'nope.png',
    );
    final c = await _container(tester, path);
    final id = await insertPack(tester, c, testPack('Nope'));
    await pumpEditorRoute(tester, c, _at(id));
    await tester.tap(find.byKey(TrophySectionScreen.tileKey('asia')));
    await settle(tester);
    await tester.tap(find.byKey(TrophySectionScreen.chooseKey));
    await pumpUntilFound(tester, find.text(_en.editorTrophyUnusable));
    expect(find.byType(TrophyCropScreen), findsNothing);
    expect(await _rows(tester, c, id), isEmpty);
  });

  testWidgets('cancel discards the picture', (tester) async {
    late Uint8List png;
    await tester.runAsync(() async => png = await _png(400, 600));
    final path = await _file(tester, png, 'cup.png');
    final c = await _container(tester, path);
    final id = await insertPack(tester, c, testPack('Cancel'));
    await pumpEditorRoute(tester, c, _at(id));
    await _pickAndPreview(tester, 'africa');
    await tester.tap(find.byKey(TrophyCropScreen.cancelKey));
    await settle(tester);
    expect(find.byType(TrophyCropScreen), findsNothing);
    expect(await _rows(tester, c, id), isEmpty);
    expect(_pack(c, id).trophies, isEmpty);
  });

  testWidgets('back to default removes it', (tester) async {
    late Uint8List png;
    await tester.runAsync(() async => png = await _png(400, 600));
    final c = await _container(tester, null);
    late int id;
    await tester.runAsync(() async {
      id = await c.read(worldPackRepositoryProvider).insert(
        testPack('Reset').copyWith(trophies: {'oceania'}),
        {
          'oceania': png,
        },
      );
    });
    await pumpEditorRoute(tester, c, _at(id));
    expect(
      find.byKey(TrophySectionScreen.customKey('oceania')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(TrophySectionScreen.tileKey('oceania')));
    await settle(tester);
    await tester.tap(find.byKey(TrophySectionScreen.resetKey));
    await settle(tester);
    // The dialog says undo will not bring it back.
    expect(find.text(_en.editorTrophyResetBody), findsOneWidget);
    await tester.tap(find.byKey(TrophySectionScreen.resetConfirmKey));
    await pumpUntilFound(
      tester,
      find.byKey(TrophySectionScreen.defaultKey('oceania')),
    );

    expect(find.byKey(TrophySectionScreen.customKey('oceania')), findsNothing);
    expect(await _rows(tester, c, id), isEmpty);
    expect(_pack(c, id).trophies, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a pack listing a picture it lacks is put right on opening', (
    tester,
  ) async {
    final c = await _container(tester, null);
    final id = await insertPack(
      tester,
      c,
      testPack('Drift').copyWith(trophies: {'asia'}),
    );
    await pumpEditorRoute(tester, c, _at(id));
    expect(_pack(c, id).trophies, isEmpty);
    expect(find.byKey(TrophySectionScreen.defaultKey('asia')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
    late WorldPack? stored;
    await tester.runAsync(() async {
      stored = await c.read(worldPackRepositoryProvider).load(id);
    });
    expect(stored!.trophies, isEmpty);
  });

  testWidgets('the frame turns into a crop of the source', (tester) async {
    // Contain fit of a 1000x1000 picture in a 200x300 frame: 0.2 a pixel,
    // centred, so the frame covers the whole width and 1500 px of height.
    expect(
      TrophyCropScreen.cropOf(
        frame: const Size(200, 300),
        offset: const Offset(0, 50),
        scale: 0.2,
      ),
      const Rect.fromLTWH(0, -250, 1000, 1500),
    );
    // Zoomed in twice and moved: 0.4 a pixel, picture 100 px left and 40 up.
    expect(
      TrophyCropScreen.cropOf(
        frame: const Size(200, 300),
        offset: const Offset(-100, -40),
        scale: 0.4,
      ),
      const Rect.fromLTWH(250, 100, 500, 750),
    );
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet layouts render, $size', (tester) async {
      late Uint8List png;
      await tester.runAsync(() async => png = await _png(600, 900));
      final path = await _file(tester, png, 'cup.png');
      final c = await _container(tester, path, formFactor: FormFactor.tablet);
      final id = await insertPack(tester, c, testPack('Tablet'));
      await pumpEditorRoute(tester, c, _at(id), size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TrophySectionScreen.tabletLayoutKey), findsOneWidget);

      // The tablet shows the picked trophy beside the grid.
      await tester.tap(find.byKey(TrophySectionScreen.tileKey('nationscup')));
      await settle(tester);
      expect(find.byKey(TrophySectionScreen.chooseKey), findsOneWidget);
      await tester.tap(find.byKey(TrophySectionScreen.chooseKey));
      await pumpUntilFound(tester, find.byKey(TrophyCropScreen.frameKey));
      expect(find.byKey(TrophyCropScreen.tabletLayoutKey), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(TrophyCropScreen.previewKey));
      await pumpUntilFound(tester, find.byKey(TrophyCropScreen.bannerKey));
      expect(tester.takeException(), isNull);
      await _confirm(tester, 'nationscup');
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}
