import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/match/score_bug_theme.dart';

/// Which matches dress the header strip and the 2D TV score bar: only the
/// finals of the World Championship and of each continental championship.
/// Every final is gold, every third-place match bronze, every other finals
/// round its tournament's own colours.
void main() {
  const own = {
    Confederation.europe: ScoreBugThemeKind.europe,
    Confederation.southAmerica: ScoreBugThemeKind.southAmerica,
    Confederation.africa: ScoreBugThemeKind.africa,
    Confederation.asia: ScoreBugThemeKind.asia,
    Confederation.northAmerica: ScoreBugThemeKind.northAmerica,
    Confederation.oceania: ScoreBugThemeKind.oceania,
  };

  test('the World Championship: group own colours, final gold, third '
      'place bronze', () {
    for (final c in [...Confederation.values, null]) {
      expect(
        ScoreBugTheme.kindFor('GROUP', c),
        ScoreBugThemeKind.worldChampionship,
      );
      expect(ScoreBugTheme.kindFor('FINAL', c), ScoreBugThemeKind.finalGold);
      expect(ScoreBugTheme.kindFor('3RD', c), ScoreBugThemeKind.bronze);
    }
    for (final r in ['R32', 'R16', 'QF', 'SF']) {
      expect(
        ScoreBugTheme.kindFor(r, Confederation.asia),
        ScoreBugThemeKind.worldChampionship,
      );
    }
  });

  test('each continental cup: group own colours, final gold, third place '
      'bronze', () {
    for (final e in own.entries) {
      expect(ScoreBugTheme.kindFor('CGROUP', e.key), e.value, reason: '$e');
      expect(
        ScoreBugTheme.kindFor('CFINAL', e.key),
        ScoreBugThemeKind.finalGold,
        reason: '$e',
      );
      expect(
        ScoreBugTheme.kindFor('C3RD', e.key),
        ScoreBugThemeKind.bronze,
        reason: '$e',
      );
      for (final r in ['CR16', 'CQF', 'CSF']) {
        expect(ScoreBugTheme.kindFor(r, e.key), e.value, reason: '$r $e');
      }
    }
    for (final r in ['CGROUP', 'CFINAL', 'C3RD']) {
      expect(ScoreBugTheme.kindFor(r, null), isNull);
    }
  });

  test('every Continental Clash match wears the Clash violet', () {
    for (final c in <Confederation?>[null, ...Confederation.values]) {
      expect(
        ScoreBugTheme.kindFor('FFINAL', c),
        ScoreBugThemeKind.continentalClash,
      );
      expect(
        ScoreBugTheme.forRound('FFINAL', c)?.accent.toARGB32(),
        0xFFC7A8FF,
      );
    }
  });

  test('Nations Cups wear their own colours, and their final gold', () {
    for (final r in ['NL', 'NGROUP', 'NR16', 'NQF', 'NSF']) {
      for (final c in Confederation.values) {
        expect(
          ScoreBugTheme.kindFor(r, c),
          ScoreBugThemeKind.nationsCup,
          reason: '$r $c',
        );
      }
    }
    for (final c in Confederation.values) {
      expect(ScoreBugTheme.kindFor('NFINAL', c), ScoreBugThemeKind.finalGold);
    }
  });

  test('qualifiers, friendlies and play-offs stay silver', () {
    for (final r in <String?>[null, 'CQ', 'FRIENDLY', 'POSF', 'POFINAL']) {
      for (final c in Confederation.values) {
        expect(ScoreBugTheme.kindFor(r, c), isNull, reason: '$r $c');
        expect(ScoreBugTheme.forRound(r, c), isNull);
      }
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
    // Every final wears the World Championship's gold.
    final gold = ScoreBugTheme.all[ScoreBugThemeKind.finalGold]!;
    expect(gold.score, wc.score);
    expect(gold.plates, wc.plates);
    expect(gold.rim, wc.rim);
    final bronze = ScoreBugTheme.all[ScoreBugThemeKind.bronze]!;
    expect(
      bronze.score.map((c) => c.toARGB32()),
      [0xFFF0C9A0, 0xFFB87333, 0xFF8A5524],
    );
    final na = ScoreBugTheme.all[ScoreBugThemeKind.northAmerica]!;
    expect(na.divider?.toARGB32(), 0xFFC8102E);
  });
}
