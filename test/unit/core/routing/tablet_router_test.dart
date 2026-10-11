import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

Set<String> _paths(List<RouteBase> routes) => {
  for (final r in routes) ...[
    if (r is GoRoute) r.path,
    ..._paths(r.routes),
  ],
};

List<RouteBase> _routes(FormFactor f) {
  final container = ProviderContainer(
    overrides: [formFactorProvider.overrideWithValue(f)],
  );
  addTearDown(container.dispose);
  return container.read(routerProvider).configuration.routes;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the phone router has no shell', () {
    expect(_routes(FormFactor.phone).whereType<ShellRoute>(), isEmpty);
  });

  test('the tablet router registers exactly the phone routes', () {
    expect(
      _paths(_routes(FormFactor.tablet)),
      _paths(_routes(FormFactor.phone)),
    );
  });

  test('full-screen routes sit outside the shell, the rest inside it', () {
    final tablet = _routes(FormFactor.tablet);
    final shells = tablet.whereType<ShellRoute>().toList();
    expect(shells, hasLength(1));
    final inShell = _paths(shells.single.routes);
    final topLevel = {
      for (final r in tablet)
        if (r is GoRoute) r.path,
    };
    expect(topLevel, Routes.fullScreen);
    expect(inShell.intersection(Routes.fullScreen), isEmpty);
    expect(inShell, containsAll([Routes.hub, Routes.messages, Routes.tactics]));
  });
}
