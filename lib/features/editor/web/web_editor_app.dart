import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart' show Routes;
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/players/nation_list_screen.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';
import 'package:fnm/features/editor/save_failure_listener.dart';
import 'package:fnm/features/editor/trophy_section_screen.dart';
import 'package:fnm/features/editor/web/browser_files.dart';
import 'package:fnm/features/editor/web/web_guide.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';
import 'package:go_router/go_router.dart';

/// What the web editor changes about the app's providers: English only, the
/// tablet layouts wherever the window is wide enough, no way out of the
/// editor, and files in and out through the browser.
final List<Override> webEditorOverrides = [
  localeProvider.overrideWith((ref) => const Locale('en')),
  uiLanguageCodeProvider.overrideWithValue('en'),
  formFactorProvider.overrideWithValue(FormFactor.tablet),
  editorHasHomeProvider.overrideWithValue(false),
  editorFilePickerProvider.overrideWithValue(pickFileAsBlobUrl),
  editorPackExporterProvider.overrideWith(
    (ref) => (packId, {required subject, origin}) async {
      final file = await ref
          .read(worldPackServiceProvider)
          .encodeForExport(packId);
      downloadBytes(file.bytes, file.fileName, type: PackCodec.mimeType);
    },
  ),
];

/// The editor's routes, as the app has them, with the list of databases as
/// the front page.
GoRouter webEditorRouter() {
  int idOf(GoRouterState s, String key) =>
      int.tryParse(s.uri.queryParameters[key] ?? '') ?? 0;
  return GoRouter(
    initialLocation: Routes.editor,
    redirect: (context, state) =>
        state.uri.path.startsWith(Routes.editor) ? null : Routes.editor,
    routes: [
      GoRoute(
        path: Routes.editor,
        builder: (context, state) => const _ListWithGuide(),
      ),
      GoRoute(
        path: Routes.editorPack,
        builder: (context, state) => PackHomeScreen(packId: idOf(state, 'id')),
      ),
      GoRoute(
        path: Routes.editorPlayers,
        builder: (context, state) =>
            NationListScreen(packId: idOf(state, 'id')),
      ),
      GoRoute(
        path: Routes.editorSquad,
        builder: (context, state) => SquadScreen(
          packId: idOf(state, 'id'),
          nationId: idOf(state, 'nation'),
          pool: state.uri.queryParameters['tab'] == 'pool',
        ),
      ),
      GoRoute(
        path: Routes.editorPlayer,
        builder: (context, state) => PlayerEditScreen(
          packId: idOf(state, 'id'),
          nationId: idOf(state, 'nation'),
          playerId: idOf(state, 'player'),
          pool: state.uri.queryParameters['pool'] == '1',
        ),
      ),
      for (final section in NameSection.values)
        GoRoute(
          path: section.editorSection.route,
          builder: (context, state) => NameSectionScreen(
            section: section,
            packId: idOf(state, 'id'),
            nationId: int.tryParse(state.uri.queryParameters['nation'] ?? ''),
          ),
        ),
      GoRoute(
        path: Routes.editorTrophies,
        builder: (context, state) =>
            TrophySectionScreen(packId: idOf(state, 'id')),
      ),
    ],
  );
}

final Provider<GoRouter> _webRouterProvider = Provider<GoRouter>((ref) {
  final router = webEditorRouter();
  ref.onDispose(router.dispose);
  return router;
});

/// The web editor: the app's database editor alone, in English, once the
/// default world is in the browser's database.
class WebEditorApp extends ConsumerWidget {
  const WebEditorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(databaseReadyProvider);
    return MaterialApp.router(
      title: 'FNM Database Editor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: const Locale('en'),
      localizationsDelegates: const [
        _WebEditorLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      routerConfig: ref.watch(_webRouterProvider),
      builder: (context, child) => switch (ready) {
        AsyncData() => PackSaveFailureListener(
          child: Column(
            children: [
              const WebDownloadReminder(),
              Expanded(child: child ?? const SizedBox.shrink()),
            ],
          ),
        ),
        AsyncError() => const _BootMessage(
          busy: false,
          text:
              'The editor could not start in this browser. Try a current '
              'Chrome, Edge, Firefox or Safari, outside a private window.',
        ),
        _ => const _BootMessage(
          busy: true,
          text: 'Loading the default world…',
        ),
      },
    );
  }
}

/// The list of databases under the big how-it-works guide.
class _ListWithGuide extends StatelessWidget {
  const _ListWithGuide();

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    child: LayoutBuilder(
      builder: (context, c) => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: c.maxHeight * 0.6),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: const WebEditorGuide(),
                ),
              ),
            ),
          ),
          const Expanded(child: EditorListScreen()),
        ],
      ),
    ),
  );
}

class _BootMessage extends StatelessWidget {
  const _BootMessage({required this.busy, required this.text});

  final bool busy;
  final String text;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The app's English copy, with the few lines that speak of a phone said
/// for a browser instead.
class _WebEditorLocalizations extends AppLocalizationsEn {
  @override
  String get editorTitle => 'Database Editor';

  @override
  String get editorIntro =>
      'Make your own starting world for Football Nations Manager: your '
      'players, their ratings, your names. Everything stays in this '
      'browser. Download the file when you are done and import it in the '
      'game on your phone or tablet.';

  @override
  String get editorImport => 'Open file';

  @override
  String get editorExport => 'Download';

  @override
  String get editorImported => 'Database opened';

  @override
  String get editorExportFailed => 'The database could not be downloaded.';
}

class _WebEditorLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _WebEditorLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(_WebEditorLocalizations());

  @override
  bool shouldReload(_WebEditorLocalizationsDelegate old) => false;
}
