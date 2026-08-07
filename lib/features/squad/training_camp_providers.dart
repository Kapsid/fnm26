import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/tournaments/city_providers.dart';

/// One base camp on offer, and which host country it sits in.
///
/// A co-hosted tournament is played across two or three countries, and a squad
/// bases itself in whichever of them suits it — so the choice is a camp AND a
/// country, not a camp inside a country picked for you.
typedef CampOption = ({
  int hostId,
  String hostName,
  String hostCode,
  TrainingCamp camp,
});

/// A tournament the manager is about to contest, the host country (or
/// countries) it is played in, the base camps on offer across them, and which
/// one has been chosen so far.
class TrainingCampPlan {
  const TrainingCampPlan({
    required this.tournament,
    required this.competition,
    required this.hostId,
    required this.hostName,
    required this.hostCode,
    required this.hostNames,
    required this.options,
    required this.cycle,
    required this.chosen,
  });

  /// The tournament's group round code: `GROUP` (World Cup) or `CGROUP`.
  final String tournament;

  /// Its name, for the heading.
  final String competition;

  /// The PRIMARY host — where the showpiece is, and the name the hub uses.
  final int hostId;
  final String hostName;
  final String hostCode;

  /// Every host country's name, in bid order, for the heading.
  final List<String> hostNames;

  /// Every camp on offer, across every host country.
  final List<CampOption> options;
  final int cycle;

  /// The camp already chosen — its country and its index within that country —
  /// or null while the decision is open.
  final ({int hostId, int campIndex})? chosen;

  bool get decided => chosen != null;

  /// Whether [option] is the chosen one. Indices are per-country, so the
  /// country has to match too — camp 0 of Portugal is not camp 0 of Spain.
  bool isChosen(CampOption option) =>
      chosen != null &&
      chosen!.hostId == option.hostId &&
      chosen!.campIndex == option.camp.index;
}

/// How many camps each host country offers when a tournament is shared.
///
/// A solo host puts up its full list; co-hosts each put up fewer, so a joint
/// tournament is a wider choice of PLACES rather than a screen of a dozen
/// near-identical lodges.
int _campsPerHost(int hostCount) => switch (hostCount) {
  <= 1 => TrainingCamps.count,
  2 => 3,
  _ => 2,
};

/// The World Cup and continental finals group rounds — a nation with an
/// unplayed fixture in one of these is going to a tournament.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
const _contFinalsRounds = {'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'};

/// The base camp decision waiting for the manager, or null when there is none —
/// which is most of the time. Live only between a finals draw putting the
/// nation in the field and its first match being played.
final AutoDisposeFutureProviderFamily<TrainingCampPlan?, int>
trainingCampPlanProvider =
    FutureProvider.autoDispose.family<TrainingCampPlan?, int>((
  ref,
  careerId,
) async {
  final careerRepo = ref.watch(careerRepositoryProvider);
  final career = await careerRepo.byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  // THIS cycle's fixtures. A career is endless and round codes repeat, so the
  // all-time list would show every past World Cup group game as already played
  // and the camp would never be offered again after the first tournament.
  final fixtures = await comp.cycleFixturesForNation(careerId, career.nationId);
  final nations = await ref.watch(nationRepositoryProvider).all();
  final byId = {for (final n in nations) n.id: n};

  // The nearest tournament the nation is in that has not kicked off yet.
  for (final rounds in [_contFinalsRounds, _wcFinalsRounds]) {
    final mine = [
      for (final f in fixtures)
        if (f.round != null && rounds.contains(f.round)) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    if (mine.isEmpty || mine.any((f) => f.hasResult)) continue;

    final isWc = rounds == _wcFinalsRounds;
    final tournament = isWc ? 'GROUP' : 'CGROUP';
    final hosts = isWc
        ? WorldCupHosts.hostsFor(
            year: mine.first.date.year,
            nations: nations,
            seed: career.rngSeed,
          )
        : WorldCupHosts.continentalHostsFor(
            confederation:
                byId[career.nationId]?.confederation ?? Confederation.europe,
            cycle: career.cyclePointer,
            seed: career.rngSeed,
            nations: nations,
          );
    if (hosts.isEmpty) continue;
    // The camp is set up in a country the tournament is played in — ANY of
    // them. A joint candidature used to offer only the primary host's camps, so
    // a World Cup shared between three countries billeted every squad in one of
    // them and the other two hosted nobody.
    final hostId = hosts.first;
    final host = byId[hostId];
    final cities = await ref.watch(countryCitiesProvider.future);
    final perHost = _campsPerHost(hosts.length);
    final options = <CampOption>[
      for (final id in hosts)
        for (final camp
            in TrainingCamps.forHost(hostId: id, cities: cities[id])
                .take(perHost))
          (
            hostId: id,
            hostName: byId[id]?.name ?? '—',
            hostCode: byId[id]?.code ?? '??',
            camp: camp,
          ),
    ];
    final chosen = await careerRepo.trainingCamp(
      careerId,
      career.cyclePointer,
      tournament,
    );
    return TrainingCampPlan(
      tournament: tournament,
      competition: isWc ? 'World Cup' : 'Continental Championship',
      hostId: hostId,
      hostName: host?.name ?? '—',
      hostCode: host?.code ?? '??',
      hostNames: [for (final id in hosts) byId[id]?.name ?? '—'],
      options: options,
      cycle: career.cyclePointer,
      // Only honour a stored choice that still names one of this tournament's
      // hosts — the host chain can change under a save.
      chosen: chosen != null && hosts.contains(chosen.hostId) ? chosen : null,
    );
  }
  return null;
});

/// What the manager's chosen camp is worth right now — the neutral profile when
/// no tournament is on, so the rest of the game can read it unconditionally.
final AutoDisposeFutureProviderFamily<TrainingCamp?, int> activeCampProvider =
    FutureProvider.autoDispose.family<TrainingCamp?, int>((ref, careerId) async {
  final plan = await ref.watch(trainingCampPlanProvider(careerId).future);
  final chosen = plan?.chosen;
  if (plan == null || chosen == null) return null;
  return TrainingCamps.resolve(
    hostId: chosen.hostId,
    cities: (await ref.watch(countryCitiesProvider.future))[chosen.hostId],
    index: chosen.campIndex,
  );
});

/// Saves the manager's base camp for a tournament.
class TrainingCampService {
  TrainingCampService(this._ref);

  final Ref _ref;

  Future<void> choose(
    int careerId,
    TrainingCampPlan plan,
    CampOption option,
  ) async {
    await _ref.read(careerRepositoryProvider).setTrainingCamp(
          careerId: careerId,
          cycle: plan.cycle,
          tournament: plan.tournament,
          hostId: option.hostId,
          campIndex: option.camp.index,
        );
    _ref
      ..invalidate(trainingCampPlanProvider(careerId))
      ..invalidate(activeCampProvider(careerId));
  }
}

final Provider<TrainingCampService> trainingCampServiceProvider =
    Provider(TrainingCampService.new);
