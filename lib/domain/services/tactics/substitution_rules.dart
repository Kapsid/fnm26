/// Whether [playerId] may be put on the pitch.
///
/// Two things stop him. The side may have spent its changes — a starter who is
/// no longer on the pitch and was not sent off has cost a substitution, and a
/// sending-off costs a player rather than a change, so it never counts. And a
/// player already withdrawn cannot return: football has no re-entry, and the
/// board previously allowed it because nothing but a snackbar said otherwise.
bool canBringOn({
  required Set<int> startingIds,
  required Set<int> onPitch,
  required Set<int> sentOffIds,
  required Set<int> withdrawnIds,
  required int maxSubs,
  required int playerId,
}) {
  if (withdrawnIds.contains(playerId)) return false;
  if (sentOffIds.contains(playerId)) return false;
  if (onPitch.contains(playerId)) return true;
  final spent = startingIds
      .where((id) => !onPitch.contains(id) && !sentOffIds.contains(id))
      .length;
  return spent < maxSubs;
}
