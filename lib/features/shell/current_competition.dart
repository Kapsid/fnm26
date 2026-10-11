import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/hub/hub_providers.dart';

/// The competition the managed nation is in right now, as the tablet
/// sidebar's quick link: the stored (English) name, printed through
/// `competitionLabel`, and the screen Tournaments would open for it.
typedef CurrentCompetition = ({String name, String location});

/// The competition [next] belongs to, or null when there is none worth a
/// link: no fixture, a friendly (Results holds those, not Tournaments), or a
/// competition with no screen of its own.
///
/// [name] is the fixture's stored competition name, when known; the round
/// code decides only what the name cannot (World Championship or continental
/// cup). [confederation] is the managed nation's own.
CurrentCompetition? currentCompetitionFor({
  required int careerId,
  required Fixture? next,
  required String? name,
  required Confederation? confederation,
}) {
  if (next == null) return null;
  final round = next.round;
  if (round == 'FRIENDLY' || name?.trim() == 'Friendlies') return null;
  String at(String path, [String? conf]) =>
      '$path?careerId=$careerId${conf == null ? '' : '&conf=$conf'}';

  final n = name?.trim();
  if ((n != null && NationsCups.isNationsCup(n)) ||
      round == 'NL' ||
      (round != null && round.startsWith('N'))) {
    // The manager's own cup, as the hub opens it.
    return (
      name: n ?? NationsCups.europe,
      location: at(Routes.nationsCup),
    );
  }
  if (round == 'FFINAL' || n == 'Continental Clash') {
    return (
      name: n ?? 'Continental Clash',
      location: at(Routes.continentalClash),
    );
  }
  if (n == 'Intercontinental Play-off') {
    return (name: n!, location: at(Routes.intercontinentalPlayoff));
  }
  if (round != null && round.startsWith('C')) {
    // A continental qualifier or the finals it leads to.
    if (confederation == null) return null;
    return (
      name: n ?? 'Continental Championship',
      location: at(Routes.continental, confederation.name),
    );
  }
  // The World Championship: its qualifiers (no round code) and its finals.
  // The qualifiers are stored per continent ("Europe Qualifiers"), which
  // beside "European Championship Qualifiers" would not say which cup they
  // lead to, so they go by the competition's own name.
  return (
    name: round == null ? 'World Cup Qualifiers' : n ?? 'World Championship',
    location: at(Routes.cup),
  );
}

/// [currentCompetitionFor] the managed nation's next fixture, from the hub's
/// data so it moves on with every step of the world.
final AutoDisposeFutureProviderFamily<CurrentCompetition?, int>
currentCompetitionProvider = FutureProvider.autoDispose
    .family<CurrentCompetition?, int>((ref, careerId) async {
      final hub = await ref.watch(hubDataProvider(careerId).future);
      if (hub == null || hub.championNationId != null) return null;
      final next = hub.next;
      if (next == null) return null;
      final names = await ref
          .watch(competitionRepositoryProvider)
          .competitionNames(careerId);
      return currentCompetitionFor(
        careerId: careerId,
        next: next,
        name: names[next.competitionId],
        confederation: hub.nations[hub.career.nationId]?.confederation,
      );
    });
