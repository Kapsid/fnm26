# Editor: merge databases and version history (design)

Date: 2026-11-12. Ships in 1.1.1. Branch `feature/editor-merge-history`.

Owner's ask: "merge more databases: into your database you can include others
and you get a list of changes; only changed places from the other DB are
suggested, so users can work together. Also some kind of versioning and
history list." The owner delegated the decisions; they are recorded here.

## 1. Merge

### Entry

- Pack home: a "Merge another database" row (phone: under the sections,
  tablet: in the right column), and the same action in the row's overflow
  menu on the editor list.
- Source: a `.fnmdb` file (same seam as Import: `editorFilePickerProvider`,
  `readPickedFile`, `PackCodec.decode` with every existing rejection and
  message, a newer format included) or another database on the device.

### Three-way diff against the default world

The base is the default world: a pack stores overrides, and an override that
is absent means "the game's own". So for every item we have base, mine and
theirs, and classify it:

| theirs vs base | mine vs theirs | mine vs base | class | shown | preselected |
| --- | --- | --- | --- | --- | --- |
| equal | - | - | only yours / untouched | no | - |
| differs | equal | - | same | no | - |
| differs | differs | equal | new from them | yes | take theirs |
| differs | differs | differs | conflict | yes, both values | keep yours |

Absent always reads as base: a nation with no squad entry has the default
squad, a pool that is not fixed is the generated pool, a missing map key is
the game's name. So "not fixed" never shows up as a change of its own.

Items (one review row each):

- **Player record**: the whole `PackPlayer` (name, age, position, the three
  attributes, potential, club, traits). Base = the default squad
  (`WorldPackService.defaultSquad`) or the default generated pool.
- **Squad membership**: where a player is (nation, squad or pool, or not in
  the database). Moving or removing a player is its own row.
- **New player** (created in their pack, unknown to mine): one row that adds
  him with his record at his place.
- **Override keys**: one row per key of `clubs`, `clubStrengths`, `stadiums`,
  `competitions`, `yAccounts`, `yHandles`, `reporters`, `sponsors`,
  `sponsorIndustries`, `nameLists` (per nation), `managers` (per nation) and
  `nations` (name and code per nation).
- **Added items** (clubs, sponsors, Y accounts, reporters, stadiums): one row
  per item. An item is matched with one of mine by id and name, else by name
  (and country or nation); a matched pair that differs is a conflict, an
  identical one is the same. Everything else is new and keeps its
  `localized` names with it.
- **Trophy picture**: one row per trophy key, compared by bytes, shown as
  thumbnails.
- **Translation**: one row per `localized` path and language.

Only nations whose squad (or pool) differs between the two packs are looked
at, so the default world is read only for those; a big merge reads a handful
of nations, not 210.

### Id remapping

Their pack is remapped before it is compared:

- A created player (`id >= kPackPlayerIdBase`) whose id mine uses for a
  player of another name gets a fresh id above both packs' highest.
- An added item that matches none of mine and whose id mine uses (all added
  kinds share one range) gets a fresh id in `kPackAddedIdBase..Max`; a
  matched one takes my id. `localized` paths naming an added id
  (`addedClubs.<id>`, `.description`, `.outlet`) follow the id.
- Players reference clubs by name, Y accounts and stadiums reference nations
  (never remapped), so no other reference moves.

### Review screen

Pushed from the pack home. Grouped by section (Players by nation, Clubs,
Stadiums, Competitions, Y, Press, Name lists, Managers, Sponsors, Trophies,
Nation names), each header with its count and All / None. A "Conflicts only"
filter. A bottom bar "Take N changes" with Apply. Rows are built lazily
(`SliverList.builder` over a flat row list), so thousands of players scroll.
Silver cards, fixed type sizes, no scale-down; values wrap.

### Apply

One new pack state: the existing editor (`PackEditor`) takes it, so undo,
the save-as-you-go and the issue list all work as for any edit. Before
writing, a history version of the current state is recorded ("Before merging
<name>"). The pack JSON, the trophy rows and the version are written in one
transaction. The existing rules run as for any edit; a merged pack that
breaks a rule (squad size, duplicate names, caps) is saved and flagged on the
home. Names are shown masked (`ProfanityFilter.mask`) and flagged
(`NotAllowedName`) exactly as after an import. A snackbar offers Undo, which
restores the version recorded before the merge (trophies included).

Diffing and applying run through `runOffUi` (a background isolate on devices,
inline in the browser).

## 2. History

### Versions

- Automatic: before every merge, before every restore, and once per editing
  session (when a pack is opened 30 minutes or more after its last version and
  it differs from that version, or has none yet).
- Manual: "Save version" with an optional name.
- Retention: the last 30 automatic versions per database; manual ones stay
  until deleted. Deleting a database deletes its versions.

### Screen

Pushed from the pack home ("History"). Newest first: the name, or the reason
("Before merging Tom's world", "Before restoring", "Session start"), the date
and time, and how many items differ from the current state (worked out
lazily per visible row). Actions: Restore (records the current state first),
Export as `.fnmdb` (share sheet on devices, download on the web), Rename,
Delete (manual versions, with a confirm).

### Storage (schema 55 -> 56, additive)

- `pack_versions`: id, pack_id, created_at, reason (text: `manual`,
  `session`, `beforeMerge`, `beforeRestore`), name (text, '' for none), json
  (blob: gzip of the pack JSON in the oldest format that holds it), trophies
  (text: JSON `{trophyKey: imageHash}`).
- `pack_version_images`: pack_id, hash, png; primary key (pack_id, hash). A
  picture is stored once per database however many versions hold it; images
  no version names any more are deleted with the last version that did.
- Migration `from55To56` creates the two tables and moves nothing. A save
  from any earlier build opens with empty history, and every pack and career
  is untouched (`schema_migration_test` and the real-fixture
  `save_upgrade_test` cover it).
- Both are global tables (no career): never in a career bundle, carried by
  the whole-database backup. The web editor stores them in the same Drift
  database in the browser.

## Out of scope

- Merging into a career's copy of a world (careers never read packs again).
- Field-level merging inside one player (the record is the unit).
- Automatic merging of two conflicting values.
