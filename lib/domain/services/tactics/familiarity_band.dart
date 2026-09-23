/// How drilled a side is in one shape, in words rather than in a number.
///
/// The stored familiarity is a `0..1` figure the match engine multiplies with
/// (see `TeamChemistry`), but the manager is being told how well his side knows
/// the shape, not handed a dial to optimise. A percentage on screen turns a
/// thing that should be felt into a number to farm, so the screen shows a bar
/// that fills and one of these words beside it.
///
/// Nothing here touches predictability. That figure is what the OPPOSITION has
/// worked out, deliberately hidden (see `TeamChemistry`), and it must stay
/// unrecoverable: a band is reported from familiarity alone, so no amount of
/// comparing this reading with anything else on screen gives it away.
enum FamiliarityBand {
  /// Never fielded. A real state, and not the same as "played once and barely
  /// remembered" — the bar is drawn empty rather than left off.
  unplayed,

  /// Fielded, but the side is still finding it.
  fresh,

  /// Coming together: the shape has had enough outings to be taking hold.
  settling,

  /// Second nature. The most the drilled bonus has to give.
  drilled,
}

/// The band for a stored familiarity, or [FamiliarityBand.unplayed] when the
/// shape has never been fielded (no stored value at all).
///
/// The thresholds are outings, read backwards: familiarity climbs 0.08 a match,
/// so a shape settles after about four or five, and is drilled after nine.
FamiliarityBand familiarityBand(double? familiarity) {
  if (familiarity == null) return FamiliarityBand.unplayed;
  final f = familiarity.clamp(0.0, 1.0);
  if (f >= 0.7) return FamiliarityBand.drilled;
  if (f >= 0.34) return FamiliarityBand.settling;
  return FamiliarityBand.fresh;
}
