import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';

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

void main() {
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
    // The sidebar has a Tactics item too, so look inside the bottom bar.
    expect(
      find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.text(enL.matchTactics),
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

  testWidgets('a friendly says so, unskinned', (tester) async {
    final friendly = _reshaped(await _realPreview(tester), round: 'FRIENDLY');
    await _openWith(tester, friendly);
    expect(tester.takeException(), isNull);
    expect(find.text(MatchStage.label(enL, friendly.fixture)), findsWidgets);
    expect(find.byType(WcHostBanner), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("a finals match in the host's colours", (tester) async {
    final real = await _realPreview(tester);
    final hosted = _reshaped(real, round: 'GROUP');
    const accent = Color(0xFFC8102E);
    await _openWith(
      tester,
      hosted,
      host: (
        active: true,
        accent: accent,
        onAccent: const Color(0xFFFFFFFF),
        colors: const [accent, Color(0xFFFFC400)],
        hostIds: [real.fixture.awayNationId],
        hostLabel: real.nations[real.fixture.awayNationId]!.name.toUpperCase(),
        competitionLabel: 'WORLD CHAMPIONSHIP 2030',
        year: 2030,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(WcHostBanner), findsOneWidget);
    expect(
      tester.widget<Text>(find.text(enL.matchPreviewTitle)).style?.color,
      accent,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
