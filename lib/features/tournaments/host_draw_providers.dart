import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/data/data_providers.dart';
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
    required this.bids,
    required this.hostIds,
    required this.nations,
    required this.year,
    required this.cycle,
    required this.watchedKind,
  });

  final String title;

  /// The candidatures on the table — each a lone nation or a joint bid. Joint
  /// bids are visible here, before the envelope is opened: who is standing with
  /// whom is part of the race, not part of the result.
  final List<HostBid> bids;

  /// The winning bid — the primary plus any co-hosts, in order.
  final List<int> hostIds;
  int get hostId => hostIds.first;
  final Map<int, Nation> nations;
  final int year;
  final int cycle;
  final String watchedKind;
}

final AutoDisposeFutureProviderFamily<HostDrawData?, HostDrawArg>
hostDrawProvider = FutureProvider.autoDispose.family<HostDrawData?, HostDrawArg>((
  ref,
  arg,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(arg.careerId);
  final l = ref.watch(appLocalizationsProvider);
  if (career == null) return null;
  final all = await ref.watch(nationRepositoryProvider).all();
  final nations = {for (final n in all) n.id: n};

  final List<HostBid> bids;
  final List<int> hosts;
  final String title;
  final String watchedKind;
  final int year;

  if (arg.worldCup) {
    year = CareerService.worldCupYear(career.cyclePointer);
    bids = WorldCupHosts.worldCupBids(
      year: year,
      nations: all,
      seed: career.rngSeed,
    );
    hosts = WorldCupHosts.hostsFor(
      year: year,
      nations: all,
      seed: career.rngSeed,
    );
    title = l.tourDrawWcHost;
    watchedKind = worldCupHostDrawKind;
  } else {
    final playerConf = nations[career.nationId]?.confederation;
    if (playerConf == null) return null;
    final cont = ContinentalCups.byConfederation[playerConf];
    if (cont == null) return null;
    // Continental finals can be co-hosted too.
    bids = WorldCupHosts.continentalBids(
      confederation: playerConf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: all,
    );
    hosts = WorldCupHosts.continentalHostsFor(
      confederation: playerConf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: all,
    );
    title = l.tourDrawContHost(
      continentalCupLabel(l, playerConf).toUpperCase(),
    );
    watchedKind = continentalHostDrawKind;
    year = CareerService.worldCupYear(career.cyclePointer) - 2;
  }

  return HostDrawData(
    title: title,
    // The winner is drawn from exactly these bids, so it is always among them —
    // no need to append it as the flat candidate list once did.
    bids: bids,
    hostIds: hosts,
    nations: nations,
    year: year,
    cycle: career.cyclePointer,
    watchedKind: watchedKind,
  );
});
