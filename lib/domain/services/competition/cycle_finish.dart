import 'package:fnm/domain/entities/fixture.dart';

/// How far a nation got in one tournament, as MEANING rather than as words.
///
/// This used to be a String built in `manager_history_providers.dart`
/// ('Champions', 'Semi-finals', 'Did not qualify'), printed straight onto the
/// career history and compared back against itself to decide whether to draw a
/// trophy beside it — so a Czech manager read his own career in English, and
/// translating the words would have silently turned the trophy off. An enum is
/// the only shape that can be both compared and translated: the comparison is
/// on the value, and the words come from `cycleFinishLabel` at the display
/// edge.
enum CycleFinish {
  champions,
  runnersUp,
  thirdPlace,
  fourthPlace,
  semiFinals,
  quarterFinals,
  roundOf16,
  roundOf32,
  groupStage,

  /// Never reached the finals at all.
  didNotQualify,
}

/// The finals ladder, shallowest first, as the stored round codes spell it.
///
/// A continental competition prefixes its rounds with `C` (see `Rounds`); the
/// prefix is stripped before the lookup so one ladder serves both.
const List<String> _ladder = [
  'GROUP',
  'R32',
  'R16',
  'QF',
  'SF',
  '3RD',
  'FINAL',
];

/// How [nationId] finished the tournament [fixtures] belong to.
///
/// [fixtures] is one cycle's worth of the nation's own matches; [continental]
/// picks which tournament is being asked about, since a cycle holds both and
/// they are told apart by the `C` prefix on the round code. A nation with no
/// finals fixture at all did not qualify.
CycleFinish cycleFinishOf(
  List<Fixture> fixtures,
  int nationId, {
  required bool continental,
}) {
  final rounds = fixtures.where((f) {
    final r = f.round;
    if (r == null) return false;
    final isC = r.startsWith('C');
    if (isC != continental) return false;
    return _ladder.contains(isC ? r.substring(1) : r);
  }).toList();
  if (rounds.isEmpty) return CycleFinish.didNotQualify;

  var deepest = -1;
  Fixture? finalTie;
  Fixture? thirdTie;
  for (final f in rounds) {
    final r = f.round!;
    final core = r.startsWith('C') ? r.substring(1) : r;
    final idx = _ladder.indexOf(core);
    if (idx > deepest) deepest = idx;
    if (core == 'FINAL') finalTie = f;
    if (core == '3RD') thirdTie = f;
  }

  bool wonAt(Fixture? f) {
    if (f == null || !f.hasResult) return false;
    final home = f.homeNationId == nationId;
    final my = home ? f.homeScore! : f.awayScore!;
    final other = home ? f.awayScore! : f.homeScore!;
    return my >= other; // ties settled on penalties list the winner as home
  }

  return switch (_ladder[deepest]) {
    'FINAL' => wonAt(finalTie) ? CycleFinish.champions : CycleFinish.runnersUp,
    '3RD' => wonAt(thirdTie) ? CycleFinish.thirdPlace : CycleFinish.fourthPlace,
    // Continental cups play no third-place match, so the two beaten
    // semi-finalists share the bronze and a lost semi there IS third place.
    'SF' => continental ? CycleFinish.thirdPlace : CycleFinish.semiFinals,
    'QF' => CycleFinish.quarterFinals,
    'R16' => CycleFinish.roundOf16,
    'R32' => CycleFinish.roundOf32,
    _ => CycleFinish.groupStage,
  };
}

/// How a nation's Nations Cup ended, for the leagues that play a Finals Four.
///
/// Was a String in the repository ('Champions', 'Runners-up',
/// 'Semi-finalist') — three English words written in `lib/data`, which the
/// career history printed as they came. Same fix as [CycleFinish].
enum NationsCupFinish { champions, runnersUp, semiFinalist }
