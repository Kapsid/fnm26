// PROMO VIDEO HARNESS: not part of the app or the test suite.
//
// Runs the real app on a simulator against copies of a prepared save, and
// drives it through scripted scenes while the host records the screen.
// Launch with:
//   flutter run -d <simulator> -t integration_test/promo/promo_main.dart \
//     --dart-define=PROMO_DIR=<work dir> [--dart-define=ONLY=01,02]
// <work dir>/saves holds the databases built by
// test/story/promo_save_test.dart. Each scene hands over to the host through
// files in <work dir>/sig (NN.ready -> NN.go -> NN.done -> NN.saved), so the
// host records exactly one clip per scene. Debug builds only; nothing in lib/
// knows this file exists.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/app.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'scenes.dart';

const String promoDir = String.fromEnvironment('PROMO_DIR');
const String onlyScenes = String.fromEnvironment('ONLY');

late FormFactor promoFormFactor;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dispatcher = PlatformDispatcher.instance;
  final display = logicalDisplaySizeOf(dispatcher);
  promoFormFactor = formFactorAtStartup(
    display: display,
    window: display.isEmpty
        ? await firstLogicalWindowSize(dispatcher)
        : Size.zero,
  );
  if (promoFormFactor == FormFactor.tablet) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('tour_offered_v1', true);
  await prefs.remove('settings.locale');
  runApp(const PromoRoot());
  unawaited(_run());
}

Future<void> _run() async {
  await Future<void>.delayed(const Duration(seconds: 2));
  final p = Promo();
  try {
    await runScenes(p);
  } on Object catch (e, st) {
    log('FAILED $e\n$st');
  }
  log('ALL_DONE');
  File('$promoDir/sig/ALL_DONE').writeAsStringSync('1');
}

void log(String s) {
  // ignore: avoid_print - the host reads the run's output.
  print('PROMO ${DateTime.now().toIso8601String()} $s');
}

/// The app under a container this harness owns, so it can swap the save and
/// reach the router.
class PromoRoot extends StatefulWidget {
  const PromoRoot({super.key});

  @override
  State<PromoRoot> createState() => PromoRootState();
}

class PromoRootState extends State<PromoRoot> {
  static late PromoRootState current;
  ProviderContainer? container;
  AppDatabase? db;
  int gen = 0;
  final List<_Touch> touches = [];
  Timer? _fade;

  @override
  void initState() {
    super.initState();
    current = this;
  }

  Future<void> load(String save) async {
    final old = container;
    final oldDb = db;
    gen++;
    final live = Directory('$promoDir/live')..createSync(recursive: true);
    final copy = '${live.path}/${save}_$gen.db';
    File('$promoDir/saves/$save.db').copySync(copy);
    db = AppDatabase.forTesting(NativeDatabase(File(copy)));
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db!),
        premiumUnlockedProvider.overrideWith((ref) => true),
        matchAttemptSaltProvider.overrideWithValue(() => 0),
        formFactorProvider.overrideWithValue(promoFormFactor),
      ],
    );
    setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      old?.dispose();
    } on Object catch (e) {
      log('dispose: $e');
    }
    try {
      await oldDb?.close();
    } on Object catch (e) {
      log('close: $e');
    }
  }

  void touch(Offset at, {bool down = true}) {
    touches.add(_Touch(at, DateTime.now(), down));
    _fade ??= Timer.periodic(const Duration(milliseconds: 16), (_) {
      final now = DateTime.now();
      touches.removeWhere(
        (t) => now.difference(t.at).inMilliseconds > 450,
      );
      if (touches.isEmpty) {
        _fade?.cancel();
        _fade = null;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = container;
    if (c == null) return const ColoredBox(color: Color(0xFF121316));
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) => touch(e.position),
      onPointerMove: (e) => touch(e.position, down: false),
      child: Stack(
        textDirection: TextDirection.ltr,
        alignment: Alignment.topLeft,
        children: [
          UncontrolledProviderScope(
            key: ValueKey(gen),
            container: c,
            child: const FnmApp(),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _TouchPainter(List.of(touches))),
            ),
          ),
          // A one-pixel flicker in a corner: the simulator's recorder only
          // writes a frame when the screen changes, so a still screen would
          // otherwise drop out of the clip's timeline.
          const Positioned(right: 0, bottom: 0, child: _Heartbeat()),
        ],
      ),
    );
  }
}

class _Heartbeat extends StatefulWidget {
  const _Heartbeat();

  @override
  State<_Heartbeat> createState() => _HeartbeatState();
}

class _HeartbeatState extends State<_Heartbeat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _c,
      builder: (_, _) => SizedBox(
        width: 1,
        height: 1,
        child: ColoredBox(
          color: Color.fromARGB(255, 0, 0, (_c.value * 6).round()),
        ),
      ),
    ),
  );
}

class _Touch {
  _Touch(this.pos, this.at, this.down);
  final Offset pos;
  final DateTime at;
  final bool down;
}

class _TouchPainter extends CustomPainter {
  _TouchPainter(this.touches);
  final List<_Touch> touches;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    for (final t in touches) {
      final age = now.difference(t.at).inMilliseconds / 450;
      final a = (1 - age).clamp(0.0, 1.0);
      final r = t.down ? 20 + 14 * age : 18.0;
      canvas
        ..drawCircle(
          t.pos,
          r,
          Paint()..color = Colors.white.withValues(alpha: 0.28 * a),
        )
        ..drawCircle(
          t.pos,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white.withValues(alpha: 0.6 * a),
        );
    }
  }

  @override
  bool shouldRepaint(_TouchPainter old) => true;
}

/// What a scene script can do.
class Promo {
  final LiveWidgetController ctl = LiveWidgetController(
    WidgetsBinding.instance,
  );
  late final Map<String, Object?> meta =
      jsonDecode(File('$promoDir/saves/meta.json').readAsStringSync())
          as Map<String, Object?>;

  bool get tablet => promoFormFactor == FormFactor.tablet;
  int get careerId => meta['careerId']! as int;
  Map<String, Object?> info(String save) =>
      (meta[save] as Map<String, Object?>?) ?? const {};

  ProviderContainer get c => PromoRootState.current.container!;

  Future<void> load(String save) => PromoRootState.current.load(save);

  void go(String route) => c.read(routerProvider).go(route);
  void push(String route) => unawaited(c.read(routerProvider).push(route));

  void setLocale(String? code) => c.read(localeProvider.notifier).state =
      code == null ? null : Locale(code);

  Future<void> acceptAutoSetPieces() =>
      c.read(setPieceTakersStoreProvider).acceptAuto(careerId);

  Future<void> wait(double seconds) => Future<void>.delayed(
    Duration(milliseconds: (seconds * 1000).round()),
  );

  Future<bool> waitFor(Finder f, {double timeout = 20}) async {
    final end = DateTime.now().add(
      Duration(milliseconds: (timeout * 1000).round()),
    );
    while (DateTime.now().isBefore(end)) {
      if (f.evaluate().isNotEmpty) return true;
      await wait(0.1);
    }
    log('TIMEOUT waiting for $f');
    return false;
  }

  /// Waits until nothing is loading (no progress indicator) for a moment.
  Future<void> settle({double timeout = 20}) async {
    final end = DateTime.now().add(Duration(seconds: timeout.round()));
    var quiet = 0;
    while (DateTime.now().isBefore(end) && quiet < 5) {
      final busy =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
          find.byType(LinearProgressIndicator).evaluate().isNotEmpty;
      quiet = busy ? 0 : quiet + 1;
      await wait(0.1);
    }
  }

  Finder text(String s) => find.text(s);
  Finder textHas(String s) => find.textContaining(s);
  Finder type(String name) =>
      find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

  Future<bool> tap(Finder f, {double after = 0.8, bool warn = true}) async {
    if (f.evaluate().isEmpty) {
      if (warn) log('MISSING tap target $f');
      return false;
    }
    final target = f.first;
    final at = ctl.getCenter(target);
    final s = screen;
    if (at.dy < 90 || at.dy > s.height - 90 || at.dx < 0 || at.dx > s.width) {
      try {
        await ctl.ensureVisible(target);
      } on Object {
        // Not in a scrollable: fine.
      }
    }
    await wait(0.15);
    await ctl.tap(target, warnIfMissed: false);
    await wait(after);
    return true;
  }

  Future<void> tapAt(Offset at, {double after = 0.8}) async {
    await ctl.tapAt(at);
    await wait(after);
  }

  Size get screen {
    final v = WidgetsBinding.instance.platformDispatcher.views.first;
    return v.physicalSize / v.devicePixelRatio;
  }

  /// A thumb flick: [dy] points up the screen (positive scrolls content
  /// down the list), over [ms], released with momentum.
  Future<void> flick(
    double dy, {
    int ms = 380,
    Offset? from,
    double after = 1.4,
  }) async {
    final s = screen;
    final start =
        from ?? Offset(s.width * 0.55, s.height * (dy < 0 ? 0.3 : 0.68));
    final g = await ctl.startGesture(start);
    const steps = 14;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(Duration(milliseconds: ms ~/ steps));
      await g.moveTo(start + Offset(0, -dy * i / steps));
      PromoRootState.current.touch(start + Offset(0, -dy * i / steps), down: false);
    }
    await g.up();
    await wait(after);
  }

  /// A horizontal swipe ([dx] positive moves the finger right).
  Future<void> swipe(double dx, {Offset? from, int ms = 300, double after = 1}) async {
    final s = screen;
    final start = from ?? Offset(s.width * 0.5, s.height * 0.5);
    final g = await ctl.startGesture(start);
    const steps = 12;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(Duration(milliseconds: ms ~/ steps));
      await g.moveTo(start + Offset(dx * i / steps, 0));
    }
    await g.up();
    await wait(after);
  }

  /// Hold, then drag from [from] to [to] (a LongPressDraggable).
  Future<void> holdDrag(Offset from, Offset to, {int ms = 900}) async {
    final g = await ctl.startGesture(from);
    PromoRootState.current.touch(from);
    await wait(0.75);
    const steps = 30;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(Duration(milliseconds: ms ~/ steps));
      final p = Offset.lerp(from, to, Curves.easeInOut.transform(i / steps))!;
      await g.moveTo(p);
      PromoRootState.current.touch(p, down: false);
    }
    await wait(0.25);
    await g.up();
    await wait(1);
  }

  Offset center(Finder f) => ctl.getCenter(f.first);

  /// Dismisses popups (news, suspensions) by their own last button.
  Future<void> clearDialogs({bool slow = false}) async {
    for (var i = 0; i < 25; i++) {
      final d = find.byType(Dialog);
      if (d.evaluate().isEmpty) return;
      final buttons = find.descendant(
        of: d.last,
        matching: find.byWidgetPredicate(
          (w) =>
              w is ButtonStyleButton ||
              w.runtimeType.toString() == 'PrimaryButton',
        ),
      );
      if (buttons.evaluate().isNotEmpty) {
        await ctl.tap(buttons.last, warnIfMissed: false);
      } else {
        Navigator.of(d.last.evaluate().first).pop();
      }
      await wait(slow ? 1 : 0.5);
    }
  }

  /// Closes a bottom sheet by tapping the dimmed area above it.
  Future<void> popSheet() async {
    final sheets = find.byType(BottomSheet);
    if (sheets.evaluate().isEmpty) return;
    Navigator.of(sheets.evaluate().first).pop();
    await wait(0.8);
  }

  /// Pops the top route as the back arrow would.
  Future<void> back({double after = 1}) async {
    final r = c.read(routerProvider);
    if (r.canPop()) r.pop();
    await wait(after);
  }

  /// One recorded clip: [setup] runs off camera, [body] on camera.
  Future<void> clip(
    String id, {
    required Future<void> Function() setup,
    required Future<void> Function() body,
  }) async {
    if (onlyScenes.isNotEmpty && !onlyScenes.split(',').contains(id)) return;
    log('SETUP $id');
    try {
      await setup();
    } on Object catch (e, st) {
      log('SETUP_FAILED $id $e\n$st');
      return;
    }
    final sig = Directory('$promoDir/sig')..createSync(recursive: true);
    File('${sig.path}/$id.ready').writeAsStringSync('1');
    log('READY $id');
    final go = File('${sig.path}/$id.go');
    for (var i = 0; i < 300 && !go.existsSync(); i++) {
      await wait(0.1);
    }
    log('GO $id');
    try {
      await body();
    } on Object catch (e, st) {
      log('BODY_FAILED $id $e\n$st');
    }
    File('${sig.path}/$id.done').writeAsStringSync('1');
    log('DONE $id');
    final saved = File('${sig.path}/$id.saved');
    for (var i = 0; i < 300 && !saved.existsSync(); i++) {
      await wait(0.1);
    }
  }
}
