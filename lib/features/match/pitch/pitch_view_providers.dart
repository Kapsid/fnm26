/// The Pitch view's wiring to the match screen.
library;

import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/match_providers.dart';

/// Both sides' line-ups for the match [preview] pins, as the Pitch view
/// draws them: each starting XI in its formation's slot order with its
/// shirts, each bench, each side's instructions and slot switches, the plan
/// [result] (the preview's own result unless a re-simulated one is being
/// shown) says it fielded, and the live tactical [changes] the screen has
/// made (its own list, as it hands them to the engine).
///
/// The manager's bench is the preview's [MatchPreview.bench]; the
/// opponent's is its named bench plus anybody its planned substitutions
/// bring on.
MatchLineups matchLineupsFromPreview(
  MatchPreview preview, {
  MatchResult? result,
  List<TacticalChange> changes = const [],
}) {
  final homeIsPlayer = preview.playerNationId == preview.homeTeam.nationId;
  List<int> ids(Iterable<Player> ps) => [for (final p in ps) p.id];
  final opponentBench = ids(preview.opponentBench);
  for (final s in preview.opponentSubs) {
    if (!opponentBench.contains(s.on.id)) opponentBench.add(s.on.id);
  }
  final playerBench = ids(preview.bench);
  return matchLineupsOf(
    home: preview.homeTeam,
    away: preview.awayTeam,
    homeBench: homeIsPlayer ? playerBench : opponentBench,
    awayBench: homeIsPlayer ? opponentBench : playerBench,
    result: result ?? preview.result,
    changes: changes,
  );
}
