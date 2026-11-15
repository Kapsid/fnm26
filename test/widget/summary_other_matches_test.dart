import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/same_day_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The Summary's other matches of the group, on the real match screen: shown
/// ticking along on our clock through both halves, their half-time score at
/// our break, their result at our whistle, a banner for each goal elsewhere; and the score card gone for good.
///
/// The seeded save opens on a qualifying group, so its first match has two
/// other group matches that day.

Future<(SeededSave, List<SameDayResult>)> _open(
  WidgetTester tester,
  FormFactor f,
  Size size,
) async {
  final save = await seedSave(tester, formFactor: f);
  await tester.runAsync(
    () => const MatchViewModeStore().save(MatchViewMode.pitch),
  );
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  final preview = (await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  ))!;
  final key = sameDayKey(preview.fixture);
  // The chain may queue behind a step the fake zone holds (see [seedSave]):
  // both zones are turned until it lands.
  final held = save.container.listen(sameDayResultsProvider(key), (_, _) {});
  addTearDown(held.close);
  List<SameDayResult>? others;
  unawaited(
    save.container
        .read(sameDayResultsProvider(key).future)
        .then((v) => others = v),
  );
  for (var i = 0; i < 400 && others == null; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 16));
  }
  await pumpRoute(
    tester,
    save,
    '${Routes.match}?careerId=${save.careerId}',
    size: size,
  );
  for (
    var i = 0;
    i < 200 &&
        (tester.state(find.byType(MatchScreen)) as MatchScreenProbe)
                .pitchMode
                .playback ==
            null;
    i++
  ) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 16));
  }
  return (save, others!);
}

MatchScreenProbe _probe(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

/// The texts of one other match's score column.
String _score(WidgetTester tester, int fixtureId) => tester
    .widgetList<Text>(
      find.descendant(
        of: find.byKey(MatchSummaryTab.otherScoreKey(fixtureId)),
        matching: find.byType(Text),
      ),
    )
    .map((t) => t.data)
    .join(' | ');

Future<void> _show(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(
    f,
    80,
    scrollable: find
        .descendant(
          of: find.byType(MatchSummaryTab),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pump();
}

void main() {
  for (final (form, size) in [
    (FormFactor.phone, kPhoneSize),
    (FormFactor.tablet, const Size(1180, 820)),
  ]) {
    testWidgets('${form.name}: live, then HT, then FT; no score card', (
      tester,
    ) async {
      final (_, others) = await _open(tester, form, size);
      expect(others, hasLength(2), reason: 'a qualifying group of six');
      final card = find.byKey(MatchSummaryTab.otherMatchesKey);
      await _show(tester, card);
      expect(card, findsOneWidget);
      // No score card on the Summary; the other matches tick along on our
      // clock, marked live.
      for (final s in others) {
        expect(
          _score(tester, s.fixture.id),
          matches(RegExp('^\\d+ - \\d+ \\| ${enL.matchSummaryLive}\$')),
        );
      }

      final screen = _probe(tester);
      final pb = screen.pitchMode.playback!;
      // A goal elsewhere comes up on its banner as our clock passes it (the
      // seeded day has first-half goals in both other matches).
      expect(
        others.any((s) => s.goalsBetween(0, 40).isNotEmpty),
        isTrue,
        reason: 'the seeded day has an early goal elsewhere',
      );
      screen.seekPitch(pb.halfTime * 40 ~/ 45);
      final banner = find.byKey(matchElsewhereBannerKey);
      for (var i = 0; i < 100 && banner.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(banner, findsOneWidget);

      // Our half time: theirs.
      final half = find.descendant(
        of: find.byType(HalfTimePrompt),
        matching: find.text(enL.matchContinue),
      );
      screen.seekPitch(pb.halfTime - const Duration(milliseconds: 100));
      for (var i = 0; i < 400 && half.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      // The interval keeps the screen to its panel: no goal elsewhere over
      // it.
      expect(find.byKey(matchElsewhereBannerKey), findsNothing);
      // The interval: their half-time score.
      await _show(tester, card);
      for (final s in others) {
        final ht = s.scoreAt(SameDayPhase.halfTime)!;
        expect(
          _score(tester, s.fixture.id),
          '${ht.home} - ${ht.away} | ${enL.matchSummaryHalfTimeMark}',
        );
      }
      // The second half: they tick along with ours again, never frozen at
      // the break.
      await tester.tap(half);
      await tester.pump(const Duration(milliseconds: 500));
      await _show(tester, card);
      for (final s in others) {
        expect(
          _score(tester, s.fixture.id),
          endsWith(' | ${enL.matchSummaryLive}'),
        );
      }

      // Our whistle: their results, and the order of the Summary.
      final cont = find.byWidgetPredicate(
        (w) => w is PrimaryButton && w.label == enL.matchContinue,
      );
      screen.seekPitch(pb.pacer.total - const Duration(milliseconds: 200));
      for (var i = 0; i < 400 && cont.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pump(const Duration(seconds: 3));
      await _show(tester, card);
      for (final s in others) {
        final ft = s.scoreAt(SameDayPhase.fullTime)!;
        expect(
          _score(tester, s.fixture.id),
          startsWith('${ft.home} - ${ft.away} | '),
        );
      }
      final list = find
          .descendant(
            of: find.byType(MatchSummaryTab),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.byKey(MatchSummaryTab.potmKey),
        -80,
        scrollable: list,
      );
      double top(Key k) => tester.getTopLeft(find.byKey(k)).dy;
      expect(
        top(MatchSummaryTab.potmKey),
        lessThan(top(MatchSummaryTab.otherMatchesKey)),
      );
      await _show(tester, find.byKey(MatchSummaryTab.stadiumKey));
      expect(
        top(MatchSummaryTab.otherMatchesKey),
        lessThan(top(MatchSummaryTab.stadiumKey)),
      );
      await _show(tester, find.byKey(MatchSummaryTab.headlineKey));
      expect(
        top(MatchSummaryTab.stadiumKey),
        lessThan(top(MatchSummaryTab.headlineKey)),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
