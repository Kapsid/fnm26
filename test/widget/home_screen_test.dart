import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/pump_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders title and primary actions', (tester) async {
      await tester.pumpApp(const HomeScreen());

      expect(find.text('Football Nations\nManager'), findsOneWidget);
      expect(find.widgetWithText(PrimaryButton, 'New Game'), findsOneWidget);
      expect(find.widgetWithText(PrimaryButton, 'Continue'), findsOneWidget);
    });
  });
}
