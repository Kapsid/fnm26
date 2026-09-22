# App Store Connect — first submission checklist

For **FNM** (`com.fnm.fnm`), iPhone only, EN + CS, fully offline, one non-consumable unlock.

> **Read this caveat first.** This was written by Claude, whose knowledge runs to
> roughly **May 2026**. Apple reshuffles App Store Connect regularly: field names
> move, questionnaires gain rows, screenshot sizes change with each new device.
> **The structure below is stable and the app-specific answers are correct. Any
> specific dimension, field name or menu path should be checked against the screen
> in front of you, which always wins.**

---

## 0. Before you start

Have ready:

- **Three candidate app names.** The name must be unique across the entire App
  Store. "FNM" is almost certainly taken. It is also what appears under the icon,
  so something like "Football Nations Manager" reads better anyway. Changeable
  until first release.
- **A privacy policy URL.** Required even though the app collects nothing. A
  single static page saying so is enough, but it must be reachable.
- **The 1024 icon** is already in the build — you do **not** upload it separately.
  App Store Connect reads it from the archive. A copy sits in your Downloads if you
  want it for the policy page or elsewhere.

---

## 1. Create the app record

**My Apps → + → New App**

| Field | Value |
|---|---|
| Platform | iOS |
| Name | your chosen name |
| Primary language | English or Czech (the fallback; both get localised later) |
| Bundle ID | **`com.fnm.fnm`** — pick from the dropdown, do not type a new one |
| SKU | internal only, never shown. `fnm-ios-001` is fine |
| User access | Full |

The bundle ID should already exist, because automatic signing registered it while
building to your phone.

---

## 2. The in-app purchase

Do this **immediately after** the app record. A first submission reviews the app
and its IAP together, so the purchase needs to be ready when the build is.

**Features → In-App Purchases → +**

| Field | Value |
|---|---|
| Type | **Non-Consumable** |
| Reference name | internal, e.g. `Unlimited` |
| Product ID | **`com.fnm.fnm.premium`** |
| Price | the **EUR 12.99** tier |

**The product ID must match exactly.** It is hardcoded as `kPremiumProductId` in
`lib/domain/services/entitlement/entitlement_service.dart`. A mismatch means the
app finds no product, and the wall correctly reports the store as unavailable —
which looks like a bug and is not one.

**Price base.** You pick one currency; Apple generates every other storefront from
it. EUR prices include VAT, USD prices do not, so the same-looking number earns
differently. The full per-storefront table is shown when you pick the price —
read it there rather than converting by hand.

Then fill in, per language you support:
- **Display name and description.** These must say the SAME two things the in-app
  wall says: **endless cycles** and **more saves**. Nothing about nations — those
  are free for everyone. A buyer or reviewer reading two different promises is a
  rejection risk and, worse, a refund.
- **Review screenshot.** Required, and easy to miss. A screenshot of your actual
  purchase screen. Take it from a real build rather than mocking one.

It must reach **Ready to Submit** before it can go with your first build.

---

## 3. App Privacy

**App Privacy → Get Started**

This app is the easy case: it has no backend, makes no network call except to the
store, and collects nothing.

- **Do you collect data from this app?** → **No**
- That should end the questionnaire.

If a later question asks about tracking: **no tracking, no tracking domains.** That
matches the `PrivacyInfo.xcprivacy` shipped in the build, which declares no
collected data types and `NSPrivacyAccessedAPICategoryUserDefaults` (`CA92.1`) as
the only required-reason API.

**You still need the privacy policy URL** even answering "No" throughout. A page
stating that the app collects nothing, stores everything on the device, and talks
only to Apple for purchases is sufficient.

---

## 4. TestFlight

**Upload:** Xcode → `Runner.xcworkspace` → destination **Any iOS Device** →
Product → Archive → Organizer → Distribute App → App Store Connect.

Run `flutter clean` first. Stale frameworks from old dependency sets accumulate in
`build/` and `flutter build` never removes them.

**Export compliance** is already answered in the build
(`ITSAppUsesNonExemptEncryption = false`), so uploads should not be held asking.

**Build numbers:** every upload needs a **strictly higher** build number than any
previously uploaded under the same version string — the number is burned even if
you delete the build. Bump `+N` in `pubspec.yaml` (`1.0.0+1` → `1.0.0+2`). The
marketing version can stay at `1.0.0` for many builds.

**Internal vs external testers:**
- **Internal** (up to 100 people on your team): available almost immediately after
  processing, **no review**. This is where you start.
- **External** (up to 10,000): needs a **TestFlight review** first, which is
  lighter than App Review but not instant. Needs a "What to Test" note and a
  contact email.

**Sandbox purchases:** a TestFlight build buys through the sandbox, not for real
money. The tester's device needs a sandbox Apple ID (Settings → Developer). Until
the IAP is Ready to Submit, the app will honestly report the store as unavailable.

---

## 5. Store listing

**Screenshots.** Required for at least the largest iPhone display size; Apple
scales down for smaller ones. **Verify the current required sizes in the upload
screen — these change with each device generation and I cannot promise 2026's
numbers.** Take them from a real device rather than a simulator where you can;
iPhone-only means one set, which was the point of dropping iPad.

**What to show:** a match in progress, the tactics pitch, the squad, a tournament
bracket, the world ranking. The strength of this game is depth, so show screens
with real data in them rather than empty states.

**Description.** Lead with what it is — an offline international football
management sim, one nation, endless cycles. Worth stating plainly, because they
are genuinely unusual: **no accounts, no ads, no subscription, no network.**

**Promotional text** (changeable without a new build) is a good place for "what's
new this build" during testing.

**Keywords:** 100 characters, comma-separated, no spaces after commas. Do not
repeat words already in your title.

**Age rating:** a football management sim with no violence, gambling or user
content should come out 4+. Answer the questionnaire honestly; **if you ever add
loot-box-like mechanics that changes.**

**Localisation:** you support EN and CS. Add both, with the Czech listing written
in Czech rather than machine-translated — your first testers are Czech and it will
show.

---

## 6. Order of operations

1. Create the app record
2. Create the IAP, get it to **Ready to Submit** (including its review screenshot)
3. `flutter clean`, bump the build number, archive, upload
4. Wait for processing, then **internal** TestFlight to yourself
5. Buy the unlock in sandbox and confirm the wall clears
6. Widen to external testers, or go to App Review

**Step 5 is the one to not skip.** The purchase path has never met a real
StoreKit sandbox. Everything up to it is verified by tests; that step is not.
