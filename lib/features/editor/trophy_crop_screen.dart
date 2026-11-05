import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Frames a picked picture as trophy [trophyKey] and previews it.
///
/// The picture sits under a frame of the trophy's shape (square for the
/// World Championship, 2:3 for the rest), starting fitted whole and centred;
/// the player drags and pinches it into place. Preview turns what the frame
/// shows into the stored picture ([TrophyNormaliser.normalise]) and shows it
/// the way a tournament's summary does. The page pops with that PNG when
/// the player uses it, and with null when he cancels: nothing is stored
/// here.
class TrophyCropScreen extends ConsumerStatefulWidget {
  const TrophyCropScreen({
    required this.trophyKey,
    required this.trophyName,
    required this.source,
    required this.sourceSize,
    super.key,
  });

  static const Key tabletLayoutKey = Key('trophyCrop.tabletLayout');
  static const Key frameKey = Key('trophyCrop.frame');
  static const Key fitKey = Key('trophyCrop.fit');
  static const Key previewKey = Key('trophyCrop.preview');
  static const Key adjustKey = Key('trophyCrop.adjust');
  static const Key saveKey = Key('trophyCrop.save');
  static const Key cancelKey = Key('trophyCrop.cancel');
  static const Key bannerKey = Key('trophyCrop.banner');
  static const Key warningKey = Key('trophyCrop.warning');

  /// How far past the whole-picture fit the player may zoom in.
  static const double maxZoom = 8;

  final String trophyKey;

  /// The trophy's name as the player reads it.
  final String trophyName;

  /// The picked file (a PNG or JPEG [TrophyNormaliser.measure] accepted).
  final Uint8List source;

  /// [source]'s size in pixels.
  final ui.Size sourceSize;

  /// The part of the source (in source pixels) a frame of [frame] shows when
  /// the picture is drawn at [scale] screen points a pixel with its top-left
  /// corner at [offset] from the frame's.
  static Rect cropOf({
    required Size frame,
    required Offset offset,
    required double scale,
  }) => Rect.fromLTWH(
    -offset.dx / scale,
    -offset.dy / scale,
    frame.width / scale,
    frame.height / scale,
  );

  @override
  ConsumerState<TrophyCropScreen> createState() => _TrophyCropScreenState();
}

enum _Stage { framing, preparing, preview }

class _TrophyCropScreenState extends ConsumerState<TrophyCropScreen> {
  late final MemoryImage _image = MemoryImage(widget.source);

  _Stage _stage = _Stage.framing;

  /// The frame's size on screen, from the last layout.
  Size _frame = Size.zero;

  /// Screen points per source pixel at the whole-picture fit.
  double _fit = 1;
  double _scale = 1;

  /// The picture's top-left corner from the frame's.
  Offset _offset = Offset.zero;

  double _startScale = 1;
  Offset _startOffset = Offset.zero;
  Offset _startFocal = Offset.zero;

  /// The previewed result.
  Uint8List? _png;
  bool _rectangle = false;

  double get _aspect {
    final s = TrophyNormaliser.sizeFor(widget.trophyKey);
    return s.width / s.height;
  }

  /// Fits the whole picture in the frame, centred.
  void _fitWhole() {
    final src = widget.sourceSize;
    _fit = math.min(_frame.width / src.width, _frame.height / src.height);
    _scale = _fit;
    _offset = _clamp(Offset.zero, _scale);
  }

  /// [o] kept so the picture never leaves a gap inside the frame on a side
  /// where it is bigger than the frame, and stays centred on a side where it
  /// is smaller. What the frame shows is then exactly what is stored: the
  /// normaliser centres whatever part of the picture the crop takes.
  Offset _clamp(Offset o, double scale) {
    final w = widget.sourceSize.width * scale;
    final h = widget.sourceSize.height * scale;
    double axis(double v, double size, double frame) =>
        size <= frame ? (frame - size) / 2 : v.clamp(frame - size, 0);
    return Offset(
      axis(o.dx, w, _frame.width),
      axis(o.dy, h, _frame.height),
    );
  }

  double _clampScale(double s) =>
      s.clamp(_fit, _fit * TrophyCropScreen.maxZoom);

  /// Zooms to [scale] keeping the picture's point under [focal] (frame
  /// coordinates) where it is.
  void _zoomAt(Offset focal, double scale) {
    final s = _clampScale(scale);
    final point = (focal - _offset) / _scale;
    setState(() {
      _scale = s;
      _offset = _clamp(focal - point * s, s);
    });
  }

  Future<void> _preview() async {
    final l = AppLocalizations.of(context);
    setState(() => _stage = _Stage.preparing);
    final crop = TrophyCropScreen.cropOf(
      frame: _frame,
      offset: _offset,
      scale: _scale,
    );
    final r = await TrophyNormaliser.normalise(
      widget.source,
      widget.trophyKey,
      crop: crop,
    );
    final rectangle =
        r != null &&
        (!r.hasAlpha || await TrophyNormaliser.showsAsRectangle(r.png));
    if (!mounted) return;
    if (r == null) {
      setState(() => _stage = _Stage.framing);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.editorTrophyUnusable)));
      return;
    }
    setState(() {
      _png = r.png;
      _rectangle = rectangle;
      _stage = _Stage.preview;
    });
  }

  void _cancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tablet = useTabletLayout(context, ref);
    final title = _stage == _Stage.preview
        ? l.editorTrophyPreviewTitle
        : l.editorTrophyFrameTitle;
    final stage = Stack(
      children: [
        Positioned.fill(
          child: _stage == _Stage.preview ? _previewView() : _canvas(),
        ),
        if (_stage == _Stage.preparing) ...[
          const Positioned.fill(
            child: ModalBarrier(dismissible: false, color: Colors.black54),
          ),
          Center(
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l.editorTrophyPreparing,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    if (tablet) {
      return Scaffold(
        key: TrophyCropScreen.tabletLayoutKey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: stage),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 340,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(title, style: AppTypography.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.trophyName,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ..._controls(l),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton(
                            key: TrophyCropScreen.cancelKey,
                            onPressed: _cancel,
                            child: Text(l.editorCancel),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: TrophyCropScreen.cancelKey,
          tooltip: l.editorCancel,
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: _cancel,
        ),
        title: Column(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              widget.trophyName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: stage),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.sm,
                AppSpacing.marginMobile,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _controls(l),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The hint (or warning) and the buttons for the stage.
  List<Widget> _controls(AppLocalizations l) {
    if (_stage == _Stage.preview) {
      return [
        if (_rectangle) ...[
          RectangleWarning(
            key: TrophyCropScreen.warningKey,
            text: l.editorTrophyRectangle,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PrimaryButton(
          key: TrophyCropScreen.saveKey,
          label: l.editorTrophyUse,
          icon: Icons.check,
          onPressed: () => Navigator.of(context).pop(_png),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          key: TrophyCropScreen.adjustKey,
          onPressed: () => setState(() => _stage = _Stage.framing),
          icon: const Icon(Icons.crop),
          label: Text(l.editorTrophyAdjust),
        ),
      ];
    }
    final busy = _stage == _Stage.preparing;
    return [
      Text(
        l.editorTrophyFrameHint,
        textAlign: TextAlign.center,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        children: [
          OutlinedButton.icon(
            key: TrophyCropScreen.fitKey,
            onPressed: busy ? null : () => setState(_fitWhole),
            icon: const Icon(Icons.fit_screen_outlined),
            label: Text(l.editorTrophyFit),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: PrimaryButton(
              key: TrophyCropScreen.previewKey,
              label: l.editorTrophyPreview,
              icon: Icons.visibility_outlined,
              height: 48,
              onPressed: busy ? null : () => unawaited(_preview()),
            ),
          ),
        ],
      ),
    ];
  }

  /// The picture under the frame, dimmed outside it, with a checkerboard
  /// where the trophy will be see-through.
  Widget _canvas() => LayoutBuilder(
    builder: (context, box) {
      const pad = AppSpacing.lg;
      final room = Size(
        math.max(1, box.maxWidth - 2 * pad),
        math.max(1, box.maxHeight - 2 * pad),
      );
      final width = math.min(room.width, room.height * _aspect);
      final frame = Size(width, width / _aspect);
      if (frame != _frame) {
        // First layout, or the window changed: start again from the fit.
        _frame = frame;
        _fitWhole();
      }
      final origin = Offset(
        (box.maxWidth - frame.width) / 2,
        (box.maxHeight - frame.height) / 2,
      );
      final frameRect = origin & frame;
      final picture = Rect.fromLTWH(
        _offset.dx,
        _offset.dy,
        widget.sourceSize.width * _scale,
        widget.sourceSize.height * _scale,
      );
      Widget image() => Image(
        image: _image,
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );

      return Listener(
        // A mouse or trackpad wheel zooms too (tablet with a pointer).
        onPointerSignal: (e) {
          if (e is PointerScrollEvent) {
            final factor = math.pow(0.998, e.scrollDelta.dy).toDouble();
            _zoomAt(e.localPosition - origin, _scale * factor);
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (d) {
            _startScale = _scale;
            _startOffset = _offset;
            _startFocal = d.localFocalPoint - origin;
          },
          onScaleUpdate: (d) {
            final s = _clampScale(_startScale * d.scale);
            final point = (_startFocal - _startOffset) / _startScale;
            final focal = d.localFocalPoint - origin;
            setState(() {
              _scale = s;
              _offset = _clamp(focal - point * s, s);
            });
          },
          onDoubleTap: () => setState(_fitWhole),
          child: ClipRect(
            child: Stack(
              children: [
                Positioned.fromRect(
                  rect: frameRect,
                  child: const CustomPaint(painter: _Checkerboard()),
                ),
                // The whole picture, faint, so what lies outside the frame
                // can still be seen and dragged in.
                Positioned.fromRect(
                  rect: picture.shift(origin),
                  child: Opacity(opacity: 0.3, child: image()),
                ),
                Positioned.fromRect(
                  rect: frameRect,
                  child: ClipRect(
                    child: Stack(
                      children: [
                        Positioned.fromRect(rect: picture, child: image()),
                      ],
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: frameRect,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      key: TrophyCropScreen.frameKey,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  /// The stored picture as a tournament's summary shows its trophy: centred
  /// at 180 points on the page, the competition's name under it.
  Widget _previewView() {
    final png = _png;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          key: TrophyCropScreen.bannerKey,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.mdAll,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (png != null)
                Image.memory(
                  png,
                  height: 180,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.trophyName,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The warning that a trophy picture has no see-through background.
class RectangleWarning extends StatelessWidget {
  const RectangleWarning({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.warning.withValues(alpha: 0.12),
      borderRadius: AppRadii.baseAll,
      border: Border.all(color: AppColors.warning.withValues(alpha: 0.6)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.crop_square, size: 18, color: AppColors.warning),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
          ),
        ),
      ],
    ),
  );
}

/// Grey squares: where a trophy picture is see-through.
class _Checkerboard extends CustomPainter {
  const _Checkerboard();

  static const double _cell = 12;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.surfaceContainerHigh,
    );
    final dark = Paint()..color = AppColors.surfaceContainerLow;
    for (var y = 0; y * _cell < size.height; y++) {
      for (var x = y % 2; x * _cell < size.width; x += 2) {
        canvas.drawRect(
          Rect.fromLTWH(
            x * _cell,
            y * _cell,
            math.min(_cell, size.width - x * _cell),
            math.min(_cell, size.height - y * _cell),
          ),
          dark,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_Checkerboard old) => false;
}
