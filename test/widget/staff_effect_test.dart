import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/federation/staff_effect.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// What the staff room says each hire is doing.
///
/// The manager's report was that he could see no effect from the people he
/// pays. So these tests hold down that every figure on the card is PRICED OFF
/// the constant the game applies — the injury rate, the newgen intake, the
/// scout's read on prospects and his opponent dossier — not typed into the
/// copy, where it would drift the first time somebody tunes `Staff`.
///
/// The "no effect" line stays for a role wired to nothing; none is today.
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

    test('every role now reaches something', () {
      expect(StaffEffect.hasEffect(StaffRole.scout), isTrue);
      expect(StaffEffect.hasEffect(StaffRole.assistant), isTrue);
      expect(StaffEffect.hasEffect(StaffRole.fitnessCoach), isTrue);
    });

    test(
      'the scout is priced off the read and the dossier he is applied by',
      () {
        expect(StaffEffect.readSpotOnPct(StaffTier.basic), 50);
        expect(StaffEffect.readSpotOnPct(StaffTier.good), 70);
        expect(StaffEffect.readSpotOnPct(StaffTier.elite), 90);
        expect(StaffEffect.capsToKnow(StaffTier.basic), 2);
        expect(StaffEffect.capsToKnow(StaffTier.elite), 1);
        expect(StaffEffect.capsSooner(StaffTier.basic), 1);
        expect(StaffEffect.capsSooner(StaffTier.elite), 2);

        // The quoted share is a floor on what the manager will actually see:
        // measured across a few thousand nineteen-year-olds, never below it.
        for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
          var exact = 0;
          const n = 4000;
          for (var id = 0; id < n; id++) {
            if (Prospects.scoutedStars(id, age: 19, scout: tier) ==
                Prospects.trueStars(id, age: 19)) {
              exact++;
            }
          }
          expect(
            exact / n * 100,
            inInclusiveRange(
              StaffEffect.readSpotOnPct(tier) - 2,
              StaffEffect.readSpotOnPct(tier) + 12,
            ),
            reason: '$tier',
          );
        }
      },
    );
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

    testWidgets('a hired scout states his read, his caps and his dossier', (
      tester,
    ) async {
      await pump(tester, {StaffRole.scout: StaffTier.elite});

      expect(reading('Reads 90% of prospects exactly'), findsOneWidget);
      expect(reading('Potential known after 1 cap'), findsOneWidget);
      expect(reading('+3 rating from opponent dossiers'), findsOneWidget);
      expect(reading('No effect on your squad yet'), findsNothing);
    });

    testWidgets('a basic scout states his own tier, not the best', (
      tester,
    ) async {
      await pump(tester, {StaffRole.scout: StaffTier.basic});
      expect(reading('Reads 50% of prospects exactly'), findsOneWidget);
      expect(reading('Potential known after 2 caps'), findsOneWidget);
      expect(reading('+1 rating from opponent dossiers'), findsOneWidget);
    });

    testWidgets('a vacant scout job says what filling it would be worth', (
      tester,
    ) async {
      await pump(tester, const {});
      expect(reading('Hiring one: 50% to 90% of reads exact'), findsOneWidget);
      expect(
        reading('and potential known 1 to 2 caps sooner'),
        findsOneWidget,
      );
      expect(reading('and +1 to +3 rating every match'), findsOneWidget);
      expect(reading('No effect on your squad yet'), findsNothing);
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
          StaffRole.scout: StaffTier.elite,
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
          reading('Reads 90% of prospects exactly'),
          "the scout's read",
        );
        expectWhole(
          reading('Potential known after 1 cap'),
          "the scout's caps",
        );
        expectWhole(
          reading('+3 rating from opponent dossiers'),
          "the scout's dossier",
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
            StaffRole.scout: StaffTier.elite,
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
          reading('Přesně odhadne 90 % talentů'),
          "the scout's read",
        );
        expectWhole(
          reading('Potenciál jasný po 1 startu'),
          "the scout's caps",
        );
        expectWhole(
          reading('+3 k síle díky rozboru soupeře'),
          "the scout's dossier",
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
        expectWhole(
          reading('Po najmutí: přesně odhadne 50 až 90 % talentů'),
          'the vacant scout line',
        );
        expectWhole(
          reading('a potenciál jasný o 1 až 2 starty dřív'),
          'the vacant scout caps line',
        );
        expectWhole(
          reading('a +1 až +3 k síle v každém zápase'),
          'the vacant scout dossier line',
        );
        expectNothingCut(tester);
      });
    }
  });
}
