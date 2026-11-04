import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/entities/enums.dart';
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
  /// The short column heading for a knockout round in a visual bracket
  /// ("QF", "čtvrtf."). Unknown codes are returned as they are.
  static String ladderLabel(AppLocalizations l, String round) =>
      switch (round) {
        'R32' => l.matchTinyRoundOf32,
        'R16' || 'NR16' || 'CR16' => l.matchTinyRoundOf16,
        'QF' || 'NQF' || 'CQF' => l.matchTinyQuarterFinal,
        'SF' || 'NSF' || 'CSF' || 'POSF' => l.matchTinySemiFinal,
        'FINAL' || 'NFINAL' || 'CFINAL' || 'POFINAL' => l.matchTinyFinal,
        '3RD' || 'C3RD' => l.matchTinyThirdPlace,
        _ => round,
      };

  /// The round on its own ("Quarter-final"). Unknown codes are returned as
  /// they are, which is what an untranslated new competition should show.
  static String stage(AppLocalizations l, String? round) => switch (round) {
    null || 'CQ' => l.resultsStageQualifier,
    'FRIENDLY' => l.resultsStageFriendly,
    'NL' || 'NGROUP' => l.resultsStageGroupStage,
    'NR16' => l.resultsStageRoundOf16,
    'NQF' => l.resultsStageQuarterFinal,
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

  /// The smallest way to say where a fixture belongs: a fan's abbreviation of
  /// the competition and, when there is one, the round ("WC Q" and "MD 1",
  /// "PN" and "QF", "Friendly" and nothing).
  ///
  /// For the call-up screen's fixture tiles, three to a phone's width, where
  /// even [labelCompact] ("CONTINENTAL CUP Q · MATCHDAY 1") is several times
  /// too wide. [conf] is the manager's own confederation, which is the only
  /// one whose continental cup and Nations Cup he ever plays in, and it is
  /// what lets the tag name the cup ("EC") rather than a vague "continental".
  ///
  /// Two parts rather than one string, so a tile can let the round drop onto
  /// a line of its own instead of breaking inside either of them.
  static ({String competition, String? stage}) tinyParts(
    AppLocalizations l,
    Fixture f,
    Confederation conf,
  ) {
    final round = f.round;
    final cup = switch (conf) {
      Confederation.europe => l.matchTinyEurope,
      Confederation.southAmerica => l.matchTinySouthAmerica,
      Confederation.northAmerica => l.matchTinyNorthAmerica,
      Confederation.africa => l.matchTinyAfrica,
      Confederation.asia => l.matchTinyAsia,
      Confederation.oceania => l.matchTinyOceania,
    };
    String? knockout(String r) => switch (r) {
      'R32' => l.matchTinyRoundOf32,
      'R16' || 'NR16' || 'CR16' => l.matchTinyRoundOf16,
      'QF' || 'NQF' || 'CQF' => l.matchTinyQuarterFinal,
      'SF' || 'NSF' || 'CSF' || 'POSF' => l.matchTinySemiFinal,
      'FINAL' || 'NFINAL' || 'CFINAL' || 'POFINAL' => l.matchTinyFinal,
      '3RD' || 'C3RD' => l.matchTinyThirdPlace,
      _ => null,
    };
    final matchday = l.matchTinyMatchday(f.matchday);
    return switch (round) {
      null => (
        competition: l.matchTinyQualifying(l.matchTinyWorld),
        stage: matchday,
      ),
      'CQ' => (competition: l.matchTinyQualifying(cup), stage: matchday),
      'FRIENDLY' => (competition: l.matchTinyFriendly, stage: null),
      'FFINAL' => (competition: l.matchTinyClash, stage: null),
      'POSF' ||
      'POFINAL' => (competition: l.matchTinyPlayoff, stage: knockout(round)),
      // A group game is the competition alone, as on [label].
      'GROUP' => (competition: l.matchTinyWorld, stage: null),
      'CGROUP' => (competition: cup, stage: null),
      'NGROUP' || 'NL' => (competition: l.matchTinyNationsCup, stage: null),
      _ when round.startsWith('N') => (
        competition: l.matchTinyNationsCup,
        stage: knockout(round),
      ),
      _ when round.startsWith('C') => (
        competition: cup,
        stage: knockout(round),
      ),
      _ => (competition: l.matchTinyWorld, stage: knockout(round) ?? round),
    };
  }

  /// [tinyParts] as one line ("WC Q · MD 1"), for anywhere that has the room
  /// for both on one line, and for the tests.
  static String labelTiny(AppLocalizations l, Fixture f, Confederation conf) {
    final parts = tinyParts(l, f, conf);
    final stage = parts.stage;
    return stage == null ? parts.competition : '${parts.competition} · $stage';
  }

  static String _label(AppLocalizations l, Fixture f, bool compact) {
    final round = f.round;
    // A friendly and a Continental Clash are one-offs: naming them twice
    // ("FRIENDLIES · FRIENDLY") reads as a bug.
    if (round == 'FRIENDLY') return l.resultsStageFriendly.capsIn(l.localeName);
    if (round == 'FFINAL') {
      return l.resultsStageContinentalClash.capsIn(l.localeName);
    }
    if (round == null || round == 'CQ') {
      final head =
          (compact
                  ? (round == null
                        ? l.resultsCategoryWorldCupQualifyingShort
                        : l.resultsCategoryContinentalQualifyingShort)
                  : category(l, round))
              .capsIn(l.localeName);
      return '$head · ${l.matchStageMatchday(f.matchday).capsIn(l.localeName)}';
    }
    // A group game is just the competition: "· GROUP STAGE" adds nothing the
    // manager needs, and on the narrow cards it pushed the line over.
    if (const {'GROUP', 'CGROUP', 'NGROUP', 'NL'}.contains(round)) {
      return category(l, round).capsIn(l.localeName);
    }
    return '${category(l, round).capsIn(l.localeName)} · '
        '${stage(l, round).capsIn(l.localeName)}';
  }
}
