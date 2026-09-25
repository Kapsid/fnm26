import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/messages/intake_report.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/fixtures.dart';

void main() {
  List<Player> pyramidOfAges(List<int> ages) => [
    for (var i = 0; i < ages.length; i++)
      player(
        id: 5000 + i,
        nationId: 1,
        name: 'Boy$i',
        position: PlayerPosition.cm,
        age: ages[i],
        attributes: flatAttributes(40 + i),
      ),
  ];

  group('intakeRows', () {
    test("takes this year's eleven-year-olds and nobody else", () {
      final rows = intakeRows(pyramidOfAges([11, 11, 12, 15, 20]));
      expect(rows, hasLength(2));
      expect(rows.every((r) => r.age == PlayerLifecycle.intakeAge), isTrue);
    });

    test('every boy is a newcomer with a scouting read and no change', () {
      final rows = intakeRows(pyramidOfAges([11, 11]));
      for (final r in rows) {
        expect(r.status, SquadDevStatus.arrived);
        expect(r.change, isNull, reason: 'there is nothing to compare with');
        expect(r.stars, isNotNull);
        expect(r.stars, inInclusiveRange(1, 5));
      }
    });

    test('an empty pyramid yields no rows rather than throwing', () {
      expect(intakeRows(const []), isEmpty);
    });
  });

  group('intakeNoteKey', () {
    final l = lookupAppLocalizations(const Locale('en'));
    String? note({
      required double academyBonus,
      required double standingBonus,
    }) {
      final key = intakeNoteKey(
        academyBonus: academyBonus,
        standingBonus: standingBonus,
      );
      // The key is what the message stores; the words are what this asserts
      // about, so it reads them the way the inbox does.
      return key == null ? null : renderMsgKey(l, MsgText(key));
    }

    test('says nothing when neither the academy nor the standing did', () {
      expect(note(academyBonus: 0, standingBonus: 0), isNull);
    });

    test('speaks up when the academy money reached this intake', () {
      final line = note(academyBonus: 0.04, standingBonus: 0);
      expect(line, isNotNull);
      expect(line, contains('academy'));
    });

    test("names the standing when the side's rise is what did it", () {
      final line = note(academyBonus: 0, standingBonus: 0.03);
      expect(line, isNotNull);
      expect(line, contains('ranking'));
      // Not a line about money that was never spent.
      expect(line, isNot(contains('investment')));
    });

    test('says both when both did', () {
      final line = note(academyBonus: 0.04, standingBonus: 0.03);
      expect(line, isNotNull);
      expect(line, contains('academy'));
      expect(line, contains('ranking'));
    });

    test('a negative pull is not reported as investment', () {
      // A sliding nation draws a NEGATIVE talent shift into its intake; that
      // is not the academy paying off and must not read as though it were.
      expect(note(academyBonus: -0.05, standingBonus: -0.02), isNull);
      // Nor does academy money cancelled out by a slide get announced.
      expect(
        intakeNoteKey(academyBonus: 0.03, standingBonus: -0.02),
        intakeNoteKey(academyBonus: 0.03, standingBonus: 0),
      );
    });
  });

  group('PlayerLifecycle.cycleOfIntake', () {
    test('maps an intake year to the cycle that funded it', () {
      expect(PlayerLifecycle.cycleOfIntake(0), 0);
      expect(PlayerLifecycle.cycleOfIntake(3), 0);
      expect(PlayerLifecycle.cycleOfIntake(4), 1);
      expect(PlayerLifecycle.cycleOfIntake(9), 2);
    });

    test('a backfilled year predates the save and draws nothing', () {
      expect(PlayerLifecycle.cycleOfIntake(-1), -1);
      expect(PlayerLifecycle.cycleOfIntake(-6), -1);
    });
  });
}
