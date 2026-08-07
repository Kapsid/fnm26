import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';

Player _p({
  required int id,
  required int age,
  required int overall,
  PlayerPosition position = PlayerPosition.cm,
}) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  position: position,
  age: age,
  club: 'C',
  attributes: PlayerAttributes(
    physical: overall,
    technical: overall,
    stamina: overall,
  ),
);

void main() {
  test('seniority and standing both count toward leadership', () {
    final kid = _p(id: 1, age: 19, overall: 62);
    final senior = _p(id: 2, age: 31, overall: 84);
    expect(
      Captaincy.leadership(senior),
      greaterThan(Captaincy.leadership(kid)),
      reason: 'a dressing room follows someone established',
    );
  });

  test('leadership is bounded to its 0-10 scale', () {
    for (final p in [
      _p(id: 1, age: 16, overall: 40),
      _p(id: 2, age: 40, overall: 99),
      _p(id: 3, age: 28, overall: 75),
    ]) {
      expect(Captaincy.leadership(p), inInclusiveRange(0, 10));
    }
  });

  test('no captain is worth no morale, and a captain is never a penalty', () {
    expect(Captaincy.moraleBonus(null), 0);
    for (var age = 17; age <= 38; age++) {
      for (final overall in [45, 65, 85, 99]) {
        final bonus = Captaincy.moraleBonus(
          _p(id: age * 100 + overall, age: age, overall: overall),
        );
        expect(bonus, inInclusiveRange(0, Captaincy.maxMoraleBonus));
      }
    }
  });

  test('a strong candidate is worth more morale than a weak one', () {
    final weak = Captaincy.moraleBonus(_p(id: 1, age: 19, overall: 60));
    final strong = Captaincy.moraleBonus(_p(id: 2, age: 32, overall: 88));
    expect(strong, greaterThan(weak));
  });

  test('the shortlist is ordered by leadership, not by rating', () {
    final squad = [
      _p(id: 1, age: 20, overall: 90), // the best player, but a kid
      _p(id: 2, age: 33, overall: 78), // the old head
      _p(id: 3, age: 24, overall: 70),
    ];
    final list = Captaincy.shortlist(squad, limit: 3);
    expect(list.first.id, 2, reason: 'the senior pro leads the shortlist');
    expect(list, hasLength(3));
  });

  test('the shortlist honours its limit', () {
    final squad = [
      for (var i = 0; i < 20; i++) _p(id: i, age: 25, overall: 70 + i % 10),
    ];
    expect(Captaincy.shortlist(squad).length, 5);
    expect(Captaincy.shortlist(squad, limit: 2).length, 2);
  });

  test('fit tiers move with leadership', () {
    expect(Captaincy.fit(_p(id: 1, age: 18, overall: 50)),
        CaptainFit.unproven);
    expect(
      Captaincy.fit(_p(id: 2, age: 34, overall: 90)).index,
      lessThan(CaptainFit.unproven.index),
      reason: 'a senior star is a better fit than an unproven one',
    );
  });
}
