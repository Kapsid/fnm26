/// What a campaign asks of the manager.
enum CampaignGoal {
  /// Reach the continental finals; stars follow the qualifying finish.
  qualifyContinental,

  /// Finish above [CampaignDef.rivalNationId]; stars are rule-based.
  aboveRival,

  /// Beat every one of [CampaignDef.rivalNationIds] at least once, in any
  /// match, across all the campaign's cycles; the continental finals add the
  /// other two stars (see `beatRivalsStars`).
  beatRivalsThenContinental,

  /// Reach a World Championship finals, win the continental championship,
  /// win the World Championship: one star each, the highest reached counts,
  /// across all the campaign's cycles (see `worldThenTitlesStars`).
  qualifyWorldThenTitles,
}

/// How hard a campaign plays, from the calibration lab
/// (`test/story/campaign_lab_test.dart`). The badge's label and colour both
/// follow it.
enum CampaignDifficulty { medium, hard }

/// One hand-built scenario: a fixed world ([rngSeed]), a nation, a goal.
///
/// The seed is part of the design. It pins the qualifying draw and the hosts,
/// so a scenario can promise things a random world cannot (the rival shares
/// the group; the nation is not handed a place as host). The guard tests in
/// `campaign_seeds_test.dart` fail if a seed stops delivering them.
class CampaignDef {
  const CampaignDef({
    required this.id,
    required this.nationId,
    required this.rngSeed,
    required this.goal,
    required this.cycles,
    required this.needsPro,
    required this.difficulty,
    this.rivalNationId,
    this.rivalNationIds = const [],
    this.friendlyNationId,
    this.donorNationId,
    this.transplantCount = 0,
    this.starThresholds = const [],
    this.canContinue = true,
    this.goldenGeneration = false,
  });

  final String id;
  final int nationId;
  final int rngSeed;
  final CampaignGoal goal;
  final int? rivalNationId;

  /// For [CampaignGoal.beatRivalsThenContinental]: the sides to beat.
  final List<int> rivalNationIds;

  /// A nation a home friendly is booked against when the run starts, in the
  /// first free international window of its first cycle. Flavour only: it is
  /// no part of the goal.
  final int? friendlyNationId;

  /// The nation whose best players are naturalised into [nationId] at the
  /// start.
  final int? donorNationId;
  final int transplantCount;
  final int cycles;
  final bool needsPro;
  final CampaignDifficulty difficulty;

  /// For [CampaignGoal.qualifyContinental], the finish ordinals that earn
  /// 1, 2 and 3 stars. Unused for [CampaignGoal.aboveRival].
  final List<int> starThresholds;

  /// Whether a settled run may be moved into the manager's save slots and
  /// played on as a normal career. False for a scenario whose world is too far
  /// from the real one for that to make sense (a modifier so large that the
  /// career would never be fair again): the run ends at its verdict. Only
  /// governs moving; a run already moved keeps working as a career.
  final bool canContinue;

  /// Whether [nationId]'s senior pool is replaced, for this run only, by its
  /// golden generation of teenagers (see `GoldenGeneration`). The run carries
  /// the marker from its start, so every read of the nation's players in it
  /// sees the cohort; no other career does.
  final bool goldenGeneration;
}

abstract final class Campaigns {
  /// San Marino with eight Italians naturalised in: qualify for the Euros.
  /// Eight is the owner's pick (campaign_lab_test.dart): with five or six San
  /// Marino all but never qualified; eight succeeds in about a fifth of
  /// autopilot runs (nine was a quarter), the Grudge in about three in ten.
  static const transplant = CampaignDef(
    id: 'transplant',
    nationId: 45, // San Marino
    donorNationId: 26, // Italy
    transplantCount: 8,
    goal: CampaignGoal.qualifyContinental,
    starThresholds: [2, 3, 7],
    canContinue: false,
    cycles: 1,
    needsPro: false,
    difficulty: CampaignDifficulty.hard,
    rngSeed: 1,
  );

  /// Georgia must finish above Albania, who share its qualifying group. A
  /// close rival by design (campaign_lab_test.dart): Armenia were bottom of
  /// the group nearly every run, Türkiye and Ukraine almost never caught.
  static const grudge = CampaignDef(
    id: 'grudge',
    nationId: 19, // Georgia
    rivalNationId: 1, // Albania
    goal: CampaignGoal.aboveRival,
    cycles: 1,
    needsPro: false,
    difficulty: CampaignDifficulty.medium,
    rngSeed: 10,
  );

  /// Equatorial Guinea, the lowest-ranked of Africa's Guineas, must beat
  /// Guinea and Guinea-Bissau within two cycles, then go far in the African
  /// Championship. Pro, and the first campaign longer than one cycle. Papua
  /// New Guinea, "the fourth Guinea", is booked for a friendly at the start.
  /// Seed 13 is the first that draws a rival (Guinea-Bissau) into Equatorial
  /// Guinea's first qualifying group, so at least one meeting is guaranteed,
  /// while Equatorial Guinea hosts neither cycle's African Championship
  /// (campaign_seeds_test.dart). No seed draws both: the two rivals sit in
  /// the same qualifying pot.
  static const guineas = CampaignDef(
    id: 'guineas',
    nationId: 116, // Equatorial Guinea
    rivalNationIds: [123, 124], // Guinea, Guinea-Bissau
    friendlyNationId: 206, // Papua New Guinea
    goal: CampaignGoal.beatRivalsThenContinental,
    cycles: 2,
    needsPro: true,
    difficulty: CampaignDifficulty.hard,
    rngSeed: 13,
  );

  /// Finland for three cycles, its senior pool replaced by a golden
  /// generation of teenagers, all 18 or younger at the start, who grow into a
  /// top side the way Norway's young generation did. Pro. Qualify for a World
  /// Championship, win the European Championship, win the World
  /// Championship. Seed 17 keeps Finland from hosting either championship in
  /// all three cycles (campaign_seeds_test.dart), so no place is handed over.
  /// Cannot be continued: a career with a manufactured generation is no fair
  /// save. The cohort's strength was tuned on the lab (campaign_lab_test.dart).
  static const youngFinns = CampaignDef(
    id: 'youngFinns',
    nationId: 17, // Finland
    goal: CampaignGoal.qualifyWorldThenTitles,
    goldenGeneration: true,
    canContinue: false,
    cycles: 3,
    needsPro: true,
    difficulty: CampaignDifficulty.medium,
    rngSeed: 17,
  );

  static const List<CampaignDef> all = [
    transplant,
    grudge,
    guineas,
    youngFinns,
  ];

  static CampaignDef? byId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}

/// The draw-watched marker that records a campaign run (cycle 0).
String campaignMarker(String id) => 'campaign:$id';

/// Marker: a settled campaign was moved into the manager's save slots.
const campaignMovedKind = 'campaignMoved';

/// Marker, at the cycle the move was made in: a moved run is still the
/// campaign for the rest of that cycle only, and an ordinary career after.
const campaignMovedAtKind = 'campaignMovedAt';

/// Marker: the campaign verdict has been delivered.
const campaignVerdictKind = 'campaignVerdict';
