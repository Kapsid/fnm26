import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/awards/poty_history.dart';

import 'seeded_save.dart' show realNations;

/// A history drawn with real nations (real flags), long names, the
/// manager's nation (the first) among the winners and the top fives.
PotyHistory fakePotyHistory() {
  final n = realNations.take(6).toList();
  PotyHistoryPlayer p(int id, Nation nation, String name, {int age = 26}) => (
    playerId: id,
    nationId: nation.id,
    name: name,
    nationCode: nation.code.toLowerCase(),
    position: PlayerPosition.values[id % PlayerPosition.values.length],
    age: age,
  );
  final a = p(1, n[1], 'Konstantinos Papadopoulos-Karamanlis', age: 27);
  final b = p(2, n[0], 'Bartholomew Featherstonehaugh');
  final c = p(3, n[2], 'Jean-Baptiste Montgomery-Laurent');
  final d = p(4, n[3], 'Ilkka Kivimäki-Häkkinen', age: 30);
  final y1 = p(5, n[4], 'Mateusz Wiśniewski', age: 19);
  final y2 = p(6, n[0], 'Miguel Ángel Rodríguez', age: 20);
  PotyHistoryYear year(
    int y,
    PotyHistoryPlayer best,
    PotyHistoryPlayer? young,
    List<PotyHistoryPlayer> rest,
  ) => (
    year: y,
    best: best,
    young: young,
    topFive: [
      (rank: 1, player: best),
      for (final (i, r) in rest.indexed) (rank: i + 2, player: r),
    ],
  );
  return PotyHistory.build([
    // An old save's year: winners only, no top five.
    (year: 2026, best: c, young: null, topFive: const []),
    year(2027, a, y1, [b, c, d]),
    year(2028, b, y2, [a, d]),
    year(2029, a, y1, [c, b]),
    year(2030, d, y2, [a, b, c]),
  ], ownNationId: n[0].id);
}
