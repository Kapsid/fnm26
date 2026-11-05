import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';

Future<Uint8List> _png(int w, int h) async {
  final rec = ui.PictureRecorder();
  ui.Canvas(rec).drawRect(
    ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    ui.Paint()..color = const ui.Color(0xFFC81E1E),
  );
  final image = await rec.endRecording().toImage(w, h);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

Future<ui.Size> _sizeOf(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  final f = await codec.getNextFrame();
  return ui.Size(f.image.width.toDouble(), f.image.height.toDouble());
}

void main() {
  testWidgets('a 1000x1500 PNG comes out 400x600', (tester) async {
    await tester.runAsync(() async {
      final r = await TrophyNormaliser.normalise(
        await _png(1000, 1500),
        'europe',
      );
      expect(r, isNotNull);
      expect(await _sizeOf(r!.png), const ui.Size(400, 600));
    });
  });

  testWidgets('the world trophy comes out 400x400', (tester) async {
    await tester.runAsync(() async {
      final r = await TrophyNormaliser.normalise(
        await _png(1000, 1500),
        'world',
      );
      expect(await _sizeOf(r!.png), const ui.Size(400, 400));
    });
  });

  testWidgets('garbage bytes return null', (tester) async {
    await tester.runAsync(() async {
      final r = await TrophyNormaliser.normalise(
        Uint8List.fromList([1, 2, 3, 4, 5]),
        'world',
      );
      expect(r, isNull);
    });
  });

  testWidgets('a JPEG is re-encoded to PNG, hasAlpha false', (tester) async {
    await tester.runAsync(() async {
      final jpg = base64Decode(
        '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAQABADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwCGiiivhz84P//Z',
      );
      final r = await TrophyNormaliser.normalise(jpg, 'asia');
      expect(r, isNotNull);
      expect(r!.hasAlpha, isFalse);
      // PNG signature.
      expect(r.png.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    });
  });

  Future<ui.Image> _decode(Uint8List png) async =>
      (await (await ui.instantiateImageCodec(png)).getNextFrame()).image;

  testWidgets('oversize bytes return null', (tester) async {
    await tester.runAsync(() async {
      final big = Uint8List(15 * 1024 * 1024 + 1);
      big.setRange(0, 4, [0x89, 0x50, 0x4E, 0x47]);
      expect(await TrophyNormaliser.normalise(big, 'world'), isNull);
    });
  });

  testWidgets('a PNG claiming 5000x5000 is refused before decoding', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final b = BytesBuilder()
        ..add([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        ..add([0, 0, 0, 13, 0x49, 0x48, 0x44, 0x52])
        ..add([0, 0, 0x13, 0x88, 0, 0, 0x13, 0x88, 8, 6, 0, 0, 0])
        ..add(List.filled(32, 0));
      expect(await TrophyNormaliser.normalise(b.toBytes(), 'europe'), isNull);
    });
  });

  testWidgets('GIF and WebP signatures return null', (tester) async {
    await tester.runAsync(() async {
      final gif = Uint8List.fromList('GIF89a'.codeUnits + List.filled(30, 0));
      final webp = Uint8List.fromList(
        'RIFF'.codeUnits + [0, 0, 0, 0] + 'WEBP'.codeUnits + List.filled(30, 0),
      );
      expect(await TrophyNormaliser.normalise(gif, 'world'), isNull);
      expect(await TrophyNormaliser.normalise(webp, 'world'), isNull);
    });
  });

  testWidgets('hasAlpha is true for a transparent source, with clear padding', (
    tester,
  ) async {
    await tester.runAsync(() async {
      // 100x100 source: half opaque red, half fully transparent.
      final rec = ui.PictureRecorder();
      ui.Canvas(rec).drawRect(
        const ui.Rect.fromLTWH(0, 0, 50, 100),
        ui.Paint()..color = const ui.Color(0xFFC81E1E),
      );
      final im = await rec.endRecording().toImage(100, 100);
      final src = (await im.toByteData(
        format: ui.ImageByteFormat.png,
      ))!.buffer.asUint8List();
      final r = await TrophyNormaliser.normalise(src, 'europe');
      expect(r!.hasAlpha, isTrue);
      final out = await _decode(r.png);
      final px = (await out.toByteData())!;
      int alphaAt(int x, int y) => px.getUint8((y * 400 + x) * 4 + 3);
      // Square source fitted into 400x600: top and bottom bands are padding.
      expect(alphaAt(0, 0), 0);
      expect(alphaAt(399, 599), 0);
      expect(alphaAt(100, 300), 255);
    });
  });

  testWidgets('crop is honoured', (tester) async {
    await tester.runAsync(() async {
      // Left half red, right half blue; crop to the blue half.
      final rec = ui.PictureRecorder();
      final c = ui.Canvas(rec)
        ..drawRect(
          const ui.Rect.fromLTWH(0, 0, 50, 100),
          ui.Paint()..color = const ui.Color(0xFFFF0000),
        )
        ..drawRect(
          const ui.Rect.fromLTWH(50, 0, 50, 100),
          ui.Paint()..color = const ui.Color(0xFF0000FF),
        );
      expect(c, isNotNull);
      final im = await rec.endRecording().toImage(100, 100);
      final src = (await im.toByteData(
        format: ui.ImageByteFormat.png,
      ))!.buffer.asUint8List();
      final r = await TrophyNormaliser.normalise(
        src,
        'world',
        crop: const ui.Rect.fromLTWH(50, 0, 50, 100),
      );
      final px = (await (await _decode(r!.png)).toByteData())!;
      // Centre pixel is blue (R 0, B 255), not red.
      final o = (200 * 400 + 200) * 4;
      expect(px.getUint8(o), 0);
      expect(px.getUint8(o + 2), 255);
    });
  });
}
