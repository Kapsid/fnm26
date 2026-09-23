import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

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

      expect(find.text('Football Nations\nManager'), findsOneWidget);
      expect(find.widgetWithText(PrimaryButton, 'New Game'), findsOneWidget);
      // With no save yet, the secondary action opens the (empty) saves list.
      expect(find.text('Load game'), findsOneWidget);
    });
  });
}
