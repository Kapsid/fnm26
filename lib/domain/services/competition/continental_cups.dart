import 'package:fnm/domain/entities/enums.dart';

/// Configuration for the continental championships: the app's tournament name,
/// the knockout bracket size, and the (real-world) month the finals are played
/// — June for the European/American summers, January for AFCON and the Asian
/// Cup. The finals year is always two before the World Cup.
abstract final class ContinentalCups {
  static const byConfederation =
      <Confederation, ({String name, int size, int month})>{
    Confederation.europe: (name: 'European Championship', size: 16, month: 6),
    Confederation.southAmerica: (name: 'South America Cup', size: 8, month: 6),
    Confederation.africa: (name: 'African Championship', size: 16, month: 1),
    Confederation.asia: (name: 'Asian Championship', size: 16, month: 1),
    Confederation.northAmerica: (name: 'North America Cup', size: 8, month: 6),
  };
}
