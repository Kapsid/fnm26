import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// A qualifier and a final must not read the same.
///
/// Continental qualifying used to answer "Continental Cup" — the heading the
/// cup itself carries — so on the hub a Euro qualifier and the Euro final were
/// written identically, and the word "qualifying" appeared on neither.
void main() {
  final AppLocalizations l = AppLocalizationsEn();

  test('continental qualifying is named as qualifying', () {
    expect(MatchStage.category(l, 'CQ'), isNot(MatchStage.category(l, 'CGROUP')));
    expect(MatchStage.category(l, 'CQ'), isNot(MatchStage.category(l, 'CFINAL')));
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
    expect(MatchStage.label(l, qualifier), isNot(MatchStage.label(l, finalTie)));
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
}
