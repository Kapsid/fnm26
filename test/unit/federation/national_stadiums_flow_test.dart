import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

/// A mid-table European side with real cities: Norway (id 39), pinned by id
/// so a new starting ranking does not swap the estate under the test.
final Nation _nation = _nations.singleWhere((n) => n.id == 39);

typedef _World = ({ProviderContainer c, int careerId});

Future<_World> _world({int seed = 7}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: _nations, playerList: const []),
      ),
      countryCitiesProvider.overrideWith((ref) async => _cities),
    ],
  );
  addTearDown(c.dispose);
  addTearDown(db.close);
  await c.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await c
              .read(careerServiceProvider)
              .create(nationId: _nation.id, managerName: 'M', rngSeed: seed))
          .valueOrNull!;
  return (c: c, careerId: career.id);
}

Future<int> _budget(_World w) async =>
    (await w.c.read(careerRepositoryProvider).byId(w.careerId))!.budget;

Future<void> _setBudget(_World w, int euros) =>
    w.c.read(careerRepositoryProvider).setBudget(w.careerId, euros);

Future<NationalStadiumsView> _view(_World w) async {
  w.c.invalidate(nationalStadiumsViewProvider(w.careerId));
  // The type steers `.future`'s inference, which otherwise fails.
  // ignore: omit_local_variable_types
  final NationalStadiumsView? v = await w.c.read(
    nationalStadiumsViewProvider(w.careerId).future,
  );
  return v!;
}

Future<List<Venue>> _grounds(_World w) async {
  final arg = (careerId: w.careerId, nationId: _nation.id);
  w.c.invalidate(nationStadiumsProvider(arg));
  return w.c.read(nationStadiumsProvider(arg).future);
}

/// Records a World Championship final in the career's current cycle, so the
/// cycle is finished and may roll.
Future<void> _finishCycle(_World w) async {
  final comp = w.c.read(competitionRepositoryProvider);
  final cycle =
      (await w.c.read(careerRepositoryProvider).byId(w.careerId))!.cyclePointer;
  await comp.createKnockout(
    careerId: w.careerId,
    cycle: cycle,
    confederation: Confederation.europe,
    kind: CompetitionKind.worldCupFinals,
    name: 'World Championship',
    pairings: [(26, 1)],
    date: DateTime(CareerService.worldCupYear(cycle), 7, 19),
    firstRound: 'FINAL',
  );
  final fin = await comp.fixturesByRound(w.careerId, 'FINAL');
  await comp.recordResult(
    fixtureId: fin.last.id,
    homeScore: 1,
    awayScore: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a save that never touched a stadium: the static grounds at their '
      'true levels, a small income already, no reputation', () async {
    final w = await _world();
    expect(
      await _grounds(w),
      VenueGenerator.forHost(
        hostId: _nation.id,
        cities: _cities[_nation.id],
        count: 16,
      ),
    );
    final v = await _view(w);
    expect(v.income, NationalStadiums.incomeOf(v.stadiums, _nation.id));
    expect(v.income, greaterThan(0));
    expect(v.reputation, 0);
    expect(v.window, isTrue);
    expect(v.stadiums, hasLength(NationalStadiums.setSize));
    for (final s in v.stadiums) {
      expect(s.built, isFalse);
      expect(s.capacity, s.baseCapacity);
      expect(s.level, StadiumLevels.levelOf(s.capacity));
    }
    expect(
      await w.c
          .read(nationalStadiumServiceProvider)
          .incomeAt(w.careerId, _nation.id, 1),
      v.income,
    );
  });

  test('an upgrade is charged once, lifts the seats into the next level, '
      'the income and the bid size, and is one work a cycle', () async {
    final w = await _world();
    await _setBudget(w, 20000000);
    final service = w.c.read(nationalStadiumServiceProvider);
    final first = (await _view(w)).stadiums[2];
    final cost = NationalStadiums.enlargeCost(first.capacity)!;
    final sizeBefore = HostBidOdds.sizeScore(await _grounds(w));
    final incomeBefore = (await _view(w)).income;

    // A double tap: two calls at once, one charge.
    final results = await Future.wait([
      service.upgrade(w.careerId, first.ref),
      service.upgrade(w.careerId, first.ref),
    ]);
    expect(results.where((r) => r), hasLength(1));
    expect(await _budget(w), 20000000 - cost);

    final v = await _view(w);
    final up = v.stadiums.firstWhere((s) => s.ref == first.ref);
    expect(up.capacity, StadiumLevels.enlargedTo(first.capacity));
    expect(up.level, first.level + 1);
    expect(v.upgradeBlock(up), StadiumBlock.doneThisCycle);
    expect(v.downsizeBlock(up), StadiumBlock.doneThisCycle);
    // Reputation counts from the next cycle start.
    expect(v.reputation, 0);
    expect(v.income, greaterThan(incomeBefore));
    expect(
      (await _grounds(w)).any((g) => g.capacity == up.capacity),
      isTrue,
    );
    expect(HostBidOdds.sizeScore(await _grounds(w)), greaterThan(sizeBefore));

    // Not a second work this cycle.
    expect(await service.upgrade(w.careerId, first.ref), isFalse);
    expect(await service.downsize(w.careerId, first.ref), isFalse);
    expect(await _budget(w), 20000000 - cost);
  });

  test('a downsize: fewer seats, a lower level, nothing charged or '
      'refunded, and never below level 1', () async {
    final w = await _world();
    await _setBudget(w, 5000000);
    final service = w.c.read(nationalStadiumServiceProvider);
    final v0 = await _view(w);
    final big = v0.stadiums.first;
    expect(big.level, greaterThan(1));
    expect(await service.downsize(w.careerId, big.ref), isTrue);
    expect(await _budget(w), 5000000);
    final v = await _view(w);
    final down = v.stadiums.firstWhere((s) => s.ref == big.ref);
    expect(down.capacity, StadiumLevels.downsizedTo(big.capacity));
    expect(down.level, big.level - 1);
    expect(down.upgrades, 0);
    // A level-1 ground cannot shrink further.
    const tiny = NationalStadium(
      city: 'X',
      name: 'X Park',
      baseCapacity: 5000,
    );
    expect(v.downsizeBlock(tiny), StadiumBlock.bottomLevel);
  });

  test('never past the free funds, and never once the budget is set', () async {
    final w = await _world();
    final service = w.c.read(nationalStadiumServiceProvider);
    final first = (await _view(w)).stadiums.first;
    final cost = NationalStadiums.enlargeCost(first.capacity) ?? 0;
    await _setBudget(w, cost - 1);
    expect(await service.upgrade(w.careerId, first.ref), isFalse);
    expect(await _budget(w), cost - 1);

    await _setBudget(w, 50000000);
    final career = (await w.c
        .read(careerRepositoryProvider)
        .byId(
          w.careerId,
        ))!;
    await w.c
        .read(competitionRepositoryProvider)
        .markDrawWatched(w.careerId, career.cyclePointer, budgetSetupKind);
    final v = await _view(w);
    expect(v.window, isFalse);
    expect(v.upgradeBlock(v.stadiums.first), StadiumBlock.closed);
    expect(await service.upgrade(w.careerId, first.ref), isFalse);
    expect(await service.build(w.careerId, v.cities.first), isFalse);
    expect(await _budget(w), 50000000);
  });

  test('a new stadium: chosen city, charged once, opens next cycle, then '
      'pays at the rollover and survives it', () async {
    final w = await _world();
    await _setBudget(w, 60000000);
    final service = w.c.read(nationalStadiumServiceProvider);
    var v = await _view(w);
    final city = v.cities.last;
    final cost = v.buildCost;
    final first = v.stadiums[2];
    final upCost = NationalStadiums.enlargeCost(first.capacity)!;

    expect(await service.build(w.careerId, city), isTrue);
    expect(await service.build(w.careerId, city), isFalse);
    expect(await service.upgrade(w.careerId, first.ref), isTrue);
    final paid = 60000000 - cost - upCost;
    expect(await _budget(w), paid);

    v = await _view(w);
    final built = v.stadiums.singleWhere((s) => s.built);
    expect(built.city, city);
    expect(v.upgradeBlock(built), StadiumBlock.underConstruction);
    expect(v.buildBlock, StadiumBlock.underConstruction);
    expect(v.cities, isNot(contains(city)));
    // Not a ground yet, and pays nothing yet.
    expect(
      (await _grounds(w)).any((g) => g.city == city && g.stadium == built.name),
      isFalse,
    );
    // The income at the next cycle start counts it: it opens then.
    final expected = NationalStadiums.incomeOf(
      NationalStadiums.openIn(v.stadiums, 1),
      _nation.id,
    );
    expect(v.income, expected);
    expect(
      expected,
      greaterThan(
        NationalStadiums.incomeOf(
          NationalStadiums.openIn(v.stadiums, 0),
          _nation.id,
        ),
      ),
    );

    // The reputation the board reads at the end of the cycle.
    await _finishCycle(w);
    final verdict = await w.c.read(rolloverVerdictProvider(w.careerId).future);
    expect(verdict, isNotNull);

    // What the rollover banks besides the stadiums, worked out the way the
    // rollover does, so the stadium income is all that is left to find.
    final closing = (await w.c
        .read(careerRepositoryProvider)
        .byId(
          w.careerId,
        ))!;
    final income = await w.c
        .read(federationServiceProvider)
        .incomeForCycle(w.careerId, 0);
    final banked =
        closing.budget +
        ((income.grant + income.prize + income.commercial) *
                ManagerSkills.incomeBonus(closing.skillNegotiation))
            .round() -
        Staff.totalCost({
          StaffRole.assistant: closing.staffAssistant,
          StaffRole.scout: closing.staffScout,
          StaffRole.fitnessCoach: closing.staffFitnessCoach,
        });
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    final career = (await w.c
        .read(careerRepositoryProvider)
        .byId(
          w.careerId,
        ))!;
    expect(career.cyclePointer, 1);
    expect(
      await w.c
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(w.careerId, 1, stadiumIncomeKind(1, expected)),
      isTrue,
    );
    expect(career.budget, banked + expected);

    // The works survive the rollover: the new stadium stands, the upgrade
    // holds, and a new cycle opens a new window.
    v = await _view(w);
    expect(v.window, isTrue);
    expect(v.stadiums.singleWhere((s) => s.built).openIn(1), isTrue);
    expect(
      v.stadiums.firstWhere((s) => s.ref == first.ref).capacity,
      StadiumLevels.enlargedTo(first.capacity),
    );
    expect(
      (await _grounds(w)).any((g) => g.stadium == built.name),
      isTrue,
    );
    expect(v.reputation, 1 + NationalStadiums.builtPoints);

    // A rollover killed after it banked and before the cycle pointer moved is
    // retried from the top: put the pointer back and roll again. Nothing is
    // banked twice, the stadium income included.
    final paidOnce = career.budget;
    await w.c
        .read(careerRepositoryProvider)
        .advanceCycle(w.careerId, 0, closing.inGameDate);
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    final retried = (await w.c
        .read(careerRepositoryProvider)
        .byId(
          w.careerId,
        ))!;
    expect(retried.cyclePointer, 1);
    expect(retried.budget, paidOnce);
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('two builds ordered together: only the first stands, '
      'and only it is charged', () async {
    final w = await _world();
    await _setBudget(w, 200000000);
    final service = w.c.read(nationalStadiumServiceProvider);
    final v = await _view(w);
    final results = await Future.wait([
      service.build(w.careerId, v.cities[0]),
      service.build(w.careerId, v.cities[1]),
    ]);
    expect(results.where((r) => r), hasLength(1));
    expect(await _budget(w), 200000000 - v.buildCost);
    expect((await _view(w)).stadiums.where((s) => s.built), hasLength(1));
  });

  test('the career reputation the board reads counts a work from the next '
      'cycle start, not the moment it is ordered', () async {
    final w = await _world();
    final repo = w.c.read(careerRepositoryProvider);
    final comp = w.c.read(competitionRepositoryProvider);
    final opened = (await repo.byId(w.careerId))!;
    await repo.advanceCycle(w.careerId, 1, opened.inGameDate);
    await _finishCycle(w);
    Future<int> rep() async {
      w.c.invalidate(rolloverVerdictProvider(w.careerId));
      return (await w.c.read(
        rolloverVerdictProvider(w.careerId).future,
      ))!.reputation;
    }

    final before = await rep();
    final city = (await _view(w)).stadiums.first.city;
    // Ordered in the cycle being judged: nothing yet.
    await comp.markDrawWatched(
      w.careerId,
      1,
      StadiumWork.resize(
        nationId: _nation.id,
        cycle: 1,
        stadium: (city: city, built: false),
        seats: 64000,
        enlarge: true,
      ).encode(),
    );
    expect(await rep(), before);
    // Paid for in an earlier cycle: it counts.
    await comp.markDrawWatched(
      w.careerId,
      0,
      StadiumWork.build(nationId: _nation.id, cycle: 0, city: city).encode(),
    );
    expect(await rep(), before + NationalStadiums.builtPoints);
  });

  test('a finals the career\'s nation hosts is staged in its live estate; '
      'other hosts and an untouched estate keep the static grounds', () async {
    final w = await _world();
    Future<Map<int, List<Venue>>> estates(List<int> hosts) => w.c.read(
      FutureProvider<Map<int, List<Venue>>>(
        (ref) => hostEstatesFor(ref, w.careerId, hosts),
      ).future,
    );
    final other = _nations.firstWhere((n) => n.id != _nation.id).id;
    // No works yet: nothing to replace.
    expect(await estates([_nation.id, other]), isEmpty);

    await _setBudget(w, 60000000);
    final service = w.c.read(nationalStadiumServiceProvider);
    final v = await _view(w);
    final target = v.stadiums[2];
    expect(await service.upgrade(w.careerId, target.ref), isTrue);

    final live = await estates([other, _nation.id]);
    expect(live.keys, [_nation.id], reason: 'only the career nation');
    final grounds = live[_nation.id]!;
    final enlarged = grounds.singleWhere(
      (g) => g.city == target.city && g.stadium == target.name,
    );
    expect(enlarged.capacity, greaterThan(target.capacity));
    // Biggest first, and exactly what home games read.
    expect(grounds, await _grounds(w));
    // The venues card takes them in place of the static grounds.
    final card = VenueGenerator.forHosts(
      hostIds: [_nation.id],
      citiesByHost: _cities,
      count: 8,
      estates: live,
    );
    expect(card[_nation.id], grounds.take(8).toList());
    // A tournament the nation does not host is not touched.
    expect(await estates([other]), isEmpty);
  });

  group('naming a new stadium', () {
    Future<List<StadiumName>> names(_World w) =>
        stadiumNames(w.c.read(competitionRepositoryProvider), w.careerId);

    test(
      'the name given at the order stands, a rename replaces it, a blank '
      'one goes back to the generated name; seed grounds keep theirs',
      () async {
        final w = await _world();
        await _setBudget(w, 60000000);
        final service = w.c.read(nationalStadiumServiceProvider);
        var v = await _view(w);
        final city = v.cities.last;
        expect(
          await service.build(w.careerId, city, name: '  東京 新国立\n競技場  '),
          isTrue,
        );
        NationalStadium built() => v.stadiums.singleWhere((s) => s.built);
        v = await _view(w);
        expect(built().name, '東京 新国立 競技場');

        expect(await service.rename(w.careerId, city, 'Arena: Ünité'), isTrue);
        v = await _view(w);
        expect(built().name, 'Arena: Ünité');
        // A name that comes back still wins over the one before it.
        expect(await service.rename(w.careerId, city, '東京 新国立 競技場'), isTrue);
        v = await _view(w);
        expect(built().name, '東京 新国立 競技場');
        // The same name again writes nothing.
        final count = (await names(w)).length;
        expect(await service.rename(w.careerId, city, '東京 新国立 競技場'), isTrue);
        expect(await names(w), hasLength(count));

        expect(await service.rename(w.careerId, city, '   '), isTrue);
        v = await _view(w);
        expect(built().name, NationalStadiums.newStadiumName(city));

        // A seed ground cannot be renamed.
        final seed = v.stadiums.first;
        expect(seed.built, isFalse);
        expect(await service.rename(w.careerId, seed.city, 'Mine'), isFalse);
        v = await _view(w);
        expect(v.stadiums.first.name, seed.name);
      },
    );

    test('a blank name keeps the generated one; a refused order leaves no '
        'name behind', () async {
      final w = await _world();
      final service = w.c.read(nationalStadiumServiceProvider);
      final city = (await _view(w)).cities.last;
      // Not enough money: refused, and nothing named.
      await _setBudget(w, 1000000);
      expect(await service.build(w.careerId, city, name: 'Nope'), isFalse);
      expect(await names(w), isEmpty);
      // The suggestion as it stood, or blank: nothing stored.
      await _setBudget(w, 60000000);
      expect(
        await service.build(
          w.careerId,
          city,
          name: NationalStadiums.newStadiumName(city),
        ),
        isTrue,
      );
      expect(await names(w), isEmpty);
      final v = await _view(w);
      expect(
        v.stadiums.singleWhere((s) => s.built).name,
        NationalStadiums.newStadiumName(city),
      );
    });

    test(
      'once open, the finals venues and the match ground read the name',
      () async {
        final w = await _world();
        await _setBudget(w, 60000000);
        final service = w.c.read(nationalStadiumServiceProvider);
        final city = (await _view(w)).cities.last;
        expect(
          await service.build(w.careerId, city, name: 'Estadio Ñandú'),
          isTrue,
        );
        await w.c
            .read(careerRepositoryProvider)
            .advanceCycle(w.careerId, 1, DateTime(2027, 8));
        final estates = await w.c.read(
          FutureProvider<Map<int, List<Venue>>>(
            (ref) => hostEstatesFor(ref, w.careerId, [_nation.id]),
          ).future,
        );
        final venue = estates[_nation.id]!.singleWhere(
          (g) =>
              g.capacity == NationalStadiums.newCapacity(_nation.id) &&
              g.city == city,
        );
        expect(venue.stadium, 'Estadio Ñandú');
        expect(
          estates[_nation.id]!.map((g) => g.stadium),
          isNot(contains(NationalStadiums.newStadiumName(city))),
        );
        // The bid's ground list reads the same estate.
        expect(
          (await _grounds(w)).any((g) => g.stadium == 'Estadio Ñandú'),
          isTrue,
        );
        // A finals tie the career's nation hosts lands there under that name,
        // which is what the ground card and the crowd read.
        MatchGround? there;
        for (var id = 1; id <= 200 && there == null; id++) {
          final g = Attendance.forFixture(
            fixture: Fixture(
              id: id,
              careerId: w.careerId,
              competitionId: 1,
              matchday: 1,
              date: DateTime(2028, 6, 20),
              homeNationId: _nation.id == 1 ? 2 : 1,
              awayNationId: _nation.id == 3 ? 4 : 3,
              round: 'GROUP',
            ),
            neutral: true,
            tournamentHostIds: [_nation.id],
            citiesByNation: _cities,
            seed: 7,
            hostEstates: estates,
          );
          if (g.stadium == 'Estadio Ñandú') there = g;
        }
        expect(there, isNotNull);
        expect(there!.city, city);
        expect(there.capacity, venue.capacity);
      },
    );

    test('a career bundle carries the name', () async {
      final w = await _world();
      await _setBudget(w, 60000000);
      final service = w.c.read(nationalStadiumServiceProvider);
      final city = (await _view(w)).cities.last;
      expect(await service.build(w.careerId, city, name: 'Ναός'), isTrue);
      expect(await service.rename(w.careerId, city, 'Νέος Ναός'), isTrue);
      final db = w.c.read(appDatabaseProvider);
      final bundle = CareerBundle.decode(
        CareerBundle.encode(await CareerBundle.export(db, w.careerId)),
      ).bundle!;
      final imported = await CareerBundle.import(db, bundle);
      expect(imported, isNot(w.careerId));
      final v = await _view((c: w.c, careerId: imported));
      expect(v.stadiums.singleWhere((s) => s.built).name, 'Νέος Ναός');
    });
  });
}
