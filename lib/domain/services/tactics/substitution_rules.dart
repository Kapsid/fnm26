/// Why a player may not be put on the pitch, or [SubRefusal.none] when he may.
///
/// A single boolean used to answer this, which meant every refusal was reported
/// to the manager as "you have used all your substitutions" — including the two
/// cases that have nothing to do with the count, and which a manager hits far
/// more often: trying to bring back a man he has already taken off, or one who
/// has been sent off.
enum SubRefusal {
  /// He may come on.
  none,

  /// Already substituted: football has no re-entry.
  alreadyWithdrawn,

  /// Sent off — he plays no further part.
  sentOff,

  /// The side has spent every change it has.
  noSubsLeft,
}

/// Whether [playerId] may be put on the pitch, and if not, why.
///
/// Three things stop him. A player already withdrawn cannot return (football
/// has no re-entry) and neither can one who has been sent off. And the side may
/// have spent its changes — a starter who is no longer on the pitch and was not
/// sent off has cost a substitution, and a sending-off costs a player rather
/// than a change, so it never counts.
SubRefusal refusalToBringOn({
  required Set<int> startingIds,
  required Set<int> onPitch,
  required Set<int> sentOffIds,
  required Set<int> withdrawnIds,
  required int maxSubs,
  required int playerId,
}) {
  if (withdrawnIds.contains(playerId)) return SubRefusal.alreadyWithdrawn;
  if (sentOffIds.contains(playerId)) return SubRefusal.sentOff;
  if (onPitch.contains(playerId)) return SubRefusal.none;
  final spent = startingIds
      .where((id) => !onPitch.contains(id) && !sentOffIds.contains(id))
      .length;
  return spent < maxSubs ? SubRefusal.none : SubRefusal.noSubsLeft;
}

/// The slots a sending-off has taken out of the side's shape — the holes that
/// must stay holes.
///
/// A red card costs a PLAYER, not a place. The hole the man leaves behind is
/// not a vacancy: nobody comes on for him, nobody shuffles across into his
/// spot, and the side plays out the match a man short. The editor used to
/// simply vacate his slot, and an empty slot reads as "put somebody here" —
/// which is exactly what a manager did, from the bench, for free, and carried
/// on with eleven.
///
/// Every empty slot is dead once the men on the pitch and the men sent off
/// between them account for the whole eleven. Stating it as a COUNT rather
/// than as a remembered slot index is what makes it survive a change of shape:
/// a reshape re-derives the whole lineup, so an index recorded under the old
/// formation would point at somebody else's position under the new one. Two
/// red cards leave two dead slots by the same arithmetic, and none of it
/// depends on which shape the manager reshuffles into.
Set<int> deadSlots({
  required List<int?> lineup,
  required int sentOffCount,
}) {
  if (sentOffCount <= 0) return const {};
  final empty = {
    for (var slot = 0; slot < lineup.length; slot++)
      if (lineup[slot] == null) slot,
  };
  final onPitch = lineup.length - empty.length;
  // Short of even the reduced eleven — a shape that could not be filled, say —
  // so the side may still put somebody somewhere. Filling one hole brings the
  // count back up and kills whatever is left, so the cap holds either way.
  if (onPitch + sentOffCount < lineup.length) return const {};
  return empty;
}

/// Whether [slot] is a hole a sending-off left, which nothing may fill.
bool slotLostToRedCard({
  required List<int?> lineup,
  required int sentOffCount,
  required int slot,
}) => deadSlots(lineup: lineup, sentOffCount: sentOffCount).contains(slot);

/// Whether [playerId] may be put on the pitch.
bool canBringOn({
  required Set<int> startingIds,
  required Set<int> onPitch,
  required Set<int> sentOffIds,
  required Set<int> withdrawnIds,
  required int maxSubs,
  required int playerId,
}) =>
    refusalToBringOn(
      startingIds: startingIds,
      onPitch: onPitch,
      sentOffIds: sentOffIds,
      withdrawnIds: withdrawnIds,
      maxSubs: maxSubs,
      playerId: playerId,
    ) ==
    SubRefusal.none;
