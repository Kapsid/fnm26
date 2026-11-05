import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing the general sponsor's brands in the manager's own language: the
/// display-edge translator pattern of `federation_label.dart`, applied to
/// [SponsorBrand]. Several names are jokes that only land in the reader's
/// own language (see [SponsorBrand]).

/// A brand's name, as the manager reads it: the career world's name for it
/// if it renamed the brand ([ActiveWorld]: its value for the app's language,
/// else its main one), else the game's own, translated. A brand the world
/// added reads as its own copy names it, unless the screen's world (when it
/// is the one that added it) names it differently in the app's language.
String sponsorBrandName(AppLocalizations l, Sponsor s) => switch (s) {
  final SponsorBrand b =>
    ActiveWorld.current.sponsor(b.name) ?? _sponsorBrandName(l, b),
  Sponsor(added: final a?) =>
    ActiveWorld.current.addedSponsorName(a.id, world: s.world) ?? a.name,
  _ => s.id,
};

String _sponsorBrandName(AppLocalizations l, SponsorBrand b) => switch (b) {
  SponsorBrand.agrofart => l.sponsorBrandAgrofart,
  SponsorBrand.betBadger => l.sponsorBrandBetBadger,
  SponsorBrand.coinGoblin => l.sponsorBrandCoinGoblin,
  SponsorBrand.easyPeasy => l.sponsorBrandEasyPeasy,
  SponsorBrand.vaporia => l.sponsorBrandVaporia,
  SponsorBrand.goldenFleece => l.sponsorBrandGoldenFleece,
  SponsorBrand.miners => l.sponsorBrandMiners,
  SponsorBrand.moth => l.sponsorBrandMoth,
  SponsorBrand.sludgeco => l.sponsorBrandSludgeco,
  SponsorBrand.skyloom => l.sponsorBrandSkyloom,
  SponsorBrand.arvella => l.sponsorBrandArvella,
  SponsorBrand.cheapoMax => l.sponsorBrandCheapoMax,
  SponsorBrand.brickhaven => l.sponsorBrandBrickhaven,
  SponsorBrand.happyBurgers => l.sponsorBrandHappyBurgers,
  SponsorBrand.oldSwamp => l.sponsorBrandOldSwamp,
  SponsorBrand.buzzhorn => l.sponsorBrandBuzzhorn,
  SponsorBrand.steamy => l.sponsorBrandSteamy,
  SponsorBrand.pixelRage => l.sponsorBrandPixelRage,
  SponsorBrand.glitterbox => l.sponsorBrandGlitterbox,
  SponsorBrand.milkwell => l.sponsorBrandMilkwell,
  SponsorBrand.herringKing => l.sponsorBrandHerringKing,
  SponsorBrand.umbrello => l.sponsorBrandUmbrello,
  SponsorBrand.tidyTeeth => l.sponsorBrandTidyTeeth,
  SponsorBrand.woollySocks => l.sponsorBrandWoollySocks,
  SponsorBrand.stackabloc => l.sponsorBrandStackabloc,
  SponsorBrand.polarPenguin => l.sponsorBrandPolarPenguin,
  SponsorBrand.hexagon => l.sponsorBrandHexagon,
  SponsorBrand.velocell => l.sponsorBrandVelocell,
  SponsorBrand.parcelion => l.sponsorBrandParcelion,
  SponsorBrand.gridwell => l.sponsorBrandGridwell,
  SponsorBrand.crownstone => l.sponsorBrandCrownstone,
  SponsorBrand.clickbait => l.sponsorBrandClickbait,
};

/// What a brand does for a living. A brand the world added borrows the
/// industry of the built-in brand it names; one this build does not know
/// (a newer game's, flagged in the editor) reads as nothing.
String sponsorIndustryLabel(AppLocalizations l, Sponsor s) {
  final b = s.builtIn ?? SponsorBrand.byName(s.added?.industry ?? '');
  return b == null ? '' : _sponsorIndustryLabel(l, b);
}

String _sponsorIndustryLabel(AppLocalizations l, SponsorBrand b) => switch (b) {
  SponsorBrand.agrofart => l.sponsorIndustryAgrofart,
  SponsorBrand.betBadger => l.sponsorIndustryBetBadger,
  SponsorBrand.coinGoblin => l.sponsorIndustryCoinGoblin,
  SponsorBrand.easyPeasy => l.sponsorIndustryEasyPeasy,
  SponsorBrand.vaporia => l.sponsorIndustryVaporia,
  SponsorBrand.goldenFleece => l.sponsorIndustryGoldenFleece,
  SponsorBrand.miners => l.sponsorIndustryMiners,
  SponsorBrand.moth => l.sponsorIndustryMoth,
  SponsorBrand.sludgeco => l.sponsorIndustrySludgeco,
  SponsorBrand.skyloom => l.sponsorIndustrySkyloom,
  SponsorBrand.arvella => l.sponsorIndustryArvella,
  SponsorBrand.cheapoMax => l.sponsorIndustryCheapoMax,
  SponsorBrand.brickhaven => l.sponsorIndustryBrickhaven,
  SponsorBrand.happyBurgers => l.sponsorIndustryHappyBurgers,
  SponsorBrand.oldSwamp => l.sponsorIndustryOldSwamp,
  SponsorBrand.buzzhorn => l.sponsorIndustryBuzzhorn,
  SponsorBrand.steamy => l.sponsorIndustrySteamy,
  SponsorBrand.pixelRage => l.sponsorIndustryPixelRage,
  SponsorBrand.glitterbox => l.sponsorIndustryGlitterbox,
  SponsorBrand.milkwell => l.sponsorIndustryMilkwell,
  SponsorBrand.herringKing => l.sponsorIndustryHerringKing,
  SponsorBrand.umbrello => l.sponsorIndustryUmbrello,
  SponsorBrand.tidyTeeth => l.sponsorIndustryTidyTeeth,
  SponsorBrand.woollySocks => l.sponsorIndustryWoollySocks,
  SponsorBrand.stackabloc => l.sponsorIndustryStackabloc,
  SponsorBrand.polarPenguin => l.sponsorIndustryPolarPenguin,
  SponsorBrand.hexagon => l.sponsorIndustryHexagon,
  SponsorBrand.velocell => l.sponsorIndustryVelocell,
  SponsorBrand.parcelion => l.sponsorIndustryParcelion,
  SponsorBrand.gridwell => l.sponsorIndustryGridwell,
  SponsorBrand.crownstone => l.sponsorIndustryCrownstone,
  SponsorBrand.clickbait => l.sponsorIndustryClickbait,
};

/// A brand's one-line character, for its offer card. A brand the world
/// added says its own description; without one, the line of its deal type
/// ([sponsorDealLine]).
String sponsorFlavour(AppLocalizations l, Sponsor s) => switch (s) {
  final SponsorBrand b => _sponsorFlavour(l, b),
  Sponsor(added: final a?) =>
    ActiveWorld.current.addedSponsorDescription(a.id, world: s.world) ??
        ActiveWorld.textOrNull(a.description) ??
        sponsorDealLine(l, s.deal),
  _ => sponsorDealLine(l, s.deal),
};

/// A short generic line for a deal of type [d]: what an added brand without
/// a description says.
String sponsorDealLine(AppLocalizations l, SponsorDeal d) => switch (d) {
  SponsorDeal.risky => l.sponsorDealLineRisky,
  SponsorDeal.bigPayer => l.sponsorDealLineBigPayer,
  SponsorDeal.crowdPleaser => l.sponsorDealLineCrowdPleaser,
  SponsorDeal.familyFriendly => l.sponsorDealLineFamilyFriendly,
  SponsorDeal.marketing => l.sponsorDealLineMarketing,
};

String _sponsorFlavour(AppLocalizations l, SponsorBrand b) => switch (b) {
  SponsorBrand.agrofart => l.sponsorFlavourAgrofart,
  SponsorBrand.betBadger => l.sponsorFlavourBetBadger,
  SponsorBrand.coinGoblin => l.sponsorFlavourCoinGoblin,
  SponsorBrand.easyPeasy => l.sponsorFlavourEasyPeasy,
  SponsorBrand.vaporia => l.sponsorFlavourVaporia,
  SponsorBrand.goldenFleece => l.sponsorFlavourGoldenFleece,
  SponsorBrand.miners => l.sponsorFlavourMiners,
  SponsorBrand.moth => l.sponsorFlavourMoth,
  SponsorBrand.sludgeco => l.sponsorFlavourSludgeco,
  SponsorBrand.skyloom => l.sponsorFlavourSkyloom,
  SponsorBrand.arvella => l.sponsorFlavourArvella,
  SponsorBrand.cheapoMax => l.sponsorFlavourCheapoMax,
  SponsorBrand.brickhaven => l.sponsorFlavourBrickhaven,
  SponsorBrand.happyBurgers => l.sponsorFlavourHappyBurgers,
  SponsorBrand.oldSwamp => l.sponsorFlavourOldSwamp,
  SponsorBrand.buzzhorn => l.sponsorFlavourBuzzhorn,
  SponsorBrand.steamy => l.sponsorFlavourSteamy,
  SponsorBrand.pixelRage => l.sponsorFlavourPixelRage,
  SponsorBrand.glitterbox => l.sponsorFlavourGlitterbox,
  SponsorBrand.milkwell => l.sponsorFlavourMilkwell,
  SponsorBrand.herringKing => l.sponsorFlavourHerringKing,
  SponsorBrand.umbrello => l.sponsorFlavourUmbrello,
  SponsorBrand.tidyTeeth => l.sponsorFlavourTidyTeeth,
  SponsorBrand.woollySocks => l.sponsorFlavourWoollySocks,
  SponsorBrand.stackabloc => l.sponsorFlavourStackabloc,
  SponsorBrand.polarPenguin => l.sponsorFlavourPolarPenguin,
  SponsorBrand.hexagon => l.sponsorFlavourHexagon,
  SponsorBrand.velocell => l.sponsorFlavourVelocell,
  SponsorBrand.parcelion => l.sponsorFlavourParcelion,
  SponsorBrand.gridwell => l.sponsorFlavourGridwell,
  SponsorBrand.crownstone => l.sponsorFlavourCrownstone,
  SponsorBrand.clickbait => l.sponsorFlavourClickbait,
};
