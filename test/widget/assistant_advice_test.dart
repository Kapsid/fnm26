import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/tactics/assistant_advice.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/assistant_advice_sheet.dart';
import 'package:fnm/features/tactics/assistant_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart';

/// "Ask the assistant", on the tactics screen and in the match.
/// WholeText draws zero-width break opportunities between letters, so a
/// plain text finder never matches it.
Finder wholeText(String text) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().replaceAll('\u200b', '') == text,
  description: 'whole text "$text"',
);

/// Every text inside [inside] is whole and was not squeezed below 60% of its
/// size to fit (the project's legibility floor, see `expectLegible`).
void expectAllLegible(WidgetTester tester, Finder inside, String where) {
  final texts = find.descendant(of: inside, matching: find.byType(Text));
  for (final element in texts.evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph || paragraph.size.width == 0) continue;
    final rect = tester.getRect(
      find.byElementPredicate((e) => identical(e, element)),
    );
    final shrink = rect.width / paragraph.size.width;
    final text = paragraph.text.toPlainText().replaceAll('\u200b', '');
    expect(
      paragraph.didExceedMaxLines,
      isFalse,
      reason: '"$text" on $where is cut off',
    );
    expect(
      shrink,
      greaterThanOrEqualTo(0.6),
      reason: '"$text" on $where is squeezed to ${(shrink * 100).round()}%',
    );
  }
}

void main() {
  /// A candidate id the staff market would hand out at [tier] (cycle 0, the
  /// assistant's job): the tier is read back out of the id.
  int candidate(StaffTier tier) =>
      StaffMarket.idBase + StaffRole.assistant.index * 1000 + tier.index * 100;

  Future<void> hire(
    WidgetTester tester,
    SeededSave save,
    StaffTier tier,
  ) async {
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setStaff(save.careerId, StaffRole.assistant, candidate(tier)),
    );
    save.container.invalidate(careerByIdProvider(save.careerId));
  }

  group('tactics screen', () {
    testWidgets('disabled, with a note, while nobody is in the job', (
      tester,
    ) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}',
      );
      final ask = find.byKey(AssistantAdviceKeys.ask);
      await tester.ensureVisible(ask);
      await tester.pumpAndSettle();
      expect(tester.widget<ButtonStyleButton>(ask).onPressed, isNull);
      expect(wholeText(enL.assistantNoneNote), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Apply puts the chosen proposal in; Close changes nothing', (
      tester,
    ) async {
      final save = await seedSave(tester);
      await hire(tester, save, StaffTier.elite);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}',
      );
      final ask = find.byKey(AssistantAdviceKeys.ask);
      await tester.ensureVisible(ask);
      await tester.pumpAndSettle();
      await settle(tester);
      expect(tester.widget<ButtonStyleButton>(ask).onPressed, isNotNull);
      expect(wholeText(enL.assistantNoneNote), findsNothing);

      Future<List<int?>> stored() async {
        late List<int?> lineup;
        await tester.runAsync(() async {
          lineup =
              (await save.container
                      .read(tacticsRepositoryProvider)
                      .tacticForCareer(save.careerId))!
                  .lineup;
        });
        return lineup;
      }

      final before = await stored();
      final sub = save.container.listen(
        lineupAdviceProvider(save.careerId).future,
        (_, _) {},
      );
      await settle(tester);
      final read = await sub.read();
      sub.close();
      final advice = read!.advice!;

      // Close: nothing moves.
      await tester.tap(ask);
      await settle(tester);
      expect(find.byKey(AssistantAdviceKeys.sheet), findsOneWidget);
      await tester.tap(find.byKey(AssistantAdviceKeys.close));
      await tester.pumpAndSettle();
      expect(await stored(), before);

      // Apply the last card offered (an alternative when there is one).
      final proposals = [advice.main, ...advice.alternatives];
      final pick = proposals.length - 1;
      await tester.tap(ask);
      await settle(tester);
      final card = find.byKey(AssistantAdviceKeys.proposal(pick));
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();
      // Tapped on the real clock: the write it starts goes to the database.
      await tester.runAsync(() async {
        await tester.tap(find.byKey(AssistantAdviceKeys.apply));
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await settle(tester);
      expect(await stored(), proposals[pick].lineup);
      expect(tester.takeException(), isNull);
      // Test-only. Riverpod 2.6.1 (async_notifier/base.dart 461-466)
      // completes a future a second time when the container is disposed
      // after a write has invalidated a provider nothing rebuilt ("Bad state:
      // Future already completed"; the same bug manager_tablet_test.dart
      // works around). It is the teardown, not the app, so dispose here and
      // let exactly that message through.
      addTearDown(() {
        try {
          save.container.dispose();
          // The riverpod bug surfaces as a StateError, an Error subclass.
          // ignore: avoid_catching_errors
        } on StateError catch (e) {
          if (!e.message.contains('Future already completed')) rethrow;
        }
      });
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('in-match', () {
    const formation = Formation.f442;
    List<Player> squad() => [
      for (var i = 0; i < 11; i++)
        player(
          id: i + 1,
          nationId: 1,
          name: 'Starter${i + 1}',
          position: formation.positions[i],
          attributes: flatAttributes(70),
        ),
      for (var i = 12; i <= 18; i++)
        player(
          id: i,
          nationId: 1,
          name: 'Bench$i',
          position: formation.positions[(i - 11) % 11],
          attributes: flatAttributes(68),
        ),
    ];

    late InMatchTacticsResult? result;

    Future<void> open(
      WidgetTester tester, {
      required StaffTier tier,
      int maxSubs = 5,
      List<int?>? lineup,
    }) async {
      result = null;
      await tester.binding.setSurfaceSize(const Size(400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (inner) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () async => result = await showInMatchTactics(
                      inner,
                      minute: 75,
                      formation: formation,
                      lineup: lineup ?? [for (var i = 1; i <= 11; i++) i],
                      instructions: const TacticalInstructions(),
                      pool: squad(),
                      startingIds: {for (var i = 1; i <= 11; i++) i},
                      maxSubs: maxSubs,
                      // Everybody on the pitch is out on his feet.
                      energyByPlayer: {for (var i = 1; i <= 11; i++) i: 25},
                      assistantTier: tier,
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('disabled with nobody in the job', (tester) async {
      await open(tester, tier: StaffTier.none);
      final ask = find.byKey(AssistantAdviceKeys.ask);
      await tester.ensureVisible(ask);
      expect(tester.widget<ButtonStyleButton>(ask).onPressed, isNull);
      expect(wholeText(enL.assistantNoneNote), findsOneWidget);
    });

    for (final (maxSubs, earlier, left) in [
      (5, null, 3),
      // Two changes already made earlier in the match, of three: one left.
      (3, <int?>[1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13], 1),
    ]) {
      testWidgets('applies his changes, never more than the $left left', (
        tester,
      ) async {
        await open(
          tester,
          tier: StaffTier.good,
          maxSubs: maxSubs,
          lineup: earlier,
        );
        final ask = find.byKey(AssistantAdviceKeys.ask);
        await tester.ensureVisible(ask);
        await tester.tap(ask);
        await tester.pumpAndSettle();
        expect(find.byKey(AssistantAdviceKeys.sheet), findsOneWidget);
        expect(find.byKey(AssistantAdviceKeys.sub(left - 1)), findsOneWidget);
        expect(find.byKey(AssistantAdviceKeys.sub(left)), findsNothing);
        await tester.tap(find.byKey(AssistantAdviceKeys.apply));
        await tester.pumpAndSettle();
        await tester.tap(find.text(enL.tacticsApply));
        await tester.pumpAndSettle();
        final starters = {for (var i = 1; i <= 11; i++) i};
        final off = starters.difference(result!.lineup.toSet());
        // Every change he proposed was made, and the side is on its limit.
        expect(off, hasLength(3));
        expect(off.length, lessThanOrEqualTo(maxSubs));
        expect(result!.lineup.whereType<int>().toSet(), hasLength(11));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('fits at 320 and 360 in the long languages', () {
    const longNames = [
      'Aleksanteri Hämäläinen-Väisänen',
      'Maximilian Schweinsteigerberger',
      'Bartholomew Oyelaran-Featherstonehaugh',
      'Konstantinos Papadopoulos-Karamanlis',
      'Jiří Navrátilovič-Dvořáček',
    ];
    const places = [
      PlayerPosition.gk,
      PlayerPosition.rb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.lb,
      PlayerPosition.rm,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.lm,
      PlayerPosition.st,
      PlayerPosition.st,
    ];
    final pool = [
      for (var i = 0; i < 16; i++)
        player(
          id: i + 1,
          nationId: 1,
          name: longNames[i % longNames.length],
          position: places[i % 11],
        ),
    ];
    final byId = {for (final p in pool) p.id: p};
    final lineup = [for (var i = 1; i <= 11; i++) i];
    LineupAdvice proposal(AdviceVariant v, List<int?> xi, AdviceReason r) =>
        LineupAdvice(
          variant: v,
          lineup: xi,
          reasons: [for (final _ in xi) r],
          bench: const [
            (playerId: 12, reason: AdviceReason.coverAttack),
            (playerId: 13, reason: AdviceReason.coverMidfield),
            (playerId: 14, reason: AdviceReason.coverDefence),
          ],
        );
    final advice = (
      main: proposal(AdviceVariant.main, lineup, AdviceReason.outOfPosition),
      alternatives: [
        proposal(
          AdviceVariant.fresherLegs,
          [...lineup]..[5] = 15,
          AdviceReason.chasing,
        ),
        proposal(
          AdviceVariant.solid,
          [...lineup]..[9] = 16,
          AdviceReason.covering,
        ),
      ],
    );
    const subs = <SubAdvice>[
      (offId: 2, onId: 12, reason: AdviceReason.outOfPosition),
      (offId: 6, onId: 13, reason: AdviceReason.chasing),
      (offId: 9, onId: 14, reason: AdviceReason.booked),
    ];

    for (final code in const ['fi', 'de', 'cs', 'hu', 'en']) {
      for (final width in const [320.0, 360.0]) {
        testWidgets('$code at ${width.toInt()}', (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 640));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          late BuildContext ctx;
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.theme,
              locale: Locale(code),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(kMaxAppTextScale),
                ),
                child: child!,
              ),
              home: Builder(
                builder: (context) {
                  ctx = context;
                  return const Scaffold(
                    body: Padding(
                      padding: EdgeInsets.all(16),
                      child: AskAssistantButton(
                        tier: StaffTier.none,
                        onPressed: null,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          expectAllLegible(
            tester,
            find.byType(AskAssistantButton),
            'the disabled button',
          );

          for (final tier in [StaffTier.basic, StaffTier.elite]) {
            final shown = showLineupAdviceSheet(
              ctx,
              advice: advice,
              tier: tier,
              places: places,
              byId: byId,
              current: lineup,
              opponentStronger: true,
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final sheet = find.byKey(AssistantAdviceKeys.sheet);
            expectLocale(tester, sheet, code);
            expectAllLegible(tester, sheet, 'the lineup sheet ($tier)');
            // Scroll the whole sheet through: every card must lay out.
            await tester.drag(
              find.byKey(AssistantAdviceKeys.sheet),
              const Offset(0, -2000),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            expectAllLegible(tester, sheet, 'the lineup sheet, scrolled');
            await tester.tap(find.byKey(AssistantAdviceKeys.close));
            await tester.pumpAndSettle();
            expect(await shown, isNull);
          }

          final shownSubs = showSubAdviceSheet(
            ctx,
            subs: subs,
            tier: StaffTier.elite,
            byId: byId,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expectAllLegible(
            tester,
            find.byKey(AssistantAdviceKeys.sheet),
            'the changes sheet',
          );
          await tester.tap(find.byKey(AssistantAdviceKeys.apply));
          await tester.pumpAndSettle();
          expect(await shownSubs, subs);
        });
      }
    }
  });
}
