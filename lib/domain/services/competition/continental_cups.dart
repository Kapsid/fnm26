import 'package:fnm/domain/entities/enums.dart';

/// Configuration for the continental championships: the app's tournament name
/// and the knockout bracket size per confederation.
abstract final class ContinentalCups {
  static const byConfederation = <Confederation, ({String name, int size})>{
    Confederation.europe: (name: 'European Championship', size: 16),
    Confederation.southAmerica: (name: 'South America Cup', size: 8),
    Confederation.africa: (name: 'African Championship', size: 16),
    Confederation.asia: (name: 'Asian Championship', size: 16),
    Confederation.northAmerica: (name: 'North America Cup', size: 8),
  };
}
