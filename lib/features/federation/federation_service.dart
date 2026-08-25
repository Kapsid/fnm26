import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/staff_providers.dart';

/// The finals rounds counted for prize money, split by tournament.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
const _contFinalsRounds = {
  'CGROUP',
  'CR16',
  'CQF',
  'CSF',
  'C3RD',
  'CFINAL',
};

/// Computes the federation's earnings for a finished cycle: central funding,
/// results prize money (how deep the nation went + titles won), and the
/// commercial return on that cycle's Commercial/PR investment. Pure read model
/// over the repositories — shared by the invest UI and the rollover.
class FederationService {
  FederationService(this._ref);

  final Ref _ref;

  /// The income the nation earns for [cycle] (the cycle just finished).
  Future<IncomeBreakdown> incomeForCycle(int careerId, int cycle) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return (grant: 0, prize: 0, commercial: 0);
    final comp = _ref.read(competitionRepositoryProvider);

    final wcYear = CareerService.worldCupYear(cycle);
    final startYear = cycle == 0
        ? CareerService.cycleStart.year
        : CareerService.worldCupYear(cycle - 1);

    // How deep the nation went this cycle, from its finals fixtures dated
    // within the cycle window (fixtures span all cycles, so filter by year).
    final fixtures = await comp.fixturesForNation(careerId, career.nationId);
    final wcRounds = <String>{};
    final contRounds = <String>{};
    for (final f in fixtures) {
      final y = f.date.year;
      if (y <= startYear || y > wcYear) continue;
      final r = f.round;
      if (r == null) continue;
      if (_wcFinalsRounds.contains(r)) wcRounds.add(r);
      if (_contFinalsRounds.contains(r)) contRounds.add(r);
    }

    // Titles the nation won this cycle (never the pre-seeded history).
    final honours = await comp.honours(careerId);
    final titlesWon = {
      for (final h in honours)
        if (h.championId == career.nationId &&
            h.year >= startYear &&
            h.year <= wcYear)
          h.competition,
    };
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    final conf = nations[career.nationId]?.confederation;
    final contName = conf == null
        ? null
        : ContinentalCups.byConfederation[conf]?.name;

    final prize = FederationFinance.resultsPrize(
      wcRounds: wcRounds,
      contRounds: contRounds,
      titlesWon: titlesWon,
      continentalName: contName,
    );

    final invest = await _ref
        .read(careerRepositoryProvider)
        .investment(careerId, cycle);
    final commercialInvested = invest.commercial;

    return (
      grant: FederationFinance.centralGrant,
      prize: prize,
      commercial: FederationFinance.commercialReturn(commercialInvested),
    );
  }
}

final Provider<FederationService> federationServiceProvider =
    Provider<FederationService>(FederationService.new);

/// The income breakdown the manager will bank at the current cycle's close —
/// shown in the invest UI so allocation happens against the real new balance.
final AutoDisposeFutureProviderFamily<IncomeBreakdown, int>
cycleIncomeProvider = FutureProvider.autoDispose.family<IncomeBreakdown, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return (grant: 0, prize: 0, commercial: 0);
  return ref
      .watch(federationServiceProvider)
      .incomeForCycle(careerId, career.cyclePointer);
});

/// The full finance snapshot for the Finances screen. Investment is planned for
/// the NEXT cycle (its effects — youth intake, medical, commercial — all land
/// then), which is always still editable; the current cycle's allocation is
/// locked and shown for reference.
typedef FinanceView = ({
  int budget,
  int cycle,
  FederationInvestment planned,
  FederationInvestment current,
  IncomeBreakdown projectedIncome,
});

final AutoDisposeFutureProviderFamily<FinanceView?, int> financeViewProvider =
    FutureProvider.autoDispose.family<FinanceView?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final repo = ref.watch(careerRepositoryProvider);
      final planned = await repo.investment(careerId, career.cyclePointer + 1);
      final current = await repo.investment(careerId, career.cyclePointer);
      final income = await ref
          .watch(federationServiceProvider)
          .incomeForCycle(careerId, career.cyclePointer);
      return (
        budget: career.budget,
        cycle: career.cyclePointer,
        planned: planned,
        current: current,
        projectedIncome: income,
      );
    });

/// The federation's money, split the only way that matters: what it holds, what
/// is already promised to the staff, and what is therefore left to spend.
typedef FederationFunds = ({int balance, int wages, int free});

/// What the federation can actually spend.
///
/// The balance alone is NOT it, and every screen that printed the balance alone
/// said it was. Staff are paid at the rollover, so their wages sit inside the
/// balance already owed to somebody: a manager who had handed every euro the
/// budget screen offered him to a department still saw a large figure on the
/// hub and read his allocation as not having saved. One answer, so the hub, the
/// budget screen and the finances screen cannot disagree about it.
final AutoDisposeFutureProviderFamily<FederationFunds, int>
federationFundsProvider = FutureProvider.autoDispose.family<FederationFunds, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  final balance = career?.budget ?? 0;
  final wages =
      (await ref.watch(staffRoomProvider(careerId).future))?.wagesPerCycle ?? 0;
  // Never negative: an over-committed wage bill means nothing is free, not that
  // the manager owes money he can invest.
  return (
    balance: balance,
    wages: wages,
    free: (balance - wages).clamp(0, balance),
  );
});

/// A department's long-term standing: its building level and the total euros
/// invested in it across every cycle of the save so far.
typedef DepartmentBuilding = ({
  Department department,
  int level,
  int cumulativeEuros,
  double progress,
});

/// The four federation buildings with their levels, derived from the whole
/// investment history — the "long-term impact" view the sliders can't show.
final AutoDisposeFutureProviderFamily<List<DepartmentBuilding>, int>
federationBuildingsProvider = FutureProvider.autoDispose
    .family<List<DepartmentBuilding>, int>((
      ref,
      careerId,
    ) async {
      final repo = ref.watch(careerRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return const [];
      final invests = await repo.investments(careerId);
      int spend(FederationInvestment i, Department d) => switch (d) {
        Department.youth => i.youth,
        Department.commercial => i.commercial,
        Department.medical => i.medical,
        Department.naturalization => i.naturalization,
        Department.boardRelations => i.boardRelations,
      };
      // A building's standing is its maintained investment — recent, sustained
      // funding, with each past cycle's spend decayed by carryOver — so it climbs
      // while you invest and slides back down when you stop.
      return [
        for (final d in Department.values)
          () {
            final byCycle = {
              for (final e in invests.entries) e.key: spend(e.value, d),
            };
            final euros = FederationBuildings.maintainedEuros(
              byCycle,
              career.cyclePointer,
            );
            return (
              department: d,
              level: FederationBuildings.levelFor(euros),
              cumulativeEuros: euros,
              progress: FederationBuildings.progressFor(euros),
            );
          }(),
      ];
    });
