import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the premium upgrade is unlocked.
///
/// This is the single source of truth for all paywall gating — UI and data
/// code should consult it rather than scattering `if (premium)` checks.
///
/// Defaults to **locked**. The EntitlementService flips it true from the
/// offline cached grant at launch and from the store's purchase stream; it
/// never flips it back. Nothing in the app writes `false` here, which is what
/// "fail open" means in practice: a check that cannot run leaves a granted
/// player granted.
final premiumUnlockedProvider = StateProvider<bool>((ref) => false);

/// How many four-year cycles a manager gets before the wall. One: a complete
/// campaign — qualifying, a continental championship and the World
/// Championship — with nothing held back, which is a far better advertisement
/// than a nation list with padlocks on it.
const int kFreeCycles = 1;

/// How many concurrent saves the free trial allows. Two: enough to keep a
/// second nation running alongside the first, and few enough that a manager
/// who wants a stable of careers can feel the ceiling.
const int kFreeSaveSlots = 2;

/// How many concurrent saves the purchase allows: no ceiling at all.
///
/// The product is sold as *unlimited*. A cap of any size is a promise a buyer
/// can count up to and find false, so there is none; null means "no limit".
/// Read it through [saveSlotLimit] rather than directly.
const int? kPremiumSaveSlots = null;

/// The concurrent-save ceiling for this entitlement, or null when unlimited.
///
/// Pure, like [trialExhausted], so the rule is testable without a store.
int? saveSlotLimit({required bool premiumUnlocked}) =>
    premiumUnlocked ? kPremiumSaveSlots : kFreeSaveSlots;

/// Whether another save may be created when [existingSaves] already exist.
///
/// Being OVER the limit answers false here, exactly as being AT it does, and
/// that is the whole point: a manager who made six saves while everything was
/// free keeps all six and can play and delete any of them. He is refused a
/// seventh, not relieved of the other five.
bool canCreateSave({
  required int existingSaves,
  required bool premiumUnlocked,
}) {
  final limit = saveSlotLimit(premiumUnlocked: premiumUnlocked);
  return limit == null || existingSaves < limit;
}

/// Whether this save has used up the free trial and may not roll into another
/// four-year cycle.
///
/// The one rule the whole free tier rests on, kept pure so it is testable
/// without a store. [cyclePointer] is the cycle the save is sitting IN, and
/// what is being asked is whether it may move to the NEXT one — so the cycle
/// the answer is about is `cyclePointer + 1`.
///
/// That `+ 1` is the whole rule, and it was missing. A free save sitting in
/// its first cycle (pointer 0) answered "not exhausted", so the roll into
/// pointer 1 went through untouched: the wall was never asked for at the end
/// of the first cycle, the manager was handed a second complete cycle, and the
/// one moment the product is sold at simply did not happen. He is not blocked
/// from playing the cycle he is in — [kFreeCycles] of those are free — he is
/// blocked from starting one he has not paid for.
bool trialExhausted({
  required int cyclePointer,
  required bool premiumUnlocked,
}) => !premiumUnlocked && cyclePointer + 1 >= kFreeCycles;
