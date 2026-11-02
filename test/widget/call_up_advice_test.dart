import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/call_up_advice.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/call_up_advice_sheet.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/tactics_providers.dart'
    show kMaxSquadSize, kMinSquadSize;
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart';

/// "Ask the assistant" on the call-up screen: his squad, with reasons.
///
/// WholeText draws zero-width break opportunities between letters, so a
/// plain text finder never matches it.
Finder wholeText(String text) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().replaceAll('​', '') == text,
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
    final text = paragraph.text.toPlainText().replaceAll('​', '');
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

/// Taps a proposal card by its head: a long card's middle may sit under the
/// buttons.
Future<void> tapCard(WidgetTester tester, Finder card) async {
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getTopLeft(card) + const Offset(24, 12));
  await tester.pumpAndSettle();
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

  // Opened as the timeline event, so the selection is drafted as it changes.
  String location(SeededSave save) =>
      '${Routes.callUps}?careerId=${save.careerId}'
      '&event=callup_test&cycle=${save.career.cyclePointer}';

  Future<Set<int>> draft(WidgetTester tester, SeededSave save) async {
    late Set<int> ids;
    await tester.runAsync(() async {
      ids = await save.container
          .read(squadRepositoryProvider)
          .callUpDraft(save.careerId, 'callup_test');
    });
    return ids;
  }

  Future<void> ask(WidgetTester tester) async {
    final button = find.byKey(CallUpAdviceKeys.ask);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await settle(tester);
    expect(find.byKey(CallUpAdviceKeys.sheet), findsOneWidget);
  }

  /// Whether proposal card [i] says it names exactly the selection.
  bool cardIsSelection(WidgetTester tester, int i) => find
      .descendant(
        of: find.byKey(CallUpAdviceKeys.proposal(i)),
        matching: wholeText(enL.assistantSameSquad),
      )
      .evaluate()
      .isNotEmpty;

  group('call-up screen', () {
    testWidgets('disabled, with a note, while nobody is in the job', (
      tester,
    ) async {
      final save = await seedSave(tester);
      await pumpRoute(tester, save, location(save));
      final button = find.byKey(CallUpAdviceKeys.ask);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      expect(tester.widget<ButtonStyleButton>(button).onPressed, isNull);
      expect(find.text(enL.assistantNoneNote), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Close changes nothing; Apply names his squad', (
      tester,
    ) async {
      final save = await seedSave(tester);
      await hire(tester, save, StaffTier.elite);
      await pumpRoute(tester, save, location(save));
      await settle(tester);
      final button = find.byKey(CallUpAdviceKeys.ask);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      expect(tester.widget<ButtonStyleButton>(button).onPressed, isNotNull);
      expect(find.text(enL.assistantNoneNote), findsNothing);

      // Close: nothing named.
      await ask(tester);
      await tester.tap(find.byKey(CallUpAdviceKeys.close));
      await settle(tester);
      expect(await draft(tester, save), isEmpty);
      expect(
        find.text(enL.tacticsSquadCount(0, kMaxSquadSize)),
        findsOneWidget,
      );

      // Apply his pick: the squad is named, the way the auto-pick names one.
      await ask(tester);
      final alternatives = find
          .byKey(CallUpAdviceKeys.proposal(1))
          .evaluate()
          .isNotEmpty;
      await tester.tap(find.byKey(CallUpAdviceKeys.apply));
      await settle(tester);
      final named = await draft(tester, save);
      expect(named.length, inInclusiveRange(kMinSquadSize, kMaxSquadSize));
      expect(
        find.text(enL.tacticsSquadCount(named.length, kMaxSquadSize)),
        findsOneWidget,
      );
      // Asked again, his pick IS the selection now.
      await ask(tester);
      expect(cardIsSelection(tester, 0), isTrue);

      // An alternative applied replaces it (a real pool always gives an
      // elite man a second idea).
      expect(alternatives, isTrue);
      {
        final card = find.byKey(CallUpAdviceKeys.proposal(1));
        expect(cardIsSelection(tester, 1), isFalse);
        await tapCard(tester, card);
        await tester.tap(find.byKey(CallUpAdviceKeys.apply));
        await settle(tester);
        expect(await draft(tester, save), isNot(named));
        await ask(tester);
        expect(cardIsSelection(tester, 1), isTrue);
        expect(cardIsSelection(tester, 0), isFalse);
      }
      await tester.tap(find.byKey(CallUpAdviceKeys.close));
      await settle(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('on a tablet too', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await hire(tester, save, StaffTier.good);
      await pumpRoute(tester, save, location(save), size: kTabletSize);
      await settle(tester);
      expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
      await ask(tester);
      await tester.tap(find.byKey(CallUpAdviceKeys.apply));
      await settle(tester);
      final named = await draft(tester, save);
      expect(named.length, inInclusiveRange(kMinSquadSize, kMaxSquadSize));
      expect(
        find.text(enL.tacticsSquadCount(named.length, kMaxSquadSize)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('fits at 320 and 360 in the long languages, at the largest text', () {
    const longNames = [
      'Aleksanteri Hämäläinen-Väisänen',
      'Maximilian Schweinsteigerberger',
      'Bartholomew Oyelaran-Featherstonehaugh',
      'Konstantinos Papadopoulos-Karamanlis',
      'Jiří Navrátilovič-Dvořáček',
    ];
    const positions = [
      PlayerPosition.gk,
      PlayerPosition.cb,
      PlayerPosition.lb,
      PlayerPosition.dm,
      PlayerPosition.cm,
      PlayerPosition.am,
      PlayerPosition.lw,
      PlayerPosition.st,
    ];
    final pool = [
      for (var i = 0; i < 30; i++)
        player(
          id: i + 1,
          nationId: 1,
          age: 18 + i % 16,
          name: longNames[i % longNames.length],
          position: positions[i % positions.length],
        ),
    ];
    final byId = {for (final p in pool) p.id: p};
    // Every reason he can give appears somewhere.
    CallUpProposal proposal(CallUpVariant v, Set<int> squad) => CallUpProposal(
      variant: v,
      squad: squad,
      reasons: {
        for (final (i, id) in squad.indexed) id: CallUpReason.values[i % 6],
      },
    );
    final current = {for (var i = 1; i <= 20; i++) i};
    final advice = (
      main: proposal(CallUpVariant.main, {for (var i = 3; i <= 25; i++) i}),
      alternatives: [
        proposal(CallUpVariant.youth, {for (var i = 5; i <= 27; i++) i}),
        proposal(CallUpVariant.experience, {for (var i = 8; i <= 30; i++) i}),
      ],
    );
    final absences = {
      1: const PlayerAbsence(playerId: 1, injuryMatches: 2),
      2: const PlayerAbsence(playerId: 2, banMatches: 1),
    };

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
                  return Scaffold(
                    body: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const AskAssistantButton(
                          tier: StaffTier.none,
                          onPressed: null,
                        ),
                        const SizedBox(height: 16),
                        // As the phone's call-up header sets it.
                        const AskAssistantButton(
                          tier: StaffTier.none,
                          onPressed: null,
                          noteBeside: true,
                        ),
                        const SizedBox(height: 16),
                        AskAssistantButton(
                          key: const Key('enabled'),
                          tier: StaffTier.good,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          for (final button in find.byType(AskAssistantButton).evaluate()) {
            expectAllLegible(
              tester,
              find.byWidget(button.widget),
              'the button',
            );
          }

          for (final (tier, base, kind) in [
            (StaffTier.basic, current, CallUpAdviceBase.selection),
            (StaffTier.elite, current, CallUpAdviceBase.lastSquad),
            (StaffTier.good, <int>{}, CallUpAdviceBase.none),
          ]) {
            final shown = showCallUpAdviceSheet(
              ctx,
              advice: advice,
              tier: tier,
              byId: byId,
              base: base,
              baseKind: kind,
              absences: absences,
              opponentsStronger: true,
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final sheet = find.byKey(CallUpAdviceKeys.sheet);
            expectLocale(tester, sheet, code);
            expectAllLegible(tester, sheet, 'the sheet ($tier)');
            // Scroll the whole sheet through: every card must lay out.
            for (var i = 0; i < 6; i++) {
              await tester.drag(sheet, const Offset(0, -400));
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
              expectAllLegible(tester, sheet, 'the sheet, scrolled');
            }
            await tester.tap(find.byKey(CallUpAdviceKeys.close));
            await tester.pumpAndSettle();
            expect(await shown, isNull);
          }

          // Apply hands back the chosen card.
          final applied = showCallUpAdviceSheet(
            ctx,
            advice: advice,
            tier: StaffTier.elite,
            byId: byId,
            base: current,
            baseKind: CallUpAdviceBase.selection,
          );
          await tester.pumpAndSettle();
          await tapCard(tester, find.byKey(CallUpAdviceKeys.proposal(1)));
          await tester.tap(find.byKey(CallUpAdviceKeys.apply));
          await tester.pumpAndSettle();
          expect(await applied, same(advice.alternatives.first));
        });
      }
    }
  });
}
