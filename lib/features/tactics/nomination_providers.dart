import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// The current squad-nomination window: whether the manager may (re-)pick the
/// squad right now, and the run of matches this nomination covers.
typedef NominationWindow = ({
  bool open,
  List<Fixture> matches,
  Map<int, Nation> nations,
  int playerNationId,
});

final AutoDisposeFutureProviderFamily<NominationWindow, int>
    nominationWindowProvider =
    FutureProvider.autoDispose.family<NominationWindow, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) {
    return (
      open: false,
      matches: const <Fixture>[],
      nations: const <int, Nation>{},
      playerNationId: -1,
    );
  }
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .fixturesForNation(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return (
    open: Nomination.windowOpen(fixtures),
    matches: Nomination.currentPeriod(fixtures),
    nations: nations,
    playerNationId: career.nationId,
  );
});
