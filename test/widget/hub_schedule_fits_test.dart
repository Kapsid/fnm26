import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:fnm/features/hub/schedule_widgets.dart';

import '../helpers/seeded_save.dart';

/// The schedule rows, on the hub's Upcoming card, the tablet's next-match
/// panel and the Schedule screen, at phone widths and in the longer
/// languages.
///
/// The owner saw the hub's schedule text overflow on every device. The
/// seeded save's own window is the everyday case; the rows below it are the
/// worst ones a cycle can produce: a finals tie settled on penalties (score
/// plus "pens" under it), a continental final (the longest stage label), a
/// qualifier against the nation with the longest name, and the pending line.
const _widths = [320.0, 360.0, 400.0];
const _locales = ['en', 'cs', 'de', 'pt', 'el', 'ja', 'ko', 'ro', 'th', 'ms'];

/// The first id of the worst-case rows, far above any seeded fixture.
const _worstId = 900000;

/// The seeded schedule with the worst-case rows added to its current block.
Override _worstCase() => scheduleProvider(kSeededCareerId).overrideWith((
  ref,
) async {
  final hub = (await ref.watch(hubDataProvider(kSeededCareerId).future))!;
  final comp = ref.watch(competitionRepositoryProvider);
  final me = hub.career.nationId;
  final blocks = MatchSchedule.blocks(
    await comp.cycleFixturesForNation(kSeededCareerId, me),
    nationId: me,
  );
  final watched = await watchedFixtureDraws(
    comp,
    kSeededCareerId,
    hub.career.cyclePointer,
  );
  final cur = MatchSchedule.currentIndex(blocks);
  final longest = hub.nations.values
      .where((n) => n.id != me)
      .reduce((a, b) => a.name.length >= b.name.length ? a : b);
  final base = blocks[cur].fixtures.first;
  // A qualifier is never extended; a knockout goes to extra time, the final
  // all the way to penalties.
  Fixture extra(
    int id,
    String? round, {
    bool played = true,
    bool knockout = false,
    bool shootout = false,
  }) => Fixture(
    id: _worstId + id,
    careerId: kSeededCareerId,
    competitionId: base.competitionId,
    matchday: 10,
    date: base.date.add(Duration(days: id)),
    homeNationId: id.isEven ? me : longest.id,
    awayNationId: id.isEven ? longest.id : me,
    round: round,
    played: played,
    homeScore: played ? 10 : null,
    awayScore: played ? (knockout ? 10 : 9) : null,
    afterExtraTime: played && knockout,
    homePenalties: played && shootout ? 10 : null,
    awayPenalties: played && shootout ? 9 : null,
  );
  final extras = [
    extra(1, 'CFINAL', knockout: true),
    extra(2, 'FINAL', knockout: true, shootout: true),
    extra(3, 'CQ'),
    extra(4, null),
    extra(5, 'NFINAL', played: false),
    extra(6, '3RD', played: false),
  ];
  return (
    nationId: me,
    blocks: <ScheduleBlock>[
      for (var i = 0; i < blocks.length; i++)
        if (i == cur)
          (
            year: blocks[i].year,
            month: blocks[i].month,
            fixtures: [...blocks[i].fixtures, ...extras],
            pending: (knockoutStage: true, from: DateTime(2030, 9, 30)),
          )
        else
          blocks[i],
    ],
    currentIndex: cur,
    nations: hub.nations,
    watchedDrawKinds: {
      ...watched,
      for (final f in extras) ?drawKindForFixture(f),
    },
  );
});

/// Fails on anything inside a schedule row that ran out of room.
///
/// The date, H/A, score and pending date are set on one line and must stay
/// there. The opponent and the stage may take two lines; on the seeded
/// save's own rows (the everyday qualifier) and the pending line they must
/// then be printed WHOLE. The worst-case rows ([_worstId] and up) may end in
/// an ellipsis on their second line at the narrowest widths, which is the
/// clean way for them to give up, but never overflow or break the one-line
/// pieces.
void _expectRowsFit(WidgetTester tester, String where) {
  final rows = find.byWidgetPredicate(
    (w) => w is ScheduleFixtureRow || w is SchedulePendingRow,
  );
  expect(rows, findsWidgets, reason: 'no schedule rows on $where');
  for (final row in rows.evaluate()) {
    final w = row.widget;
    final worst = w is ScheduleFixtureRow && w.fixture.id >= _worstId;
    for (final element
        in find
            .descendant(of: find.byWidget(w), matching: find.byType(RichText))
            .evaluate()) {
      final p = element.renderObject! as RenderParagraph;
      final text = p.text.toPlainText();
      final wanted = p.getMaxIntrinsicWidth(double.infinity);
      if (p.maxLines == 1) {
        final line = p.getFullHeightForCaret(const TextPosition(offset: 0));
        expect(
          p.size.height < line * 1.5 && !p.didExceedMaxLines,
          isTrue,
          reason:
              'on $where "$text" left its one line: wants ${wanted}px, '
              'given ${p.size.width}px',
        );
      } else if (!worst) {
        expect(
          p.didExceedMaxLines,
          isFalse,
          reason:
              'on $where "$text" is cut: wants ${wanted}px, given '
              '${p.size.width}px',
        );
      }
    }
  }
}

Future<void> _pumpHub(
  WidgetTester tester, {
  required Size size,
  required String locale,
  FormFactor formFactor = FormFactor.phone,
  String route = Routes.hub,
}) async {
  final save = await seedSave(
    tester,
    formFactor: formFactor,
    overrides: [_worstCase()],
  );
  await watchContinentalQualifyingDraw(tester, save);
  await pumpRoute(
    tester,
    save,
    '$route?careerId=${save.careerId}',
    size: size,
    locale: Locale(locale),
  );
  expect(tester.takeException(), isNull, reason: 'a RenderFlex overflowed');
}

void main() {
  for (final width in _widths) {
    for (final locale in _locales) {
      testWidgets('the hub Upcoming card fits $width in $locale', (
        tester,
      ) async {
        await _pumpHub(tester, size: Size(width, 2400), locale: locale);
        _expectRowsFit(tester, 'the hub at $width in $locale');
      });

      testWidgets('the Schedule screen fits $width in $locale', (
        tester,
      ) async {
        await _pumpHub(
          tester,
          size: Size(width, 2400),
          locale: locale,
          route: Routes.schedule,
        );
        _expectRowsFit(tester, 'the schedule at $width in $locale');
      });
    }
  }

  for (final locale in _locales) {
    testWidgets('the tablet next-match panel fits in $locale', (tester) async {
      await _pumpHub(
        tester,
        size: kTabletSize,
        locale: locale,
        formFactor: FormFactor.tablet,
      );
      expect(find.byKey(HubScreen.nextMatchPanelKey), findsOneWidget);
      _expectRowsFit(tester, 'the tablet panel in $locale');
      await tester.pumpWidget(const SizedBox());
    });
  }
}
