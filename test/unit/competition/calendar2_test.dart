import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/competition/window_plan.dart';

/// The calendar2 rhythm (release 1.1.2) as pure dates: what each event of a
/// cycle whose World Championship is in 2030 is dated.
void main() {
  const europe = Confederation.europe;
  const wc = 2030;

  group('Calendar2 dates for the cycle to 2030', () {
    test("Europe's two Nations Cups: autumn 2026 and autumn 2028", () {
      expect(
        Calendar2.nationsCupLeagueYear(wc, europe, 0, calendar2: true),
        2026,
      );
      expect(
        Calendar2.nationsCupLeagueYear(wc, europe, 1, calendar2: true),
        2028,
      );
      // North America and Africa keep their one cup in the old slot.
      for (final conf in [Confederation.northAmerica, Confederation.africa]) {
        expect(
          Calendar2.editionsOf(conf, calendar2: true),
          [Calendar2.firstEdition],
        );
        expect(
          Calendar2.nationsCupLeagueYear(wc, conf, 0, calendar2: true),
          2028,
        );
      }
      // A cycle without the mark: one cup, autumn 2028, as before.
      expect(Calendar2.editionsOf(europe, calendar2: false), [0]);
      expect(
        Calendar2.nationsCupLeagueYear(wc, europe, 0, calendar2: false),
        2028,
      );
      expect(
        Calendar2.nationsCupHonourYear(wc, europe, 0, calendar2: true),
        2026,
      );
      expect(
        Calendar2.nationsCupHonourYear(wc, europe, 1, calendar2: true),
        2028,
      );
    });

    test('Finals Fours on 4/5 and 8 June 2027 and 2029', () {
      final first = Calendar2.finalsFour(wc, europe, 0, calendar2: true)!;
      expect(first.semi1, DateTime(2027, 6, 4));
      expect(first.semi2, DateTime(2027, 6, 5));
      expect(first.finalDay, DateTime(2027, 6, 8));
      final second = Calendar2.finalsFour(wc, europe, 1, calendar2: true)!;
      expect(second.semi1, DateTime(2029, 6, 4));
      expect(second.semi2, DateTime(2029, 6, 5));
      expect(second.finalDay, DateTime(2029, 6, 8));
      // North America's keeps 18/21 June, and so does an unmarked cycle.
      expect(
        Calendar2.finalsFour(
          wc,
          Confederation.northAmerica,
          0,
          calendar2: true,
        ),
        isNull,
      );
      expect(Calendar2.finalsFour(wc, europe, 0, calendar2: false), isNull);
      // The second edition is drawn from July 2027, once the first is
      // crowned (January 2028 at the latest).
      expect(Calendar2.secondEditionDue(wc), DateTime(2027, 7));
      expect(Calendar2.secondEditionLatest(wc), DateTime(2028));
    });

    test('Euro qualifying March to November 2027, drawn by December 2026', () {
      final span = Calendar2.euroQualifying(wc);
      expect(span.start, DateTime(2027, 3));
      expect(span.deadline, DateTime(2027, 11, 30));
      expect(Calendar2.euroQualifyingDrawDue(wc), DateTime(2026, 12));
    });

    test('WC qualifying: CONMEBOL Sep 2028 to Nov 2029, the rest Mar to '
        'Nov 2029, drawn by December 2028', () {
      final sa = Calendar2.wcQualifying(wc, Confederation.southAmerica);
      expect(sa.start, DateTime(2028, 9));
      expect(sa.deadline, DateTime(2029, 11, 30));
      expect(sa.fillAll, isTrue);
      for (final conf in Confederation.values) {
        if (conf == Confederation.southAmerica) continue;
        final span = Calendar2.wcQualifying(wc, conf);
        expect(span.start, DateTime(2029, 3), reason: conf.name);
        expect(span.deadline, DateTime(2029, 11, 30), reason: conf.name);
      }
      expect(Calendar2.conmebolQualifyingDrawDue(wc), DateTime(2028, 7, 15));
      expect(Calendar2.wcQualifyingDrawDue(wc), DateTime(2028, 12));
    });

    test('the board grades the second edition, as the old slot', () {
      expect(Calendar2.gradedEdition(europe, calendar2: true), 1);
      expect(Calendar2.gradedEdition(europe, calendar2: false), 0);
      expect(
        Calendar2.gradedEdition(Confederation.northAmerica, calendar2: true),
        0,
      );
    });
  });

  group('groups that leave June free', () {
    final span = (
      start: DateTime(2027, 3),
      deadline: DateTime(2027, 11, 30),
      seed: 77,
      fillAll: false,
    );

    test('WindowPlan skips June when asked, and only then', () {
      final dates = WindowPlan.dates(span, 10, skipMonths: const {6})!;
      expect(dates, hasLength(10));
      expect(dates.where((d) => d.month == 6), isEmpty);
      expect(dates.every((d) => d.year == 2027 && d.month >= 3), isTrue);
      expect(
        WindowPlan.windowsOf(span).map((w) => w.month),
        [3, 6, 9, 10, 11],
      );
      expect(
        WindowPlan.windowsOf(span, skipMonths: const {6}).map((w) => w.month),
        [3, 9, 10, 11],
      );
    });

    test("a Finals Four side's group has no June match; the rest are "
        'exactly as without it', () {
      final nations = [
        for (var i = 1; i <= 30; i++)
          Nation(
            id: i,
            name: 'N$i',
            code: 'N$i',
            confederation: europe,
            ranking: i,
          ),
      ];
      const finalsFour = {1, 2, 3, 4};
      ScheduleGenerator gen() => const ScheduleGenerator();
      final plain = gen().generate(
        confederation: europe,
        nations: nations,
        rngSeed: 99,
        groupSize: 6,
        windows: span,
      );
      final free = gen().generate(
        confederation: europe,
        nations: nations,
        rngSeed: 99,
        groupSize: 6,
        windows: span,
        noJuneNationIds: finalsFour,
      );
      expect(free.groups.length, plain.groups.length);
      for (var g = 0; g < free.groups.length; g++) {
        final a = plain.groups[g];
        final b = free.groups[g];
        expect(b.nationIds, a.nationIds, reason: 'the draw is unchanged');
        if (b.nationIds.any(finalsFour.contains)) {
          expect(
            b.fixtures.where((f) => f.date.month == 6),
            isEmpty,
            reason: 'group ${b.name}',
          );
          expect(b.fixtures.length, a.fixtures.length);
        } else {
          expect(
            [for (final f in b.fixtures) (f.date, f.homeNationId)],
            [for (final f in a.fixtures) (f.date, f.homeNationId)],
            reason: 'group ${b.name} keeps its dates',
          );
        }
      }
    });
  });
}
