"""Builds assets/data/stadium_build_cities.json: the extra towns and cities
a nation can BUILD a stadium in, beyond its seed cities, and pins each one
in tool/geo/city_fallback.json (src "build:wikidata:<qid>").

    python3 -I tool/geo/fetch_build_cities.py <dir with the NE geojson files> [cache.json]

Natural Earth's populated places were the first choice, but at 1:10m they
hold too few towns outside the big nations (five for the Czech Republic, six
for the Netherlands) and spell many of them in ASCII ("Usti Nad Labem"). So
the list is read off Wikidata (CC0, as the fallback positions already are):
each nation's most populous human settlements with an English name, a
position and a population, kept only when they stand inside the box the
stadium map already opens on (or one of its insets), on the outline, and at
least MIN_SPACING_KM from every city already listed or picked (no suburbs or
second spellings of a city the game already has). Up to MAX_PER_NATION.

Run gen_geo.py afterwards: it pins them without moving any view.

This list is for building ONLY. country_cities.json feeds clubs' home
cities, the seed grounds and host venues, and must not grow, or existing
saves' grounds and clubs would move.
"""

import json
import math
import os
import re
import sys
import time
import urllib.parse
import urllib.request

sys.path.insert(0, os.path.dirname(__file__))
from geo_common import (DATA, FALLBACK, ROOT, all_cities, city_lists,
                        distance_to_outline_km, load_nations, norm,
                        outline_polygons, place_countries)

OUT = os.path.join(DATA, 'stadium_build_cities.json')
GEO = os.path.join(ROOT, 'assets', 'geo')
OVERRIDES = os.path.join(os.path.dirname(__file__), 'outline_overrides.json')
UA = 'fnm26-geo-build/1.0 (offline asset generator)'

MAX_PER_NATION = 30
MAX_OFF_OUTLINE_KM = 8
MIN_SPACING_KM = 8
BIG_CITY_SPACING_KM = 25
SAME_TOWN_KM = 3

# Not towns, whatever the data says.
_BAD = re.compile(
    r'[\d(),/]|\b(District|Municipality|County|Province|Prefecture|Region|'
    r'Governorate|Department|Oblast|Raion|Canton|Commune|Parish|Borough|'
    r'Township|Subdistrict|Ward|Island|Islands|Atoll|Area|area|metropolitan|'
    r'Metropolitan|agglomeration|Agglomeration|urban|Urban|Greater|metroplex|'
    r'Metro|Valley|Empire|Roads|Corridor|Built-up|Tricity|City Region|Bezirk|'
    r'Somerset|M\u00e9tropole|Metropole|Territory|Industrial|Camp|Refugee|Settlement)\b|\u2013')

# Names that really do end in "City"; any other Wikidata label of one word
# and "City" ("Murcia City") is its disambiguation and loses it.
_CITY_NAMES = {'Kansas City', 'Panama City', 'Quezon City', 'Mexico City',
               'Kuwait City', 'Guatemala City', 'Belize City', 'Iowa City',
               'Jersey City', 'Carson City', 'Vatican City', 'Davao City',
               'Cebu City'}


def clean(name, source, code):
    name = re.sub(r'\s+', ' ', name).strip()
    name = re.sub(r'^Ft\. ', 'Fort ', name)
    m = re.fullmatch(r'(\S+) [Cc]ity', name)
    if (m and source != 'naturalearth' and code != 'PHI'
            and name not in _CITY_NAMES):
        name = m.group(1)
    return name


def sparql(iso3):
    """[iso3]'s settlements, most populous first. A nation too big to answer
    in time is asked again for its bigger places only."""
    for min_pop in (2000, 50000, 200000):
        data = _query(iso3, min_pop)
        if data is not None:
            break
    else:
        raise SystemExit('wikidata unreachable for ' + iso3)
    out = {}
    for b in data['results']['bindings']:
        m = re.match(r'Point\(([-\d.eE]+) ([-\d.eE]+)\)', b['coord']['value'])
        if not m:
            continue
        try:
            pop = float(b['pop']['value'])
        except ValueError:
            continue
        qid = b['item']['value'].rsplit('/', 1)[-1]
        prev = out.get(qid)
        if prev is None or pop > prev[3]:
            out[qid] = (b['label']['value'], float(m.group(1)), float(m.group(2)), pop)
    return sorted(((n, x, y, p, q) for q, (n, x, y, p) in out.items()),
                  key=lambda e: (-e[3], e[0]))


def _query(iso3, min_pop):
    query = (
        'SELECT ?item ?label ?coord ?pop WHERE { '
        f'?country wdt:P298 "{iso3}" . '
        '?item wdt:P17 ?country ; wdt:P1082 ?pop . '
        f'FILTER(?pop >= {min_pop}) '
        '?item wdt:P625 ?coord ; wdt:P31/wdt:P279* wd:Q486972 . '
        '?item rdfs:label ?label FILTER(lang(?label) = "en") '
        '} ORDER BY DESC(?pop) LIMIT 400')
    url = 'https://query.wikidata.org/sparql?' + urllib.parse.urlencode(
        {'query': query, 'format': 'json'})
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                data = json.load(r)
            time.sleep(1.0)
            return data
        except Exception as e:
            print('  retry', iso3, min_pop, attempt, e, file=sys.stderr)
            time.sleep(10 + attempt * 20)
    return None


def fetch_all(codes, cache_path):
    """Every ISO3 code's settlements, four queries at a time, cached in
    [cache_path] so an interrupted run picks up where it stopped."""
    import concurrent.futures
    cache = {}
    if cache_path and os.path.exists(cache_path):
        with open(cache_path, encoding='utf-8') as f:
            cache = {k: [tuple(e) for e in v] for k, v in json.load(f).items()}
    todo = [c for c in dict.fromkeys(codes) if c not in cache]
    with concurrent.futures.ThreadPoolExecutor(4) as pool:
        for iso3, rows in zip(todo, pool.map(sparql, todo)):
            print(iso3, len(rows), file=sys.stderr)
            cache[iso3] = rows
            if cache_path:
                with open(cache_path, 'w', encoding='utf-8') as f:
                    json.dump(cache, f, ensure_ascii=False)
    return cache


def iso3_of(iso):
    return {'SDS': 'SSD', 'KOS': 'XKX', 'PSX': 'PSE', 'CYN': None,
            'SOL': None}.get(iso, iso)


def km(a, b):
    k = math.cos(math.radians((a[1] + b[1]) / 2))
    return math.hypot((a[0] - b[0]) * k, a[1] - b[1]) * 111.2


def in_boxes(x, y, boxes):
    return any(b[0] <= x <= b[2] and b[1] <= y <= b[3] for b in boxes)


def candidates(code, ne_places, cache):
    """[(name, lon, lat, population, source)] for a nation, most populous
    first: Natural Earth's places and Wikidata's settlements together. Where
    the two name one town (within SAME_TOWN_KM, the same name but for its
    accents), Wikidata's spelling is kept with Natural Earth's position:
    Natural Earth often writes towns in ASCII ("Usti Nad Labem")."""
    pool = []
    for iso in place_countries(code):
        for p in ne_places.get(iso, []):
            pool.append((clean(p['NAME'], 'naturalearth', code),
                         p['LONGITUDE'], p['LATITUDE'],
                         float(p.get('POP_MAX') or 0), 'naturalearth'))
        iso3 = iso3_of(iso)
        for name, lon, lat, pop, qid in (cache.get(iso3, []) if iso3 else []):
            pool.append((clean(name, 'wikidata', code), lon, lat, pop,
                         f'wikidata:{qid}'))
    # Not towns ([_BAD]), and nothing shouted in capitals ("GANEY MODIIN").
    pool = [c for c in pool
            if c[0] and not _BAD.search(c[0]) and c[0] != c[0].upper()]
    pool.sort(key=lambda c: (-c[3], c[0]))
    kept = []
    for c in pool:
        twin = next((i for i, k in enumerate(kept)
                     if km((c[1], c[2]), (k[1], k[2])) <= SAME_TOWN_KM), None)
        if twin is None:
            kept.append(c)
        elif (kept[twin][4] == 'naturalearth' and c[4] != 'naturalearth'
              and norm(c[0]) == norm(kept[twin][0])):
            k = kept[twin]
            kept[twin] = (c[0], k[1], k[2], k[3], c[4])
    return kept


def main(ne_dir, cache_path=None):
    with open(OVERRIDES, encoding='utf-8') as f:
        overrides = {k for k in json.load(f) if not k.startswith('_')}
    with open(FALLBACK, encoding='utf-8') as f:
        fallback = json.load(f)
    # Drop earlier build picks: they are re-read below.
    fallback = {k: v for k, v in fallback.items()
                if not v.get('src', '').startswith('build:')}
    with open(os.path.join(ne_dir, 'ne_10m_populated_places.geojson'),
              encoding='utf-8') as f:
        ne_places = {}
        for feat in json.load(f)['features']:
            p = feat['properties']
            ne_places.setdefault(p['ADM0_A3'], []).append(p)
    seed, stadiums, extra = city_lists()
    nations = load_nations()
    cache = fetch_all(
        [i for _, code, _ in nations
         for i in map(iso3_of, place_countries(code)) if i],
        cache_path)
    out = {}
    for nid, code, _ in nations:
        with open(os.path.join(GEO, f'{nid}.json'), encoding='utf-8') as f:
            geo = json.load(f)
        s = geo['s']
        boxes = [[v / s for v in geo['v']]] + [[v / s for v in b] for b in geo['i']]
        polys = None if code in overrides else outline_polygons(ne_dir, code)
        listed = all_cities(nid, seed, stadiums, extra)
        taken = {norm(c) for c in listed}
        # (position, how close a new town may come): the nation's two
        # biggest cities keep a wider ring, so none of their districts or
        # boroughs passes for a town of its own.
        spots = [(tuple(v / s for v in geo['c'][c]),
                  BIG_CITY_SPACING_KM if i < 2 else MIN_SPACING_KM)
                 for i, c in enumerate(listed) if c in geo['c']]
        picks = []
        for name, lon, lat, _, src in candidates(code, ne_places, cache):
            if len(picks) == MAX_PER_NATION:
                break
            if norm(name) in taken:
                continue
            at = None
            for d in (0, 360, -360):
                if in_boxes(lon + d, lat, boxes):
                    at = (lon + d, lat)
                    break
            if at is None:
                continue
            if polys is not None and distance_to_outline_km(
                    lon, lat, polys) > MAX_OFF_OUTLINE_KM:
                continue
            if any(km(at, p) < gap for p, gap in spots):
                continue
            taken.add(norm(name))
            spots.append((at, MIN_SPACING_KM))
            picks.append(name)
            fallback[f'{nid}|{name}'] = {
                'lon': round(lon, 4), 'lat': round(lat, 4),
                'src': f'build:{src}'}
        if picks:
            out[str(nid)] = picks
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(dict(sorted(out.items(), key=lambda e: int(e[0]))), f,
                  ensure_ascii=False, indent=1)
        f.write('\n')
    with open(FALLBACK, 'w', encoding='utf-8') as f:
        json.dump(dict(sorted(fallback.items())), f, ensure_ascii=False, indent=1)
        f.write('\n')
    counts = sorted(len(v) for v in out.values())
    print('nations', len(out), 'cities', sum(counts),
          'median', counts[len(counts) // 2] if counts else 0)


if __name__ == '__main__':
    # An optional second argument caches the Wikidata answers (a JSON file).
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
