import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/federation/staff_effect.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// What the staff room says each hire is doing.
///
/// The manager's report was that he could see no effect from the people he
/// pays. Reading the seams says why: only two of the three jobs reach anything
/// at all, and what they reach is the injury rate and the newgen intake. So
/// these tests hold two things down.
///
/// One, that every figure on the card is PRICED OFF the constant the engine
/// applies — not typed into the copy, where it would drift the first time
/// somebody tunes `Staff`.
///
/// Two, that the screen does not claim an effect the scout does not have. The
/// scout's tier is stored, displayed, charged for, and read by nothing:
/// `Staff.capsToKnow` is defined and never called. A screen that says so is
/// worth more than one that pads the line.
void main() {
  /// Text as it READS: [WholeText] threads zero-width spaces through a string
  /// so a long one can break anywhere, so plain `find.text` never finds it.
  Finder reading(String text) => find.byWidgetPredicate(
    (w) => w is Text && w.data?.replaceAll('​', '') == text,
    description: 'text "$text"',
  );

  StaffCandidate person(StaffRole role, StaffTier tier) => (
    id: 900000000 + role.index * 1000 + tier.index * 100,
    name: 'Coach ${role.index}',
    country: 'cz',
    role: role,
    tier: tier,
  );

  /// A staff room with [hired] in the jobs named and nobody in the rest.
  StaffRoom room(Map<StaffRole, StaffTier> hired) => (
    hired: {
      for (final role in StaffRole.values)
        role: hired[role] == null ? null : person(role, hired[role]!),
    },
    applicants: {
      for (final role in StaffRole.values)
        role: [
          for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite])
            person(role, tier),
        ],
    },
    wagesPerCycle: Staff.totalCost(hired),
  );

  /// Pumps the card with the locale set on the MaterialApp ITSELF.
  ///
  /// `Localizations.override` around a launcher does not reach a pushed route,
  /// and a test that uses one silently measures English while believing it is
  /// measuring Czech. Every Czech case below also asserts a Czech-only string
  /// is on screen before it measures anything.
  Future<void> pump(
    WidgetTester tester,
    Map<StaffRole, StaffTier> hired, {
    Locale locale = const Locale('en'),
    double width = 400,
  }) async {
    tester.view
      ..physicalSize = Size(width, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          staffRoomProvider(1).overrideWith((ref) => room(hired)),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: StaffCard(careerId: 1, readOnly: true),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('what the numbers are priced off', () {
    test(
      'the fitness coach is priced off the injury factor he is applied by',
      () {
        // The match preview multiplies the side's per-minute injury rate by
        // exactly this, so the percentage the screen quotes has to fall out of
        // it rather than sit beside it in the copy.
        for (final tier in StaffTier.values) {
          expect(
            StaffEffect.injuryReductionPct(StaffRole.fitnessCoach, tier),
            ((1 - Staff.injuryFactor(tier)) * 100).round(),
            reason: '$tier',
          );
        }
        // And the figures themselves, so a change to the constants shows up here
        // rather than quietly changing what the manager is promised.
        expect(
          StaffEffect.injuryReductionPct(
            StaffRole.fitnessCoach,
            StaffTier.none,
          ),
          0,
        );
        expect(
          StaffEffect.injuryReductionPct(
            StaffRole.fitnessCoach,
            StaffTier.basic,
          ),
          6,
        );
        expect(
          StaffEffect.injuryReductionPct(
            StaffRole.fitnessCoach,
            StaffTier.good,
          ),
          13,
        );
        expect(
          StaffEffect.injuryReductionPct(
            StaffRole.fitnessCoach,
            StaffTier.elite,
          ),
          22,
        );
      },
    );

    test(
      'the assistant is priced off his own injury factor and his youth hours',
      () {
        for (final tier in StaffTier.values) {
          expect(
            StaffEffect.injuryReductionPct(StaffRole.assistant, tier),
            ((1 - Staff.assistantInjuryFactor(tier)) * 100).round(),
            reason: '$tier',
          );
        }
        expect(
          StaffEffect.injuryReductionPct(StaffRole.assistant, StaffTier.elite),
          10,
        );
        // His youth work reaches the newgen intake through
        // `youthBonusByCycleProvider`, and is put on the same overall-point
        // scale the academy slider reads in.
        expect(StaffEffect.youthOverall(StaffTier.none), 0);
        expect(StaffEffect.youthOverall(StaffTier.elite), 3);
      },
    );

    test('the scout reaches nothing, and the card is told so', () {
      // `Staff.capsToKnow` is defined and never called; `Prospects.capsToKnow`
      // is a flat three whoever is in the job. Until that is wired, the honest
      // answer is nothing.
      expect(StaffEffect.hasEffect(StaffRole.scout), isFalse);
      expect(StaffEffect.hasEffect(StaffRole.assistant), isTrue);
      expect(StaffEffect.hasEffect(StaffRole.fitnessCoach), isTrue);
    });
  });

  group('what the card says', () {
    testWidgets('a hired man states his own tier, not the best tier', (
      tester,
    ) async {
      await pump(tester, {
        StaffRole.fitnessCoach: StaffTier.good,
        StaffRole.assistant: StaffTier.basic,
      });

      // Good fitness coach: 1 - 0.87.
      expect(reading('13% fewer injuries'), findsOneWidget);
      // Basic assistant: 1 - 0.06 x 1.0, and 0.025 of the talent scale.
      expect(reading('6% fewer injuries'), findsOneWidget);
      expect(reading('Youngsters +2 overall'), findsOneWidget);
      // The elite figure belongs to nobody in this room.
      expect(reading('22% fewer injuries'), findsNothing);
    });

    testWidgets('an empty job says what filling it would be worth', (
      tester,
    ) async {
      await pump(tester, const {});

      // The market always offers a basic slot and an elite one, so the range
      // is what a manager judging the spend is actually choosing between.
      expect(
        reading('Hiring one: 6% to 22% fewer injuries'),
        findsOneWidget,
      );
      expect(
        reading('Hiring one: 6% to 10% fewer injuries'),
        findsOneWidget,
      );
      expect(
        reading('and youngsters +2 to +3 overall'),
        findsOneWidget,
      );
    });

    testWidgets('the scout is not handed an effect he does not have', (
      tester,
    ) async {
      await pump(tester, {StaffRole.scout: StaffTier.elite});

      // Not "improves your squad", not a blank line: the truth.
      expect(reading('No effect on your squad yet'), findsOneWidget);
      // And an elite scout is worth no more than none of one.
      await pump(tester, const {});
      expect(reading('No effect on your squad yet'), findsOneWidget);
    });
  });

  group('the width', () {
    for (final width in <double>[360, 400]) {
      testWidgets('every figure fits whole in English at ${width}px', (
        tester,
      ) async {
        await pump(tester, {
          StaffRole.fitnessCoach: StaffTier.elite,
          StaffRole.assistant: StaffTier.elite,
        }, width: width);

        expectWhole(reading('Fitness Coach'), 'the fitness coach\'s job');
        expectWhole(reading('Assistant Manager'), 'the assistant\'s job');
        expectWhole(reading('Chief Scout'), 'the scout\'s job');
        expectWhole(
          reading('22% fewer injuries'),
          'the fitness coach\'s figure',
        );
        expectWhole(reading('10% fewer injuries'), "the assistant's figure");
        expectWhole(
          reading('Youngsters +3 overall'),
          "the assistant's youth figure",
        );
        expectWhole(
          reading('No effect on your squad yet'),
          'the scout\'s line',
        );
        expectNothingCut(tester);
      });

      testWidgets('every figure fits whole in Czech at ${width}px', (
        tester,
      ) async {
        await pump(
          tester,
          {
            StaffRole.fitnessCoach: StaffTier.elite,
            StaffRole.assistant: StaffTier.elite,
          },
          locale: const Locale('cs'),
          width: width,
        );

        // Czech really is on screen: a locale that did not take would measure
        // English and pass.
        expect(reading('Kondiční trenér'), findsOneWidget);

        expectWhole(reading('Kondiční trenér'), 'the fitness coach\'s job');
        expectWhole(reading('Asistent trenéra'), 'the assistant\'s job');
        expectWhole(reading('Hlavní skaut'), 'the scout\'s job');
        expectWhole(
          reading('O 22 % méně zranění'),
          'the fitness coach\'s figure',
        );
        expectWhole(reading('O 10 % méně zranění'), "the assistant's figure");
        expectWhole(
          reading('Mladíci +3 na celkovém'),
          "the assistant's youth figure",
        );
        expectWhole(
          reading('Na tým zatím nemá žádný vliv'),
          'the scout\'s line',
        );
        expectNothingCut(tester);
      });

      testWidgets('an empty room fits whole in Czech at ${width}px', (
        tester,
      ) async {
        await pump(
          tester,
          const {},
          locale: const Locale('cs'),
          width: width,
        );

        expect(reading('Místo je neobsazené'), findsNWidgets(3));
        expectWhole(
          reading('Po najmutí: o 6 až 22 % méně zranění'),
          'the vacant fitness coach line',
        );
        expectWhole(
          reading('Po najmutí: o 6 až 10 % méně zranění'),
          'the vacant assistant line',
        );
        expectWhole(
          reading('a mladíci +2 až +3 na celkovém'),
          'the vacant assistant youth line',
        );
        expectNothingCut(tester);
      });
    }
  });
}
