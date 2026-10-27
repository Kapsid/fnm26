"""Builds the stadium map's geography: assets/geo/<nation id>.json.

    python3 -I tool/geo/gen_geo.py <dir with the Natural Earth geojson files>

Inputs (all public domain):
  - Natural Earth 1:10m admin-0 countries and map units (the UK's four
    football nations), from github.com/nvkelso/natural-earth-vector/geojson;
  - Natural Earth 1:10m populated places, for city positions;
  - tool/geo/city_fallback.json for the cities Natural Earth does not name
    (looked up once by fetch_city_fallback.py, reviewed, checked in);
  - the game's own nations and cities.

Each nation's file holds its outline (simplified to its own size), every city
the map may pin, the box the map opens on and, when a city lies far off the
main landmass (Funchal on Madeira), an inset box for it. One file per
nation, so the app only ever reads the one it shows.

Format (all coordinates are integers: degrees x "s"):
  {"s": units per degree,
   "v": [minLon, minLat, maxLon, maxLat]   the box the map opens on,
   "i": [[minLon, minLat, maxLon, maxLat]] inset boxes (may be empty),
   "r": [[lon0, lat0, dLon, dLat, ...]]    rings, first point absolute,
                                           then deltas; holes are rings too
                                           (fill even-odd),
   "c": {"City": [lon, lat]}}
Longitudes may run past 180 (or below -180) so a nation across the
antimeridian (Fiji) stays in one piece.
"""

import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from geo_common import (FALLBACK, ROOT, all_cities, city_lists, distance_to_outline_km,
                        load_nations,
                        match_place, outline_polygons, outline_sources,
                        place_index)

OUT = os.path.join(ROOT, 'assets', 'geo')

# Douglas-Peucker tolerance as a share of the view's diagonal.
TOLERANCE = 0.0008
# Grid the integers snap to, as a share of the view's diagonal (before the
# scale is rounded to a power of ten).
GRID = 1 / 6000


def ring_area(ring):
    a = 0.0
    for i in range(len(ring) - 1):
        x1, y1 = ring[i]
        x2, y2 = ring[i + 1]
        a += x1 * y2 - x2 * y1
    return a / 2


def bbox(points):
    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    return [min(xs), min(ys), max(xs), max(ys)]


def union_box(a, b):
    return [min(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), max(a[3], b[3])]


def box_gap(a, b, k):
    """Distance between two boxes in cos-scaled degrees (0 if they touch)."""
    dx = max(0.0, max(a[0], b[0]) - min(a[2], b[2])) * k
    dy = max(0.0, max(a[1], b[1]) - min(a[3], b[3]))
    return math.hypot(dx, dy)


def box_size(b, k):
    return max((b[2] - b[0]) * k, b[3] - b[1])


def merge_rings(polys):
    """Dissolves the shared borders of several features into one outline
    (Cyprus, Somalia): every directed edge that also runs the other way in
    another ring is dropped, and what is left is chained back into rings.
    Holes are dropped; none of the merged nations has one."""
    edges = {}
    for poly in polys:
        ring = poly[0]
        if ring_area(ring) < 0:
            ring = ring[::-1]
        for i in range(len(ring) - 1):
            a, b = ring[i], ring[i + 1]
            if a == b:
                continue
            if (b, a) in edges:
                del edges[(b, a)]
            else:
                edges[(a, b)] = True
    nxt = {}
    for a, b in edges:
        nxt.setdefault(a, []).append(b)
    out = []
    while nxt:
        start = next(iter(nxt))
        ring = [start]
        cur = start
        while True:
            outs = nxt.get(cur)
            if not outs:
                break
            b = outs.pop()
            if not outs:
                del nxt[cur]
            ring.append(b)
            cur = b
            if cur == start:
                break
        if len(ring) >= 4 and ring[0] == ring[-1]:
            out.append([ring])
    return out


def simplify(ring, tol):
    """Douglas-Peucker on a closed ring of projected points."""
    if len(ring) < 5:
        return ring
    keep = [False] * len(ring)
    keep[0] = keep[-1] = True
    # Split the closed ring at its farthest point from the start so both
    # halves have distinct ends.
    x0, y0 = ring[0]
    far = max(range(len(ring)), key=lambda i: (ring[i][0] - x0) ** 2 + (ring[i][1] - y0) ** 2)
    keep[far] = True
    stack = [(0, far), (far, len(ring) - 1)]
    tol2 = tol * tol
    while stack:
        s, e = stack.pop()
        if e <= s + 1:
            continue
        ax, ay = ring[s]
        bx, by = ring[e]
        dx, dy = bx - ax, by - ay
        ll = dx * dx + dy * dy
        best, bi = -1.0, -1
        for i in range(s + 1, e):
            px, py = ring[i]
            if ll == 0:
                d = (px - ax) ** 2 + (py - ay) ** 2
            else:
                t = max(0.0, min(1.0, ((px - ax) * dx + (py - ay) * dy) / ll))
                d = (ax + t * dx - px) ** 2 + (ay + t * dy - py) ** 2
            if d > best:
                best, bi = d, i
        if best > tol2:
            keep[bi] = True
            stack.append((s, bi))
            stack.append((bi, e))
    return [p for p, k in zip(ring, keep) if k]


def city_position(nid, code, city, idx, fallback):
    hand = fallback.get(f'{nid}|{city}')
    if hand is not None and hand.get('src', '').startswith('hand'):
        return (hand['lon'], hand['lat']), 'hand'
    pos = match_place(code, city, idx)
    if pos is not None:
        return pos, 'ne'
    if hand is not None:
        return (hand['lon'], hand['lat']), hand.get('src', 'hand').split(':')[0]
    return None, None


def build(ne_dir):
    idx = place_index(ne_dir)
    with open(FALLBACK, encoding='utf-8') as f:
        fallback = json.load(f)
    with open(os.path.join(os.path.dirname(__file__), 'outline_overrides.json'),
              encoding='utf-8') as f:
        overrides = {k: v for k, v in json.load(f).items() if not k.startswith('_')}
    seed, stadiums, extra = city_lists()
    os.makedirs(OUT, exist_ok=True)
    report = {'sources': {}, 'missing': [], 'insets': {}, 'merged': [],
              'sizes': {}, 'hand_outlines': [], 'off_outline': []}
    total = 0
    for nid, code, name in load_nations():
        if code in overrides:
            polys = [[[tuple(pt) for pt in ring] for ring in overrides[code]]]
            report['hand_outlines'].append(code)
        else:
            polys = outline_polygons(ne_dir, code)
        if code not in overrides and len(outline_sources(code)) > 1:
            merged = merge_rings(polys)
            if merged:
                polys = merged
                report['merged'].append(code)
        # The largest polygon is the main landmass.
        main_i = max(range(len(polys)), key=lambda i: abs(ring_area(polys[i][0])))
        mb = bbox(polys[main_i][0])
        east = (mb[0] + mb[2]) / 2 >= 0

        def wrap(lon):
            if east and lon < -90:
                return lon + 360
            if not east and lon > 90:
                return lon - 360
            return lon

        def wrap_poly(poly):
            b = bbox(poly[0])
            if east and b[2] < -90:
                return [[(x + 360, y) for x, y in r] for r in poly]
            if not east and b[0] > 90:
                return [[(x - 360, y) for x, y in r] for r in poly]
            return poly

        polys = [wrap_poly(p) for p in polys]
        mb = bbox(polys[main_i][0])
        k = math.cos(math.radians((mb[1] + mb[3]) / 2))

        cities = {}
        for c in all_cities(nid, seed, stadiums, extra):
            pos, src = city_position(nid, code, c, idx, fallback)
            if pos is None:
                report['missing'].append(f'{code} {c}')
                continue
            report['sources'][src] = report['sources'].get(src, 0) + 1
            cities[c] = (wrap(pos[0]), pos[1])
            off = distance_to_outline_km(cities[c][0], pos[1], polys)
            if off > 8:
                report['off_outline'].append(f'{code} {c} {off:.0f} km ({src})')

        # The cities the screen pins: its stadiums and its build candidates.
        shown = [c for c in dict.fromkeys(seed.get(nid, []) + stadiums.get(nid, []))
                 if c in cities]
        # Cluster the pinned cities (single link, 2 degrees). The map opens
        # on the biggest city's cluster; each further cluster joins
        # it unless it is a small, lone outpost far out (at most a quarter
        # of the cities, on an island under half the main box, that would
        # stretch the box over four times its area): that one gets an inset.
        def near_polys(x, y):
            return [p for p in polys if box_gap(bbox(p[0]), [x, y, x, y], k) <= 0.3]

        clusters = []
        for c in shown:
            x, y = cities[c]
            hit = [cl for cl in clusters
                   if any(math.hypot((x - cities[o][0]) * k, y - cities[o][1]) <= 2.0
                          for o in cl)]
            merged = [c]
            for cl in hit:
                merged += cl
                clusters.remove(cl)
            clusters.append(merged)

        def cluster_box(cl):
            b = None
            for c in cl:
                x, y = cities[c]
                b = [x, y, x, y] if b is None else union_box(b, [x, y, x, y])
                for p in near_polys(x, y):
                    b = union_box(b, bbox(p[0]))
            return b

        def area(b):
            return max((b[2] - b[0]) * k, 0.05) * max(b[3] - b[1], 0.05)

        if clusters:
            # The map opens on the biggest city's cluster.
            first = shown[0]
            clusters.sort(key=lambda cl: (first not in cl, -len(cl)))
            focus = cluster_box(clusters[0])
            rest = clusters[1:]
        else:
            focus = list(mb)
            rest = []
        outposts = []
        rest.sort(key=lambda cl: box_gap(focus, cluster_box(cl), k))
        for cl in rest:
            cb = cluster_box(cl)
            grown = union_box(focus, cb)
            if (area(grown) > 4 * area(focus) and len(cl) <= 0.25 * len(shown)
                    and area(cb) < 0.5 * area(focus)):
                outposts.append(cl)
            else:
                focus = grown
        # An outpost the grown box now nearly reaches folds back in.
        for cl in list(outposts):
            if area(union_box(focus, cluster_box(cl))) <= 4 * area(focus):
                focus = union_box(focus, cluster_box(cl))
                outposts.remove(cl)
        # More than two outposts is an archipelago (the Maldives): show it
        # whole rather than as a row of insets.
        if len(outposts) > 2:
            for cl in outposts:
                focus = union_box(focus, cluster_box(cl))
            outposts = []
        # Land near the focus joins it (Corsica, the Balearics): anything
        # just off the coast, and a sizeable island a little further out
        # (Bornholm; within about 330 km), unless it would stretch the view
        # by 80% more (Alaska). A speck far out at sea (Brazil's Trindade)
        # and a far archipelago (Svalbard) are left off.
        size = box_size(focus, k)
        kept = []
        view = list(focus)
        for p in sorted(polys, key=lambda p: box_gap(focus, bbox(p[0]), k)):
            pb = bbox(p[0])
            gap = box_gap(focus, pb, k)
            near = gap <= 0.08 * size
            island = (gap <= 0.45 * size and gap <= 3.0
                      and box_size(pb, k) >= 0.04 * size)
            if not (near or island):
                continue
            grown = union_box(view, pb)
            if not near and area(grown) > 1.8 * area(view):
                continue
            kept.append(p)
            view = grown
        insets = []
        for cl in outposts:
            insets.append(cluster_box(cl))
            for c in cl:
                for p in near_polys(*cities[c]):
                    if p not in kept:
                        kept.append(p)
            report['insets'][code] = report['insets'].get(code, []) + sorted(cl)

        # Pad the boxes a little so the coast never touches the frame.
        def pad(b, share):
            w = (b[2] - b[0])
            h = (b[3] - b[1])
            m = max(w * k, h) * share
            return [b[0] - m / k, b[1] - m, b[2] + m / k, b[3] + m]

        view = pad(view, 0.04)
        insets = [pad(b, 0.12) for b in insets]
        diag = math.hypot((view[2] - view[0]) * k, view[3] - view[1])
        tol = diag * TOLERANCE
        scale = 10 ** math.ceil(math.log10(1 / (diag * GRID)))

        def q(v):
            return int(round(v * scale))

        rings = []
        for p in kept:
            pb = bbox(p[0])
            # Tiny islets, far below what the view can show, are left out
            # unless a city stands on them.
            in_inset = any(box_gap(b, pb, k) == 0 for b in insets)
            idiag = min([math.hypot((b[2] - b[0]) * k, b[3] - b[1]) for b in insets]
                        + [diag]) if in_inset else diag
            rtol = idiag * TOLERANCE
            for r in p:
                rb = bbox(r)
                if box_size(rb, k) < rtol * 1.5:
                    continue
                proj = [(x * k, y) for x, y in r]
                s = simplify(proj, rtol)
                if len(s) < 4:
                    continue
                pts = [(q(x / k), q(y)) for x, y in s]
                dedup = [pts[0]]
                for pt in pts[1:]:
                    if pt != dedup[-1]:
                        dedup.append(pt)
                if len(dedup) < 4:
                    continue
                flat = [dedup[0][0], dedup[0][1]]
                for a, b in zip(dedup, dedup[1:]):
                    flat += [b[0] - a[0], b[1] - a[1]]
                rings.append(flat)
        doc = {
            's': scale,
            'v': [q(v) for v in view],
            'i': [[q(v) for v in b] for b in insets],
            'r': rings,
            'c': {c: [q(x), q(y)] for c, (x, y) in cities.items()},
        }
        path = os.path.join(OUT, f'{nid}.json')
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))
        size_b = os.path.getsize(path)
        report['sizes'][code] = size_b
        total += size_b
    report['total_bytes'] = total
    return report


if __name__ == '__main__':
    rep = build(sys.argv[1])
    big = sorted(rep['sizes'].items(), key=lambda e: -e[1])[:12]
    print(json.dumps({k: v for k, v in rep.items() if k != 'sizes'}, ensure_ascii=False, indent=1))
    print('largest files:', big)
