import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/ranking/elo.dart';

/// What a result is worth. The reported complaint is that a World Cup run did
/// not move a nation the way a tournament should, while a single ordinary
/// match swung the table about.
void main() {
  test('a World Cup run outweighs any run of ordinary results', () {
    expect(Elo.finalsSettled, greaterThan(Elo.finals * 2));
  });

  test('a single match matters less next to a tournament', () {
    // The complaint was the RATIO, not the scale: the cups came down rather
    // than the qualifier, which has a floor of its own (see [Elo.qualifier] —
    // below 16 a favoured qualifying win stops being worth a world place).
    expect(Elo.nationsCup, lessThan(10));
    expect(Elo.finals, lessThan(30));
    expect(Elo.finalsSettled / Elo.qualifier, greaterThan(4));
  });

  test('the order of importance is unchanged', () {
    expect(Elo.friendly, lessThan(Elo.nationsCup));
    expect(Elo.nationsCup, lessThan(Elo.qualifier));
    expect(Elo.qualifier, lessThan(Elo.finals));
    expect(Elo.finals, lessThan(Elo.finalsSettled));
  });

  test('an expected friendly win still moves the table', () {
    // The documented floor: below roughly K=4 an expected friendly win rounds
    // to zero and the table looks frozen.
    final delta = Elo.homeDelta(
      homePoints: Elo.base + 100,
      awayPoints: Elo.base,
      homeScore: 2,
      awayScore: 0,
      weight: Elo.friendly,
    );
    expect(delta, greaterThan(0));
  });

  test('a beaten favourite still loses points in a friendly', () {
    final delta = Elo.homeDelta(
      homePoints: Elo.base + 100,
      awayPoints: Elo.base,
      homeScore: 0,
      awayScore: 1,
      weight: Elo.friendly,
    );
    expect(delta, lessThan(0));
  });

  test('winning the World Cup outweighs a season of qualifiers', () {
    // Six wins over comparable sides in qualifying, against one deep run
    // settled at the tournament weight.
    int move(double weight) => Elo.homeDelta(
      homePoints: Elo.base,
      awayPoints: Elo.base,
      homeScore: 1,
      awayScore: 0,
      weight: weight,
    );
    expect(move(Elo.finalsSettled), greaterThan(move(Elo.qualifier) * 4));
  });
}
