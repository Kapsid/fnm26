# Monetisation — 2026-08-16

**Date:** 2026-08-16
**Status:** approved design, not yet built

## Problem

The game is finished enough to sell and has no way to take money. What exists is
a half-model left over from an earlier idea: a handful of "free demo" nations
(`Nation.isFreeDemo`), two save slots instead of five
(`maxSaveSlots`), and an `EntitlementService` that already talks to the store
but is gated on nothing the player would notice.

That model sells the wrong thing. It advertises the game as crippled — a nation
list with padlocks on it — when the thing actually worth paying for is the
endless career.

## Decisions

- **One free cycle, then €11.99, once.** The first four-year cycle is the whole
  game with nothing held back: qualifying, a continental championship, a World
  Cup. Paying continues the save into the next cycle. A trial that ends at a
  natural boundary reads as generous; a padlocked nation list reads as a demo.
- **One gate, not many.** `startNextCycle` is the only place a save moves from
  cycle 0 to cycle 1, so it is the only place the paywall lives. The free-demo
  nation flag and the save-slot split are retired.
- **The app stays offline.** No permissions, no privacy policy, no analytics
  SDK, nothing collected. The store's purchase sheet is the only thing that
  ever touches a network, plus a restore the player asks for.
- **Entitlement is a signed receipt, not a boolean.** Today the unlock is
  `prefs.setBool('premium_unlocked', true)`, which a file manager can write.
  The store's signed purchase payload is stored instead and verified
  cryptographically, on device, at launch.
- **Fail open.** If verification cannot run — unreadable receipt, store
  unavailable, anything — a player who has been granted the unlock keeps it.
  Locking out someone who paid is worse than a pirate playing free.
- **No RevenueCat, for now.** See below.
- **Measurement comes from the store consoles.** Play Console and App Store
  Connect give revenue, units, refunds, country and day, for free, with no code
  and no disclosure.

## Anti-piracy: what is actually being bought

On Android a patched APK unlocks anything, and no client-side work changes
that. The goal is to stop casual sharing and generic unlocker tools — not a
determined cracker, who cannot be stopped without a server, and cannot be
stopped *with* one either if they patch the check out.

| approach | beaten by | needs network |
| --- | --- | --- |
| bool in prefs (today) | a text editor | no |
| **signed receipt, verified locally (chosen)** | copying a receipt file; patching the APK | no |
| server-side verification | patching the APK | yes, always |

The middle row costs about a day, keeps the app silent, and the attack that
beats it — extracting a receipt from app-private storage and copying it to
another device — needs root and effort well beyond the price of the game.

**Verification is local.** It is an RSA/JWS signature check against a public key
compiled into the app, run over a blob already on the device. Milliseconds, no
connectivity. The app does not phone home at startup.

- **Play**: `verificationData.localVerificationData` is the purchase JSON,
  `serverVerificationData` its signature. Verify against the app's Play public
  key (public data — safe to ship).
- **iOS**: use StoreKit 2, where `Transaction.currentEntitlements` is JWS the
  operating system verifies. Verification is close to free, and the on-device
  transaction cache reads fine in aeroplane mode.

Release builds get `--obfuscate --split-debug-info`, which makes
patch-the-check meaningfully more annoying for one flag's effort.

## Moving to a new phone

A non-consumable is tied to the **store account**, not the device.

- Android restores silently: Play returns owned products on the next launch
  under the same Google account.
- iOS needs a visible **Restore purchases** control. This is an App Review
  requirement for non-consumables, not a nicety. `EntitlementService.restore()`
  already exists; it needs to be reachable from the UI.

That costs one internet connection on the new device, which is unavoidable —
no scheme can prove a purchase to a device that has never heard of it. After
it, the receipt is local again and every launch verifies offline.

**Not solved:** an Android purchase does not carry to an iPhone. Different
stores, different transactions. The only fix is an account system, which means
a backend; at €11.99 it is not worth it. Answer it in a FAQ line.

**Saves usually travel too**, incidentally: the database lives in
`getApplicationDocumentsDirectory()`, which iOS backs up to iCloud and Android
covers with Auto Backup (25 MB per-app cap, which a save fits inside).

## Measurement

Two different things, and only one of them is at risk by waiting.

**Money is never lost.** The store consoles record every transaction from day
one, regardless of what the app ships. Revenue, units, refunds, by country and
day, readable years later.

**The funnel cannot be backfilled.** How many players reached the cycle-1 wall
and closed the app instead of paying is a non-event, and nothing records a
non-event retroactively — not RevenueCat, not the stores. If the launch
window's conversion specifically matters, it must be instrumented before
launch, because that window happens once.

The judgement taken: for a first paid release the number that matters is
whether anyone buys at all, and the consoles give that. Instrument the funnel
later, when there is a specific question it would answer.

## RevenueCat: considered, deferred

It would genuinely solve three things — server-side validation (closing the
receipt-copying hole), a conversion dashboard, and cross-platform entitlement.
It is free below a monthly-revenue threshold.

Deferred because:

- It is a third-party SDK talking to a third-party server, which means a
  privacy policy, App Store privacy labels ("Purchases", "Identifiers") and a
  GDPR processor agreement — in an app that today declares nothing. That is the
  same objection that removed `supabase_flutter`.
- Its value is concentrated in *subscriptions*: renewals, churn, grace periods,
  billing retry. This is one non-consumable. Most of what it does would go
  unused; the dashboard is the real purchase.

**The decision is cheap to reverse.** Entitlement sits behind one provider
(`premiumUnlockedProvider`) and one service, so swapping the source from a
local receipt to `Purchases.getCustomerInfo()` later touches one file, and
existing buyers sync automatically the first time they open an SDK-carrying
build. Nobody has to buy again.

## Out of scope

- Any subscription, tier, or second product.
- Cross-platform accounts.
- Cloud saves.
- In-app analytics of any kind.
