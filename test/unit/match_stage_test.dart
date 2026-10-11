import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// A qualifier and a final must not read the same.
///
/// Continental qualifying used to answer "Continental Cup" — the heading the
/// cup itself carries — so on the hub a Euro qualifier and the Euro final were
/// written identically, and the word "qualifying" appeared on neither.
void main() {
  final AppLocalizations l = AppLocalizationsEn();

  test('continental qualifying is named as qualifying', () {
    expect(
      MatchStage.category(l, 'CQ'),
      isNot(MatchStage.category(l, 'CGROUP')),
    );
    expect(
      MatchStage.category(l, 'CQ'),
      isNot(MatchStage.category(l, 'CFINAL')),
    );
    expect(MatchStage.category(l, 'CQ').toLowerCase(), contains('qualifying'));
  });

  test('the banner tells a qualifier from the final it leads to', () {
    Fixture at(String round) => Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: 3,
      date: DateTime(2030, 6),
      homeNationId: 1,
      awayNationId: 2,
      round: round,
    );
    final qualifier = at('CQ');
    final finalTie = at('CFINAL');
    expect(
      MatchStage.label(l, qualifier),
      isNot(MatchStage.label(l, finalTie)),
    );
    expect(
      MatchStage.label(l, qualifier),
      contains(MatchStage.category(l, 'CQ').toUpperCase()),
    );
  });

  test('the other competitions keep their headings', () {
    expect(MatchStage.category(l, null), MatchStage.category(l, null));
    expect(MatchStage.category(l, 'NGROUP'), MatchStage.category(l, 'NFINAL'));
    expect(MatchStage.category(l, 'CGROUP'), MatchStage.category(l, 'CFINAL'));
  });

  test('a group game is just the competition, no stage', () {
    for (final round in ['GROUP', 'CGROUP', 'NGROUP']) {
      final f = Fixture(
        id: 1,
        careerId: 1,
        competitionId: 1,
        matchday: 2,
        date: DateTime(2030, 6),
        homeNationId: 1,
        awayNationId: 2,
        round: round,
      );
      expect(
        MatchStage.label(l, f),
        MatchStage.category(l, round).toUpperCase(),
      );
    }
  });

  test('every finals round has a stage name, never its raw code', () {
    // The African Finals Eight opens at 'NQF'; it used to fall through to the
    // raw code and read "NATIONS CUP · NQF" on every banner.
    // Read in Czech: an English stage can spell its own code ('FINAL'), a
    // fallthrough reads the raw code in every language.
    final AppLocalizations cs = AppLocalizationsCs();
    for (final round in {...FinalsRounds.all, 'NGROUP', 'NL'}) {
      final stage = MatchStage.stage(cs, round);
      expect(stage, isNot(round), reason: round);
      expect(stage.trim(), isNotEmpty, reason: round);
    }
    expect(MatchStage.stage(l, 'NQF'), MatchStage.stage(l, 'QF'));
  });
}
