/// Marks a cycle whose national teams are run by world managers.
///
/// Stored with the cycle's watched events, so no schema change. Stamped at a
/// career's creation for cycle 0 and at each rollover for the new cycle; a
/// cycle without it (any cycle of a save from before world managers) reads
/// each nation's own style and sees no manager move.
const worldManagersKind = 'worldManagers1';

/// Marks the decision on the manager question [key] as taken, so it is
/// taken once.
String mgrDecidedKind(String key) => 'mgrDecided:$key';

/// Marks the managers' rollover as done; its row's cycle is the new cycle.
const mgrRolloverKind = 'mgrRollover';
