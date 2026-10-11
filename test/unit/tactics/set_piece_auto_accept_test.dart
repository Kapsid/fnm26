import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The rule behind "leave the takers to the coach", stated as the warning
/// itself states it.
///
/// A tester was asked to change his set-piece takers after almost every match
/// with an unchanged side. The strip warned whenever nobody was named, and
/// naming nobody is a legitimate way to play: the code said so in a comment
/// and had no way to hear it said back.
///
/// The acknowledgement holds ONLY while nobody is named. That is the part
/// worth pinning: a manager who later picks a taker and then loses him to a
/// ban has to be told, and an old "leave it" must not swallow that.
bool warningSilenced({
  required int? penalty,
  required int? deadBall,
  required bool acceptedAuto,
  required bool penaltyAvailable,
  required bool deadBallAvailable,
}) =>
    (penalty == null && deadBall == null && acceptedAuto) ||
    (penaltyAvailable && deadBallAvailable);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('nobody named and nothing said: the manager is warned', () {
    expect(
      warningSilenced(
        penalty: null,
        deadBall: null,
        acceptedAuto: false,
        penaltyAvailable: false,
        deadBallAvailable: false,
      ),
      isFalse,
    );
  });

  test('nobody named and "leave it to the coach": silent for good', () {
    expect(
      warningSilenced(
        penalty: null,
        deadBall: null,
        acceptedAuto: true,
        penaltyAvailable: false,
        deadBallAvailable: false,
      ),
      isTrue,
    );
  });

  test('a named taker who cannot play is reported, acknowledgement or not', () {
    // He said "leave it" in 2028 and named a penalty taker in 2031. That man
    // is now banned. The old acknowledgement must not cover for him.
    expect(
      warningSilenced(
        penalty: 7,
        deadBall: null,
        acceptedAuto: true,
        penaltyAvailable: false,
        deadBallAvailable: false,
      ),
      isFalse,
      reason: 'naming somebody is a change of mind',
    );
  });

  test('both named and both available: silent, as it always was', () {
    expect(
      warningSilenced(
        penalty: 7,
        deadBall: 9,
        acceptedAuto: false,
        penaltyAvailable: true,
        deadBallAvailable: true,
      ),
      isTrue,
    );
  });

  test('the acknowledgement survives a reload', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('set_piece_auto_v1:3', true);

    final again = await SharedPreferences.getInstance();
    expect(again.getBool('set_piece_auto_v1:3'), isTrue);
    expect(
      again.getBool('set_piece_auto_v1:4'),
      isNull,
      reason: 'the choice is per career, not per app',
    );
  });
}
