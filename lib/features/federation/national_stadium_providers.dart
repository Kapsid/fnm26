import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart'
    show budgetSetupKind;
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/host_bid_providers.dart'
    show
        hostBidOfferProvider,
        hostBidOffersProvider,
        hostBidStatusProvider,
        nationStadiumsProvider;
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

/// Every stadium work [careerId] has paid for, any nation.
Future<List<StadiumWork>> stadiumWorks(
  CompetitionRepository comp,
  int careerId,
) async => [
  for (final r in await comp.watchedKindsWithPrefix(
    NationalStadiums.markerPrefix,
  ))
    if (r.careerId == careerId) ?StadiumWork.decode(r.kind),
];

/// Every name [careerId] gave a stadium it built, any nation (see
/// [StadiumName]): the ONE read every place a built ground's name shows goes
/// through, by way of [NationalStadiums.forNation].
Future<List<StadiumName>> stadiumNames(
  CompetitionRepository comp,
  int careerId,
) async => [
  for (final r in await comp.watchedKindsWithPrefix(StadiumName.prefix))
    if (r.careerId == careerId) ?StadiumName.decode(r.kind),
];

/// The static grounds every career starts [nationId] with, biggest first: the
/// seed cities plus the extra host cities, capacities tapered from the
/// national stadium (see [VenueGenerator.forHost]).
List<Venue> seedStadiums(int nationId, Map<int, List<String>> cities) =>
    VenueGenerator.forHost(
      hostId: nationId,
      cities: cities[nationId],
      count: seedStadiumsListed,
    );

/// As many grounds as the biggest finals uses (sixteen, see
/// [VenueGenerator.countForField]).
const int seedStadiumsListed = 16;

/// [nationId]'s grounds standing in [careerId]'s current cycle (or
/// [atCycle]), biggest first: the seed grounds with the career's works, plus
/// any stadium it built that has opened. A nation nobody worked on gets
/// exactly the static grounds back.
Future<List<NationalStadium>> careerStadiumsFor(
  Ref ref,
  int careerId,
  int nationId, {
  int? atCycle,
}) async {
  final all = await _allStadiums(ref, careerId, nationId);
  final cycle =
      atCycle ??
      (await ref.read(careerRepositoryProvider).byId(careerId))?.cyclePointer ??
      0;
  return NationalStadiums.openIn(all, cycle);
}

/// The grounds a finals hosted by [careerId]'s own nation is staged in, as
/// [VenueGenerator.forHosts] takes them: that nation's estate standing in the
/// current cycle (built Arena Novas, enlarged and downsized grounds), keyed
/// by its id. Empty when the career's nation is not among [hostIds], or has
/// never had a stadium work, so every other host, and an untouched estate,
/// keeps exactly the static grounds. No venue is ever stored, so nothing
/// stored can change.
Future<Map<int, List<Venue>>> hostEstatesFor(
  Ref ref,
  int careerId,
  List<int> hostIds,
) async {
  if (hostIds.isEmpty) return const {};
  final career = await ref.read(careerRepositoryProvider).byId(careerId);
  if (career == null || !hostIds.contains(career.nationId)) return const {};
  final works = await stadiumWorks(
    ref.read(competitionRepositoryProvider),
    careerId,
  );
  if (!works.any((w) => w.nationId == career.nationId)) return const {};
  final grounds = await careerStadiumsFor(
    ref,
    careerId,
    career.nationId,
    atCycle: career.cyclePointer,
  );
  return {
    career.nationId: [for (final g in grounds) g.venue],
  };
}

/// Read with `ref.read`: a service calls these from inside its own
/// methods, and the screens invalidate them by hand after every work.
///
/// [nationId]'s national set (see [NationalStadiums.nationalSet]) standing in
/// [careerId]'s current cycle (or [atCycle]), biggest first: what its income
/// and its right to bid for a tournament are read from.
Future<List<NationalStadium>> nationalSetFor(
  Ref ref,
  int careerId,
  int nationId, {
  int? atCycle,
}) async {
  final all = await _allStadiums(ref, careerId, nationId);
  final cycle =
      atCycle ??
      (await ref.read(careerRepositoryProvider).byId(careerId))?.cyclePointer ??
      0;
  return NationalStadiums.openIn(NationalStadiums.nationalSet(all), cycle);
}

Future<List<NationalStadium>> _allStadiums(
  Ref ref,
  int careerId,
  int nationId,
) async {
  final cities = await ref.read(countryCitiesProvider.future);
  final comp = ref.read(competitionRepositoryProvider);
  final works = await stadiumWorks(comp, careerId);
  return NationalStadiums.forNation(
    nationId: nationId,
    seed: seedStadiums(nationId, cities),
    works: works,
    names: await stadiumNames(comp, careerId),
  );
}

/// The national-stadiums screen's read of one career.
class NationalStadiumsView {
  const NationalStadiumsView({
    required this.careerId,
    required this.nationId,
    required this.cycle,
    required this.stadiums,
    required this.cities,
    required this.window,
    required this.freeFunds,
    required this.income,
    required this.reputation,
    required this.resizedThisCycle,
    required this.building,
  });

  final int careerId;
  final int nationId;
  final int cycle;

  /// The national stadiums: the [NationalStadiums.setSize] biggest seed
  /// grounds and every stadium built (open or not), in that order.
  final List<NationalStadium> stadiums;

  /// The cities a new stadium can go in: the nation's cities that have not
  /// had one built yet.
  final List<String> cities;

  /// Whether works may be commissioned now: the opening of the cycle, before
  /// the budget is set.
  final bool window;

  /// Balance less the wages owed.
  final int freeFunds;

  /// What the current nation's stadiums earn at the next cycle start, every
  /// open ground counted (see [NationalStadiums.groundIncome]).
  final int income;

  /// The reputation the career's stadium works add now: those ordered
  /// before this cycle opened (see [NationalStadiums.reputationPoints]).
  final int reputation;

  /// Stadiums already resized this cycle (one work a cycle each).
  final Set<StadiumRef> resizedThisCycle;

  /// A stadium under construction (one at a time).
  final bool building;

  int get buildCost => NationalStadiums.buildCost(nationId);
  int get newCapacity => NationalStadiums.newCapacity(nationId);

  /// What [s] earns at the next cycle start.
  int incomeOf(NationalStadium s) => s.openIn(cycle + 1)
      ? NationalStadiums.groundIncome(seats: s.capacity, nationId: nationId)
      : 0;

  /// Why [s] cannot be enlarged now, or null when it can.
  StadiumBlock? upgradeBlock(NationalStadium s) {
    if (!s.openIn(cycle)) return StadiumBlock.underConstruction;
    final cost = NationalStadiums.enlargeCost(s.capacity);
    if (cost == null) return StadiumBlock.topLevel;
    if (resizedThisCycle.contains(s.ref)) return StadiumBlock.doneThisCycle;
    if (!window) return StadiumBlock.closed;
    if (freeFunds < cost) return StadiumBlock.funds;
    return null;
  }

  /// Why [s] cannot be downsized now, or null when it can.
  StadiumBlock? downsizeBlock(NationalStadium s) {
    if (!s.openIn(cycle)) return StadiumBlock.underConstruction;
    if (StadiumLevels.downsizedTo(s.capacity) == null) {
      return StadiumBlock.bottomLevel;
    }
    if (resizedThisCycle.contains(s.ref)) return StadiumBlock.doneThisCycle;
    if (!window) return StadiumBlock.closed;
    return null;
  }

  /// Why a new stadium cannot be ordered now, or null when it can.
  StadiumBlock? get buildBlock {
    if (building) return StadiumBlock.underConstruction;
    if (cities.isEmpty) return StadiumBlock.noCity;
    if (!window) return StadiumBlock.closed;
    if (freeFunds < buildCost) return StadiumBlock.funds;
    return null;
  }
}

/// Why a stadium work is not on offer.
enum StadiumBlock {
  underConstruction,
  topLevel,
  bottomLevel,
  doneThisCycle,
  closed,
  funds,
  noCity,
}

/// Reads [careerId]'s stadium state fresh, for the screen and (re-read) for
/// every charge.
Future<NationalStadiumsView?> _loadView(Ref ref, int careerId) async {
  final career = await ref.read(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.read(competitionRepositoryProvider);
  final cities = await ref.read(countryCitiesProvider.future);
  final works = await stadiumWorks(comp, careerId);
  final nationId = career.nationId;
  final cycle = career.cyclePointer;
  final all = NationalStadiums.forNation(
    nationId: nationId,
    seed: seedStadiums(nationId, cities),
    works: works,
    names: await stadiumNames(comp, careerId),
  );
  final set = NationalStadiums.nationalSet(all);
  final builtIn = {
    for (final s in all)
      if (s.built) s.city,
  };
  final cityPool = cities[nationId] ?? [for (final s in all) s.city];
  return NationalStadiumsView(
    careerId: careerId,
    nationId: nationId,
    cycle: cycle,
    stadiums: set,
    cities: [
      for (final c in cityPool)
        if (!builtIn.contains(c)) c,
    ],
    window: !await comp.hasWatchedDraw(careerId, cycle, budgetSetupKind),
    freeFunds: freeFunds(career),
    income: FanMood.stadiumIncome(
      estate: NationalStadiums.incomeOf(
        NationalStadiums.openIn(set, cycle + 1),
        nationId,
      ),
      mood: (await ref.read(fanMoodProvider(careerId).future)).band,
      grant:
          (await ref
                  .read(federationServiceProvider)
                  .incomeForCycle(careerId, cycle))
              .grant,
    ),
    reputation: NationalStadiums.reputationFor(
      NationalStadiums.reputationPoints(works, cycle),
    ),
    resizedThisCycle: {
      for (final w in works)
        if (!w.isBuild && w.nationId == nationId && w.cycle == cycle) w.stadium,
    },
    building: all.any((s) => s.built && !s.openIn(cycle)),
  );
}

/// What [career] can spend: the balance less the wages owed at the
/// rollover, never negative. The same sum as [federationFundsProvider], read
/// straight off the career so a charge never waits on (or is cancelled with)
/// a screen's provider.
int freeFunds(Career career) {
  final wages = Staff.totalCost({
    StaffRole.assistant: career.staffAssistant,
    StaffRole.scout: career.staffScout,
    StaffRole.fitnessCoach: career.staffFitnessCoach,
  });
  return (career.budget - wages).clamp(0, career.budget);
}

final AutoDisposeFutureProviderFamily<NationalStadiumsView?, int>
nationalStadiumsViewProvider = FutureProvider.autoDispose
    .family<NationalStadiumsView?, int>(_loadView);

/// What the supporters' mood really does to the stadium income paid at the
/// next rollover: its band and the change in percent after the grant cap,
/// zero when the estate earns nothing or already sits at the cap. The
/// finances screen's mood line reads it.
final AutoDisposeFutureProviderFamily<({FanMoodBand band, int percent})?, int>
stadiumMoodEffectProvider = FutureProvider.autoDispose
    .family<({FanMoodBand band, int percent})?, int>((ref, careerId) async {
      final mood = await ref.watch(fanMoodProvider(careerId).future);
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final parts = await ref
          .read(nationalStadiumServiceProvider)
          .incomeParts(careerId, career.nationId, career.cyclePointer + 1);
      return (
        band: mood.band,
        percent: FanMood.effectivePercent(
          estate: parts.estate,
          grant: parts.grant,
          mood: mood.band,
        ),
      );
    });

/// The marker a cycle-start stadium payment leaves (row = the cycle it opened).
String stadiumIncomeKind(int cycle, int euros) => 'stadiumIncome:$cycle:$euros';

/// The marker the rollover into a cycle leaves once it has banked the closing
/// cycle's money (row = the new cycle): a retried rollover banks nothing twice.
const String cycleBankedKind = 'cycleBanked';

/// Paying for stadium works and the income they bring.
class NationalStadiumService {
  NationalStadiumService(this._ref);

  final Ref _ref;

  /// Enlarges [stadium] of the career's nation into the next level. Everything
  /// is re-read here, never taken from the screen, and the marker is checked
  /// inside the same transaction that charges: a double tap, or a stale
  /// screen, never pays twice. Returns whether it was bought.
  Future<bool> upgrade(int careerId, StadiumRef stadium) =>
      _resize(careerId, stadium, enlarge: true);

  /// Downsizes [stadium] into the level below: fewer seats, less upkeep,
  /// nothing refunded ([NationalStadiums.downsizeRefund]).
  Future<bool> downsize(int careerId, StadiumRef stadium) =>
      _resize(careerId, stadium, enlarge: false);

  Future<bool> _resize(
    int careerId,
    StadiumRef stadium, {
    required bool enlarge,
  }) async {
    final view = await _loadView(_ref, careerId);
    if (view == null) return false;
    NationalStadium? target;
    for (final s in view.stadiums) {
      if (s.ref == stadium) target = s;
    }
    if (target == null) return false;
    final block = enlarge
        ? view.upgradeBlock(target)
        : view.downsizeBlock(target);
    if (block != null) return false;
    final seats = enlarge
        ? StadiumLevels.enlargedTo(target.capacity)
        : StadiumLevels.downsizedTo(target.capacity);
    if (seats == null) return false;
    final work = StadiumWork.resize(
      nationId: view.nationId,
      cycle: view.cycle,
      stadium: stadium,
      seats: seats,
      enlarge: enlarge,
    );
    final cost = enlarge
        ? NationalStadiums.enlargeCost(target.capacity)!
        : -NationalStadiums.downsizeRefund;
    return _charge(
      careerId,
      view,
      work,
      cost,
      allowed: (fresh) {
        for (final s in fresh.stadiums) {
          if (s.ref == stadium) {
            return s.capacity == target!.capacity &&
                (enlarge ? fresh.upgradeBlock(s) : fresh.downsizeBlock(s)) ==
                    null;
          }
        }
        return false;
      },
    );
  }

  /// Orders a new stadium in [city]; it opens at the start of the next cycle.
  /// [name] is what the manager called it (see [StadiumName.clean]); blank,
  /// or the suggestion as it stood, and it keeps the generated name.
  Future<bool> build(int careerId, String city, {String? name}) async {
    final view = await _loadView(_ref, careerId);
    if (view == null) return false;
    if (view.buildBlock != null || !view.cities.contains(city)) return false;
    final work = StadiumWork.build(
      nationId: view.nationId,
      cycle: view.cycle,
      city: city,
    );
    final given = _given(name, city);
    return _charge(
      careerId,
      view,
      work,
      view.buildCost,
      allowed: (fresh) =>
          fresh.buildBlock == null && fresh.cities.contains(city),
      // The first name of a new ground: written in the same transaction as
      // the order, so a refused order leaves no name behind.
      also: given == null
          ? null
          : () => _name(careerId, view.nationId, view.cycle, city, given),
    );
  }

  /// Renames the stadium the career's nation built in [city]: free, at any
  /// time, under construction or open. A blank [name] goes back to the
  /// generated one. Returns whether the name now stands; false when the
  /// career's nation built nothing there (a seed or curated ground keeps its
  /// name).
  Future<bool> rename(int careerId, String city, String name) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return false;
    final comp = _ref.read(competitionRepositoryProvider);
    final works = await stadiumWorks(comp, careerId);
    final built = works.any(
      (w) =>
          w.isBuild && w.nationId == career.nationId && w.stadium.city == city,
    );
    if (!built) return false;
    final names = StadiumName.latestFor(
      await stadiumNames(comp, careerId),
      career.nationId,
    );
    final generated = NationalStadiums.newStadiumName(city);
    final wanted = StadiumName.clean(name) ?? generated;
    if ((names[city] ?? generated) == wanted) return true;
    await _ref
        .read(appDatabaseProvider)
        .transaction(
          () => _name(
            careerId,
            career.nationId,
            career.cyclePointer,
            city,
            wanted,
          ),
        );
    _invalidate(careerId);
    return true;
  }

  /// [name] as stored for a new ground in [city], or null when it is blank
  /// or the generated name (nothing to store).
  static String? _given(String? name, String city) {
    final clean = name == null ? null : StadiumName.clean(name);
    return clean == null || clean == NationalStadiums.newStadiumName(city)
        ? null
        : clean;
  }

  /// Writes [name] for [nationId]'s built ground in [city], after every name
  /// it had (the next [StadiumName.seq]). Run inside a transaction.
  Future<void> _name(
    int careerId,
    int nationId,
    int cycle,
    String city,
    String name,
  ) async {
    final comp = _ref.read(competitionRepositoryProvider);
    var seq = 0;
    for (final n in await stadiumNames(comp, careerId)) {
      if (n.nationId == nationId && n.city == city && n.seq > seq) seq = n.seq;
    }
    await comp.markDrawWatched(
      careerId,
      cycle,
      StadiumName(
        nationId: nationId,
        seq: seq + 1,
        city: city,
        name: name,
      ).encode(),
    );
  }

  Future<bool> _charge(
    int careerId,
    NationalStadiumsView view,
    StadiumWork work,
    int cost, {
    required bool Function(NationalStadiumsView fresh) allowed,
    Future<void> Function()? also,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final careers = _ref.read(careerRepositoryProvider);
    var paid = false;
    await _ref.read(appDatabaseProvider).transaction(() async {
      final kind = work.encode();
      if (await comp.hasWatchedDraw(careerId, view.cycle, kind)) return;
      final fresh = await careers.byId(careerId);
      if (fresh == null || fresh.cyclePointer != view.cycle) return;
      if (cost > 0 && freeFunds(fresh) < cost) return;
      // The rules again, read inside the transaction: two orders started
      // together (two builds, or an order racing the budget confirm) each
      // passed them outside it, and only the first to commit may stand.
      final again = await _loadView(_ref, careerId);
      if (again == null || again.cycle != view.cycle || !allowed(again)) {
        return;
      }
      await comp.markDrawWatched(careerId, view.cycle, kind);
      if (cost != 0) await careers.setBudget(careerId, fresh.budget - cost);
      if (also != null) await also();
      paid = true;
    });
    _invalidate(careerId);
    return paid;
  }

  /// What [nationId]'s stadiums earn at the start of [intoCycle] in
  /// [careerId]: every ground of its national set open by then, each from
  /// its seats and level (see [NationalStadiums.groundIncome]). The
  /// rollover adds it to the balance it banks.
  ///
  /// The whole is held to a tenth of the central grant of the cycle it is
  /// paid for ([NationalStadiums.cappedToGrant]). The supporters' mood moves
  /// it first, by up to a fifth either way ([FanMood.moodIncome]): full
  /// grounds through a good run earn more than half-empty ones. Only the
  /// career's own nation has a mood the game reads.
  Future<int> incomeAt(int careerId, int nationId, int intoCycle) async {
    final parts = await incomeParts(careerId, nationId, intoCycle);
    return FanMood.stadiumIncome(
      estate: parts.estate,
      grant: parts.grant,
      mood: parts.mood,
    );
  }

  /// What [incomeAt] is made of: the estate's earnings before the mood and
  /// the cap, the grant the cap is cut from, and the mood (null for a nation
  /// other than the career's own, whose mood the game does not read).
  Future<({int estate, int grant, FanMoodBand? mood})> incomeParts(
    int careerId,
    int nationId,
    int intoCycle,
  ) async {
    final set = await nationalSetFor(
      _ref,
      careerId,
      nationId,
      atCycle: intoCycle,
    );
    final grant =
        (await _ref
                .read(federationServiceProvider)
                .incomeForCycle(careerId, intoCycle - 1))
            .grant;
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    return (
      estate: NationalStadiums.incomeOf(set, nationId),
      grant: grant,
      mood: career != null && career.nationId == nationId
          ? (await _ref.read(fanMoodProvider(careerId).future)).band
          : null,
    );
  }

  void _invalidate(int careerId) {
    _ref
      ..invalidate(nationalStadiumsViewProvider(careerId))
      ..invalidate(federationFundsProvider(careerId))
      ..invalidate(financeViewProvider(careerId))
      // More seats, a better bid: an open offer reads the grounds again.
      ..invalidate(nationStadiumsProvider)
      ..invalidate(hostBidStatusProvider)
      ..invalidate(hostBidOffersProvider)
      ..invalidate(hostBidOfferProvider);
  }
}

final Provider<NationalStadiumService> nationalStadiumServiceProvider =
    Provider<NationalStadiumService>(NationalStadiumService.new);
