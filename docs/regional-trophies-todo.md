# Handoff: regional cup trophy artwork

Repo `Kapsid/fnm26`. The code is done and already in `main`
(commit `55ad59d9`, "Regional cups join the trophy cabinet and the
achievements"). The two image files below are TEMPORARY placeholders: copies
of `asia.png`, put there so nothing breaks. Replace both with the real artwork
the user supplies: the palm-and-barrel trophy for the Gulf Cup and the lotus
trophy for the Southeast Asian Championship.

## What the code expects

| Cup | File |
|---|---|
| Gulf Cup (palm + barrel) | `assets/trophies/gulfcup.png` |
| Southeast Asian Championship (lotus) | `assets/trophies/southeastasia.png` |

Format, the same as the other trophies in `assets/trophies/`:
- PNG, RGBA, transparent background;
- exactly **400 x 600** px;
- the trophy centred, about 10 px margin, base near the bottom.

`pubspec.yaml` already lists `assets/trophies/`, so no change is needed there.

## Steps

1. `git fetch origin && git checkout main && git pull` (or work on a branch and fast-forward `main` at the end)
2. Save the two images the user gives you (any names), then run this script:
   `python3 process.py <palm_barrel.png> <lotus.png>`
   It needs Pillow (`pip install pillow`).

```python
# process.py: white background -> transparent, trim, fit to 400x600.
import sys
from collections import deque
from PIL import Image

def cut(src, dst):
    im = Image.open(src).convert("RGBA")
    w, h = im.size
    px = im.load()
    # Flood-fill the near-white background from the edges only, so the silver
    # highlights inside the trophy stay opaque.
    seen = bytearray(w * h)
    q = deque()
    for x in range(w):
        q.append((x, 0)); q.append((x, h - 1))
    for y in range(h):
        q.append((0, y)); q.append((w - 1, y))
    while q:
        x, y = q.popleft()
        if not (0 <= x < w and 0 <= y < h) or seen[y * w + x]:
            continue
        seen[y * w + x] = 1
        r, g, b, a = px[x, y]
        if min(r, g, b) < 235:
            continue
        px[x, y] = (r, g, b, 0)
        q.extend(((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)))
    # Soften the fringe: near-white pixels touching the cut become partly clear.
    for y in range(1, h - 1):
        for x in range(1, w - 1):
            r, g, b, a = px[x, y]
            if a and min(r, g, b) >= 225 and any(
                px[x + dx, y + dy][3] == 0
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
            ):
                px[x, y] = (r, g, b, int(255 * (255 - min(r, g, b)) / 30))
    im = im.crop(im.getbbox())
    # Fit inside 380x580, centred horizontally, base 10 px off the bottom.
    im.thumbnail((380, 580), Image.LANCZOS)
    out = Image.new("RGBA", (400, 600), (0, 0, 0, 0))
    out.paste(im, ((400 - im.width) // 2, 590 - im.height), im)
    out.save(dst, optimize=True)
    print(dst, out.size)

cut(sys.argv[1], "assets/trophies/gulfcup.png")
cut(sys.argv[2], "assets/trophies/southeastasia.png")
```

3. Open both PNGs and check them by eye. The background must be clear with no
   white halo, and the trophy must be whole with nothing cut off. If a white
   fringe shows on the dark theme, raise the `225` threshold toward `235`.
4. Tests (use `TZ=Europe/Prague`, and never `flutter install`):
   - `flutter analyze`
   - `flutter test test/unit/achievements test/unit/world_pack test/golden/share_cards_test.dart`
   - If a golden that shows the trophy cabinet changes (the share-card or
     manager-history goldens), check that the only difference is the two new
     shelves, then refresh it with `--update-goldens`.
5. Commit. Use the message
   "Regional cup trophies: Gulf Cup and Southeast Asian Championship artwork"
   and the usual `Co-Authored-By` / `Claude-Session` trailer.
6. Push to `main`, as a fast-forward only:
   ```
   git fetch origin main
   git merge-base --is-ancestor origin/main HEAD && git push origin HEAD:main
   ```
   Do not leave untracked files behind, and do not commit `process.py`.
7. Delete this file (`docs/regional-trophies-todo.md`) in the same commit.

## Already done, for context
- `Trophies` (`lib/domain/services/competition/trophies.dart`) maps both cups to
  the keys `gulfcup` and `southeastasia`, and shows them last in the cabinet.
- Two silver achievements, `title_gulf` and `title_sea`, with strings in all 28
  ARBs. `flutter gen-l10n` and `copy/strings.csv` (CRLF) are regenerated.
- Stats already counted these cups: manager points, career summary, nation
  vitrine and board mood.
