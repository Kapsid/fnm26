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

/// Maximum number of concurrent save games. The same for everyone: the trial
/// is the whole game for one cycle, and nothing else is held back.
const int kSaveSlots = 10;

/// Whether this save has used up the free trial and may not roll into another
/// four-year cycle.
///
/// The one rule the whole free tier rests on, kept pure so it is testable
/// without a store. [cyclePointer] is the cycle the save is sitting in, so a
/// save still inside its first cycle (pointer 0) is free; moving it to pointer
/// 1 is what is being sold.
bool trialExhausted({
  required int cyclePointer,
  required bool premiumUnlocked,
}) => !premiumUnlocked && cyclePointer >= kFreeCycles;
