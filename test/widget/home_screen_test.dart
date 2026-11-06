import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/home/home_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders title and primary actions', (tester) async {
      // No saves: the home screen offers New Game and a Load-game link.
      await tester.pumpApp(
        const HomeScreen(),
        overrides: [savesProvider.overrideWith((ref) async => const [])],
      );
      await tester.pump();

      expect(find.text('Football Nations Manager'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(HomeScreen.newGameKey),
          matching: find.text('New Game'),
        ),
        findsOneWidget,
      );
      // With no save yet, the secondary action opens the (empty) saves list.
      expect(find.text('Load game'), findsOneWidget);
      // A first launch has no continue card: the logo block has the room.
      expect(find.byKey(HomeScreen.heroKey), findsNothing);
      expect(find.byKey(HomeScreen.brandKey), findsOneWidget);
      // The three tiles, each a button.
      for (final key in [
        HomeScreen.savesKey,
        HomeScreen.campaignsKey,
        HomeScreen.editorKey,
        HomeScreen.settingsKey,
      ]) {
        expect(find.byKey(key), findsOneWidget);
      }
    });
  });
}
