import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/match/score_bug_theme.dart';

/// Which matches dress the 2D TV score bar in a tournament's colours: only
/// the finals of the World Championship and of each continental
/// championship.
void main() {
  test('every World Championship finals round is the gold theme', () {
    for (final r in ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL']) {
      for (final c in [...Confederation.values, null]) {
        expect(
          ScoreBugTheme.kindFor(r, c),
          ScoreBugThemeKind.worldChampionship,
          reason: '$r $c',
        );
      }
    }
  });

  test('a continental finals round takes its confederation', () {
    const expected = {
      Confederation.europe: ScoreBugThemeKind.europe,
      Confederation.southAmerica: ScoreBugThemeKind.southAmerica,
      Confederation.africa: ScoreBugThemeKind.africa,
      Confederation.asia: ScoreBugThemeKind.asia,
      Confederation.northAmerica: ScoreBugThemeKind.northAmerica,
      Confederation.oceania: ScoreBugThemeKind.oceania,
    };
    for (final r in ['CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL']) {
      for (final e in expected.entries) {
        expect(ScoreBugTheme.kindFor(r, e.key), e.value, reason: '$r');
      }
      expect(ScoreBugTheme.kindFor(r, null), isNull);
    }
  });

  test('qualifiers, friendlies, play-offs, Nations Cups and the Clash stay '
      'silver', () {
    for (final r in <String?>[
      null,
      'CQ',
      'FRIENDLY',
      'POSF',
      'POFINAL',
      'NL',
      'NGROUP',
      'NR16',
      'NQF',
      'NSF',
      'NFINAL',
      'FFINAL',
    ]) {
      expect(
        ScoreBugTheme.kindFor(r, Confederation.europe),
        isNull,
        reason: '$r',
      );
      expect(ScoreBugTheme.forRound(r, Confederation.europe), isNull);
    }
  });

  test('every kind has its theme, with the approved colours', () {
    for (final k in ScoreBugThemeKind.values) {
      expect(ScoreBugTheme.all[k]?.kind, k);
    }
    final wc = ScoreBugTheme.all[ScoreBugThemeKind.worldChampionship]!;
    expect(wc.score.first.toARGB32(), 0xFFFBE7A6);
    expect(wc.scoreText.toARGB32(), 0xFF1C1405);
    expect(wc.rim?.toARGB32(), 0xFFC9972F);
    expect(wc.clockText.toARGB32(), 0xFFF3D27A);
    final na = ScoreBugTheme.all[ScoreBugThemeKind.northAmerica]!;
    expect(na.divider?.toARGB32(), 0xFFC8102E);
  });
}
