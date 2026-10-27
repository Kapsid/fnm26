"""Shared inputs for the stadium-map geo tools (gen_geo.py, fetch_city_fallback.py).

Everything here reads the game's own data files: the nations, their cities
(country_cities.json, the curated stadium estate and the extra host cities)
and which Natural Earth features draw each nation.
"""

import json
import os
import re
import unicodedata

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DATA = os.path.join(ROOT, 'assets', 'data')
FALLBACK = os.path.join(os.path.dirname(__file__), 'city_fallback.json')

# Greenland is not in nations.json (it joins from the dormant pool).
GREENLAND_ID = 212

# FIFA code -> the Natural Earth features that draw it, as
# (dataset, field, value). The UK's four football nations come from the
# map-units set; a few nations merge features (see the report).
_COUNTRY = 'countries'
_UNITS = 'map_units'

OUTLINE_SOURCES = {
    'ENG': [(_UNITS, 'GU_A3', 'ENG')],
    'SCO': [(_UNITS, 'GU_A3', 'SCT')],
    'WAL': [(_UNITS, 'GU_A3', 'WLS')],
    'NIR': [(_UNITS, 'GU_A3', 'NIR')],
    # The whole island: the game's Cyprus plays in Nicosia and Famagusta.
    'CYP': [(_COUNTRY, 'ADM0_A3', a) for a in ('CYP', 'CYN', 'CNM', 'ESB', 'WSB')],
    # Hargeisa is one of the game's Somali cities.
    'SOM': [(_COUNTRY, 'ADM0_A3', a) for a in ('SOM', 'SOL')],
}

# FIFA code -> Natural Earth ADM0_A3, where they differ.
FIFA_TO_NE = {
    'ALB': 'ALB', 'AND': 'AND', 'ARM': 'ARM', 'AUT': 'AUT', 'AZE': 'AZE',
    'BEL': 'BEL', 'BIH': 'BIH', 'BUL': 'BGR', 'CRO': 'HRV', 'CZE': 'CZE',
    'DEN': 'DNK', 'EST': 'EST', 'FRO': 'FRO', 'FIN': 'FIN', 'FRA': 'FRA',
    'GEO': 'GEO', 'GER': 'DEU', 'GIB': 'GIB', 'GRE': 'GRC', 'HUN': 'HUN',
    'ISL': 'ISL', 'ISR': 'ISR', 'ITA': 'ITA', 'KAZ': 'KAZ', 'KVX': 'KOS',
    'LVA': 'LVA', 'LIE': 'LIE', 'LTU': 'LTU', 'LUX': 'LUX', 'MLT': 'MLT',
    'MDA': 'MDA', 'MNE': 'MNE', 'NED': 'NLD', 'MKD': 'MKD', 'NOR': 'NOR',
    'POL': 'POL', 'POR': 'PRT', 'IRL': 'IRL', 'ROU': 'ROU', 'SMR': 'SMR',
    'SRB': 'SRB', 'SVK': 'SVK', 'SVN': 'SVN', 'ESP': 'ESP', 'SWE': 'SWE',
    'SUI': 'CHE', 'TUR': 'TUR', 'UKR': 'UKR', 'ARG': 'ARG', 'BOL': 'BOL',
    'BRA': 'BRA', 'CHI': 'CHL', 'COL': 'COL', 'ECU': 'ECU', 'PAR': 'PRY',
    'PER': 'PER', 'URU': 'URY', 'VEN': 'VEN', 'AIA': 'AIA', 'ATG': 'ATG',
    'ARU': 'ABW', 'BAH': 'BHS', 'BRB': 'BRB', 'BLZ': 'BLZ', 'BER': 'BMU',
    'VGB': 'VGB', 'CAN': 'CAN', 'CAY': 'CYM', 'CRC': 'CRI', 'CUB': 'CUB',
    'CUW': 'CUW', 'DMA': 'DMA', 'DOM': 'DOM', 'SLV': 'SLV', 'GRN': 'GRD',
    'GUA': 'GTM', 'GUY': 'GUY', 'HAI': 'HTI', 'HON': 'HND', 'JAM': 'JAM',
    'MEX': 'MEX', 'MSR': 'MSR', 'NCA': 'NIC', 'PAN': 'PAN', 'PUR': 'PRI',
    'SKN': 'KNA', 'LCA': 'LCA', 'VIN': 'VCT', 'SUR': 'SUR', 'TRI': 'TTO',
    'TCA': 'TCA', 'USA': 'USA', 'VIR': 'VIR', 'ALG': 'DZA', 'ANG': 'AGO',
    'BEN': 'BEN', 'BOT': 'BWA', 'BFA': 'BFA', 'BDI': 'BDI', 'CMR': 'CMR',
    'CPV': 'CPV', 'CTA': 'CAF', 'CHA': 'TCD', 'COM': 'COM', 'CGO': 'COG',
    'COD': 'COD', 'DJI': 'DJI', 'EGY': 'EGY', 'EQG': 'GNQ', 'ERI': 'ERI',
    'SWZ': 'SWZ', 'ETH': 'ETH', 'GAB': 'GAB', 'GAM': 'GMB', 'GHA': 'GHA',
    'GUI': 'GIN', 'GNB': 'GNB', 'CIV': 'CIV', 'KEN': 'KEN', 'LES': 'LSO',
    'LBR': 'LBR', 'LBY': 'LBY', 'MAD': 'MDG', 'MWI': 'MWI', 'MLI': 'MLI',
    'MTN': 'MRT', 'MRI': 'MUS', 'MAR': 'MAR', 'MOZ': 'MOZ', 'NAM': 'NAM',
    'NIG': 'NER', 'NGA': 'NGA', 'RWA': 'RWA', 'STP': 'STP', 'SEN': 'SEN',
    'SEY': 'SYC', 'SLE': 'SLE', 'RSA': 'ZAF', 'SSD': 'SDS', 'SDN': 'SDN',
    'TAN': 'TZA', 'TOG': 'TGO', 'TUN': 'TUN', 'UGA': 'UGA', 'ZAM': 'ZMB',
    'ZIM': 'ZWE', 'AFG': 'AFG', 'AUS': 'AUS', 'BHR': 'BHR', 'BAN': 'BGD',
    'BHU': 'BTN', 'BRU': 'BRN', 'CAM': 'KHM', 'CHN': 'CHN', 'TPE': 'TWN',
    'GUM': 'GUM', 'HKG': 'HKG', 'IND': 'IND', 'IDN': 'IDN', 'IRN': 'IRN',
    'IRQ': 'IRQ', 'JPN': 'JPN', 'JOR': 'JOR', 'KUW': 'KWT', 'KGZ': 'KGZ',
    'LAO': 'LAO', 'LIB': 'LBN', 'MAC': 'MAC', 'MAS': 'MYS', 'MDV': 'MDV',
    'MNG': 'MNG', 'MYA': 'MMR', 'NEP': 'NPL', 'PRK': 'PRK', 'OMA': 'OMN',
    'PAK': 'PAK', 'PLE': 'PSX', 'PHI': 'PHL', 'QAT': 'QAT', 'KSA': 'SAU',
    'SGP': 'SGP', 'KOR': 'KOR', 'SRI': 'LKA', 'SYR': 'SYR', 'TJK': 'TJK',
    'THA': 'THA', 'TLS': 'TLS', 'TKM': 'TKM', 'UAE': 'ARE', 'UZB': 'UZB',
    'VIE': 'VNM', 'YEM': 'YEM', 'ASA': 'ASM', 'COK': 'COK', 'FIJ': 'FJI',
    'NCL': 'NCL', 'NZL': 'NZL', 'PNG': 'PNG', 'SAM': 'WSM', 'SOL': 'SLB',
    'TAH': 'PYF', 'TGA': 'TON', 'VAN': 'VUT', 'GRL': 'GRL', 'ENG': 'GBR',
    'SCO': 'GBR', 'WAL': 'GBR', 'NIR': 'GBR', 'CYP': 'CYP', 'SOM': 'SOM',
}

# Places in Natural Earth filed under another ADM0 than the nation's own
# outline code (Somaliland's Hargeisa, the north of Cyprus).
PLACE_COUNTRIES = {
    'CYP': ['CYP', 'CYN'],
    'SOM': ['SOM', 'SOL'],
}


def outline_sources(code):
    if code in OUTLINE_SOURCES:
        return OUTLINE_SOURCES[code]
    return [(_COUNTRY, 'ADM0_A3', FIFA_TO_NE[code])]


def place_countries(code):
    return PLACE_COUNTRIES.get(code, [FIFA_TO_NE[code]])


def load_nations():
    """[(id, code, name)] for the 209 nations plus Greenland."""
    with open(os.path.join(DATA, 'nations.json'), encoding='utf-8') as f:
        raw = json.load(f)
    out = [(n['id'], n['code'], n['name']) for n in raw]
    out.append((GREENLAND_ID, 'GRL', 'Greenland'))
    return out


def extra_host_cities():
    """extraHostCities from lib/domain/services/competition/host_cities.dart."""
    path = os.path.join(ROOT, 'lib', 'domain', 'services', 'competition',
                        'host_cities.dart')
    with open(path, encoding='utf-8') as f:
        src = f.read()
    body = src[src.index('extraHostCities = {'):]
    body = re.sub(r'//[^\n]*', '', body)
    out = {}
    for m in re.finditer(r'(\d+):\s*\[(.*?)\]', body, re.S):
        names = re.findall(r"'((?:[^'\\]|\\.)*)'|\"([^\"]*)\"", m.group(2))
        out[int(m.group(1))] = [a.replace("\\'", "'") or b for a, b in names]
    return out


def city_lists():
    """id -> (seed cities, curated stadium cities, extra host cities)."""
    with open(os.path.join(DATA, 'country_cities.json'), encoding='utf-8') as f:
        seed = {int(k): v for k, v in json.load(f).items()}
    with open(os.path.join(DATA, 'national_stadiums.json'), encoding='utf-8') as f:
        stadiums = {int(k): [e['city'] for e in v] for k, v in json.load(f).items()}
    extra = extra_host_cities()
    return seed, stadiums, extra


def all_cities(nation_id, seed, stadiums, extra):
    """Every city the map may pin for a nation, without repeats, in order."""
    out = []
    for c in seed.get(nation_id, []) + stadiums.get(nation_id, []) + extra.get(nation_id, []):
        if c not in out:
            out.append(c)
    return out


def norm(name):
    s = unicodedata.normalize('NFKD', name)
    s = ''.join(ch for ch in s if not unicodedata.combining(ch))
    s = s.lower().replace('ı', 'i').replace('ł', 'l').replace('ø', 'o')
    s = s.replace('æ', 'ae').replace('ð', 'd').replace('þ', 'th').replace('ß', 'ss')
    s = re.sub(r'\bsaint\b|\bsankt\b', 'st', s)
    s = re.sub(r"[^a-z0-9]+", ' ', s).strip()
    return s


_FILES = {
    'countries': 'ne_10m_admin_0_countries.geojson',
    'map_units': 'ne_10m_admin_0_map_units.geojson',
}
_cache = {}


def _features(ne_dir, dataset):
    if dataset not in _cache:
        with open(os.path.join(ne_dir, _FILES[dataset]), encoding='utf-8') as f:
            _cache[dataset] = json.load(f)['features']
    return _cache[dataset]


def outline_polygons(ne_dir, code):
    """The nation's polygons, each a list of rings (outer first) of (lon, lat)."""
    polys = []
    for dataset, field, value in outline_sources(code):
        found = False
        for f in _features(ne_dir, dataset):
            if f['properties'].get(field) != value:
                continue
            found = True
            g = f['geometry']
            parts = [g['coordinates']] if g['type'] == 'Polygon' else g['coordinates']
            for poly in parts:
                polys.append([[(float(x), float(y)) for x, y in ring] for ring in poly])
        if not found:
            raise SystemExit(f'no Natural Earth feature {dataset} {field}={value} for {code}')
    return polys


def point_in_ring(x, y, ring):
    inside = False
    n = len(ring)
    j = n - 1
    for i in range(n):
        xi, yi = ring[i]
        xj, yj = ring[j]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            inside = not inside
        j = i
    return inside


def distance_to_outline_km(lon, lat, polys):
    """0 inside the outline, else the distance to its nearest vertex in km."""
    import math
    for poly in polys:
        if point_in_ring(lon, lat, poly[0]) and not any(
                point_in_ring(lon, lat, h) for h in poly[1:]):
            return 0.0
    best = 1e18
    k = math.cos(math.radians(lat))
    for poly in polys:
        for x, y in poly[0]:
            dx = (x - lon) * k
            dy = y - lat
            d = dx * dx + dy * dy
            if d < best:
                best = d
    return math.sqrt(best) * 111.2


def place_index(ne_dir):
    """(ADM0_A3, normalised name) -> [(population, lon, lat)] from Natural
    Earth populated places, by every name a place carries."""
    with open(os.path.join(ne_dir, 'ne_10m_populated_places.geojson'),
              encoding='utf-8') as f:
        feats = json.load(f)['features']
    idx = {}
    for f in feats:
        p = f['properties']
        names = {p['NAME'], p['NAMEASCII'], p.get('NAME_EN') or ''}
        names |= set((p.get('NAMEALT') or '').split('|'))
        for k in ('NAME_DE', 'NAME_ES', 'NAME_FR', 'NAME_PT', 'NAME_IT'):
            if p.get(k):
                names.add(p[k])
        for n in names:
            if n:
                idx.setdefault((p['ADM0_A3'], norm(n)), []).append(
                    (p.get('POP_MAX') or 0, p['LONGITUDE'], p['LATITUDE']))
    return idx


def match_place(code, city, idx):
    """(lon, lat) of the most populous Natural Earth place of that name in
    the nation, or None."""
    hits = []
    for a in place_countries(code):
        hits += idx.get((a, norm(city)), [])
    if not hits:
        return None
    _, lon, lat = max(hits)
    return (lon, lat)
