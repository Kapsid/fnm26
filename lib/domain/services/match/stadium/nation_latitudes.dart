import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Roughly how far north (positive) or south (negative) each nation plays,
/// in degrees: the latitude of its capital or main football city, to one
/// decimal. It decides how light the sky is at kick-off (see `Daylight`).
///
/// Keyed by the nation's code, so every nation is covered whatever its id,
/// the dormant ones (Greenland, Zanzibar, Belarus) included. A nation with
/// no row (one made in the world editor) falls back to its confederation's
/// [_byConfederation] figure.
abstract final class NationLatitudes {
  static double of(Nation n) => ofCode(n.code, n.confederation);

  /// The latitude of a ground in the country [code], of [confederation].
  static double ofCode(String code, Confederation confederation) =>
      table[code.toUpperCase()] ?? _byConfederation[confederation]!;

  static const Map<Confederation, double> _byConfederation = {
    Confederation.europe: 48.0,
    Confederation.southAmerica: -15.0,
    Confederation.northAmerica: 18.0,
    Confederation.africa: 5.0,
    Confederation.asia: 25.0,
    Confederation.oceania: -15.0,
  };

  static const Map<String, double> table = {
    // Europe
    'ALB': 41.3, 'AND': 42.5, 'ARM': 40.2, 'AUT': 48.2, 'AZE': 40.4,
    'BEL': 50.8, 'BIH': 43.9, 'BUL': 42.7, 'CRO': 45.8, 'CYP': 35.2,
    'CZE': 50.1, 'DEN': 55.7, 'ENG': 51.5, 'EST': 59.4, 'FRO': 62.0,
    'FIN': 60.2, 'FRA': 48.9, 'GEO': 41.7, 'GER': 52.5, 'GIB': 36.1,
    'GRE': 38.0, 'HUN': 47.5, 'ISL': 64.1, 'ISR': 32.1, 'ITA': 41.9,
    'KAZ': 51.2, 'KVX': 42.7, 'LVA': 56.9, 'LIE': 47.1, 'LTU': 54.7,
    'LUX': 49.6, 'MLT': 35.9, 'MDA': 47.0, 'MNE': 42.4, 'NED': 52.4,
    'MKD': 42.0, 'NIR': 54.6, 'NOR': 59.9, 'POL': 52.2, 'POR': 38.7,
    'IRL': 53.3, 'ROU': 44.4, 'SMR': 43.9, 'SCO': 55.9, 'SRB': 44.8,
    'SVK': 48.1, 'SVN': 46.1, 'ESP': 40.4, 'SWE': 59.3, 'SUI': 46.9,
    'TUR': 41.0, 'UKR': 50.5, 'WAL': 51.5, 'BLR': 53.9, 'GRL': 64.2,
    'RUS': 55.8,
    // South America
    'ARG': -34.6, 'BOL': -16.5, 'BRA': -22.9, 'CHI': -33.4, 'COL': 4.7,
    'ECU': -0.2, 'PAR': -25.3, 'PER': -12.0, 'URU': -34.9, 'VEN': 10.5,
    // North and Central America, the Caribbean
    'AIA': 18.2, 'ATG': 17.1, 'ARU': 12.5, 'BAH': 25.0, 'BRB': 13.1,
    'BLZ': 17.3, 'BER': 32.3, 'VGB': 18.4, 'CAN': 43.7, 'CAY': 19.3,
    'CRC': 9.9, 'CUB': 23.1, 'CUW': 12.1, 'DMA': 15.3, 'DOM': 18.5,
    'SLV': 13.7, 'GRN': 12.1, 'GUA': 14.6, 'GUY': 6.8, 'HAI': 18.5,
    'HON': 14.1, 'JAM': 18.0, 'MEX': 19.4, 'MSR': 16.7, 'NCA': 12.1,
    'PAN': 9.0, 'PUR': 18.5, 'SKN': 17.3, 'LCA': 14.0, 'VIN': 13.2,
    'SUR': 5.9, 'TRI': 10.7, 'TCA': 21.5, 'USA': 38.9, 'VIR': 18.3,
    // Africa
    'ALG': 36.8, 'ANG': -8.8, 'BEN': 6.4, 'BOT': -24.7, 'BFA': 12.4,
    'BDI': -3.4, 'CMR': 3.9, 'CPV': 14.9, 'CTA': 4.4, 'CHA': 12.1,
    'COM': -11.7, 'CGO': -4.3, 'COD': -4.3, 'DJI': 11.6, 'EGY': 30.0,
    'EQG': 3.8, 'ERI': 15.3, 'SWZ': -26.3, 'ETH': 9.0, 'GAB': 0.4,
    'GAM': 13.5, 'GHA': 5.6, 'GUI': 9.5, 'GNB': 11.9, 'CIV': 5.3,
    'KEN': -1.3, 'LES': -29.3, 'LBR': 6.3, 'LBY': 32.9, 'MAD': -18.9,
    'MWI': -14.0, 'MLI': 12.6, 'MTN': 18.1, 'MRI': -20.2, 'MAR': 34.0,
    'MOZ': -26.0, 'NAM': -22.6, 'NIG': 13.5, 'NGA': 9.1, 'RWA': -1.9,
    'STP': 0.3, 'SEN': 14.7, 'SEY': -4.6, 'SLE': 8.5, 'SOM': 2.0,
    'RSA': -26.2, 'SSD': 4.9, 'SDN': 15.6, 'TAN': -6.8, 'TOG': 6.1,
    'TUN': 36.8, 'UGA': 0.3, 'ZAM': -15.4, 'ZIM': -17.8, 'ZAN': -6.2,
    // Asia
    'AFG': 34.5, 'AUS': -33.9, 'BHR': 26.2, 'BAN': 23.8, 'BHU': 27.5,
    'BRU': 4.9, 'CAM': 11.6, 'CHN': 39.9, 'TPE': 25.0, 'GUM': 13.5,
    'HKG': 22.3, 'IND': 28.6, 'IDN': -6.2, 'IRN': 35.7, 'IRQ': 33.3,
    'JPN': 35.7, 'JOR': 32.0, 'KUW': 29.4, 'KGZ': 42.9, 'LAO': 18.0,
    'LIB': 33.9, 'MAC': 22.2, 'MAS': 3.1, 'MDV': 4.2, 'MNG': 47.9,
    'MYA': 16.8, 'NEP': 27.7, 'PRK': 39.0, 'OMA': 23.6, 'PAK': 33.7,
    'PLE': 31.9, 'PHI': 14.6, 'QAT': 25.3, 'KSA': 24.7, 'SGP': 1.4,
    'KOR': 37.6, 'SRI': 6.9, 'SYR': 33.5, 'TJK': 38.6, 'THA': 13.8,
    'TLS': -8.6, 'TKM': 37.9, 'UAE': 24.5, 'UZB': 41.3, 'VIE': 21.0,
    'YEM': 15.4,
    // Oceania
    'ASA': -14.3, 'COK': -21.2, 'FIJ': -18.1, 'NCL': -22.3, 'NZL': -36.8,
    'PNG': -9.4, 'SAM': -13.8, 'SOL': -9.4, 'TAH': -17.5, 'TGA': -21.1,
    'VAN': -17.7,
  };
}
