import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:fnm/domain/entities/enums.dart';

/// Which colours the match's header strip and 2D TV score bar wear.
///
/// Only the FINALS of a tournament dress them: the World Championship
/// finals and each confederation's continental championship finals. The
/// final itself of every one of them is GOLD, every third-place match
/// BRONZE, and the other rounds wear their tournament's own colours. The
/// Continental Clash (a one-off, round `FFINAL`) wears its own violet, and
/// every Nations Cup match its graphite and ice blue (its final the gold).
/// Qualifiers, friendlies and play-offs keep the plain silver.
enum ScoreBugThemeKind {
  /// The final of any finals tournament.
  finalGold,

  /// The third-place match of any finals tournament.
  bronze,
  worldChampionship,
  europe,
  southAmerica,
  africa,
  asia,
  northAmerica,
  oceania,

  /// Every Continental Clash match.
  continentalClash,

  /// Every Nations Cup match but its final (which is gold).
  nationsCup,
}

/// The colours of a tournament-dressed score bar. The silver bar is not one
/// of these: it is the bar's own look, drawn when there is no theme.
@immutable
class ScoreBugTheme {
  const ScoreBugTheme({
    required this.kind,
    required this.plates,
    required this.score,
    required this.scoreText,
    required this.clockText,
    required this.accent,
    this.rim,
    this.divider,
  });

  final ScoreBugThemeKind kind;

  /// The dark team plates, top to bottom.
  final List<Color> plates;

  /// The score block, top to bottom.
  final List<Color> score;

  /// The figures on the score block.
  final Color scoreText;

  /// The minute in the clock box.
  final Color clockText;

  /// The header strip's text and edge.
  final Color accent;

  /// A hairline round the whole bar (the World Championship's gold), or null
  /// for the bar's usual edge.
  final Color? rim;

  /// The line between the two figures, or null for one in the score text.
  final Color? divider;

  /// The World Championship's gold, which every final wears too.
  static const List<Color> _goldPlates = [Color(0xFF22201B), Color(0xFF0E0D0A)];
  static const List<Color> _goldScore = [
    Color(0xFFFBE7A6),
    Color(0xFFD4A440),
    Color(0xFFB88A2A),
  ];

  /// The themes, by tournament: the owner's approved design.
  static const Map<ScoreBugThemeKind, ScoreBugTheme> all = {
    ScoreBugThemeKind.finalGold: ScoreBugTheme(
      kind: ScoreBugThemeKind.finalGold,
      plates: _goldPlates,
      score: _goldScore,
      scoreText: Color(0xFF1C1405),
      clockText: Color(0xFFF3D27A),
      accent: Color(0xFFF3D27A),
      rim: Color(0xFFC9972F),
    ),
    // A darker copper in the gold's style: a near-black plate, a copper
    // clock.
    ScoreBugThemeKind.bronze: ScoreBugTheme(
      kind: ScoreBugThemeKind.bronze,
      plates: [Color(0xFF1D1713), Color(0xFF0B0907)],
      score: [Color(0xFFF0C9A0), Color(0xFFB87333), Color(0xFF8A5524)],
      scoreText: Color(0xFF1F0F05),
      clockText: Color(0xFFE0A06A),
      accent: Color(0xFFE0A06A),
      rim: Color(0xFF9A5E2C),
    ),
    ScoreBugThemeKind.worldChampionship: ScoreBugTheme(
      kind: ScoreBugThemeKind.worldChampionship,
      plates: _goldPlates,
      score: _goldScore,
      scoreText: Color(0xFF1C1405),
      clockText: Color(0xFFF3D27A),
      accent: Color(0xFFF3D27A),
      rim: Color(0xFFC9972F),
    ),
    ScoreBugThemeKind.europe: ScoreBugTheme(
      kind: ScoreBugThemeKind.europe,
      plates: [Color(0xFF1B2A63), Color(0xFF0C1433)],
      score: [Color(0xFFF4F6FB), Color(0xFFC2C9DC)],
      scoreText: Color(0xFF0C1433),
      clockText: Color(0xFF9FB4FF),
      accent: Color(0xFF9FB4FF),
    ),
    ScoreBugThemeKind.southAmerica: ScoreBugTheme(
      kind: ScoreBugThemeKind.southAmerica,
      plates: [Color(0xFF0F4C75), Color(0xFF06233A)],
      score: [Color(0xFFFFF6D6), Color(0xFFF0C64A)],
      scoreText: Color(0xFF06233A),
      clockText: Color(0xFFFFD75E),
      accent: Color(0xFFFFD75E),
    ),
    ScoreBugThemeKind.africa: ScoreBugTheme(
      kind: ScoreBugThemeKind.africa,
      plates: [Color(0xFF174D2E), Color(0xFF0A2616)],
      score: [Color(0xFFFFE2B0), Color(0xFFE9A443)],
      scoreText: Color(0xFF2A1402),
      clockText: Color(0xFFF0B25A),
      accent: Color(0xFFF0B25A),
    ),
    ScoreBugThemeKind.asia: ScoreBugTheme(
      kind: ScoreBugThemeKind.asia,
      plates: [Color(0xFF5C0B1A), Color(0xFF2A050C)],
      score: [Color(0xFFEAFAF3), Color(0xFF9FD9C0)],
      scoreText: Color(0xFF0B2E22),
      clockText: Color(0xFF9FD9C0),
      accent: Color(0xFF9FD9C0),
    ),
    ScoreBugThemeKind.northAmerica: ScoreBugTheme(
      kind: ScoreBugThemeKind.northAmerica,
      plates: [Color(0xFF14234A), Color(0xFF070E22)],
      score: [Color(0xFFFFFFFF), Color(0xFFD3D8E2)],
      scoreText: Color(0xFF070E22),
      // The design names no clock colour here: the bar's red, lifted to
      // read on the dark box.
      clockText: Color(0xFFFF8A9A),
      accent: Color(0xFFFF8A9A),
      divider: Color(0xFFC8102E),
    ),
    // Not in the owner's sheet: a deep sea teal with a lagoon-pale score, in
    // the same spirit.
    ScoreBugThemeKind.oceania: ScoreBugTheme(
      kind: ScoreBugThemeKind.oceania,
      plates: [Color(0xFF0B5560), Color(0xFF042A30)],
      score: [Color(0xFFE8FBF8), Color(0xFF8ED8CF)],
      scoreText: Color(0xFF042A30),
      clockText: Color(0xFF7FE3D6),
      accent: Color(0xFF7FE3D6),
    ),
    // Not one of the confederations': deep violet plates, a silver score
    // block washed lilac, a soft violet clock.
    ScoreBugThemeKind.continentalClash: ScoreBugTheme(
      kind: ScoreBugThemeKind.continentalClash,
      plates: [Color(0xFF2B1650), Color(0xFF12082A)],
      score: [Color(0xFFF4F1FA), Color(0xFFCDBDEB)],
      scoreText: Color(0xFF12082A),
      clockText: Color(0xFFC7A8FF),
      accent: Color(0xFFC7A8FF),
    ),
    // The Nations Cup: graphite plates, a silver score block with a cold
    // blue wash, an ice-blue clock. Not a confederation's colours, since
    // every confederation plays one.
    ScoreBugThemeKind.nationsCup: ScoreBugTheme(
      kind: ScoreBugThemeKind.nationsCup,
      plates: [Color(0xFF2A3038), Color(0xFF0F1216)],
      score: [Color(0xFFF7FAFD), Color(0xFFBCD3E6)],
      scoreText: Color(0xFF0F1216),
      clockText: Color(0xFF8FD3FF),
      accent: Color(0xFF8FD3FF),
    ),
  };

  /// The Continental Clash's round (a one-off between two continental
  /// champions; its own final and third place, if it ever has them, keep
  /// the gold and the bronze as every finals' do).
  static const String _clash = 'FFINAL';

  /// The World Championship finals' rounds.
  static const Set<String> _worldFinals = {
    'GROUP',
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  };

  /// A continental championship finals' rounds.
  static const Set<String> _continentalFinals = {
    'CGROUP',
    'CR16',
    'CQF',
    'CSF',
    'C3RD',
    'CFINAL',
  };

  /// The finals' finals and third-place matches (the round codes of
  /// `MatchStage`).
  static const Set<String> _finals = {'FINAL', 'CFINAL', 'NFINAL'};

  /// A Nations Cup's rounds before its final.
  static const Set<String> _nationsCup = {'NL', 'NGROUP', 'NR16', 'NQF', 'NSF'};
  static const Set<String> _thirdPlace = {'3RD', 'C3RD'};

  /// Which colours [round] wears, if its finals dress the bar.
  /// [confederation] is the continental championship's (the manager only
  /// ever plays his own confederation's). Null: silver.
  static ScoreBugThemeKind? kindFor(
    String? round,
    Confederation? confederation,
  ) {
    if (round == null) return null;
    final continental = _continentalFinals.contains(round);
    if (continental && confederation == null) return null;
    if (_finals.contains(round)) return ScoreBugThemeKind.finalGold;
    if (_thirdPlace.contains(round)) return ScoreBugThemeKind.bronze;
    if (round == _clash) return ScoreBugThemeKind.continentalClash;
    if (_nationsCup.contains(round)) return ScoreBugThemeKind.nationsCup;
    if (_worldFinals.contains(round)) {
      return ScoreBugThemeKind.worldChampionship;
    }
    if (_continentalFinals.contains(round)) {
      return switch (confederation) {
        Confederation.europe => ScoreBugThemeKind.europe,
        Confederation.southAmerica => ScoreBugThemeKind.southAmerica,
        Confederation.africa => ScoreBugThemeKind.africa,
        Confederation.asia => ScoreBugThemeKind.asia,
        Confederation.northAmerica => ScoreBugThemeKind.northAmerica,
        Confederation.oceania => ScoreBugThemeKind.oceania,
        null => null,
      };
    }
    return null;
  }

  /// The theme for [round] (see [kindFor]), or null for the silver bar.
  static ScoreBugTheme? forRound(String? round, Confederation? confederation) =>
      switch (kindFor(round, confederation)) {
        final k? => all[k],
        null => null,
      };
}
