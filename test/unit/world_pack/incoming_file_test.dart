import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/features/world_pack/incoming_file.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Answers [importFile] with [answer] and remembers every path it was given.
class _FakeService implements WorldPackService {
  _FakeService(this.answer);

  Result<int> answer;
  final List<String> imported = [];

  @override
  Future<Result<int>> importFile(String path) async {
    imported.add(path);
    return answer;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Seeded implements SeedLoader {
  @override
  Future<bool> ensureSeeded() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _channel = MethodChannel(IncomingFileChannel.name);

TestDefaultBinaryMessenger get _messenger =>
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

void main() {
  late Directory dir;
  late int initialCalls;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('incoming_file_test');
    initialCalls = 0;
  });

  tearDown(() {
    _messenger.setMockMethodCallHandler(_channel, null);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  /// A cached copy, as the native side leaves one.
  String cached(String name) {
    final file = File('${dir.path}/$name')..writeAsBytesSync([1, 2, 3]);
    return file.path;
  }

  /// Pumps the app shell at [start] with the listener at its root; the
  /// native side answers `initial()` with [initial].
  Future<GoRouter> pumpApp(
    WidgetTester tester,
    _FakeService service, {
    String start = '/',
    String? initial,
  }) async {
    _messenger.setMockMethodCallHandler(_channel, (call) async {
      if (call.method == 'initial') {
        initialCalls++;
        return initial;
      }
      return null;
    });
    Widget page(String label) => Scaffold(body: Text(label));
    final router = GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(path: '/', builder: (_, _) => page('home')),
        GoRoute(path: Routes.hub, builder: (_, _) => page('hub')),
        GoRoute(path: Routes.match, builder: (_, _) => page('match')),
        GoRoute(path: Routes.editorPack, builder: (_, _) => page('pack')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
          worldPackServiceProvider.overrideWithValue(service),
          seedLoaderProvider.overrideWithValue(_Seeded()),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) =>
              IncomingFileListener(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  /// The native side calling `opened(path)`, as a warm open does.
  Future<void> open(WidgetTester tester, String path) async {
    await _messenger.handlePlatformMessage(
      IncomingFileChannel.name,
      const StandardMethodCodec().encodeMethodCall(MethodCall('opened', path)),
      (_) {},
    );
    await tester.pumpAndSettle();
  }

  String location(GoRouter router) =>
      router.routerDelegate.currentConfiguration.uri.toString();

  testWidgets('an opened path imports and navigates', (tester) async {
    final service = _FakeService(const Result.success(7));
    final router = await pumpApp(
      tester,
      service,
      start: '${Routes.hub}?careerId=3',
    );
    final path = cached('one.fnmdb');

    await open(tester, path);

    expect(service.imported, [path]);
    expect(find.text('Database imported'), findsOneWidget);
    expect(location(router), '${Routes.editorPack}?id=7');
    expect(find.text('pack'), findsOneWidget);
    // The cached copy is gone once it is in.
    expect(File(path).existsSync(), isFalse);
  });

  testWidgets('a rejected file shows the reason and stays put', (
    tester,
  ) async {
    final service = _FakeService(
      Result.failure(
        Failure('Refused', code: PackRejection.newerFormat.name),
      ),
    );
    final router = await pumpApp(tester, service);
    final path = cached('newer.fnmdb');

    await open(tester, path);

    expect(service.imported, [path]);
    expect(
      find.text(
        'That database was made with a newer version of the game. '
        'Update the game to import it.',
      ),
      findsOneWidget,
    );
    expect(location(router), '/');
    expect(File(path).existsSync(), isFalse);
  });

  testWidgets('a file too big to copy is refused without an import', (
    tester,
  ) async {
    final service = _FakeService(const Result.success(1));
    final router = await pumpApp(tester, service);

    await open(tester, IncomingFileChannel.tooBig);

    expect(service.imported, isEmpty);
    expect(
      find.text('That file is too big to be a database.'),
      findsOneWidget,
    );
    expect(location(router), '/');
  });

  testWidgets('a file that could not be copied reads as not a database', (
    tester,
  ) async {
    final service = _FakeService(const Result.success(1));
    await pumpApp(tester, service);

    await open(tester, IncomingFileChannel.unreadable);

    expect(service.imported, isEmpty);
    expect(find.text('That file is not an FNM database.'), findsOneWidget);
  });

  testWidgets('the cold-start file is imported once, not on every rebuild', (
    tester,
  ) async {
    final path = cached('cold.fnmdb');
    final service = _FakeService(const Result.success(4));
    final router = await pumpApp(tester, service, initial: path);

    expect(service.imported, [path]);
    expect(location(router), '${Routes.editorPack}?id=4');

    // A rebuild of the app root asks nothing again.
    router.go('/');
    await tester.pumpAndSettle();
    expect(initialCalls, 1);
    expect(service.imported, [path]);
  });

  testWidgets('a live match is not left: the import lands, the match stays', (
    tester,
  ) async {
    final service = _FakeService(const Result.success(9));
    final router = await pumpApp(
      tester,
      service,
      start: '${Routes.match}?careerId=2',
    );
    final path = cached('mid_match.fnmdb');

    await open(tester, path);

    expect(service.imported, [path]);
    expect(find.text('Database imported'), findsOneWidget);
    expect(location(router), '${Routes.match}?careerId=2');
  });

  testWidgets('a failing import still clears the cached copy', (tester) async {
    final router = await pumpApp(tester, _ThrowingService());
    final path = cached('boom.fnmdb');

    await open(tester, path);

    expect(find.text('That file is not an FNM database.'), findsOneWidget);
    expect(location(router), '/');
    expect(File(path).existsSync(), isFalse);
  });
}

class _ThrowingService extends _FakeService {
  _ThrowingService() : super(const Result.success(0));

  @override
  Future<Result<int>> importFile(String path) async {
    imported.add(path);
    throw const FileSystemException('gone');
  }
}
