"""Fills tool/geo/city_fallback.json with a position for every map city that
Natural Earth's populated places do not name, looked up on Wikidata (CC0).

Run once by hand after the city lists change, then review the file (it is
checked in, so gen_geo.py never needs the network):

    python3 -I tool/geo/fetch_city_fallback.py <dir with the NE geojson files>

A city already in the file is kept as it is, so hand corrections stick. A
candidate is accepted only when it lies inside the nation's outline, or
within 30 km of it (coastal towns on a simplified coast).
"""

import json
import sys
import time
import urllib.parse
import urllib.request

sys.path.insert(0, __import__('os').path.dirname(__file__))
from geo_common import (FALLBACK, all_cities, city_lists, distance_to_outline_km,
                        load_nations, match_place, outline_polygons, place_index)

UA = 'fnm26-geo-build/1.0 (offline asset generator)'


def get(params):
    url = 'https://www.wikidata.org/w/api.php?' + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    for attempt in range(6):
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                time.sleep(0.5)
                return json.load(r)
        except Exception as e:
            print('  retry', attempt, e, file=sys.stderr)
            time.sleep(5 + attempt * 10)
    raise SystemExit('wikidata unreachable: ' + url)


def sparql(labels):
    """Every Wikidata item with a position whose English (or multilingual)
    label or alias is one of [labels]: label -> [(lon, lat, population, qid)]."""
    vals = ' '.join(json.dumps(l, ensure_ascii=False) + lang
                    for l in labels for lang in ('@en', '@mul'))
    query = ('SELECT ?item ?label ?coord ?pop WHERE { VALUES ?label { ' + vals +
             ' } ?item rdfs:label|skos:altLabel ?label ; wdt:P625 ?coord . '
             'OPTIONAL { ?item wdt:P1082 ?pop } }')
    url = 'https://query.wikidata.org/sparql?' + urllib.parse.urlencode(
        {'query': query, 'format': 'json'})
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    for attempt in range(6):
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                data = json.load(r)
            break
        except Exception as e:
            print('  retry', attempt, e, file=sys.stderr)
            time.sleep(10 + attempt * 20)
    else:
        raise SystemExit('wikidata query service unreachable')
    out = {}
    for b in data['results']['bindings']:
        wkt = b['coord']['value']
        if not wkt.startswith('Point('):
            continue
        lon, lat = (float(v) for v in wkt[6:-1].split())
        pop = float(b['pop']['value']) if 'pop' in b else 0.0
        qid = b['item']['value'].rsplit('/', 1)[1]
        out.setdefault(b['label']['value'], []).append((lon, lat, pop, qid))
    return out


def save(have):
    with open(FALLBACK, 'w', encoding='utf-8') as f:
        json.dump(dict(sorted(have.items(), key=lambda e: (int(e[0].split('|')[0]), e[0]))),
                  f, ensure_ascii=False, indent=1)
        f.write('\n')


def main():
    ne = sys.argv[1]
    try:
        with open(FALLBACK, encoding='utf-8') as f:
            have = json.load(f)
    except FileNotFoundError:
        have = {}
    idx = place_index(ne)
    seed, st, ex = city_lists()
    todo = []
    outlines = {}
    for nid, code, name in load_nations():
        for city in all_cities(nid, seed, st, ex):
            key = f'{nid}|{city}'
            if key in have or match_place(code, city, idx):
                continue
            todo.append((nid, code, city))
            outlines.setdefault(code, outline_polygons(ne, code))
    labels = sorted({c for _, _, c in todo})
    found = {}
    for i in range(0, len(labels), 40):
        found.update(sparql(labels[i:i + 40]))
        time.sleep(2)
    misses = []
    for nid, code, city in todo:
        best = None
        for lon, lat, pop, qid in found.get(city, []):
            d = distance_to_outline_km(lon, lat, outlines[code])
            if d > 30:
                continue
            rank = (d == 0, pop)
            if best is None or rank > best[0]:
                best = (rank, lon, lat, qid)
        if best is None:
            misses.append(f'{nid}|{city}')
            print('MISS', code, city, flush=True)
            continue
        _, lon, lat, qid = best
        have[f'{nid}|{city}'] = {'lon': round(lon, 4), 'lat': round(lat, 4),
                                 'src': 'wikidata:' + qid}
        print('ok  ', code, city, qid, lon, lat, flush=True)
    save(have)
    print('misses:', len(misses), misses)


if __name__ == '__main__':
    main()
