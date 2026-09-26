/// What an offer on the table would MEAN for a manager's standing, relative to
/// the job he is in.
///
/// It was a String on the offer tile ('Step up', 'Lateral move', 'A rebuild'),
/// decided in `nation_offers_providers.dart` and printed as it came, so the one
/// screen a Czech manager cannot avoid between cycles handed him three English
/// phrases. The judgement is the domain's; the words belong to the copy (see
/// `offerTierLabel`).
enum OfferTier {
  /// A better nation than the one being left.
  stepUp,

  /// About the same standing, somewhere else.
  lateral,

  /// A lesser nation, taken on to build it back up.
  rebuild,
}

/// Which tier an offer from the world's [offered]-ranked nation is, for a
/// manager currently at the [current]-ranked one (1 = strongest).
///
/// The bands are deliberately wide. A place or two either way is the same job
/// with a different badge, so only a clear move in the table reads as a step up
/// or a rebuild.
OfferTier offerTierFor({required int offered, required int current}) {
  if (offered < current * _stepUpAt) return OfferTier.stepUp;
  if (offered > current * _rebuildAt) return OfferTier.rebuild;
  return OfferTier.lateral;
}

/// How much stronger a nation has to be before taking it is a step up.
const double _stepUpAt = 0.85;

/// And how much weaker before it is a rebuild.
const double _rebuildAt = 1.2;
