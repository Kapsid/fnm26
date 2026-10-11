import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/seeded_save.dart';

/// A seeded save's real next-match preview, read in a save of its own: a
/// provider cannot be overridden with a value derived from itself.
Future<MatchPreview> _realPreview(WidgetTester tester) async {
  final source = await seedSave(tester);
  late MatchPreview preview;
  await tester.runAsync(() async {
    final sub = source.container.listen(
      matchPreviewProvider(source.careerId).future,
      (_, _) {},
    );
    preview = (await sub.read())!;
    sub.close();
  });
  return preview;
}

/// [p] in another [round], or with the manager's side moved to the other
/// end ([swap]): the away branch.
MatchPreview _reshaped(MatchPreview p, {String? round, bool swap = false}) {
  var f = p.fixture;
  if (round != null) f = f.copyWith(round: round);
  if (swap) {
    f = f.copyWith(homeNationId: f.awayNationId, awayNationId: f.homeNationId);
  }
  return MatchPreview(
    fixture: f,
    result: p.result,
    nations: p.nations,
    homeTeam: swap ? p.awayTeam : p.homeTeam,
    awayTeam: swap ? p.homeTeam : p.awayTeam,
    playerNationId: p.playerNationId,
    bench: p.bench,
    saveSeed: p.saveSeed,
    opponentBench: p.opponentBench,
    opponentSubs: p.opponentSubs,
    injuryFactorByNation: p.injuryFactorByNation,
    chemistryByNation: p.chemistryByNation,
    neutralVenue: p.neutralVenue,
    venueHostId: p.venueHostId,
    bigMatch: p.bigMatch,
    ground: p.ground,
  );
}

Future<void> _openWith(
  WidgetTester tester,
  MatchPreview preview, {
  WcHostTheme? host,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      matchPreviewProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => preview),
      if (host != null)
        wcHostThemeProvider(kSeededCareerId).overrideWith((ref) async => host),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.matchPreview}?careerId=${save.careerId}',
    size: kTabletSize,
  );
}

const Color _accent = Color(0xFFC8102E);

/// An active host theme for a finals hosted by [p]'s away side.
WcHostTheme _host(MatchPreview p) => (
  active: true,
  accent: _accent,
  onAccent: const Color(0xFFFFFFFF),
  colors: const [_accent, Color(0xFFFFC400)],
  hostIds: [p.fixture.awayNationId],
  hostLabel: p.nations[p.fixture.awayNationId]!.name.toUpperCase(),
  competitionLabel: 'WORLD CHAMPIONSHIP 2030',
  year: 2030,
);

void main() {
  // Each seeded save is its own in-memory database, and some tests here
  // open two (a source save for the real preview, then the one on show):
  // drift's warning about several databases is expected, not a leak.
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  tearDownAll(
    () => driftRuntimeOptions.dontWarnAboutMultipleDatabases = false,
  );

  testWidgets('the preview is two columns: your side, then theirs', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchPreviewScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    final mine = tester.getCenter(find.byType(MatchHeadline));
    final theirs = tester.getCenter(find.byType(OpponentBriefing));
    expect(mine.dx, lessThan(theirs.dx));
    expect(find.text(enL.matchKickOff), findsOneWidget);
    // The sidebar has a Tactics item too, so look for the button.
    final tactics = find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.text(enL.matchTactics),
    );
    expect(tactics, findsOneWidget);
    // No bar across the foot of the screen: the two actions are stacked at
    // the bottom of the right-hand column, each its full width, Kick-off
    // last.
    final scaffold = tester.widget<Scaffold>(
      find.byKey(MatchPreviewScreen.tabletLayoutKey),
    );
    expect(scaffold.bottomNavigationBar, isNull);
    final column = tester.getRect(find.byType(OpponentBriefing));
    final tacticsBox = tester.getRect(find.byType(OutlinedButton));
    final kickOff = tester.getRect(
      find.ancestor(
        of: find.text(enL.matchKickOff),
        matching: find.byType(PrimaryButton),
      ),
    );
    for (final r in [tacticsBox, kickOff]) {
      expect(r.left, closeTo(column.left, 1));
      expect(r.right, closeTo(column.right, 1));
      expect(r.height, greaterThanOrEqualTo(60));
    }
    expect(kickOff.top, greaterThan(tacticsBox.bottom));
    expect(kickOff.bottom, greaterThan(kTabletSize.height - 40));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Tactics and Kick-off stay when there is no preview to show, '
      'and an error offers a retry', (tester) async {
    Finder tactics() => find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.text(enL.matchTactics),
    );

    // No upcoming match.
    final none = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        matchPreviewProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => null),
      ],
    );
    await pumpRoute(
      tester,
      none,
      '${Routes.matchPreview}?careerId=${none.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.matchNoUpcoming), findsOneWidget);
    expect(tactics(), findsOneWidget);
    expect(find.text(enL.matchKickOff), findsOneWidget);
    await tester.pumpWidget(const SizedBox());

    // The preview failed to load.
    var calls = 0;
    final failed = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        matchPreviewProvider(kSeededCareerId).overrideWith((ref) async {
          calls++;
          throw StateError('boom');
        }),
      ],
    );
    await pumpRoute(
      tester,
      failed,
      '${Routes.matchPreview}?careerId=${failed.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.matchCouldNotLoad('Bad state: boom')), findsOneWidget);
    expect(tactics(), findsOneWidget);
    expect(find.text(enL.matchKickOff), findsOneWidget);
    final before = calls;
    await tester.tap(find.text(enL.commonRetry));
    await tester.pump();
    await tester.pump();
    expect(calls, greaterThan(before));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the briefing tabs are both in capitals on a tablet only', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    final briefing = find.byType(OpponentBriefing);
    for (final label in [enL.matchHeadToHead, enL.matchDossierTitle]) {
      expect(
        find.descendant(of: briefing, matching: find.text(label.toUpperCase())),
        findsOneWidget,
        reason: label,
      );
    }
    await tester.pumpWidget(const SizedBox());

    // The phone keeps the copy as written.
    final phone = await seedSave(tester);
    await pumpRoute(
      tester,
      phone,
      '${Routes.matchPreview}?careerId=${phone.careerId}',
    );
    expect(
      find.descendant(
        of: find.byType(OpponentBriefing),
        matching: find.text(enL.matchDossierTitle),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  // Stage 3 carry-over: the branches the shared derivation took over.
  testWidgets("away: the manager's side is still his, on the right end", (
    tester,
  ) async {
    final real = await _realPreview(tester);
    final away = _reshaped(real, swap: true);
    expect(away.playerIsHome, isNot(real.playerIsHome));
    await _openWith(tester, away);
    expect(tester.takeException(), isNull);
    final briefing = tester.widget<OpponentBriefing>(
      find.byType(OpponentBriefing),
    );
    expect(briefing.myNationId, real.playerNationId);
    expect(briefing.oppNationId, isNot(real.playerNationId));
    expect(
      tester.widget<MatchHeadline>(find.byType(MatchHeadline)).homeCode,
      away.nations[away.fixture.homeNationId]!.code,
    );
    expect(find.text(enL.matchYourXi), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  // Under the same active host theme as the finals match below: a friendly
  // is not part of the finals, so it gets no banner and its stage line is
  // not in the host's colour. The page title follows the live finals on
  // both layouts (the phone's app bar title too), whatever the match.
  testWidgets('a friendly says so, unskinned', (tester) async {
    final real = await _realPreview(tester);
    final friendly = _reshaped(real, round: 'FRIENDLY');
    await _openWith(tester, friendly, host: _host(real));
    expect(tester.takeException(), isNull);
    final stage = find.descendant(
      of: find.byKey(MatchPreviewScreen.tabletLayoutKey),
      matching: find.text(MatchStage.label(enL, friendly.fixture)),
    );
    expect(stage, findsWidgets);
    expect(find.byType(WcHostBanner), findsNothing);
    expect(tester.widget<Text>(stage.first).style?.color, isNot(_accent));
    expect(
      tester.widget<Text>(find.text(enL.matchPreviewTitle)).style?.color,
      _accent,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("a finals match in the host's colours", (tester) async {
    final real = await _realPreview(tester);
    final hosted = _reshaped(real, round: 'GROUP');
    await _openWith(tester, hosted, host: _host(real));
    expect(tester.takeException(), isNull);
    expect(find.byType(WcHostBanner), findsOneWidget);
    expect(
      tester.widget<Text>(find.text(enL.matchPreviewTitle)).style?.color,
      _accent,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
