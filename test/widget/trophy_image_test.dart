import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/world_pack/trophy_image.dart';

void main() {
  testWidgets('TrophyImage shows the custom picture in a pack career and the '
      'asset otherwise', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    Future<void> pump() => tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: TrophyImage('europe', height: 40)),
      ),
    );

    await pump();
    var image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
    expect((image.image as AssetImage).assetName, 'assets/trophies/europe.png');

    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/'
      'q842iQAAAABJRU5ErkJggg==',
    );
    container.read(activeWorldProvider.notifier).state = ActiveWorld(
      WorldPack(
        uuid: 't',
        name: 'T',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        trophies: const {'europe'},
      ),
      trophies: {'europe': png},
    );
    await tester.pump();
    image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<MemoryImage>());
    expect(image.gaplessPlayback, isTrue);

    // A key the world has no picture for keeps the asset.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: TrophyImage('asia')),
      ),
    );
    image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
  });
}
