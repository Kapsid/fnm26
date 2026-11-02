# The carousel shots

There are two carousels now: iPhone (`shot-1` … `shot-12`) and iPad
(`ipad-1` … `ipad-10`, 960 x 720 thumbnails and 2000 x 1500 full size, 4:3,
marked `data-wide` so the lightbox opens them at full width). Shots 7 to 12
and every iPad shot came from the render harness, EN here and CS in
`cs/shots/`. What follows was written for the original six.

Six of them, `shot-1.jpg` … `shot-6.jpg`, plus a `-full.jpg` beside each for
the lightbox. Both language trees show the SAME files, so they live here at
the root and the Czech pages reach them as `../shots/`.

## Sizes

| file | pixels | shown at | why |
| --- | --- | --- | --- |
| `shot-N.jpg` | 500 x 1010 | 236px wide in the carousel | loaded on page load, all six |
| `shot-N-full.jpg` | 1000 x 2020 | up to 460px in the lightbox | fetched only when a slide is opened |

The split is the point: the page costs about 400 kB of shots up front instead
of 1.4 MB, and the sharp copy arrives only for the one picture somebody asked
to see.

## The ratio is not arbitrary

500 x 1010 is the phone's own crop (1206 x 2436) scaled down, and
`_style.css` sets `aspect-ratio: 500 / 1010` on the slide to match. That is
why nothing is cropped and there are no bars.

**Replace a shot and you must keep that ratio**, or change both together. A
shot at a different shape will be cut by `object-fit: cover` to fit the frame,
and the cut comes off the SIDES, which is where this app puts its numbers.

## Making them

From a phone screenshot, with macOS's own `sips`:

    sips -s format jpeg -s formatOptions 82 --resampleWidth 500 in.jpeg --out shot-1.jpg
    sips -c 1010 500 --padColor 0E1012 shot-1.jpg

    sips -s format jpeg -s formatOptions 80 --resampleWidth 1000 in.jpeg --out shot-1-full.jpg
    sips -c 2020 1000 --padColor 0E1012 shot-1-full.jpg

`--padColor 0E1012` is the app's own background, so a shot a few pixels short
is padded invisibly rather than with white.

## What is in them, and the order

The order follows how the game is actually played, and the two strongest
pictures are first. Captions live in `index.html` and `cs/index.html`.

1. Select national team, "Every nation" / "Každá země"
2. Lineup on the pitch, "Your lineup" / "Sestava"
3. A live match, "Match day" / "Zápas"
4. The half-time team talk, "Half time" / "Poločas"
5. The group draw, "The draw" / "Los"
6. A player's detail, "Your players" / "Hráči"

There is now a CZECH set too, in `cs/shots/`, made the same way and referenced
by `cs/index.html` as `shots/...` (relative to itself, not `../shots/`). The
two sets are NOT the same six: the Czech source had no draw ceremony shot, so
its fifth and sixth slides are the player detail and the youth pyramid, and
the English fifth slide is the draw. If a Czech draw shot turns up, it can go
back in step.

## The localised sets

Since 1.0.7 German, Spanish, Portuguese and Italian have their own sets in
`de/shots/`, `es/shots/`, `pt/shots/` and `it/shots/`, plus their own
`hero-phone.jpg` / `hero-tablet.jpg`. They follow the ENGLISH composition
exactly: the same twelve phone screens and ten tablet screens, in the same
order, with the captions translated in each `index.html`.

<!-- LOCALISED-SETS-STATUS -->
Since the 28-language site every game language has its own set
(`<lang>/shots/`, 44 files, plus `hero-phone.jpg` / `hero-tablet.jpg`), made
the same way. French (France, WC 2034 R32 win 3-1 vs Saudi Arabia) was shot
last, from the 1.0.9 work in progress, so its live match shows the half-time
score line under the scoreline.

A nation that rarely reaches the World Championship is shot around its
continental championship instead (the save harness also keeps those finals
matches as `cf_*`). Nations and matches used for the 21 newer languages:
bg Bulgaria (Euro 2032 group, 1-1 Portugal), da Denmark (WC R16), el Greece
(WC QF), fi Finland (Euro group, 1-1 Portugal), fil Philippines (Asian
Championship R16), hi India (Asian Championship R16), hr Croatia (Euro final),
hu Hungary (WC group), id Indonesia (Asian Championship group), ja Japan (WC
R16), ko South Korea (WC final), ms Malaysia (Asian Championship group, 2-2),
nb Norway (Euro final), nl Netherlands (WC R32), pl Poland (WC R32), ro Romania
(Euro R16), sv Sweden (WC group), th Thailand (Asian Championship group), tr
Türkiye (WC R16), uk Ukraine (WC group), vi Vietnam (Asian Championship group).

The test engine has no system font fallback, so `capture.dart` loads SF,
Hiragino Sans, Apple SD Gothic Neo, Thonburi and Kohinoor Devanagari, and
`site_shots_test.dart` gives every paragraph that lacks a fallback list those
faces before it shoots (buttons and bars replace the ambient text style and
would otherwise draw non-Latin labels as boxes). The ranking chart's small
labels are still grey boxes in every set, as in EN and CS: the painter sets
no font family at all.

Each set comes from a real played career, not a fresh save: two full
four-year cycles played by the story driver on the app's own asset seed,
ending in the 2034 World Championship finals. The nation is the language's
own: Germany (de), Spain (es), Brazil (pt), Italy (it).

They are made by two test-only harnesses in `test/story/`, neither part of
the suite (both skip unless their environment variables are set), always run
through the shared `ftest.sh`:

1. `site_save_test.dart` plays the career and keeps copies of the database
   at the second cycle's budget, its finals draw and before every World
   Championship finals match. It tries seeds until the run wins a late
   knockout with the board pleased (a hub reading "job at risk" undersells
   the game):

       SITE_SAVE_OUT=<dir> SITE_NATION=20 STORY_SEED=1 SEED_COUNT=10 \
         SITE_MIN_BOARD=75 SITE_ROUNDS=SF,FINAL CYCLES=2 flutter test test/story/site_save_test.dart

2. `site_shots_test.dart` renders every shot from those copies in one
   language: phones at 402 x 874 points, 3x (the iPhone 17 Pro frame);
   tablets at 1366 x 1024 points, 2x, through the real tablet shell.

       SITE_SAVES=<dir>/seed<N> SITE_KO=wc_07_SF SITE_STAR=<player id> \
         SITE_LANG=de SITE_RAW=<png dir> flutter test test/story/site_shots_test.dart

   `SITE_KO` names the match the story is told around (hub, preview, live
   match); `SITE_STAR` the player on the player screens; `ONLY` / `SKIP`
   limit the run (the live match is the slow part).

The raw phone PNGs lose their top 186 px (the status-bar band) to become the
1206 x 2436 crop this README asks for, then go through the same `sips` lines
as above. The tablet PNGs are scaled to 960 x 720 and 2000 x 1500 at quality
80. The hero pair is the hub: `hero-phone.jpg` is phone shot 7 at 400 x 808,
`hero-tablet.jpg` is tablet shot 1 at 1400 x 1050.

Deliberately left out of the carousel: the manager skills, the federation
budget, the challenges and the board objectives. Every one of those was shot
on a fresh save, so they read "No points to spend", "Nobody in the job", all
sliders at zero, everything 0/25. They are true screens of an empty save, and
they undersell the game. Shoot them again from a career a few cycles in and
they would earn a place.
