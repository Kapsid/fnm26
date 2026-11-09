import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/features/player/club_history_card.dart';
import 'package:fnm/features/player/club_history_providers.dart';
import 'package:fnm/shared/widgets/club_stars.dart';

import '../helpers/pump_app.dart';

/// A one-club player used to get NO club history section at all, on the
/// reasoning that a single spell only repeats the club named at the top of the
/// card. What that actually read as, on the device, was a player whose
/// transfers the game refused to show — the section was simply missing, with
/// nothing to say it was missing on purpose.
void main() {
  const arg = (careerId: 1, playerId: 42);

  Override withSpells(List<ClubSpell> spells) =>
      clubHistoryProvider(arg).overrideWith((ref) async => spells);

  testWidgets('a player who has never moved still gets the section', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: ClubHistoryCard(careerId: 1, playerId: 42)),
      overrides: [
        withSpells(const [
          (
            club: 'Prague Green',
            country: 'cze',
            fromYear: 2026,
            toYear: 2029,
            stars: 0,
          ),
        ]),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Prague Green'), findsOneWidget);
  });

  testWidgets('a player who moved lists both clubs, newest first', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: ClubHistoryCard(careerId: 1, playerId: 42)),
      overrides: [
        withSpells(const [
          (
            club: 'Prague Green',
            country: 'cze',
            fromYear: 2026,
            toYear: 2028,
            stars: 0,
          ),
          (
            club: 'Man Blue',
            country: 'eng',
            fromYear: 2029,
            toYear: 2031,
            stars: 0,
          ),
        ]),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Man Blue'), findsOneWidget);
    expect(find.text('Prague Green'), findsOneWidget);
  });

  testWidgets('a player with no derived spells shows nothing', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: ClubHistoryCard(careerId: 1, playerId: 42)),
      overrides: [withSpells(const [])],
    );
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('the history rows carry no stars: the current club shows them above', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpApp(
      const Scaffold(body: ClubHistoryCard(careerId: 1, playerId: 42)),
      overrides: [
        withSpells(const [
          (
            club: 'Prague Green',
            country: 'cze',
            fromYear: 2026,
            toYear: 2028,
            stars: 2,
          ),
          (
            club: 'Man Blue',
            country: 'eng',
            fromYear: 2029,
            toYear: 2031,
            stars: 5,
          ),
        ]),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Man Blue'), findsOneWidget);
    expect(find.byType(ClubStars), findsNothing);
    semantics.dispose();
  });

  testWidgets('no stars for a club whose strength is not known', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: ClubStars(0)),
    );
    expect(find.byType(Icon), findsNothing);
  });
}
