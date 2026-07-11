import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';

/// Watched-draw keys for the host-selection ceremonies.
const worldCupHostDrawKind = 'wcHostDraw';
const continentalHostDrawKind = 'contHostDraw';

/// Which host draw to present: the World Cup's or the player's continental cup.
typedef HostDrawArg = ({int careerId, bool worldCup});

/// Everything the host-draw ceremony needs: a shortlist of candidates to show
/// up front, and the winner to reveal from the envelope.
class HostDrawData {
  const HostDrawData({
    required this.title,
    required this.candidateIds,
    required this.hostId,
    required this.nations,
    required this.year,
    required this.cycle,
    required this.watchedKind,
  });

  final String title;
  final List<int> candidateIds;
  final int hostId;
  final Map<int, Nation> nations;
  final int year;
  final int cycle;
  final String watchedKind;
}

final AutoDisposeFutureProviderFamily<HostDrawData?, HostDrawArg>
hostDrawProvider =
    FutureProvider.autoDispose.family<HostDrawData?, HostDrawArg>((
  ref,
  arg,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(arg.careerId);
  if (career == null) return null;
  final all = await ref.watch(nationRepositoryProvider).all();
  final nations = {for (final n in all) n.id: n};

  final Confederation conf;
  final int host;
  final String title;
  final String watchedKind;
  final int year;

  if (arg.worldCup) {
    year = CareerService.worldCupYear(career.cyclePointer);
    conf = WorldCupHosts.confederationFor(year);
    host = WorldCupHosts.hostFor(
      year: year,
      nations: all,
      seed: career.rngSeed,
    );
    title = 'WORLD CUP HOST';
    watchedKind = worldCupHostDrawKind;
  } else {
    final playerConf = nations[career.nationId]?.confederation;
    if (playerConf == null) return null;
    final cont = ContinentalCups.byConfederation[playerConf];
    if (cont == null) return null;
    conf = playerConf;
    host = WorldCupHosts.continentalHostFor(
      confederation: conf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: all,
    );
    title = '${cont.name.toUpperCase()} HOST';
    watchedKind = continentalHostDrawKind;
    year = CareerService.worldCupYear(career.cyclePointer) - 2;
  }

  final candidates = WorldCupHosts.hostCandidates(
    confederation: conf,
    nations: all,
  );
  if (!candidates.contains(host)) candidates.add(host);

  return HostDrawData(
    title: title,
    candidateIds: candidates,
    hostId: host,
    nations: nations,
    year: year,
    cycle: career.cyclePointer,
    watchedKind: watchedKind,
  );
});
