import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/match_officials.dart';
import 'package:fnm/features/match/pitch/var_check_overlay.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// The 2D TV's video referee caption: "VAR check" while he looks, then the
/// call, then nothing.

VarCheckShow _show(VarReview review) => VarCheckShow(
  eventIndex: 0,
  shot: const ShotMoment(
    minute: 30,
    stoppage: 0,
    seq: 0,
    teamNationId: 1,
    shooterId: 9,
    zone: PitchZone.boxCentre,
    xg: 0.3,
    outcome: ShotOutcome.goal,
    origin: ShotOrigin.openPlay,
  ),
  review: review,
  goalAt: 10,
  checkFrom: 11,
  decisionAt: 14,
  until: 16,
  goalX: 105,
);

void main() {
  final en = AppLocalizationsEn();

  for (final (review, call) in [
    (VarReview.confirmed, en.pitchVarConfirmed),
    (VarReview.offside, en.pitchVarDisallowedOffside),
    (VarReview.foul, en.pitchVarDisallowedFoul),
  ]) {
    testWidgets('the check, then "$call", then nothing', (tester) async {
      final clock = ValueNotifier(const Duration(seconds: 5));
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VarCheckOverlay(checks: [_show(review)], clock: clock),
          ),
        ),
      );
      expect(find.byKey(varCheckOverlayKey), findsNothing);
      clock.value = const Duration(seconds: 12);
      await tester.pump();
      expect(find.text(en.pitchVarCheck), findsOneWidget);
      clock.value = const Duration(seconds: 15);
      await tester.pump();
      expect(find.text(call), findsOneWidget);
      clock.value = const Duration(seconds: 17);
      await tester.pump();
      expect(find.byKey(varCheckOverlayKey), findsNothing);
    });
  }
}
