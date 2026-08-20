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
