import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/dev/style_gallery_screen.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:go_router/go_router.dart';

/// Named route paths, centralised so navigation call-sites never hard-code
/// string literals.
abstract final class Routes {
  static const home = '/';

  /// Development-only design-system showcase.
  static const gallery = '/gallery';
}

/// Provides the app's [GoRouter]. Exposed as a provider so routing can later
/// depend on app state (e.g. redirecting based on whether a save exists or the
/// premium entitlement) without a global singleton.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.gallery,
        builder: (context, state) => const StyleGalleryScreen(),
      ),
    ],
  );
});
