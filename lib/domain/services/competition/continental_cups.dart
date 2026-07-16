import 'package:fnm/domain/entities/enums.dart';

/// Configuration for the continental championships: the app's tournament name,
/// the knockout bracket `size`, the (real-world) `month` the finals are played
/// — June for the European/American summers, January for AFCON and the Asian
/// Cup — and whether the cup is reached via a `qualifying` group stage. The
/// finals year is always two before the World Cup.
///
/// `qualifying: false` mirrors the Copa América, where the whole confederation
/// takes part with no separate qualifying campaign; the finals field is seeded
/// straight from the confederation ranking.
abstract final class ContinentalCups {
  static const byConfederation =
      <Confederation, ({String name, int size, int month, bool qualifying})>{
    Confederation.europe:
        (name: 'European Championship', size: 24, month: 6, qualifying: true),
    Confederation.southAmerica:
        (name: 'South America Cup', size: 8, month: 6, qualifying: false),
    Confederation.africa:
        (name: 'African Championship', size: 16, month: 1, qualifying: true),
    Confederation.asia:
        (name: 'Asian Championship', size: 16, month: 1, qualifying: true),
    Confederation.northAmerica:
        (name: 'North America Cup', size: 8, month: 6, qualifying: true),
    Confederation.oceania:
        (name: 'Oceania Cup', size: 8, month: 6, qualifying: true),
  };
}
