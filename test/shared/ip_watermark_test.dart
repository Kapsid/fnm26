import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/ip_watermark.dart';

void main() {
  testWidgets('watermark never blocks taps and has no semantics', (t) async {
    final handle = t.ensureSemantics();
    var taps = 0;
    await t.pumpWidget(
      MaterialApp(
        home: IpWatermark(
          child: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => taps++,
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byKey(IpWatermark.overlayKey), findsOneWidget);
    await t.tap(find.text('Go'));
    expect(taps, 1);
    expect(
      find.bySemanticsLabel(RegExp('copyright', caseSensitive: false)),
      findsNothing,
    );
    expect(
      find.ancestor(
        of: find.byKey(IpWatermark.overlayKey),
        matching: find.byType(ExcludeSemantics),
      ),
      findsWidgets,
    );
    expect(
      find.ancestor(
        of: find.byKey(IpWatermark.overlayKey),
        matching: find.byType(IgnorePointer),
      ),
      findsWidgets,
    );
    handle.dispose();
  });

  testWidgets('disabled watermark adds nothing', (t) async {
    await t.pumpWidget(
      const MaterialApp(home: IpWatermark(enabled: false, child: Text('x'))),
    );
    expect(find.byKey(IpWatermark.overlayKey), findsNothing);
  });
}
