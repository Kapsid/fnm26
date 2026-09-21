import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

Player at(int overall, {required int id, required int age}) => player(
  id: id,
  nationId: 7,
  position: PlayerPosition.cm,
  age: age,
  attributes: flatAttributes(overall),
);

void main() {
  test('probe2 step direction', () {
    for (final ov in [86, 80, 74, 66]) {
      var up = 0, down = 0, side = 0;
      for (final seed in [3, 17, 31, 64, 99]) {
        for (var i = 0; i < 120; i++) {
          final id = 4000 + i * 7;
          String? prevKey;
          int? prevTier;
          for (var age = 18; age < 34; age++) {
            final c = ClubService.clubForSeed(
              at(ov, id: id, age: age),
              seed,
              homeCode: 'bra',
              homeCities: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
            );
            final key = '${c.name}|${c.country}';
            final tier = ClubService.tierOfCountry(c.country);
            if (prevKey != null && prevKey != key) {
              final step = prevTier!.compareTo(tier);
              if (step > 0) {
                up++;
              } else if (step < 0) {
                down++;
              } else {
                side++;
              }
            }
            prevKey = key;
            prevTier = tier;
          }
        }
      }
      final total = up + down + side;
      // ignore: avoid_print
      print('PROBE2 ov=$ov moves=$total up=${(100*up/total).round()}% down=${(100*down/total).round()}% side=${(100*side/total).round()}%');
    }
  });
}
