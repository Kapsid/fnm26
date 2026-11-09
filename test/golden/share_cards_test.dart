import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The share cards at their real size (1080 px square, 1080 x 1920 story),
/// rendered in the app's own fonts and art, with fictional players.
///
/// Every case must lay out without an overflow. The images are written to
/// `build/share_preview/` (or `$SHARE_OUT`) for a human to look at; they are
/// previews, not pixel goldens.
void main() {
  final out = Platform.environment['SHARE_OUT'] ?? 'build/share_preview';
  setUpAll(_loadMaterialIcons);

  for (final format in ShareFormat.values) {
    for (final (name, data) in _matches) {
      testWidgets('match card: $name (${format.name})', (tester) async {
        await _render(
          tester,
          MatchShareCard(data: data, format: format),
          format,
          '$out/match_${name}_${format.name}.png',
        );
      });
    }
    for (final (name, data) in _cabinets) {
      testWidgets('cabinet card: $name (${format.name})', (tester) async {
        await _render(
          tester,
          CabinetShareCard(data: data, format: format),
          format,
          '$out/cabinet_${name}_${format.name}.png',
        );
      });
    }
  }
}

const _root = Key('share.root');

Future<void> _render(
  WidgetTester tester,
  Widget card,
  ShareFormat format,
  String path,
) async {
  tester.view
    ..physicalSize = format.size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Center(
        child: RepaintBoundary(key: _root, child: card),
      ),
    ),
  );
  // Let the flags (SVG) and the trophy and logo art (PNG) decode.
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(() async {
      for (final e in find.byType(Image).evaluate()) {
        await precacheImage((e.widget as Image).image, e);
      }
      await Future<void>.delayed(const Duration(milliseconds: 120));
    });
    await tester.pump();
  }
  expect(tester.takeException(), isNull);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_root),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> _loadMaterialIcons() async {
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
  final file = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!file.existsSync()) return;
  final bytes = await file.readAsBytes();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
}

final ScoreBugTheme? _gold = ScoreBugTheme.all[ScoreBugThemeKind.finalGold];

/// Fictional players throughout, in the game's own generated style.
final List<(String, MatchShareData)> _matches = [
  (
    'final',
    MatchShareData(
      home: const ShareSide(
        name: 'Czechia',
        code: 'CZE',
        color: Color(0xFFD7141A),
        goals: 2,
      ),
      away: const ShareSide(
        name: 'Brazil',
        code: 'BRA',
        color: Color(0xFFFEDD00),
        goals: 1,
      ),
      competition: 'World Championship',
      round: 'Final',
      dateLabel: '19 July 2030',
      venue: 'Estadio Centenario, Montevideo',
      trophyAsset: Trophies.worldCup,
      plateTheme: _gold,
      goals: const [
        ShareGoal(scorer: 'Filip Král', minute: 23, home: true),
        ShareGoal(scorer: 'Caio Azevedo', minute: 51, home: false),
        ShareGoal(
          scorer: 'Marek Pokorný',
          minute: 88,
          home: true,
          penalty: true,
        ),
      ],
      star: const ShareStar(name: 'Filip Král', code: 'CZE', rating: 8.7),
      homePossession: 46,
      homeShots: 11,
      awayShots: 15,
    ),
  ),
  (
    'group',
    const MatchShareData(
      home: ShareSide(
        name: 'Netherlands',
        code: 'NED',
        color: Color(0xFFF36C21),
        goals: 3,
      ),
      away: ShareSide(
        name: 'Germany',
        code: 'GER',
        color: Color(0xFF000000),
        goals: 3,
      ),
      competition: 'European Championship',
      round: 'Group C',
      dateLabel: '14 June 2028',
      venue: 'Råsunda, Stockholm',
      trophyAsset: 'assets/trophies/europe.png',
      goals: [
        ShareGoal(scorer: 'Bart Verheij', minute: 9, home: true),
        ShareGoal(scorer: 'Niklas Hartmann', minute: 31, home: false),
        ShareGoal(scorer: 'Bart Verheij', minute: 45, stoppage: 2, home: true),
        ShareGoal(scorer: 'Pascal Vogel', minute: 63, home: false),
        ShareGoal(scorer: 'Wout Timmermans', minute: 77, home: true),
        ShareGoal(
          scorer: 'Niklas Hartmann',
          minute: 90,
          stoppage: 4,
          home: false,
        ),
      ],
      star: ShareStar(name: 'Niklas Hartmann', code: 'GER', rating: 8.1),
      homePossession: 52,
      homeShots: 17,
      awayShots: 13,
    ),
  ),
  (
    'long_names_pens',
    const MatchShareData(
      home: ShareSide(
        name: 'Bosnia and Herzegovina',
        code: 'BIH',
        color: Color(0xFF002395),
        goals: 1,
      ),
      away: ShareSide(
        name: 'Central African Republic',
        code: 'CTA',
        color: Color(0xFF289728),
        goals: 1,
      ),
      competition: 'World Championship Qualifiers',
      round: 'Intercontinental Play-off',
      dateLabel: '27 March 2029',
      venue: 'Stade Barthélemy Boganda, Bangui',
      extraTime: true,
      homePens: 5,
      awayPens: 4,
      goals: [
        ShareGoal(scorer: 'Armin Kadić', minute: 58, home: true),
        ShareGoal(
          scorer: "Emmanuel N'Gaïssona",
          minute: 104,
          home: false,
        ),
      ],
      star: ShareStar(name: 'Mahir Omerović', code: 'BIH', rating: 7.6),
      homePossession: 49,
      homeShots: 12,
      awayShots: 10,
    ),
  ),
];

const _years = [2030, 2034, 2042];

final List<(String, CabinetShareData)> _cabinets = [
  (
    'rich',
    const CabinetShareData(
      nationName: 'Czechia',
      nationCode: 'CZE',
      managerName: 'Tomáš Hrubý',
      trophies: [
        ShareTrophy(
          label: 'World Championship',
          asset: Trophies.worldCup,
          years: [2034, 2042],
        ),
        ShareTrophy(
          label: 'European Championship',
          asset: 'assets/trophies/europe.png',
          years: [2032, 2036, 2040],
        ),
        ShareTrophy(
          label: 'Nations Cup',
          asset: Trophies.nationsCup,
          years: [2029, 2031, 2033, 2035, 2039],
        ),
        ShareTrophy(
          label: 'Continental Clash',
          asset: Trophies.continentalClash,
          years: [2037],
        ),
      ],
    ),
  ),
  (
    'many',
    CabinetShareData(
      nationName: 'Bosnia and Herzegovina',
      nationCode: 'BIH',
      managerName: 'Elvir Hodžić',
      trophies: [
        for (final t in Trophies.cabinet)
          ShareTrophy(label: t.label, asset: t.asset, years: _years),
      ],
    ),
  ),
  (
    'sparse',
    const CabinetShareData(
      nationName: 'Netherlands',
      nationCode: 'NED',
      managerName: 'Joost Bakhuizen',
      trophies: [
        ShareTrophy(
          label: 'Nations Cup',
          asset: Trophies.nationsCup,
          years: [2031],
        ),
      ],
    ),
  ),
];
