import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// A squad is named for an international WINDOW — the two matches a country
/// plays in one gathering — and lives for exactly that. The campaign used to
/// re-open the squad every four matchdays, so a manager named one side and kept
/// it through four or six qualifiers spread over half a year, which nobody does.
void main() {
  Fixture qualifier(int id, int matchday, {bool played = false}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    homeNationId: 1,
    awayNationId: 2,
    date: DateTime(2026, 9 + matchday),
    matchday: matchday,
    played: played,
    homeScore: played ? 1 : null,
    awayScore: played ? 0 : null,
  );

  test('a qualifying window is two matches, not four', () {
    final campaign = [for (var md = 1; md <= 8; md++) qualifier(md, md)];
    final period = Nomination.currentPeriod(campaign);

    expect(period, hasLength(2));
    expect(period.map((f) => f.matchday), [1, 2]);
  });

  test('every window through a campaign opens its own nomination', () {
    final campaign = [for (var md = 1; md <= 8; md++) qualifier(md, md)];
    final opens = [
      for (var i = 0; i < campaign.length; i++)
        if (Nomination.isPeriodStart(
          campaign[i],
          i == 0 ? null : campaign[i - 1],
        ))
          campaign[i].matchday,
    ];
    // Four gatherings across an eight-match campaign.
    expect(opens, [1, 3, 5, 7]);
  });

  test('the squad holds inside a window', () {
    // Matchday 1 played, matchday 2 still to come: no new nomination, because
    // the side named for this gathering is the side that plays both matches.
    final campaign = [
      qualifier(1, 1, played: true),
      qualifier(2, 2),
      qualifier(3, 3),
    ];
    expect(Nomination.windowOpen(campaign), isFalse);
    expect(Nomination.currentPeriod(campaign).map((f) => f.matchday), [2]);
  });

  test('the next gathering opens a fresh one', () {
    final campaign = [
      qualifier(1, 1, played: true),
      qualifier(2, 2, played: true),
      qualifier(3, 3),
      qualifier(4, 4),
    ];
    expect(Nomination.windowOpen(campaign), isTrue);
    expect(Nomination.currentPeriod(campaign).map((f) => f.matchday), [3, 4]);
  });
}
