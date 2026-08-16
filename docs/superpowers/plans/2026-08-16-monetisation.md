# Monetisation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sell the game. One free four-year cycle, then a one-time €11.99 unlock, on an app that stays offline and collects nothing.

**Architecture:** Three independent pieces. The **gate** decides when to ask (one choke point, `startNextCycle`). The **entitlement** decides whether the answer is yes (a signed receipt, verified on device). The **build** raises the cost of patching it out. They can land in any order, but the gate is worthless without the entitlement it reads, so build 1 → 2 → 3.

**Tech Stack:** Flutter / Dart, Riverpod (no codegen), `in_app_purchase` (already a dependency), `crypto`/`pointycastle` for the Play signature check, StoreKit 2 on iOS.

**Spec:** `docs/superpowers/specs/2026-08-16-monetisation-design.md`

## Global Constraints

- **No network at startup.** Verification is a local signature check. The only network calls in the app are the store's purchase sheet and a restore the player asked for. If a change here would add a background request, it is the wrong change.
- **Fail open.** A player already granted the unlock never loses it to a failed check. Every failure path in verification grants, not denies — the only thing that denies is a receipt that is present and provably wrong.
- **No new dependency that talks to a server.** No analytics SDK, no RevenueCat, nothing that would add a privacy disclosure. See the spec's "RevenueCat: considered, deferred".
- **Every user-facing string is localised** in both `lib/l10n/app_en.arb` and `lib/l10n/app_cs.arb`.
- **No `@riverpod` codegen**; hand-write providers.
- **Verification:** `dart format` check + `flutter analyze` + `flutter test` all pass before any commit.
- **The price is set in the consoles, not in code.** €11.99 is a Play/App Store price tier; the app only ever shows `ProductDetails.price`, which is already how the paywall reads it.

---

## Phase A — The gate

### Task 1: The trial ends where the cycle does [A1]

**Files:**
- Modify: `lib/features/hub/season_rollover.dart` (`_startNextCycle`)
- Modify: `lib/features/hub/hub_providers.dart` (`startNextCycle` — the public entry)
- Modify: `lib/features/hub/cycle_rollover_screen.dart` (where the manager rolls over)
- Test: `test/unit/career/trial_gate_test.dart` (create)

The free tier becomes "cycle 0, complete". `startNextCycle` is the only path
from cycle 0 to cycle 1, so it is the only gate.

**Interfaces:**
- Produces: `bool trialExhausted({required int cyclePointer, required bool premiumUnlocked})` in `lib/domain/services/entitlement/entitlement.dart` — pure, so the rule is testable without a store.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/career/trial_gate_test.dart
test('the first cycle is free', () {
  expect(trialExhausted(cyclePointer: 0, premiumUnlocked: false), isFalse);
});

test('the second cycle is not', () {
  expect(trialExhausted(cyclePointer: 1, premiumUnlocked: false), isTrue);
});

test('paying lifts it for good', () {
  for (var c = 0; c < 10; c++) {
    expect(trialExhausted(cyclePointer: c, premiumUnlocked: true), isFalse);
  }
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/career/trial_gate_test.dart`
Expected: FAIL — `trialExhausted` is not defined.

- [ ] **Step 3: Add the rule and read it at the choke point**

`startNextCycle` returns without rolling when the trial is exhausted. It must
NOT throw, and must not half-roll: the caller shows the paywall and the save is
left exactly as it was, so declining to pay costs the player nothing.

- [ ] **Step 4: Show the paywall where the roll was refused**

`cycle_rollover_screen` offers "Continue your career" as the primary action.
When the trial is exhausted that button opens `PaywallSheet` instead, and on a
successful purchase it rolls immediately — the manager should not have to find
the button again.

- [ ] **Step 5: Retire the old model**

Remove the `isFreeDemo` nation restriction from `nation_select_screen` and the
save-slot split in `maxSaveSlots` (five slots for everyone). The trial is the
whole game for one cycle; nothing else is held back. Leave the `isFreeDemo`
column in place — it is stored data and dropping it needs a migration for no
benefit.

- [ ] **Step 6: Verify and commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/domain/services/entitlement/ lib/features/hub/ lib/features/career/ lib/features/nations/ test/unit/career/trial_gate_test.dart
git commit -m "feat: the first cycle is the trial, and the wall is where it ends"
```

---

## Phase B — Entitlement worth trusting

### Task 2: Store the receipt, not a boolean [B1]

**Files:**
- Modify: `lib/domain/services/entitlement/entitlement_service.dart`
- Create: `lib/domain/services/entitlement/receipt.dart`
- Test: `test/unit/entitlement/receipt_test.dart` (create)

`_grant()` writes `prefs.setBool('premium_unlocked', true)`. Anything that can
write that file owns the game. Store the store's signed payload instead and
verify it at launch.

**Interfaces:**
- Produces: `bool verifyPlayReceipt({required String payload, required String signature, required String publicKeyBase64})`
- Produces: `Future<bool> hasValidReceipt()` on `EntitlementService`, replacing the cached bool as the source of truth.

- [ ] **Step 1: Write the failing test**

Use a throwaway RSA keypair generated in the test, sign a known payload with
it, and assert the verifier accepts it — then assert it rejects the same
payload with one byte changed, and rejects a payload signed by a different key.
Do not embed the real Play key in a test.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/entitlement/receipt_test.dart`
Expected: FAIL — `verifyPlayReceipt` is not defined.

- [ ] **Step 3: Implement the verifier**

Play's signature is RSA-SHA1 (their scheme) over the raw purchase JSON, base64
encoded, checked against the app's public key from Play Console → Monetisation
setup. The key is public; ship it as a constant. Prefer `pointycastle` if
`crypto` cannot do the RSA verify directly.

- [ ] **Step 4: Persist and re-verify**

On grant: store `localVerificationData` and `serverVerificationData`. On
`init()`: read them back and verify locally. No network.

**Fail open** — if the stored blob is missing or unreadable *and* the legacy
`premium_unlocked` bool is set, grant and rewrite it as a receipt when the
store next reports one. Existing buyers from any earlier build must not lose
their unlock.

- [ ] **Step 5: iOS — StoreKit 2**

Enable StoreKit 2 in `in_app_purchase_storekit` and read entitlement from
`Transaction.currentEntitlements`, which the OS has already verified and which
reads offline. The Play verifier above is Android-only; do not run it on iOS.

- [ ] **Step 6: Verify and commit**

```bash
git add lib/domain/services/entitlement/ test/unit/entitlement/
git commit -m "fix: the unlock is a signed receipt, not a boolean anyone can write"
```

---

### Task 3: Restore, and the moment it is needed most [B2]

**Files:**
- Modify: `lib/features/paywall/paywall_sheet.dart`
- Modify: `lib/features/settings/settings_screen.dart`
- Modify: `lib/domain/services/entitlement/entitlement_service.dart` (`restore`)

- [ ] **Step 1: Put Restore where review will find it**

Apple requires a visible restore control for a non-consumable. It belongs on
the paywall *and* in Settings — the second is where a player on a new phone
will look, having never seen the paywall on that device.

- [ ] **Step 2: Fix the false negative**

`restore()` currently gives up after 8 seconds and says "No previous purchase
found for this store account." On a new phone with a weak connection that tells
someone who paid that they did not. Distinguish *still waiting* from *nothing
found*: keep the pending state until the store answers, and only report
"nothing found" on an actual empty result.

- [ ] **Step 3: Verify and commit**

```bash
git add lib/features/paywall/ lib/features/settings/ lib/domain/services/entitlement/ lib/l10n/
git commit -m "feat: restoring a purchase is findable, and honest about waiting"
```

---

## Phase C — The build

### Task 4: Make patching it out annoying [C1]

**Files:**
- Modify: the release build invocation / any build script or CI

- [ ] **Step 1: Obfuscate release builds**

```bash
flutter build ipa --release --obfuscate --split-debug-info=build/symbols
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

Keep `build/symbols` — without it a crash report from a real device is
unreadable. Do not commit it.

- [ ] **Step 2: A real Android signing key**

`android/app/build.gradle.kts` still signs release with the debug keystore
(the Flutter template's TODO). Generate an upload keystore, wire it through
`key.properties`, and keep both out of git. **A debug-signed artifact cannot be
uploaded to Play**, so nothing ships until this is done.

- [ ] **Step 3: Commit**

```bash
git add android/app/build.gradle.kts .gitignore
git commit -m "build: sign release properly and obfuscate the binary"
```

---

## Console work (not code)

- [ ] Create the non-consumable `com.fnm.fnm.premium` in both consoles at the €11.99 tier.
- [ ] Enable **Family Sharing** (App Store) and **family library** (Play). Free toggles that remove a common refund request.
- [ ] Copy the Play **public key** (Monetisation setup) into the app constant used by Task 2.
- [ ] Fill the App Store privacy questionnaire: nothing collected. It stays true — keep it that way.

## Final verification

- [ ] **Full suite green.** `dart format --set-exit-if-changed lib test && flutter analyze && flutter test`
- [ ] **Sandbox purchase on a real device**, both platforms: buy, kill the app, relaunch in aeroplane mode, confirm the unlock survives.
- [ ] **Restore on a second device** signed into the same store account.
- [ ] **Confirm no startup network traffic** — the whole point. Watch the device's network activity through a launch.
- [ ] Update project memory with the model and the deferred RevenueCat decision.
