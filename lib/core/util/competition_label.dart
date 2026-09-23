import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing continents and competitions in the manager's own language.
///
/// Competition names are STORED in English and compared in logic all over the
/// app (`h.competition == 'Nations Cup'`, the honours switch, the challenge
/// catalogue), so they cannot be translated where they are generated without
/// silently breaking every one of those comparisons. They are translated HERE
/// instead, at the moment they are printed, and anything this table has not
/// been taught falls through unchanged.

/// The continent's name, written for the manager.
String confederationLabel(AppLocalizations l, Confederation c) => switch (c) {
  Confederation.europe => l.confEurope,
  Confederation.southAmerica => l.confSouthAmerica,
  Confederation.northAmerica => l.confNorthAmerica,
  Confederation.africa => l.confAfrica,
  Confederation.asia => l.confAsia,
  Confederation.oceania => l.confOceania,
};

/// The continental cup's name, written for the manager.
String continentalCupLabel(AppLocalizations l, Confederation c) => switch (c) {
  Confederation.europe => l.compEuropeanChampionship,
  Confederation.southAmerica => l.compSouthAmericaCup,
  Confederation.northAmerica => l.compNorthAmericaCup,
  Confederation.africa => l.compAfricanChampionship,
  Confederation.asia => l.compAsianChampionship,
  Confederation.oceania => l.compOceaniaCup,
};

/// A stored competition name, written for the manager.
///
/// [stored] is whatever the save holds — the canonical English name. Unknown
/// names (there should be none, but a save from an older build may carry one)
/// are returned as they came in rather than blanked.
String competitionLabel(AppLocalizations l, String stored) {
  final trimmed = stored.trim();
  final known = _byEnglishName(l)[trimmed];
  if (known != null) return known;
  // "Europe Qualifiers", "Africa Qualifiers", … — the confederation's own World
  // Cup campaign, named after the continent by the schedule generator.
  if (trimmed.endsWith(_qualifiersSuffix)) {
    final region = trimmed
        .substring(0, trimmed.length - _qualifiersSuffix.length)
        .trim();
    for (final c in Confederation.values) {
      if (c.label == region) return l.compQualifiers(confederationLabel(l, c));
    }
    return l.compQualifiers(region);
  }
  return stored;
}

const String _qualifiersSuffix = ' Qualifiers';

Map<String, String> _byEnglishName(AppLocalizations l) => {
  'World Cup': l.compWorldCup,
  'the World Cup': l.compWorldCup,
  'World Championship': l.compWorldCup,
  'World Championship Finals': l.compWorldCupFinals,
  'World Cup Qualifying': l.compWorldCupQualifying,
  // The name the schedule generator actually stores for the player's own
  // qualifying campaign. Without it the ' Qualifiers' branch below reads
  // "World Cup" as if it were a continent and prints it back untranslated —
  // the one place the old name survived the rename.
  'World Cup Qualifiers': l.compWorldCupQualifying,
  'World Championship Qualifiers': l.compWorldCupQualifying,
  'Friendlies': l.compFriendlies,
  'Nations Cup': l.compNationsCup,
  'Continental Clash': l.compContinentalClash,
  'Intercontinental Play-off': l.compIntercontinentalPlayoff,
  'Continental Championship': l.compContinentalChampionship,
  for (final e in ContinentalCups.byConfederation.entries)
    e.value.name: continentalCupLabel(l, e.key),
};
