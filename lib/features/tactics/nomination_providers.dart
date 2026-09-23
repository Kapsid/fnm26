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

/// The key a part-named squad is stored under.
///
/// A draft belongs to the window it is naming, so it is keyed on that window's
/// first match — the same key the timeline fires the call-up event with. A
/// squad edited outside any window (the manager browsing their own call-ups)
/// shares one 'open' slot; there is nothing to tie it to.
String callUpDraftKey({String? eventKind, Fixture? periodStart}) =>
    eventKind ??
    (periodStart == null ? 'callup:open' : 'callup:${periodStart.id}');

/// Reads back the part-named squad stored under a draft key.
final AutoDisposeFutureProviderFamily<Set<int>, ({int careerId, String key})>
callUpDraftProvider = FutureProvider.autoDispose
    .family<Set<int>, ({int careerId, String key})>(
      (ref, arg) =>
          ref.watch(squadRepositoryProvider).callUpDraft(arg.careerId, arg.key),
    );

final AutoDisposeFutureProviderFamily<NominationWindow, int>
nominationWindowProvider = FutureProvider.autoDispose.family<NominationWindow, int>((
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
  // THIS cycle's fixtures. The all-time list is ordered by date and the window
  // is read off its FIRST unplayed match, so a single fixture left unplayed in
  // an earlier cycle (an arranged friendly the tournament swallowed, say) would
  // sit at the head of the list for the rest of the save and pin the window to
  // a period that had already gone — after which no tournament ever opened a
  // fresh nomination again.
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .cycleFixturesForNation(careerId, career.nationId);
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
