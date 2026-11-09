# Clubs expansion report (branch `feat/clubs-expansion`)

Implements `clubs-proposal.md`: 5+ named clubs per country, editor cap 500 to
5,000 with an O(n) clash check, derived 1-5 star club strength with editor
override, level-weighted club pick, pack format 3. Not merged, not pushed.

## Commits

- `fdabac7e` feat(clubs): every country gets a named league, clubs get 1-5 stars, new careers draw by level
- `eafcb868` feat(clubs): club strength stars on the player page, squad (phone and tablet), club history and transfer report
- `9c7d8df6` feat(editor): club strength picker for league and added clubs, stars on club rows
- `ab1073e2` test(clubs): goldens show club stars; story pins hold names and ratings, clubs held to the career's first read
- (this report)

## What changed

- **Leagues** (`lib/domain/services/club/clubs_more_leagues.dart`, a `part` of
  `clubs.dart`): 178 fictional leagues for every nation without a curated one
  (209 base nations plus Belarus, Greenland, Zanzibar). 8 hand-picked clubs for
  the 11 stronger countries (cro, srb, ukr, pol, uru, chi, rou, isr, qat, uae,
  irn; tier 4), 6 generated clubs (city plus colour/animal/trade, never the
  legacy `City/United/FC...` suffixes, brand denylist) for the rest (tier 5).
  None is a destination abroad. Curated lists untouched.
- **Strength** (`ClubStrength`): `derived(index, count, tier)` per the
  proposal; `targetFor(level)`; `weight(distance)` 100/20/3/1. `ClubWorld`
  indexes a world's added clubs, added-club strengths and game-club overrides
  once per world (the per-read `_withAdded` copy is gone).
- **Saves**: `clubStrengthKind = 'clubStrength1'` cycle-0 marker, written by
  `CareerService.create` before `briefRules2`. `DriftPlayerRepository` reads it
  (settled like the pool era) and passes `strength:` to every `_finish`. No
  marker = the legacy draw, byte for byte. No schema change.
- `Player.clubStars` (freezed, default 0) set on every read, off the club's own
  name before a world renames it.
- **Pack format 3**: `WorldPack.clubStrengths`, `PackClub.strength` (written only
  when set), `_from2To3`. Encode always writes 3, so an older build says
  "newer version". `PackRules`: cap 5,000, `clubStrengthsMax` 5,000, strength
  1-5 else `BadField`; `ClubNameIndex` replaces the quadratic scan
  (`clubNameClash` keeps its signature).
- **UI**: `ClubStars` (muted, semantics "Club strength: N of 5") on the player
  page, squad tab (phone and tablet grid), club history (`ClubSpell.stars`),
  transfer report (`#transfers/v4` carries both sides' stars; v1-v3 still decode).
- **Editor**: `ClubStrengthPicker` (Default / 1-5) inside `NameEditForm` and
  `AddedItemForm`, which both the phone sheet and the tablet pane use; stars on
  every club row; all 212 countries listed; a set strength counts as a change;
  renaming an added club keeps its strength.
- **Copy**: `clubStrengthOf`, `editorClubStrength`, `editorClubStrengthDefault`,
  `editorClubStrengthHelp`, 28 languages via `copy/strings.csv`, imported, `gen-l10n`.

## Rulings

1. **Existing careers keep the whole legacy draw; only new careers draw by
   strength** (no per-deal switch-over). Why: the owner's hard rule, and it is
   provable byte for byte without threading the aging year into seven call
   sites. Cost if wrong: running careers never get the new leagues or the
   level-weighted pick (they do show stars, derived, on their old clubs; a
   legacy city side reads its league's lowest). A later per-deal switch can
   reuse the marker by giving it an activation year.
2. **Target-star bands 84/78/72/66** (the `tierForOverall` bands), not the
   proposal's 86/80/74/68. Why: the proposal's own worked example (85-rated: 74%
   at a five-star club) only holds with 85 targeting 5 stars. Cost: players sit
   one star higher near each band edge.
3. **`tierOfCountry` and fee ceilings unchanged**; a new league's tier (4 for
   the stronger 11) feeds its stars only. Why: fees and transfer news of
   running careers must not move. Cost: a move into Croatia is still priced
   with the tier-5 ceiling.
4. **Strengths live on `Player.clubStars`**, computed before the world's
   rename. Why: the screens only know the renamed name, which no lookup can
   resolve. Cost: one more freezed field (default 0, json-compatible).
5. **Generated lists for 167 nations, hand-picked for 11.** Why: about 1,000
   names; the generator is deterministic, avoids legacy suffixes and a brand
   denylist. Cost: some read plain ("Andorra la Vella Oranges"); worth an owner
   read-through of `clubs_more_leagues.dart` (append only from now on).
6. **Unknown `clubStrengths` keys are not flagged** (proposal said "key must be
   a game club"). Why: same as the `clubs` rename map, an unknown key does
   nothing, and flagging would put packs into "needs attention" after any
   future club rename. Cost: a typo in a hand-edited file silently does nothing.
7. **Strength is not part of "Reset to original"** (names only); the picker's
   Default is its reset. Picker shown under All languages only.
8. **A format-2 file carrying a format-3 key is refused as malformed**, the
   same rule `_from1To2` applies.
9. **Story pins** (`world_pack_story`, `editor_2_story`) now compare names,
   ratings and traits to the pin, and hold clubs to the career's own first read
   (their careers are new, so they draw by strength). The legacy draw stays
   pinned on unmarked careers by `v1_world_pin_test` and
   `player_repo_world_test` (golden files untouched).
10. `localizedMax` left at 20,000 as proposed.

## Tests

- New: `test/unit/club/club_legacy_fingerprint_test.dart` (legacy draw
  fingerprint measured on adc7c1b2, 6,720 draws over 8 seeds, matches);
  `test/unit/club/club_strength_test.dart` (stars table, overrides, level-85 in
  England 78% five-star / under 6% three-star, 74-79 mid-table, Czech top and
  bottom, exports, contract clock 10-40% moves, every nation 5+ unique clubs,
  name guards, new leagues never a destination); `test/unit/world_pack/club_cap_test.dart`
  (5,000 pass / 5,001 refused in rules and in a file, `issues()` over 5,000
  clubs in about 6-14 ms, bound 200 ms, index equals the old scan over a grid
  of cases, strength range); codec/json format 2 and 3 round trips;
  `test/widget/editor_club_strength_test.dart` (phone, added club, every tablet size).
- Existing-career proof: `player_repo_world_test` "default career from before
  club strength" (marker removed, fresh app, matches the pre-change golden) and
  `v1_world_pin_test` (same for a 1.1.0 pack career).
- Goldens regenerated and looked at: `player_phone.png`,
  `player_phone_tall.png`, `squad_phone.png` (stars after the club name).
- Run green: test/unit/world_pack, test/unit/club, test/unit/domain/clubs*,
  club history, transfer report, l10n, editor widget tests, player/squad phone
  and tablet tests, both world-pack stories, hub/career/squad/data/campaign units.

## Concerns

- Tier-5 leagues are one star throughout, so the pick is uniform there: most
  new leagues and the curated Norway, Sweden, Denmark, China, Ecuador,
  Paraguay, Chinese Taipei. The "club follows level" effect shows in tiers 1-4.
- On the phone squad row the stars take about 50 px, so long club names
  truncate sooner. Needs a device look.
- A pack whose added club happens to share a name with a new league club of
  its country now reads as a `NameClash` (needs attention) until renamed.
- Not checked: an older build importing a `.fnmcareer` bundle made by this
  build (its world is format 3).
- Full suite not run (per instructions); device playtest still to do.
