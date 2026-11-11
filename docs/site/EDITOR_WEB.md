# Web database editor

The game's database editor, alone, as a static web page at
`https://footballnationsmanager.com/editor/`. English only. No server and no
accounts: everything runs in the visitor's browser and nothing is uploaded.

## What it does

- Starts with the game's default world (seeded into SQLite in the browser on
  the first visit, about 20 to 30 seconds; later visits open in a few
  seconds).
- **New database** copies the default world, **Open file** loads a `.fnmdb`
  from disk, the card menu has **Download** (saves the `.fnmdb`), Rename,
  Duplicate and Delete. Editing is the app's editor, screen for screen.
- Everything is kept in the browser's IndexedDB, so closing the tab loses
  nothing. Clearing the site data (or a private window) starts afresh.
- Files are written with the game's own codec and rules, so a downloaded file
  imports in the app like one exported from a phone.

## Build

From the repo root:

```sh
flutter build web --release -t lib/main_editor_web.dart --base-href /editor/
```

The output is `build/web/` (do not commit it). Upload the CONTENTS of
`build/web/` by FTP into `www/editor/` on Active24, replacing what is there.
The page then lives at `/editor/`; nothing else on the site changes and no
server rewrite rules are needed (the editor uses `#/` URLs).

Notes:

- `build/web/.htaccess` (from `web/.htaccess`) is a dotfile: make sure the
  FTP client uploads it. It serves `.wasm` as `application/wasm`; without it
  the site's `nosniff` header makes browsers refuse `sqlite3.wasm` and the
  editor never gets past "Loading the default world". Upload `.wasm` and
  images in binary mode.

- `web/sqlite3.wasm` must match the `sqlite3` package version in
  `pubspec.lock` (now 3.2.0). After bumping `sqlite3`, download the matching
  `sqlite3.wasm` from
  `https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-<version>/sqlite3.wasm`
  into `web/`.
- The upload is about 55 MB, most of it the renderer files in `canvaskit/`.
  A visitor downloads `main.dart.js` (5.7 MB, about 1.6 MB compressed),
  `sqlite3.wasm` (0.7 MB) and the assets the editor shows; the renderer
  itself comes from Google's CDN.
  To serve it from our own host instead, add `--no-web-resources-cdn`.
- After uploading a new build, a visitor may need one hard refresh
  (Ctrl+Shift+R / Cmd+Shift+R) if the browser cached the old files.
- A schema bump in the app migrates the browser database on the next visit,
  the same way it migrates a phone.

## What is not there on the web

- Photo gallery picking for trophy pictures shows only on phone browsers;
  on a computer the trophy picture comes from a file.
- The link to the Discord opens in a new tab.
- No way back to the game's home screen: the editor is the whole page.
