import 'package:fnm/domain/entities/nation.dart';

/// How much of a ground the travelling support fills, 0.03 to 0.45.
///
/// Nations carry no coordinates, so callers that have no real distance use
/// [proxyDistanceKm]: the same confederation counts as near (600 km), any
/// other as far (6000 km).
abstract final class AwayFanShare {
  static const double min = 0.03;
  static const double max = 0.45;
  static const double neighbourKm = 800;
  static const int bigNationRank = 20;

  /// Distance stand-in: same confederation is near, otherwise far.
  static double proxyDistanceKm(Nation home, Nation away) =>
      home.confederation == away.confederation ? 600 : 6000;

  static double estimate({
    required Nation home,
    required Nation away,
    required bool neutral,
    required bool tournament,
    required double distanceKm,
  }) {
    // How well each side travels: big nations bring more.
    double following(Nation n) => n.ranking <= bigNationRank ? 1.3 : 1.0;
    if (neutral) {
      final h = following(home), a = following(away);
      final share = a / (h + a);
      return (tournament ? share + 0.02 : share).clamp(0.35, 0.65);
    }
    var s = 0.08;
    if (distanceKm < neighbourKm) s += 0.10;
    if (distanceKm > 4000) s -= 0.03;
    if (away.ranking <= bigNationRank) s += 0.06;
    if (tournament) s += 0.08;
    return s.clamp(min, max);
  }
}
