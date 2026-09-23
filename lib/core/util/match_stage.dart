import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Turns a fixture's round code into words.
///
/// The results screen has read round codes in the player's language for a
/// while; the hub, the match preview and the call-up screen were still
/// building the same labels from hardcoded English. One definition now, so a
/// Czech save doesn't say "WC FINALS · QUARTER-FINAL" on the one screen that
/// matters most and "ČTVRTFINÁLE" on the next.
abstract final class MatchStage {
  /// The round on its own ("Quarter-final"). Unknown codes are returned as
  /// they are, which is what an untranslated new competition should show.
  static String stage(AppLocalizations l, String? round) => switch (round) {
    null || 'CQ' => l.resultsStageQualifier,
    'FRIENDLY' => l.resultsStageFriendly,
    'NL' || 'NGROUP' => l.resultsStageGroupStage,
    'NSF' => l.resultsStageSemiFinal,
    'NFINAL' => l.resultsStageFinal,
    'FFINAL' => l.resultsStageContinentalClash,
    'GROUP' => l.resultsStageFinalsGroup,
    'R32' => l.resultsStageRoundOf32,
    'R16' => l.resultsStageRoundOf16,
    'QF' => l.resultsStageQuarterFinal,
    'SF' => l.resultsStageSemiFinal,
    '3RD' => l.resultsStageThirdPlace,
    'FINAL' => l.resultsStageFinal,
    'CGROUP' => l.resultsStageGroupStage,
    'CR16' => l.resultsStageRoundOf16,
    'CQF' => l.resultsStageQuarterFinal,
    'CSF' => l.resultsStageSemiFinal,
    'C3RD' => l.resultsStageThirdPlace,
    'CFINAL' => l.resultsStageFinal,
    _ => round,
  };

  /// The competition a fixture belongs to, derived from its round code.
  static String category(AppLocalizations l, String? round) {
    if (round == null) return l.resultsCategoryWorldCupQualifying;
    if (round == 'FRIENDLY') return l.resultsCategoryFriendlies;
    if (round == 'FFINAL') return l.resultsCategoryContinentalClash;
    if (round.startsWith('N')) return l.resultsCategoryNationsCup;
    // Continental QUALIFYING is its own competition, and it used to answer
    // "Continental Cup" — the same heading the cup itself carries. So a
    // qualifier and the final of the tournament it leads to read identically
    // on the hub, and the word "qualifying" appeared nowhere on either.
    if (round == 'CQ') return l.resultsCategoryContinentalQualifying;
    if (round.startsWith('C')) return l.resultsCategoryContinentalCup;
    return l.resultsCategoryWorldCupFinals;
  }

  /// The one-line banner above a fixture: the competition and where in it the
  /// match falls ("WORLD CUP FINALS · QUARTER-FINAL"), or the matchday number
  /// for a qualifying campaign, which has rounds but no named stages.
  static String label(AppLocalizations l, Fixture f) => _label(l, f, false);

  /// [label] with the word "qualifying" written as a Q.
  ///
  /// For the hub's next-match strip, which has a heading beside it and about
  /// half a line to fit in. "WORLD CUP QUALIFYING · MATCHDAY 6" is the longest
  /// banner in the game, and shrunk into that gap it came out too small to
  /// read — which defeated the point of naming the competition at all. Only
  /// the qualifying campaigns say it differently; every other banner is short
  /// enough already and stays exactly as it reads elsewhere.
  static String labelCompact(AppLocalizations l, Fixture f) =>
      _label(l, f, true);

  static String _label(AppLocalizations l, Fixture f, bool compact) {
    final round = f.round;
    // A friendly and a Continental Clash are one-offs: naming them twice
    // ("FRIENDLIES · FRIENDLY") reads as a bug.
    if (round == 'FRIENDLY') return l.resultsStageFriendly.toUpperCase();
    if (round == 'FFINAL') {
      return l.resultsStageContinentalClash.toUpperCase();
    }
    if (round == null || round == 'CQ') {
      final head = (compact
              ? (round == null
                    ? l.resultsCategoryWorldCupQualifyingShort
                    : l.resultsCategoryContinentalQualifyingShort)
              : category(l, round))
          .toUpperCase();
      return '$head · ${l.matchStageMatchday(f.matchday).toUpperCase()}';
    }
    return '${category(l, round).toUpperCase()} · '
        '${stage(l, round).toUpperCase()}';
  }
}
