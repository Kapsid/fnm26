import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/features/share/share_capture.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/features/share/share_data.dart';
import 'package:fnm/features/share/share_sheet.dart';
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
    // The longest names the game prints, in the manager's own language.
    for (final (name, locale, data) in _cabinetsLocalized) {
      testWidgets('cabinet card: $name (${format.name})', (tester) async {
        await _render(
          tester,
          CabinetShareCard(data: data, format: format),
          format,
          '$out/cabinet_${name}_${format.name}.png',
          locale: locale,
        );
      });
    }
  }

  // The share sheet as a phone shows it (iPhone 17 Pro, 402 x 874 at 3x,
  // and an iPhone SE, 320 x 568 at 2x), with the preview of each format.
  for (final (device, size, dpr, top, bottom) in const [
    ('', Size(402, 874), 3.0, 62.0, 34.0),
    ('se_', Size(320, 568), 2.0, 20.0, 0.0),
  ]) {
    for (final (what, card, flags)
        in <(String, ShareCardBuilder, List<String>)>[
          (
            'match',
            (f) => MatchShareCard(data: _matches.first.$2, format: f),
            matchShareFlags(_matches.first.$2).toList(),
          ),
          (
            'cabinet',
            (f) => CabinetShareCard(data: _cabinets[1].$2, format: f),
            cabinetShareFlags(_cabinets[1].$2).toList(),
          ),
        ]) {
      for (final format in ShareFormat.values) {
        final name = 'sheet_$device${what}_${format.name}';
        testWidgets(name, (tester) async {
          tester.view
            ..physicalSize = size * dpr
            ..devicePixelRatio = dpr
            ..padding = FakeViewPadding(top: top * dpr, bottom: bottom * dpr)
            ..viewPadding = FakeViewPadding(
              top: top * dpr,
              bottom: bottom * dpr,
            );
          addTearDown(tester.view.reset);
          const root = Key('sheet.root');
          await tester.pumpWidget(
            RepaintBoundary(
              key: root,
              child: ProviderScope(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.theme,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        'MANAGER CAREER',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    body: Center(
                      child: ShareCardButton(
                        card: card,
                        fileStem: 'preview',
                        flagCodes: flags,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(ShareKeys.button));
          for (var i = 0; i < 40; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 40)),
            );
            await tester.pump(const Duration(milliseconds: 60));
          }
          await tester.tap(find.byKey(ShareKeys.format(format)));
          for (var i = 0; i < 12; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 40)),
            );
            await tester.pump(const Duration(milliseconds: 60));
          }
          expect(find.byKey(ShareKeys.preview(format)), findsOneWidget);
          expect(tester.takeException(), isNull);
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(root),
          );
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: dpr);
            final data = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            File('$out/$name.png')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data!.buffer.asUint8List());
            image.dispose();
          });
        });
      }
    }
  }

  // The real share path: the card built off screen by renderShareCard, as
  // the Share button does it, in a phone-sized app (density 3). Proves the
  // flags and trophy art are in before the capture and the size is exact.
  for (final format in ShareFormat.values) {
    testWidgets('captured off screen (${format.name})', (tester) async {
      tester.view
        ..physicalSize = const Size(1206, 2622)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      );
      final data = _matches.first.$2;
      final png = await tester.runAsync(
        () => renderShareCard(
          context,
          card: MatchShareCard(data: data, format: format),
          format: format,
          flagCodes: matchShareFlags(data),
        ),
      );
      final image = await tester.runAsync(
        () async => (await ui.instantiateImageCodec(png!)).getNextFrame(),
      );
      expect(image!.image.width, format.size.width);
      expect(image.image.height, format.size.height);
      File('$out/captured_match_${format.name}.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!);
    });
  }
}

const _root = Key('share.root');

Future<void> _render(
  WidgetTester tester,
  Widget card,
  ShareFormat format,
  String path, {
  Locale? locale,
}) async {
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
      locale: locale,
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

List<ShareWin> _w(String code, List<int> years) => [
  for (final y in years) (year: y, code: code),
];

const ShareNation _cze = (code: 'CZE', name: 'Czechia');
const ShareNation _ned = (code: 'NED', name: 'Netherlands');
const ShareNation _bih = (code: 'BIH', name: 'Bosnia and Herzegovina');
const ShareNation _cmr = (code: 'CMR', name: 'Kamerun');

final List<(String, CabinetShareData)> _cabinets = [
  (
    'rich',
    CabinetShareData(
      managerName: 'Tomáš Hrubý',
      nations: const [_cze],
      record: (played: 186, won: 104, drawn: 41, lost: 41),
      trophies: [
        ShareTrophy(
          label: 'World Championship',
          asset: Trophies.worldCup,
          wins: _w('CZE', [2034, 2042]),
        ),
        ShareTrophy(
          label: 'European Championship',
          asset: 'assets/trophies/europe.png',
          wins: _w('CZE', [2032, 2036, 2040]),
        ),
        ShareTrophy(
          label: 'Nations Cup',
          asset: Trophies.nationsCup,
          wins: _w('CZE', [2029, 2031, 2033, 2035, 2039]),
        ),
        ShareTrophy(
          label: 'Continental Clash',
          asset: Trophies.continentalClash,
          wins: _w('CZE', [2037]),
        ),
      ],
    ),
  ),
  (
    'two_nations',
    CabinetShareData(
      managerName: 'Tomáš Hrubý',
      nations: const [_ned, _cze],
      record: (played: 241, won: 139, drawn: 52, lost: 50),
      trophies: [
        ShareTrophy(
          label: 'World Championship',
          asset: Trophies.worldCup,
          wins: [
            ..._w('CZE', [2034]),
            ..._w('NED', [2046]),
          ],
        ),
        ShareTrophy(
          label: 'European Championship',
          asset: 'assets/trophies/europe.png',
          wins: [
            ..._w('CZE', [2032, 2036]),
            ..._w('NED', [2044]),
          ],
        ),
        ShareTrophy(
          label: 'Nations Cup',
          asset: Trophies.nationsCup,
          wins: _w('CZE', [2029, 2031, 2035]),
        ),
        ShareTrophy(
          label: 'Continental Clash',
          asset: Trophies.continentalClash,
          wins: _w('NED', [2045]),
        ),
      ],
    ),
  ),
  (
    'many',
    CabinetShareData(
      managerName: 'Elvir Hodžić',
      nations: const [_bih],
      record: (played: 1204, won: 811, drawn: 214, lost: 179),
      trophies: [
        for (final t in Trophies.cabinet)
          ShareTrophy(
            label: t.label,
            asset: t.asset,
            wins: _w('BIH', [2030, 2034, 2042]),
          ),
      ],
    ),
  ),
  (
    'sparse',
    CabinetShareData(
      managerName: 'Joost Bakhuizen',
      nations: const [_ned],
      record: (played: 22, won: 11, drawn: 6, lost: 5),
      trophies: [
        ShareTrophy(
          label: 'Nations Cup',
          asset: Trophies.nationsCup,
          wins: _w('NED', [2031]),
        ),
      ],
    ),
  ),
];

/// Long names on a long manager: three nations (the stack's cap), German
/// and Czech shelves, every continent's cup.
final List<(String, Locale, CabinetShareData)> _cabinetsLocalized = [
  (
    'three_nations_de',
    const Locale('de'),
    CabinetShareData(
      managerName: 'Maximilian Oberkirchner-Hagedorn',
      nations: const [
        (code: 'CMR', name: 'Kamerun'),
        (code: 'BIH', name: 'Bosnien und Herzegowina'),
        (code: 'CZE', name: 'Tschechien'),
      ],
      record: (played: 312, won: 170, drawn: 71, lost: 71),
      trophies: [
        ShareTrophy(
          label: 'Weltmeisterschaft',
          asset: Trophies.worldCup,
          wins: _w('CMR', [2050]),
        ),
        ShareTrophy(
          label: 'Afrikameisterschaft',
          asset: 'assets/trophies/africa.png',
          wins: [
            ..._w('CMR', [2047, 2049, 2051]),
          ],
        ),
        ShareTrophy(
          label: 'Europameisterschaft',
          asset: 'assets/trophies/europe.png',
          wins: [
            ..._w('CZE', [2032]),
            ..._w('BIH', [2040, 2044]),
          ],
        ),
        ShareTrophy(
          label: 'Nordamerika-Pokal',
          asset: 'assets/trophies/northamerica.png',
          wins: _w('CMR', [2053]),
        ),
        ShareTrophy(
          label: 'Kontinental-Duell',
          asset: Trophies.continentalClash,
          wins: _w('BIH', [2041]),
        ),
      ],
    ),
  ),
  (
    'many_cs',
    const Locale('cs'),
    CabinetShareData(
      managerName: 'Bořivoj Štěpánek-Zahradníček',
      nations: const [
        (code: 'BIH', name: 'Bosna a Hercegovina'),
        _cmr,
      ],
      record: (played: 1204, won: 811, drawn: 214, lost: 179),
      trophies: [
        for (final (i, t) in Trophies.cabinet.indexed)
          ShareTrophy(
            label: const [
              'Mistrovství světa',
              'Evropský šampionát',
              'Pohár Jižní Ameriky',
              'Africký šampionát',
              'Asijský šampionát',
              'Pohár Severní Ameriky',
              'Pohár Oceánie',
              'Pohár národů',
              'Souboj kontinentů',
            ][i],
            asset: t.asset,
            wins: [
              ..._w('BIH', [2030, 2034]),
              ..._w('CMR', [2042, 2046]),
            ],
          ),
      ],
    ),
  ),
];
