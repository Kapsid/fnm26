# Editor feedback batch 2026-11-09 (items 1, 2, 3, 4, 5)

Branch `feat/feedback-editor-1109` (not merged, not pushed).

## Item 3: "it says something needs fixing when nothing does"

Honest status: I could NOT reproduce a rule that misfires on valid data. What I did try, all clean:

- A default pack (real nations, expanded fringe seed): `PackEditor.issues` is empty at open.
- Every nation's generated pool fixed by a first pool edit (the "shown pool becomes the pack's pool" path): still empty, so generated fringe players never trip `PackRules.poolIssues`, the id-range check or `PackGameKeys` fringe ranges.
- The list status chip across edit, save, edit-back (repository cache, `assessPackAsync` Expando, `worldPacksProvider` invalidation): ready -> missing 1 -> ready, no stale count.
- Read-through of every cache keyed on pack identity (`PackEditor._issues`, `_squadIssues`, `_poolIssues`, nation list `_rowsCache`, name-section `_toFix`): all invalidate on a new pack object.

What I found and fixed instead (a real contradiction between screens, and the likely source of the report):

- `lib/features/editor/players/nation_list_screen.dart:98` counted `editor.squadIssues(n.id)` only. The pack home's Players section counts every issue under `squads.<n>` AND `pools.<n>` (`pack_home_screen.dart` `_PackView.of`, via `describePackIssue` -> `EditorSection.players`). A nation whose reserves had a problem (an unnamed reserve is the usual one: a new pool player starts with no name) therefore showed "Squad ready" in the nation list while the home said "N to fix": the two screens disagreed, and once you fixed the squad the nation list gave no hint where the remaining count was.
- Fix: new `PackEditor.nationToFix(nationId)` (squad issues + pool issues, both already cached per list, so still one nation rechecked per keystroke) used by the nation list.
- Regression test (failing first against the old line, passing after): `test/widget/editor_feedback_1109_test.dart`, group "the nation list agrees with the pack home". With the old `squadIssues` line it fails at the tile showing "Squad ready" instead of "2 to fix".

Remaining candidates I could not confirm (for the owner to describe if it still happens):

- The duplicate-name warning triangle on player rows (`SquadScreen.duplicateKey`, `_PlayerRow`) is a warning only, but a generated 80-man pool will often hold two players with one name, so rows can look flagged while nothing blocks the pack.
- `packFactsProvider` (`world_pack_providers.dart`) is a non-autoDispose FutureProvider read once per app run: if it were first read before the seed finished, every fixed pool would read as incompatible (red "Needs attention") until restart. Not reproduced.

## Item 1: reserves to the squad
- Model: "reserves" are `WorldPack.pools[nation]` (the Pool tab; a generated pool until the first change fixes it), the squad is `WorldPack.squads[nation]`, caps `PackRules.squadMax` 40, `poolMax` 150.
- `SquadEdits.promote(pack, nation, shown, playerId, {swapOutId})`: one `copyWith` (so one undo). Both players get fresh pack-made ids (a fringe id may not sit in a squad, a core id may not sit in a pool). Returns null when the squad is full and no swap is given.
- UI (`squad_screen.dart`, shared by phone and tablet): an up-arrow button on every pool row (`SquadScreen.promoteKey(id)`), snackbar with Undo. If the squad is full a dialog lists the squad (`SquadScreen.swapKey(id)`); the chosen player goes back to the pool.

## Item 2: only what needs a fix
- Nation list (phone chip row and tablet wrap): "Needs a fix" FilterChip first in the row (`NationListScreen.fixFilterKey`).
- Name sections (clubs, stadiums, competitions, Y accounts, press, name lists, sponsors; phone and tablet): chip under the search (`NameSectionScreen.fixFilterKey`), keeps rows whose `toFix > 0`, combines with search.
- Empty result says "Nothing needs fixing here." The pack home already lists only issues.

## Item 4: trophy images from the photo gallery
- `image_picker ^1.1.2` (resolved 1.2.4), `flutter pub get` run. `editorGalleryPickerProvider` (`ImageSource.gallery`) feeds the existing `_choose` -> `TrophyCropScreen` flow.
- `_TrophyDetail` (phone sheet and tablet detail): on Android/iOS the primary button is "Choose from your photos" (`galleryKey`), the file picker stays as the outlined "Choose a file instead" (`chooseKey`); on desktop only the file button, as before.
- iOS: `NSPhotoLibraryUsageDescription` already existed but said "never reads your photos"; reworded to say it opens the library only to pick a trophy picture. Android: image_picker 1.x uses the system photo picker, no manifest permission needed (manifest has INTERNET only, unchanged).

## Item 5: save safety
- `test/unit/world_pack/pack_career_snapshot_test.dart` (4 tests): a career started on a pack keeps the pack JSON and trophy image after (a) the pack is edited (names, a squad, the trophy picture), (b) the pack is deleted; and a later career on the edited pack gets the edit while the first does not.

## Copy
8 new keys (ARBs for all 28 languages, translated; `flutter gen-l10n`; rows appended to `copy/strings.csv`, `dart run tool/import_copy.dart --dry-run` reports 0 changes): editorFilterToFix, editorNothingToFix, editorPromoteTooltip, editorPromoted, editorPromoteFullTitle, editorPromoteFullBody, editorTrophyGallery, editorTrophyFile. No em dashes, no "World Cup". Note: `dart run tool/export_copy.dart` would rewrite many other CSV rows (the committed CSV was already out of step with the ARBs and uses CRLF), so I appended my rows by hand instead of re-exporting.

## Tests run
- `test/unit/world_pack/pack_career_snapshot_test.dart`: 4 passed.
- `test/widget/editor_feedback_1109_test.dart`: 10 passed (new).
- `test/widget/editor_trophies_test.dart`: 12 passed (2 new gallery tests).
- `editor_players_test`, `editor_pool_test`, `editor_names_test`: 61 passed.
- `editor_added_test`, `editor_list_test`, `editor_save_retry_test`, `pack_home_test`, all of `test/unit/world_pack`: 352 passed.
- `test/unit/l10n`: 206 passed (incl. editor_copy_test, french spacing, copy round trip).
- `flutter analyze` on touched files: no errors or warnings (only the repo's existing info-level lints).
- No goldens touched. Not run: full suite; device playtest of the real photo picker (needs a phone).
