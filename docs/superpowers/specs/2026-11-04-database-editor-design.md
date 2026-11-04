# Database Editor (1.1.0) — Design

Date: 2026-11-04. Owner-approved in conversation; items marked *(builder's call, settled)* were decided by Claude where the owner gave no direction.

## Intent

1.1.0's headline feature. Players can make their own version of the starting world, mostly to put in the players they want with the powers they want, and share it with friends as a file. It is a fan-pack system in the spirit of Football Manager / PES option files: the community makes and passes around packs; the game only gives them a good editor and a safe way to load them.

Success: a player can open the editor from the main menu, rename and re-rate a nation's squad on a phone without frustration, export the result, send it to a friend, and the friend can import it and start a career on it. The default game is untouched.

## Goals

- A main-menu entry, **Editor**, that lists the databases on this device and lets the player create, edit, rename, duplicate, delete, export and import them.
- Any number of databases per device.
- A new database starts as a copy of the default world (one fixed draw of its fictional names) and is edited from there.
- **New Game** lets the player choose the world: **Default** or any complete, compatible database on the device.
- Free for everyone. No Pro gate on making, sharing, importing or playing a custom database (a career on a custom database still follows the normal free-cycle/Pro rules of the game itself).
- Robust to the owner's game updates (see "Game updates").

## Non-goals

- **No backend, no marketplace, no uploads to the owner's site.** Sharing is a file passed around outside the game (AirDrop, messaging apps, Discord, e-mail, cloud drives, forums). This was chosen for legal reasons: the owner does not host or curate fan content.
- **No photos of people, kits, crests or anything else.** The only images are trophy pictures.
- Editing a running career. A database only shapes the world a *new* career starts from.
- Changing the competition system: no adding/removing nations, no moving nations between confederations, no changing formats, places, hosts rules or calendars. (The *starting ranking* is recalculated from the edited squads; see decisions.)
- Changing the default world in any way.

## Anti-goals (would make it a failure even if it works)

- An existing save changes, breaks or loses data because of this feature.
- Deleting or re-importing a database breaks a career that was started on it.
- A game update silently corrupts a custom database, or lets an incompatible one start a career.
- A file from the internet can do anything other than supply names, numbers and trophy pictures.
- Store screenshots, the store listing or the default experience show real people's names.

## What can be edited

Organised **by section** (owner chose this layout over by-nation and one-big-table). The database home shows each section with its completeness, plus an overall "ready to play" bar.

1. **Players** — per nation: name, age, position, club, overall + player type, potential. Add and remove players within the completeness limits.
2. **Nation names** — the display name of each nation (the nation list itself is fixed).
3. **Clubs** — club names (per country lists the game already uses).
4. **Stadiums** — national stadium names (and the names used when a stadium is built/named in-game).
5. **Competitions** — the display names of the World Championship, the six continental championships, the Nations Cups, the Continental Clash and other named competitions; plus their **trophy pictures**.
6. **Y accounts** — the names/handles of the recurring Y accounts (regulars, personas) and the local fan name sources.
7. **Press** — journalists' and pundits' names.
8. **Staff** — the names in the staff market.
9. **Sponsors** — the general sponsor brand names.

A custom name replaces the game's name **in every language** (today competitions and nations are translated into 28 languages; a custom "Pohár Hamburgerů" shows the same everywhere). Untouched names keep their normal translations. *(builder's call, settled)*

### Editing a player

Owner chose **Overall + player type** over three raw sliders:

- The editor shows one **Overall** number (1–99) and a **type** chip row (e.g. Athlete, Playmaker, Engine, Balanced; the builder settles the final list per position group).
- The editor converts overall + type + position into the game's three stored qualities (physical, technical, stamina) such that the game's own position-weighted overall comes out at the number shown.
- **Potential is editable.** Today it is hidden and derived from the player id; for custom databases it must be stored and honoured by development. Default-world behaviour must stay exactly as now.
- Name, age, position, club are plain fields. Club is picked from the database's own clubs (search), not typed freely.

### Trophies

- The game has 9 trophy pictures (`assets/trophies/*.png`, transparent PNG; the World Championship one 400×400, the rest 400×600).
- The player picks an image from the device. The editor shows a frame in the right shape over it, lets them position/scale it, previews it the way the game shows trophies, and stores a re-encoded transparent PNG at the game's size.
- A picture without transparency is allowed but the editor warns that it will show as a rectangle. *(builder's call, settled)*

### Name checks

Light, no content moderation: not empty, a sensible length cap per field, no control characters, printable Unicode only. Duplicate player names inside one nation get a warning, not a block.

### Decisions after the builder check (owner: "ok to all", 2026-11-05)

1. **Names.** The default world re-draws every player's name per save from the name pools (`DriftPlayerRepository._namerFor`), so `players.json` names are placeholders nobody sees. A new database therefore starts from **one fixed draw** of the pools, stored in the database, so the editor shows real-looking names. A career on a database uses **exactly the database's names**, no re-draw; an edited name is exactly what was typed. Players the game generates later (youth intake, fringe padding) still get drawn names, as now.
2. **Clubs.** The editor's club is the player's club **on day one only**; the normal transfer clock (`ClubService`) carries on from there. The Clubs section **renames** the existing clubs of each country's lists; it does not add or remove clubs (tiers and retention figures depend on those lists).
3. **Long-run strength.** Edited strength **carries on**: youth intake quality follows the edited squad (`PlayerLifecycle._intake`) as it does for the default world. The **starting world ranking is recalculated from the edited squads** for a database career, so draw pots and seeding at the start reflect the pack. Competition formats, places and hosts rules are unchanged.
4. **Potential** in the editor is the **peak overall** the player can reach if he develops well (a ceiling, not a guarantee). The game's id-derived hidden superstar status is **off for database players**: a player plays at the strength the editor gives him, and superstars exist only where the creator set a very high potential.
5. **Nation codes.** Renaming a nation also lets its 3-letter code be edited (3 letters A–Z, unique in the database). *(builder's call, settled)*

## Completeness ("ready to play")

A database can be saved, exported and shared at any stage (friends can work on one together). It can only **start a career** when complete. The completeness check is about counts and shape, not content:

- Every nation has at least the squad the game needs to run all its competitions (the default world has 23 core players per nation; the minimum, goalkeeper count and per-position cover are the builder's call from what match, call-up and injury code actually need).
- Every edited field is within range (ages, ratings 1–99, potential ≥ overall where it must be).
- Every required name is present.

The home screen shows exactly what is missing and jumps to it ("Czechia: 2 goalkeepers needed").

## Sharing

- **Export** produces one file, e.g. `My World 2027.fnmdb`, and opens the system share sheet.
- **Import**: tapping a `.fnmdb` file anywhere (Files, Mail, WhatsApp, AirDrop) opens the game and imports it; there is also an Import button in the editor that opens a file picker.
- **Every import becomes its own database** in the list. Importing a newer version of a pack does not replace the old one; the player deletes whichever they don't want.
- The file records the pack's name, author name (free text, optional), the game version it was made with, and a format version.

### Safety

The file is data only. On import the game:

- Accepts only the expected parts (structured data + up to 9 trophy PNGs); anything else in the file is refused and the import fails with a plain message.
- Enforces a total size cap and per-part caps.
- Validates every field against the same rules as the editor (types, ranges, lengths).
- Decodes and **re-encodes every trophy image** to a fresh PNG at the game's size, so nothing hidden in an image survives.
- Never executes anything from the file.

## Game updates

The owner will keep updating the base game (new nations for new careers like Belarus, new name lists, new fields).

- A database is stored as **changes on top of the default world** (only what the player edited), keyed by stable ids, plus the format version. Parts the player never touched follow the current game, so most updates flow straight in. *(builder's call, settled)*
- When an update adds something new (e.g. a dormant nation that new careers now get), a database simply uses the default for it.
- If an update makes a database **incompatible** (it refers to something that no longer exists, or a rule it breaks), it is kept, marked as needing attention in the database list and the editor, and cannot start a career until fixed in the editor. The editor shows what to fix. This should be rare; the owner's updates should prefer migrations that keep packs compatible.
- Every format change ships a migration from the previous format, the same discipline the save schema already follows.

## Careers and databases

- New Game offers **Default** plus every complete, compatible database.
- A career started on a database **keeps working forever**, even if the database is later edited, deleted or replaced. *(builder's call, settled: the career keeps its own copy of what it started from.)*
- Existing careers and saves are untouched. A career with no database recorded is a default-world career.
- Campaigns (Greenland, Zanzibar, Legacy, etc.) always use the default world. *(builder's call, settled)*
- The career list / save card shows which database a career uses.

## UI quality bar

"Nice and useful". Phone first, tablet layouts like the rest of the app (the tablet-ready sweep must cover every new route). Fast on 209 nations × 23+ players: search everywhere, no screen that renders thousands of rows at once. Unsaved work is never lost (edits save as you go; undo for the last changes). Every new string in all 28 languages, no em dashes, never "World Cup" in English copy.

## Constraints from the existing game

- Saves must stay compatible; any schema change follows the stepwise migration recipe.
- The world is deterministic per career (seeded); a custom database must keep that property.
- The base player table is shared; careers reconstruct their world from it plus per-career markers. A custom database changes what a career reads as its starting world, so every place that reads seed data for a career (players, names, clubs, stadiums, competition names, trophies, Y, press, staff, sponsors) must respect the career's database.
- Fringe players are generated from each nation's squad names and name lists; a custom database's names feed that generation the same way.

## Left to the builder

- File format details (container, structure, size caps).
- The exact completeness minimums.
- The player-type list and the overall→qualities conversion.
- How potential is stored and how development reads it.
- How the career keeps its copy of the database.
- Undo depth, editor navigation details, empty states.
- Which Y/press/staff names are exposed (all recurring named accounts and people the player sees).
