# The carousel shots

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

The shots are in ENGLISH on both language trees. Shooting a Czech set is a
nice-to-have, not a requirement; if you do, they go in a `cs/shots/` of their
own and `cs/index.html` points at that instead.

Deliberately left out of the carousel: the manager skills, the federation
budget, the challenges and the board objectives. Every one of those was shot
on a fresh save, so they read "No points to spend", "Nobody in the job", all
sliders at zero, everything 0/25. They are true screens of an empty save, and
they undersell the game. Shoot them again from a career a few cycles in and
they would earn a place.
