import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

void main() {
  testWidgets('every standing has its own words', (tester) async {
    late AppLocalizations l;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l = AppLocalizations.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    final labels = {
      for (final s in ClubStanding.values) clubStandingLabel(l, s),
    };
    expect(
      labels,
      hasLength(ClubStanding.values.length),
      reason: 'two standings read the same, so the badge says nothing',
    );
  });
}
