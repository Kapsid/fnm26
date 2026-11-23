import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Promo-reel run, 2026-11: Nigeria went out of a 48-team World
/// Championship in the round of 32 and the board's verdict said they reached
/// the round of 16. The ladder files both under one rung (3, the knockout
/// rounds); the wording now says which round the run really ended in.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  const me = 7;
  var id = 0;
  Fixture fx(String round, {int home = me, int away = 9}) => Fixture(
    id: ++id,
    careerId: 1,
    competitionId: 3,
    matchday: 1,
    date: DateTime(2030, 6, 1).add(Duration(days: id)),
    homeNationId: home,
    awayNationId: away,
    homeScore: 0,
    awayScore: 1,
    round: round,
    played: true,
  );

  test('a round-of-32 exit is read as one', () {
    final out = [fx('GROUP'), fx('GROUP'), fx('GROUP'), fx('R32')];
    expect(endedAtRoundOf32(out, me), isTrue);
    expect(worldFinishOrdinal(out, me), 3);
    expect(
      objectiveFinishText(en, TournamentTier.world, 3, roundOf32: true),
      'Round of 32',
    );
  });

  test('reaching the round of 16 is not', () {
    final out = [fx('GROUP'), fx('R32'), fx('R16')];
    expect(endedAtRoundOf32(out, me), isFalse);
    expect(
      objectiveFinishText(en, TournamentTier.world, 3),
      'Round of 16',
    );
  });

  test("other sides' round-of-32 ties do not count", () {
    expect(endedAtRoundOf32([fx('R32', home: 4, away: 5)], me), isFalse);
  });

  test('only the World Championship knockout rung is reworded', () {
    expect(
      objectiveFinishKey(TournamentTier.world, 4, roundOf32: true),
      MsgKey.finishQuarterFinals,
    );
    expect(
      objectiveFinishKey(TournamentTier.continental, 3, roundOf32: true),
      MsgKey.finishRoundOf16,
    );
  });
}
