import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// A press topic cannot ship mute, and cannot ship in English only.
///
/// The failure this guards against is cheap to make and expensive to see: a
/// topic is added to [PressTopic], selected by the provider, and has no
/// wording behind it — or has one in the template language only, so a manager
/// playing in Czech is handed an English sentence in the middle of his own
/// conference. Both reach a player before they reach a test, because neither
/// is a crash.
void main() {
  /// A question on [topic], carrying the sort of subject its selector gives
  /// it, so the copy is asked for exactly as the sheet asks for it.
  PressQuestion question(PressTopic topic, {bool ours = true}) => (
    key: '${Press.keyPrefixOf(topic)}:1',
    topic: topic,
    subject: switch (topic) {
      PressTopic.sendingOff => const PressSubjectIncident(
        type: MatchEventType.redCard,
        minute: 34,
        playerId: 1,
        name: 'Nomenjanahary Randriamampionona',
      ),
      PressTopic.injuryBlow => const PressSubjectIncident(
        type: MatchEventType.injury,
        minute: 61,
        playerId: 1,
        name: 'Nomenjanahary Randriamampionona',
      ),
      PressTopic.lateDrama => PressSubjectIncident(
        type: MatchEventType.goal,
        minute: 90,
        playerId: 1,
        name: 'Nomenjanahary Randriamampionona',
        ours: ours,
      ),
      PressTopic.shootoutFate => const PressSubjectOpponent(1),
      _ => const PressSubjectTeam(),
    },
    subjectNationId: 1,
    options: Press.optionsFor(topic),
  );

  group('every topic has something to ask', () {
    test('in both languages, with no placeholder left in it', () async {
      for (final code in const ['en', 'cs']) {
        final l = await AppLocalizations.delegate.load(Locale(code));
        for (final topic in PressTopic.values) {
          for (final ours in const [true, false]) {
            final wordings = pressAskWordings(
              l,
              question(topic, ours: ours),
              opponentName: 'Brazil',
            );
            expect(
              wordings,
              isNotEmpty,
              reason: '${topic.name} has no question in $code',
            );
            for (final w in wordings) {
              expect(
                w.trim(),
                isNotEmpty,
                reason: '${topic.name} has an empty wording in $code',
              );
              expect(
                w,
                isNot(contains('{')),
                reason: '${topic.name} left a placeholder unfilled in $code',
              );
            }
          }
        }
      }
    });

    test('and the Czech is Czech, not the English fallback', () async {
      final en = await AppLocalizations.delegate.load(const Locale('en'));
      final cs = await AppLocalizations.delegate.load(const Locale('cs'));
      for (final topic in PressTopic.values) {
        final inEnglish = pressAskWordings(
          en,
          question(topic),
          opponentName: 'Brazil',
        );
        final inCzech = pressAskWordings(
          cs,
          question(topic),
          opponentName: 'Brazil',
        );
        expect(
          inCzech.length,
          inEnglish.length,
          reason: '${topic.name} has a different number of wordings',
        );
        for (var i = 0; i < inCzech.length; i++) {
          expect(
            inCzech[i],
            isNot(inEnglish[i]),
            reason:
                '${topic.name} wording $i is untranslated: a Czech save '
                'would show the English sentence',
          );
        }
      }
    });
  });

  /// Asserts the question on screen is not broken mid-word — the failure a
  /// long surname inside a long sentence actually produces, and the one an
  /// ellipsis guard cannot see because a paragraph is allowed to wrap.
  ///
  /// The prompt is found by its words rather than by position: the sheet draws
  /// one of [pressAskWordings], and which one is a seeded draw.
  Future<void> expectQuestionUnbroken(
    WidgetTester tester,
    PressQuestion q,
    String locale,
  ) async {
    final l = await AppLocalizations.delegate.load(Locale(locale));
    final wordings = pressAskWordings(l, q, opponentName: 'Brazílie').toSet();
    expectNoBrokenWord(
      find.byWidgetPredicate(
        (w) => w is Text && wordings.contains(w.data),
        description: 'the question',
      ),
      'the ${q.topic.name} question in $locale',
    );
  }

  group('the new questions fit on a phone', () {
    /// The real sheet, with a real question, at [width].
    ///
    /// The database is empty rather than seeded: the sheet reads the room's
    /// mood through `valueOrNull`, so a save it cannot find simply leaves the
    /// arrows at their neutral reading — and the copy, which is what is being
    /// measured, is unaffected.
    Future<void> pump(
      WidgetTester tester,
      PressQuestion q, {
      required double width,
      required String locale,
    }) async {
      tester.view
        ..physicalSize = Size(width, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final db = createTestDatabase();
      addTearDown(db.close);
      await tester.pumpApp(
        Scaffold(
          body: PressSheet(careerId: 1, question: q, opponentName: 'Brazílie'),
        ),
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        locale: Locale(locale),
      );
      // Pumped rather than settled: the mood and habit providers are futures
      // that resolve into the tree, and there is no animation to wait out.
      await tester.pump();
      await tester.pump();
    }

    for (final width in const [320.0, 360.0, 400.0]) {
      for (final locale in const ['en', 'cs']) {
        for (final topic in const [
          PressTopic.sendingOff,
          PressTopic.injuryBlow,
          PressTopic.shootoutFate,
          PressTopic.lateDrama,
        ]) {
          testWidgets(
            '${topic.name} at ${width.toInt()}px in $locale',
            (tester) async {
              await pump(
                tester,
                question(topic),
                width: width,
                locale: locale,
              );
              expectLocale(
                tester,
                find.byType(PressSheet),
                locale,
              );
              expectNothingCut(tester, 'the ${topic.name} conference');
              await expectQuestionUnbroken(tester, question(topic), locale);
            },
          );
        }
      }
    }

    testWidgets('a late goal conceded reads at 320px in cs', (tester) async {
      await pump(
        tester,
        question(PressTopic.lateDrama, ours: false),
        width: 320,
        locale: 'cs',
      );
      expectNothingCut(tester, 'the late-drama conference');
      await expectQuestionUnbroken(
        tester,
        question(PressTopic.lateDrama, ours: false),
        'cs',
      );
    });
  });
}
