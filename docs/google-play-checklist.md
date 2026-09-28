# Google Play Console: first release checklist

For **Football Nations Manager** (`com.fnm.fnm`), phones, EN + CS, fully offline,
one one-time unlock (`com.fnm.fnm.premium`).

> **Caveat.** Written by Claude from knowledge that runs to mid 2026. Google
> renames Play Console menus often. **The app-specific answers below are
> correct; any menu path or field name should be checked against the screen
> in front of you, which always wins.**

Everything uploadable is in `docs/play-store/`.

---

## 0. Before anything: the account type decides your timeline

- **Personal developer account created after Nov 2023:** Play will not let you
  publish to Production until a **closed test has run with at least 12 testers
  opted in for 14 continuous days**. Start that closed test as early as you can;
  it is the longest wait in this whole list.
- **Organisation account** (needs a D-U-N-S number): no such requirement.

You also need a **payments profile** (Setup → Payments profile / merchant
account) before you can create a paid product. Do it early; tax and bank
details can take a while to verify.

---

## 1. The upload key (once, and back it up)

Play signs the app delivered to phones with its own key (Play App Signing).
You sign uploads with an **upload key**. Lose it and you must ask Google to
reset it, which takes days, so keep a backup somewhere safe.

Run in this session with the `!` prefix so the passwords stay with you:

```
! keytool -genkey -v -keystore ~/fnm-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` (git-ignored, see
`android/key.properties.example`):

```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/Users/martinurbanczyk/fnm-upload-key.jks
```

Build the bundle:

```
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab
```

Without `key.properties` this build stops with an explanation, on purpose.

**Version code:** every upload needs a higher `+N` in `pubspec.yaml` than any
bundle uploaded before, even a rejected one.

---

## 2. Create the app

**All apps → Create app**

| Field | Value |
|---|---|
| App name | Football Nations Manager |
| Default language | English (United Kingdom) or Czech, your choice |
| App or game | **Game** |
| Free or paid | **Free** (the unlock is an in-app product) |
| Declarations | accept both |

Free vs paid **cannot be changed later** from free to paid. Free is correct.

---

## 3. Upload a first build to Internal testing

**Testing → Internal testing → Create new release**, upload the `.aab`, and
accept Play App Signing when asked.

This comes before the product on purpose: Play only lets you create in-app
products once it has seen a bundle that requests the billing permission (ours
does: `com.android.vending.BILLING`, added by the plugin).

Add yourself under **Testers** (an email list), then open the opt-in link on
the phone and install from Play. The sideloaded APK must be uninstalled first:
Play refuses to update over a build signed with a different key.

---

## 4. The in-app product

**Monetize → Products → In-app products** (may be called *One-time products*)
**→ Create product**

| Field | Value |
|---|---|
| Product ID | **`com.fnm.fnm.premium`** (must match `kPremiumProductId`; cannot be changed or reused) |
| Name | Unlimited / Neomezené FNM |
| Description | the same two promises the in-app wall makes: endless cycles and more saves |
| Price | **EUR 12.99**, let Play convert the other countries |

Then **Activate** it. An inactive product is invisible to the app, which then
correctly reports the store as unavailable.

### Testing the purchase without paying

**Settings → License testing**: add the Google account on the phone. Licence
testers get test cards ("always approves", "always declines", "slow card")
and are never charged. Test, on an **internal testing** install:

1. Buy: the wall clears.
2. Uninstall, reinstall from Play, launch: **unlocked with no Restore tap**
   (this is the new launch-time check).
3. Refund it in **Order management**, relaunch: locked again.
4. "Slow card": stays pending, then unlocks once the payment goes through.

---

## 5. App content (Policy → App content)

| Section | Answer |
|---|---|
| Privacy policy | `https://footballnationsmanager.com/privacy.html` (now covers Google Play; **upload the updated `docs/site` first**) |
| Ads | **No ads** |
| App access | All functionality available without special access (no login) |
| Content rating | IARC questionnaire, category **Game**. No violence, no sexual content, no gambling, no user interaction or chat, no location sharing. It **does** have digital purchases. Expected result: PEGI 3 / Everyone |
| Target audience | **13 and over** recommended. Including under-13 opts you into the Families policy and a stricter review; the app would pass, but it adds work for little gain |
| News app | No |
| Data safety | **No data collected, no data shared.** Everything stays on the device; the purchase is handled by Google Play itself, which Google declares, not you. Encryption in transit: not applicable. Deletion request: not applicable (no accounts) |
| Government app / financial features / health | No |

---

## 6. Store listing (Grow → Store presence → Main store listing)

Add a **Czech translation** of the listing alongside English (the same
screen, *Manage translations*).

| Asset | File |
|---|---|
| App icon 512 x 512 | `docs/play-store/icon-512.png` |
| Feature graphic 1024 x 500 | `docs/play-store/feature-graphic-en.png`, `feature-graphic-cs.png` |
| Phone screenshots (2 to 8) | `docs/play-store/screenshots-en/`, `screenshots-cs/` (1000 x 2000, inside Play's 2:1 limit) |

The screenshots come from the iPhone. They are fine for Play, but shots taken
on the Android phone would look more native once the build is final.

Category: **Games → Sports** (or *Simulation*). Contact email and website:
`https://footballnationsmanager.com`.

### English

**Title** (max 30): `Football Nations Manager`

**Short description** (max 80):
`Offline international football manager. Take a nation, lead it to glory.`

**Full description** (max 4000):

```
Take a nation. Lead it to football Olympus.

Football Nations Manager is an international football management game that plays entirely offline. Pick any of 209 nations, a giant or a minnow, and manage it through endless four-year cycles: qualifying, your continental cup, the World Championship, then round again.

LIVE MATCHES
Change shape, bring players on, and talk to your team at half time. When it goes to penalties, you choose the order and you take them yourself.

A WHOLE FOOTBALL WORLD
- 209 nations, all playable from day one, none locked away
- A youth pyramid from U-13 to U-21: follow a boy for years and see what he becomes
- Transfers across borders: your players change clubs every summer, step up and drop down
- The press asks thirty kinds of question, and a feed has opinions about your answers
- A board with objectives every cycle, and consequences when you miss them

A CAREER OF YOUR OWN
Skills that grow, staff to hire, a federation budget to spend. Every cap and goal is kept, with thirty-seven challenges to chase.

PLAYS OFFLINE
Every match runs on your phone. No account, no server, no signal needed.

ONE PAYMENT
Play a whole cycle free, with nothing held back. If it suits you, one payment unlocks endless cycles and more saves. No subscription, no adverts, no in-game currency, ever.

English and Czech.
```

### Čeština

**Název** (max 30): `Football Nations Manager`

**Krátký popis** (max 80):
`Offline manažer reprezentace. Vezměte zemi a doveďte ji na vrchol.`

**Úplný popis** (max 4000):

```
Vezměte reprezentaci. Doveďte ji na fotbalový Olymp.

Football Nations Manager je manažerská hra o reprezentačním fotbale, která běží celá offline. Vyberte si kteroukoli z 209 zemí, velmoc i otloukánka, a veďte ji nekonečnými čtyřletými cykly: kvalifikace, kontinentální pohár, mistrovství světa, a zase od začátku.

ŽIVÉ ZÁPASY
Měňte rozestavení, střídejte a v poločase k hráčům promluvte. Když dojde na penalty, určíte pořadí exekutorů a kopete je sami.

CELÝ FOTBALOVÝ SVĚT
- 209 zemí, všechny hratelné od prvního dne, žádná zamčená
- Mládežnická pyramida od U-13 po U-21: sledujte kluka roky a uvidíte, co z něj bude
- Přestupy přes hranice: vaši hráči mění kluby každé léto, jdou nahoru i dolů
- Novináři kladou třicet druhů otázek a feed má na vaše odpovědi názor
- Svaz s cíli na každý cyklus a následky, když je nesplníte

VLASTNÍ KARIÉRA
Dovednosti, které rostou, štáb k najmutí, rozpočet svazu k rozdělení. Každý start i gól se počítá a čeká na vás sedmatřicet výzev.

HRAJE SE OFFLINE
Každý zápas se počítá v telefonu. Žádný účet, žádný server, žádný signál.

JEDNA PLATBA
Zahrajte si celý cyklus zdarma a bez omezení. Když vám hra sedne, jedna platba odemkne nekonečné cykly a víc uložených her. Žádné předplatné, žádné reklamy, žádná herní měna.

Česky a anglicky.
```

---

## 7. Order of operations

1. Payments profile (and check the account type, section 0)
2. Upload key + `key.properties`, bump `+N`, `flutter build appbundle`
3. Create the app
4. Internal testing release, install from Play on the phone
5. In-app product, activate, licence tester, run the four purchase tests
6. App content + store listing (EN + CS), deploy the updated privacy page
7. **Closed testing** with 12+ testers for 14 days (personal accounts)
8. Production
