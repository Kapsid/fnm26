import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Hands a finished share image to the platform: by default writes it to a
/// temp file and opens the OS share sheet. Tests override
/// [shareImageSinkProvider] so nothing reaches the platform.
///
/// [origin] is where an iPad's share popover points (see `shareOriginOf`).
typedef ShareImageSink =
    Future<void> Function(Uint8List png, String fileName, Rect? origin);

final Provider<ShareImageSink> shareImageSinkProvider =
    Provider<ShareImageSink>((ref) => _shareToPlatform);

Future<void> _shareToPlatform(
  Uint8List png,
  String fileName,
  Rect? origin,
) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(png, flush: true);
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'image/png')],
      sharePositionOrigin: origin,
    ),
  );
}

/// Renders [card] off screen at exactly [format]'s pixel size (1080 x 1080 or
/// 1080 x 1920, whatever the phone's density) and returns it as a PNG.
///
/// The card is laid out in a pipeline of its own, never attached to the
/// screen, under the app's current language ([context]'s locale). Its art is
/// loaded first ([flagCodes], the brand logo, every trophy), and the tree is
/// rebuilt until the last image has arrived, so nothing comes out blank.
///
/// Needs real asynchrony: in a widget test, call it inside `runAsync`.
Future<Uint8List> renderShareCard(
  BuildContext context, {
  required Widget card,
  required ShareFormat format,
  Iterable<String> flagCodes = const [],
}) async {
  final size = format.size;
  final locale = Localizations.localeOf(context);
  final view = View.of(context);

  // Warm the art: the PNGs into the image cache (so they paint on the first
  // frame), the flags' bytes into the SVG cache.
  await Future.wait([
    precacheImage(const AssetImage(ShareBrand.logoAsset), context),
    for (final t in Trophies.cabinet)
      precacheImage(AssetImage(t.asset), context),
    for (final c in {...flagCodes})
      () async {
        final loader = SvgAssetLoader('assets/flags/${c.toLowerCase()}.svg');
        try {
          await svg.cache.putIfAbsent(
            loader.cacheKey(null),
            () => loader.loadBytes(null),
          );
        } on Object {
          // A missing flag draws its code instead (CountryFlag's fallback).
        }
      }(),
  ]);

  final boundary = RenderRepaintBoundary();
  final renderView = RenderView(
    view: view,
    configuration: ViewConfiguration(
      logicalConstraints: BoxConstraints.tight(size),
      physicalConstraints: BoxConstraints.tight(size),
    ),
    child: RenderPositionedBox(child: boundary),
  );
  final pipeline = PipelineOwner()..rootNode = renderView;
  renderView.prepareInitialFrame();

  var dirty = false;
  final build = BuildOwner(
    focusManager: FocusManager(),
    onBuildScheduled: () => dirty = true,
  );
  final root = RenderObjectToWidgetAdapter<RenderBox>(
    container: boundary,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: Localizations(
        locale: locale,
        delegates: AppLocalizations.localizationsDelegates,
        child: card,
      ),
    ),
  ).attachToRenderTree(build);

  void frame() {
    build
      ..buildScope(root)
      ..finalizeTree();
    pipeline
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
  }

  try {
    frame();
    // Images (the flags above all, which decode off the first frame) mark
    // the tree dirty when they land. Settled = two quiet waits in a row.
    var quiet = 0;
    for (var i = 0; i < 60 && quiet < 2; i++) {
      dirty = false;
      await Future<void>.delayed(const Duration(milliseconds: 40));
      if (dirty) {
        quiet = 0;
        frame();
      } else {
        quiet++;
      }
    }
    frame();
    final image = await boundary.toImage();
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('no PNG data');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    // Unmount the card, so its state (image streams) is disposed.
    RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
    ).attachToRenderTree(build, root);
    build
      ..buildScope(root)
      ..finalizeTree();
  }
}
