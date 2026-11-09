/// Trades an ADDED sponsor can be given in the world editor, beyond the
/// industries of the built-in `SponsorBrand`s. They are picker options only:
/// there is no brand behind one, so a sponsor of such a trade reads as the
/// trade's label and nothing else.
///
/// Stored in a pack's `industry` as [id] (`ind` + the CamelCase name, letters
/// only so every build's field check accepts it). No `SponsorBrand.name`
/// starts with `ind`, so the two id spaces can never collide.
enum SponsorIndustry {
  sportswear,
  airline,
  railway,
  hotels,
  coffee,
  chocolate,
  mineralWater,
  pharmacy,
  fashion,
  watches,
  electronics,
  software,
  streaming,
  socialNetwork,
  furniture,
  tyres,
  shipping,
  lottery,
  tourism,
  cosmetics,
  petFood,
  bakery,
  supermarket,
  sportsNutrition,
  wine,
  tea,
  realEstate,
  fitness,
  newspaper;

  static const String prefix = 'ind';

  /// The stored id, e.g. `indSportswear`.
  String get id => prefix + name[0].toUpperCase() + name.substring(1);

  /// The trade with stored id [id], or null.
  static SponsorIndustry? byId(String id) {
    for (final i in values) {
      if (i.id == id) return i;
    }
    return null;
  }
}
