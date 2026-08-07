import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';

void main() {
  group('TrainingCamps', () {
    test('every host offers a full list of camps, real cities or not', () {
      for (final hostId in [1, 7, 42, 199]) {
        expect(
          TrainingCamps.forHost(hostId: hostId),
          hasLength(TrainingCamps.count),
          reason: 'host $hostId must always have somewhere to stay',
        );
      }
      expect(
        TrainingCamps.forHost(hostId: 5, cities: const ['Praha', 'Brno']),
        hasLength(TrainingCamps.count),
      );
    });

    test('a host always offers the same camps', () {
      final a = TrainingCamps.forHost(hostId: 12);
      final b = TrainingCamps.forHost(hostId: 12);
      expect(a.map((c) => c.name).toList(), b.map((c) => c.name).toList());
      expect(a.map((c) => c.terrain).toList(), b.map((c) => c.terrain).toList());
    });

    test('the national centre is always the first, safe option', () {
      for (final hostId in [3, 21, 88]) {
        expect(
          TrainingCamps.forHost(hostId: hostId).first.terrain,
          CampTerrain.nationalCentre,
        );
      }
    });

    test('camps are real trades, not one strictly better than the rest', () {
      final camps = TrainingCamps.forHost(hostId: 9);
      // Nothing may be best at everything: whatever a camp gives on one axis it
      // gives up on another, or the choice is not a choice.
      for (final c in camps) {
        final beatsAll = camps.where((o) => o.index != c.index).every(
          (o) =>
              c.travelFatigue <= o.travelFatigue &&
              c.injuryRecovery >= o.injuryRecovery &&
              c.conditionBonus >= o.conditionBonus,
        );
        expect(beatsAll, isFalse, reason: '${c.name} dominates every other');
      }
    });

    test('an unset or stale index falls back to the national centre', () {
      final camps = TrainingCamps.forHost(hostId: 4);
      expect(TrainingCamps.resolve(hostId: 4).index, camps.first.index);
      expect(TrainingCamps.resolve(hostId: 4, index: 99).index, 0);
      expect(TrainingCamps.resolve(hostId: 4, index: -1).index, 0);
      expect(TrainingCamps.resolve(hostId: 4, index: 2).index, 2);
    });

    test('the mountain camp is the one that clears knocks fastest', () {
      final mountain = TrainingCamps.profileOf(CampTerrain.mountain);
      for (final t in CampTerrain.values) {
        if (t == CampTerrain.mountain) continue;
        expect(
          mountain.recovery,
          greaterThan(TrainingCamps.profileOf(t).recovery),
        );
      }
      // …and it costs travel to get it.
      expect(mountain.travel, greaterThan(1));
    });

    test('a city base is the one with no travel', () {
      final city = TrainingCamps.profileOf(CampTerrain.cityCentre);
      expect(city.travel, lessThan(1));
      // Paid for in the squad's peace of mind.
      expect(city.condition, lessThan(0));
    });
  });
}
