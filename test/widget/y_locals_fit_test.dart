import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_locals.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// Y's local fans carry real-looking names, which run longer than the cast's
/// (Christian Randriamampionona is a Malagasy supporter's whole name). The
/// longest name and handle any nation's cast can produce, measured at the
/// narrowest phone and the text-size ceiling: the header stays legible, and
/// the profile shows the fan's disposition like any other account's.
void main() {
  final classic =
      jsonDecode(File('assets/data/country_names.json').readAsStringSync())
          as Map<String, Object?>;
  final more =
      jsonDecode(File('assets/data/country_names_more.json').readAsStringSync())
          as Map<String, Object?>;
  List<String> read(Object? m, String key) =>
      (((m as Map?)?[key] as List?) ?? const []).cast<String>();

  // The widest fans the casts produce, across every nation and a few saves.
  var longestName = '';
  var longestHandle = '';
  YPersona? sample;
  for (final id in classic.keys) {
    for (final seed in const [1, 2, 3, 4, 5]) {
      for (final f in YLocals.castFor(
        pool: YLocals.poolFrom(
          first: read(classic[id], 'first'),
          firstMore: read(more[id], 'firstMore'),
          sur: read(classic[id], 'sur'),
          surMore: read(more[id], 'surMore'),
        ),
        nation: id,
        seed: seed,
        avoid: realInternationalNames,
      )) {
        sample ??= f;
        if (f.displayName.length > longestName.length) {
          longestName = f.displayName;
        }
        if (f.handle.length > longestHandle.length) longestHandle = f.handle;
      }
    }
  }

  YPost reply(YMood mood, int variant, {String? name, String? handle}) => (
    voice: YVoice.fan,
    handle: handle ?? longestHandle,
    displayName: name ?? longestName,
    template: YTemplate.reaction,
    variant: variant,
    args: const <String>[],
    date: DateTime(2030, 12, 28),
    key: 'fx:${mood.name}$variant|re|local0|reaction',
    replyTo: 'fx:0|stats|winTight',
    mood: mood,
  );

  Widget app(String code, Widget home) => MaterialApp(
    locale: Locale(code),
    theme: AppTheme.theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(kMaxAppTextScale),
        ),
        child: home,
      ),
    ),
  );

  /// How far the name row's [name] is scaled down, whichever form of it
  /// (whole or initialled) is on screen.
  double nameShrink(WidgetTester tester, String name) {
    final forms = {name, initialledName(name)};
    return shrinkOf(
      tester,
      find
          .descendant(
            of: find.byType(YPostTile).first,
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Text && forms.contains(w.data?.replaceAll('\u200B', '')),
            ),
          )
          .first,
    );
  }

  /// The same measure for the longest name the existing cast carries.
  Future<double> baseline(WidgetTester tester, String code) async {
    final cast = YFeed.castNames.reduce((a, b) => a.length >= b.length ? a : b);
    await tester.pumpWidget(
      app(
        code,
        Scaffold(
          body: YPostTile(
            post: reply(YMood.shrug, 0, name: cast, handle: '@$cast'),
            onAccountTap: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    return nameShrink(tester, cast);
  }

  for (final code in const ['de', 'fi', 'hu', 'el', 'cs', 'ja', 'vi', 'en']) {
    testWidgets('$code: the longest local fan fits a reply at 360 and 1.4', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      for (final mood in YMood.values) {
        await tester.pumpWidget(
          app(
            code,
            Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var v = 0; v < 3; v++)
                      YPostTile(post: reply(mood, v), onAccountTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$code ${mood.name}');
      }
      // No more squeezed than the cast's own longest name already is on
      // the same row: a long real name gives way to its initial first.
      expect(
        nameShrink(tester, longestName),
        greaterThanOrEqualTo(await baseline(tester, code)),
        reason: '$code: $longestName',
      );
    });
  }

  testWidgets('a local fan profile names his disposition', (tester) async {
    final fan = sample!;
    final post = reply(
      YMood.elation,
      0,
      name: fan.displayName,
      handle: fan.handle,
    );
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      app(
        'cs',
        YProfileSheet(persona: YFeed.personaOf(post), all: [post]),
      ),
    );
    await tester.pumpAndSettle();
    final l = AppLocalizations.of(tester.element(find.byType(YProfileSheet)));
    expect(find.text(yTraitLine(l, fan.trait)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
