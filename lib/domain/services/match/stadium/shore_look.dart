import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:meta/meta.dart' show immutable;

/// The boats out on the water behind a ground.
enum Sails {
  /// No boats.
  none,

  /// Wooden dhows under slanted lateen sails (the Swahili coast, the
  /// Indian Ocean).
  dhows,

  /// Small white sailing boats.
  sailboats,
}

/// What a region's climate lays over a ground's backdrop, on top of its
/// city style and horizon: the arctic's ice and painted wooden houses, a
/// tropical island's beach and palms, and the boats on the water.
///
/// Cosmetic only: no match, weather roll or save reads it, and it draws
/// from the backdrop's own seeded look, never from a match's random
/// stream.
@immutable
class ShoreLook {
  const ShoreLook({
    this.arctic = false,
    this.beach = false,
    this.sails = Sails.none,
  });

  /// The look laid over a ground in the country [code], in a city with
  /// [features] (null when the geography table does not know the city),
  /// under [horizon]. Only a coastal city looking out to sea gets a beach
  /// or boats; an arctic country is arctic wherever the ground is.
  factory ShoreLook.of(
    String code, {
    required Set<CityFeature>? features,
    required Horizon horizon,
  }) {
    final c = code.toUpperCase();
    final coast = features?.contains(CityFeature.coast) ?? false;
    final water = horizon == Horizon.sea || horizon == Horizon.fjords;
    final arctic = arcticNations.contains(c);
    final beach =
        !arctic &&
        coast &&
        horizon == Horizon.sea &&
        tropicalIslands.contains(c);
    final sails = !coast || !water || arctic
        ? Sails.none
        : dhowCoasts.contains(c)
        ? Sails.dhows
        : beach
        ? Sails.sailboats
        : Sails.none;
    if (!arctic && !beach && sails == Sails.none) return none;
    return ShoreLook(arctic: arctic, beach: beach, sails: sails);
  }

  /// Nothing laid over: every ground outside the listed places.
  static const ShoreLook none = ShoreLook();

  /// Icebergs in the water, the ice sheet's edge on the horizon, wooden
  /// houses painted red, blue, yellow and green, and snow lying longer
  /// (see [BackdropSeason.at]) with patches on the hills all summer.
  final bool arctic;

  /// A sandy beach between the town and the sea, and coconut palms.
  final bool beach;

  /// The boats out on the water.
  final Sails sails;

  bool get isNone => !arctic && !beach && sails == Sails.none;

  /// Nations whose grounds all stand in the arctic. Only Greenland for now;
  /// the look is built so another arctic place can join by its code.
  static const Set<String> arcticNations = {'GRL'};

  /// Tropical island and beach nations: a coastal ground there looks out
  /// over a beach with palms.
  static const Set<String> tropicalIslands = {
    // The Indian Ocean.
    'ZAN', 'MDV', 'SEY', 'MRI', 'COM',
    // The Atlantic off Africa.
    'CPV', 'STP',
    // The Pacific.
    'FIJ', 'SAM', 'TGA', 'VAN', 'SOL', 'PNG', 'TAH', 'NCL', 'ASA', 'COK',
    // The Caribbean and its Atlantic edge.
    'JAM', 'TRI', 'BRB', 'BAH', 'CUB', 'DOM', 'HAI', 'PUR', 'ATG', 'LCA',
    'GRN', 'VIN', 'SKN', 'DMA', 'ARU', 'CUW', 'CAY', 'BER', 'VGB', 'VIR',
    'TCA', 'MSR', 'AIA',
  };

  /// Where the boats on the water are dhows: the Swahili coast and the
  /// Indian Ocean round it. Everywhere else a beach gets small sailboats.
  static const Set<String> dhowCoasts = {
    'ZAN', 'TAN', 'KEN', 'COM', 'OMA', 'MDV', //
  };

  /// Whether a ground in [code] stands in the arctic.
  static bool isArctic(String code) =>
      arcticNations.contains(code.toUpperCase());

  @override
  bool operator ==(Object other) =>
      other is ShoreLook &&
      other.arctic == arctic &&
      other.beach == beach &&
      other.sails == sails;

  @override
  int get hashCode => Object.hash(arctic, beach, sails);

  @override
  String toString() =>
      'ShoreLook(arctic: $arctic, beach: $beach, sails: ${sails.name})';
}
