import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
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

  group('labelTiny', () {
    final AppLocalizations cs = AppLocalizationsCs();
    Fixture at(String? round, {int matchday = 1}) => Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: matchday,
      date: DateTime(2030, 6),
      homeNationId: 1,
      awayNationId: 2,
      round: round,
    );

    // Every round code a fixture is stored under, with what it reads as in
    // English and in Czech for a European side.
    const expected = <String?, (String, String)>{
      null: ('WC Q · MD 3', 'MS kv. · 3. kolo'),
      'CQ': ('EC Q · MD 3', 'ME kv. · 3. kolo'),
      'FRIENDLY': ('Friendly', 'přát.'),
      'FFINAL': ('Clash', 'Souboj'),
      'GROUP': ('WC', 'MS'),
      'R32': ('WC · R32', 'MS · 1/16'),
      'R16': ('WC · R16', 'MS · osmif.'),
      'QF': ('WC · QF', 'MS · čtvrtf.'),
      'SF': ('WC · SF', 'MS · semif.'),
      '3RD': ('WC · 3rd pl.', 'MS · o 3. m.'),
      'FINAL': ('WC · Final', 'MS · finále'),
      'CGROUP': ('EC', 'ME'),
      'CR16': ('EC · R16', 'ME · osmif.'),
      'CQF': ('EC · QF', 'ME · čtvrtf.'),
      'CSF': ('EC · SF', 'ME · semif.'),
      'C3RD': ('EC · 3rd pl.', 'ME · o 3. m.'),
      'CFINAL': ('EC · Final', 'ME · finále'),
      'NL': ('NC', 'PN'),
      'NGROUP': ('NC', 'PN'),
      'NR16': ('NC · R16', 'PN · osmif.'),
      'NQF': ('NC · QF', 'PN · čtvrtf.'),
      'NSF': ('NC · SF', 'PN · semif.'),
      'NFINAL': ('NC · Final', 'PN · finále'),
      'POSF': ('PO · SF', 'baráž · semif.'),
      'POFINAL': ('PO · Final', 'baráž · finále'),
    };

    for (final e in expected.entries) {
      test('${e.key ?? 'qualifier'} reads short in both languages', () {
        final f = at(e.key, matchday: 3);
        expect(
          MatchStage.labelTiny(l, f, Confederation.europe),
          e.value.$1,
        );
        expect(
          MatchStage.labelTiny(cs, f, Confederation.europe),
          e.value.$2,
        );
      });
    }

    test('every continent names its own cup, and no two the same', () {
      for (final loc in [l, cs]) {
        final cups = {
          for (final c in Confederation.values)
            MatchStage.labelTiny(loc, at('CGROUP'), c),
        };
        expect(cups, hasLength(Confederation.values.length));
        final quals = {
          for (final c in Confederation.values)
            MatchStage.labelTiny(loc, at('CQ'), c),
        };
        expect(quals, hasLength(Confederation.values.length));
      }
    });

    test('a tag is a few characters in every language', () async {
      for (final locale in AppLocalizations.supportedLocales) {
        final loc = await AppLocalizations.delegate.load(locale);
        for (final round in expected.keys) {
          for (final c in Confederation.values) {
            final parts = MatchStage.tinyParts(loc, at(round), c);
            for (final part in [parts.competition, ?parts.stage]) {
              expect(part.trim(), isNotEmpty);
              expect(
                part.length,
                lessThanOrEqualTo(18),
                reason: '"$part" (${locale.languageCode}) is not tiny',
              );
              expect(part, isNot(contains('—')));
            }
          }
        }
      }
    });
  });
}
