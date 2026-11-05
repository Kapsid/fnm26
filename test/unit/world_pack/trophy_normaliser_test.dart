import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/world_pack/trophy_image.dart';

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
}
