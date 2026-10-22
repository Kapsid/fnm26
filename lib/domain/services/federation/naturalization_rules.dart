/// The most caps a player may hold for his current nation and still be
/// offered to another federation through a naturalisation.
///
/// A game rule, deliberately looser than FIFA's (three competitive caps, all
/// won before the player turned 21): it counts every cap the save has logged
/// for him (see `CompetitionRepository.capsFor`), whatever the match and
/// whatever his age, and lets a fringe international with a handful of caps
/// switch while a man who has really played for his country stays with it.
///
/// Only the choice of candidates for a new offer is held to it. An offer
/// already made, or a naturalisation already accepted, stands; and the San
/// Marino transplant campaign naturalises capped Italians on purpose (it
/// writes its links directly, not through an offer).
const int kMaxCapsToSwitch = 10;

/// Whether a player with [capsForCurrentNation] caps may still switch.
bool canSwitchAllegiance(int capsForCurrentNation) =>
    capsForCurrentNation <= kMaxCapsToSwitch;
