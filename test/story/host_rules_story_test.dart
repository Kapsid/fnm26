import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../helpers/save_fixtures.dart';
import 'driver.dart';

const int _czechia = 12;

/// One edition as its cup screen shows it.
typedef _Shown = ({
  String label,
  HostBar bar,
  List<int> hostIds,
  Map<int, List<String>> hostCities,
  Map<int, List<Venue>> hostEstates,
  VenueRules venueRules,
  HostGroundPlan? groundPlan,
  int teamCount,
});

/// The host stadium rules end to end: real careers under the bars, played
/// through the hub across two rollovers, seeds 1 to 10, Czechia (whose
/// grounds miss the EURO's bar).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  Future<T> read<T>(
    ProviderContainer c,
    AutoDisposeFutureProvider<T> p,
  ) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  /// The editions of the current cycle as the cup screens show them.
  Future<List<_Shown>> shown(ProviderContainer c, int careerId) async {
    final wc = (await read(c, cupDetailProvider(careerId)))!;
    return [
      (
        label: 'wc',
        bar: HostStadiumRules.worldChampionship,
        hostIds: wc.hostIds,
        hostCities: wc.hostCities,
        hostEstates: wc.hostEstates,
        venueRules: wc.venueRules,
        groundPlan: wc.groundPlan,
        teamCount:
            QualificationFormat.totalFinalsBerths +
            QualificationFormat.playoffBerths,
      ),
      for (final conf in Confederation.values)
        if (ContinentalCups.byConfederation[conf] case final cup?)
          if (await read(
                c,
                continentalDetailProvider((
                  careerId: careerId,
                  confederation: conf,
                )),
              )
              case final data?)
            (
              label: cup.name,
              bar: HostStadiumRules.continental(conf),
              hostIds: data.hostIds,
              hostCities: data.hostCities,
              hostEstates: data.hostEstates,
              venueRules: data.venueRules,
              groundPlan: data.groundPlan,
              teamCount: cup.size,
            ),
    ];
  }

  /// Checks the played cycle's editions on their cup screens, and the
  /// player's bids at the rollover. Returns how many short bids it saw.
  Future<int> checkAtRollover(
    ProviderContainer c,
    int careerId,
    String why,
  ) async {
    final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
    final cycle = career.cyclePointer;
    final nations = await c.read(nationRepositoryProvider).forCareer(careerId);
    expect(WorldCupHosts.isV2(cycle, nations), isTrue, reason: why);

    var editions = 0;
    for (final e in await shown(c, careerId)) {
      final w = '$why cycle $cycle ${e.label} hosts ${e.hostIds}';
      if (e.hostIds.isEmpty) continue;
      editions++;
      final plan = e.groundPlan;
      expect(plan, isNotNull, reason: '$w: decided under the bars');
      // Decided at or above the bar: the hosts' own qualifying grounds plus
      // the grounds promised for it.
      final seats = [
        for (final h in e.hostIds)
          ...HostStadiumRules.qualifyingSeats(nationId: h, editionCycle: cycle),
        for (final p in plan!.promised.values) ...p,
      ];
      expect(HostStadiumRules.meets(seats, e.bar), isTrue, reason: w);

      // Every ground the cup screen lists is at least the bar.
      final byHost = VenueGenerator.forHosts(
        hostIds: e.hostIds,
        citiesByHost: e.hostCities,
        count: VenueGenerator.countForField(e.teamCount),
        estates: e.hostEstates,
        rules: e.venueRules,
        qualifyingOnly: true,
        minSeats: plan.minSeats,
        planned: plan.planned,
      );
      final grounds = [for (final v in byHost.values) ...v];
      expect(grounds, isNotEmpty, reason: w);
      for (final v in grounds) {
        expect(
          v.capacity,
          greaterThanOrEqualTo(e.bar.otherSeats),
          reason: '$w: ${v.stadium}, ${v.city}',
        );
      }
      final broken = plan.promised.entries.any(
        (p) => (plan.planned[p.key]?.length ?? 0) < p.value.length,
      );
      if (!broken) {
        expect(
          HostStadiumRules.meets([for (final v in grounds) v.capacity], e.bar),
          isTrue,
          reason: '$w: the grounds shown reach the bar',
        );
      }
    }
    expect(editions, greaterThan(1), reason: '$why cycle $cycle: not vacuous');

    // The player's bids for the next cycle's editions: a nation short of the
    // bar is told so and gets no offer.
    c
      ..invalidate(hostBidStatusProvider)
      ..invalidate(hostBidOffersProvider);
    final statuses = await read(
      c,
      hostBidStatusProvider((careerId: careerId, nationId: null)),
    );
    final offers = await read(
      c,
      hostBidOffersProvider((careerId: careerId, nationId: null)),
    );
    var short = 0;
    for (final s in statuses) {
      final w = '$why ${s.comp.name} ${s.editionCycle} ${s.nation.name}';
      final bar = HostStadiumRules.of(s.comp, s.nation.confederation);
      final meets = HostStadiumRules.meets(
        HostStadiumRules.qualifyingSeats(
          nationId: s.nation.id,
          editionCycle: s.editionCycle,
        ),
        bar,
      );
      expect(s.belowBar, !meets, reason: w);
      if (s.belowBar) {
        short++;
        expect(s.eligible, isFalse, reason: w);
        expect(s.offer, isNull, reason: w);
        expect(offers.where((o) => o.comp == s.comp), isEmpty, reason: w);
      }
    }
    return short;
  }

  for (var seed = 1; seed <= 10; seed++) {
    test(
      'seed $seed: two rollovers, every v2 edition at its bar',
      () async {
        final db = storyDb();
        final c = storyContainer(db, 0);
        addTearDown(() async {
          c.dispose();
          await db.close();
        });
        final d = await StoryDriver.start(c, seed, nationId: _czechia);
        final comp = c.read(competitionRepositoryProvider);
        for (var cycle = 0; cycle < 2; cycle++) {
          while (await d.step(stopAtRollover: true)) {}
          expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
          // Czechia's grounds miss the World Championship's bar: its card
          // shows the bar and offers no bid.
          expect(
            await checkAtRollover(c, d.careerId, 'seed $seed'),
            greaterThan(0),
            reason: 'seed $seed cycle $cycle: a short bid turned up',
          );
          await d.step();
          final career = (await c
              .read(careerRepositoryProvider)
              .byId(
                d.careerId,
              ))!;
          expect(career.cyclePointer, cycle + 1);
          // The new cycle and the one it decides are under the bars too.
          expect(
            await comp.hasWatchedDraw(
              d.careerId,
              cycle + 1,
              HostBidding.rules2Kind(cycle + 1),
            ),
            isTrue,
            reason: 'seed $seed cycle ${cycle + 1}',
          );
        }
        // Cycle 2's editions are decided but not yet drawn: no screen shows
        // them, so check the decision itself.
        final nations = await c
            .read(nationRepositoryProvider)
            .forCareer(d.careerId);
        final seedNo =
            (await c
                    .read(careerRepositoryProvider)
                    .byId(
                      d.careerId,
                    ))!
                .rngSeed;
        final year = CareerService.worldCupYear(2);
        final wcHosts = WorldCupHosts.hostsFor(
          year: year,
          nations: nations,
          seed: seedNo,
        );
        final wcPlan = WorldCupHosts.worldCupGroundPlan(
          year: year,
          nations: nations,
          seed: seedNo,
        );
        expect(wcPlan, isNotNull);
        expect(
          HostStadiumRules.meets([
            for (final h in wcHosts)
              ...HostStadiumRules.qualifyingSeats(nationId: h, editionCycle: 2),
            for (final p in wcPlan!.promised.values) ...p,
          ], HostStadiumRules.worldChampionship),
          isTrue,
          reason: 'seed $seed cycle 2 wc $wcHosts',
        );
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  }

  test(
    "cycle 0's hosts and venues equal a pre-feature run of the same seed "
    'when the career starts without the bars',
    () async {
      final m = readManifest('pre55', 'late_cycle');
      final db = storyDb();
      final c = storyContainer(db, 0);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final d = await StoryDriver.start(
        c,
        777,
        nationId: _czechia,
        stadiumHostRules: false,
      );
      final now = await computeManifest(c, d.careerId);
      expect(m.hosts, isNotEmpty);
      for (final k in m.hosts.keys) {
        expect(now.hosts[k], m.hosts[k], reason: 'hosts $k');
        expect(now.venues[k], m.venues[k], reason: 'venues $k');
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
