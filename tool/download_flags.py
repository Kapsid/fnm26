#!/usr/bin/env python3
"""Download flag SVGs for every FIFA nation into assets/flags/{fifa}.svg.

Source: flagcdn.com (public domain flag set), keyed by ISO 3166-1 alpha-2 (plus
GB subdivisions and a few territories). FIFA 3-letter codes map to these below.

Run:  python3 tool/download_flags.py
SVGs are tiny (a few KB each) so the whole set is ~1 MB on disk.
"""
import os
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor

# FIFA 3-letter code -> flagcdn code (ISO alpha-2 / GB subdivision / territory).
FIFA_TO_FLAGCDN = {
    # UEFA / Europe
    "ALB": "al", "AND": "ad", "ARM": "am", "AUT": "at", "AZE": "az",
    "BLR": "by", "BEL": "be", "BIH": "ba", "BUL": "bg", "CRO": "hr",
    "CYP": "cy", "CZE": "cz", "DEN": "dk", "ENG": "gb-eng", "EST": "ee",
    "FRO": "fo", "FIN": "fi", "FRA": "fr", "GEO": "ge", "GER": "de",
    "GIB": "gi", "GRE": "gr", "HUN": "hu", "ISL": "is", "ISR": "il",
    "ITA": "it", "KAZ": "kz", "KVX": "xk", "LVA": "lv", "LIE": "li",
    "LTU": "lt", "LUX": "lu", "MLT": "mt", "MDA": "md", "MNE": "me",
    "NED": "nl", "MKD": "mk", "NIR": "gb-nir", "NOR": "no", "POL": "pl",
    "POR": "pt", "IRL": "ie", "ROU": "ro", "RUS": "ru", "SMR": "sm",
    "SCO": "gb-sct", "SRB": "rs", "SVK": "sk", "SVN": "si", "ESP": "es",
    "SWE": "se", "SUI": "ch", "TUR": "tr", "UKR": "ua", "WAL": "gb-wls",
    # CONMEBOL / South America
    "ARG": "ar", "BOL": "bo", "BRA": "br", "CHI": "cl", "COL": "co",
    "ECU": "ec", "PAR": "py", "PER": "pe", "URU": "uy", "VEN": "ve",
    # CONCACAF / North America
    "AIA": "ai", "ATG": "ag", "ARU": "aw", "BAH": "bs", "BRB": "bb",
    "BLZ": "bz", "BER": "bm", "VGB": "vg", "CAN": "ca", "CAY": "ky",
    "CRC": "cr", "CUB": "cu", "CUW": "cw", "DMA": "dm", "DOM": "do",
    "SLV": "sv", "GRN": "gd", "GUA": "gt", "GUY": "gy", "HAI": "ht",
    "HON": "hn", "JAM": "jm", "MEX": "mx", "MSR": "ms", "NCA": "ni",
    "PAN": "pa", "PUR": "pr", "SKN": "kn", "LCA": "lc", "VIN": "vc",
    "SUR": "sr", "TRI": "tt", "TCA": "tc", "USA": "us", "VIR": "vi",
    # CAF / Africa
    "ALG": "dz", "ANG": "ao", "BEN": "bj", "BOT": "bw", "BFA": "bf",
    "BDI": "bi", "CMR": "cm", "CPV": "cv", "CTA": "cf", "CHA": "td",
    "COM": "km", "CGO": "cg", "COD": "cd", "DJI": "dj", "EGY": "eg",
    "EQG": "gq", "ERI": "er", "SWZ": "sz", "ETH": "et", "GAB": "ga",
    "GAM": "gm", "GHA": "gh", "GUI": "gn", "GNB": "gw", "CIV": "ci",
    "KEN": "ke", "LES": "ls", "LBR": "lr", "LBY": "ly", "MAD": "mg",
    "MWI": "mw", "MLI": "ml", "MTN": "mr", "MRI": "mu", "MAR": "ma",
    "MOZ": "mz", "NAM": "na", "NIG": "ne", "NGA": "ng", "RWA": "rw",
    "STP": "st", "SEN": "sn", "SEY": "sc", "SLE": "sl", "SOM": "so",
    "RSA": "za", "SSD": "ss", "SDN": "sd", "TAN": "tz", "TOG": "tg",
    "TUN": "tn", "UGA": "ug", "ZAM": "zm", "ZIM": "zw",
    # AFC / Asia
    "AFG": "af", "AUS": "au", "BHR": "bh", "BAN": "bd", "BHU": "bt",
    "BRU": "bn", "CAM": "kh", "CHN": "cn", "TPE": "tw", "GUM": "gu",
    "HKG": "hk", "IND": "in", "IDN": "id", "IRN": "ir", "IRQ": "iq",
    "JPN": "jp", "JOR": "jo", "KUW": "kw", "KGZ": "kg", "LAO": "la",
    "LIB": "lb", "MAC": "mo", "MAS": "my", "MDV": "mv", "MNG": "mn",
    "MYA": "mm", "NEP": "np", "PRK": "kp", "OMA": "om", "PAK": "pk",
    "PLE": "ps", "PHI": "ph", "QAT": "qa", "KSA": "sa", "SGP": "sg",
    "KOR": "kr", "SRI": "lk", "SYR": "sy", "TJK": "tj", "THA": "th",
    "TLS": "tl", "TKM": "tm", "UAE": "ae", "UZB": "uz", "VIE": "vn",
    "YEM": "ye",
    # OFC / Oceania
    "ASA": "as", "COK": "ck", "FIJ": "fj", "NCL": "nc", "NZL": "nz",
    "PNG": "pg", "SAM": "ws", "SOL": "sb", "TAH": "pf", "TGA": "to",
    "VAN": "vu",
}

OUT_DIR = os.path.join("assets", "flags")
BASE = "https://flagcdn.com"


def fetch(item):
    fifa, cdn = item
    dest = os.path.join(OUT_DIR, f"{fifa.lower()}.svg")
    url = f"{BASE}/{cdn}.svg"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "fnm/1.0"})
        with urllib.request.urlopen(req, timeout=30) as r:
            data = r.read()
        if not data.lstrip().startswith(b"<svg") and b"<svg" not in data[:200]:
            return (fifa, f"not svg ({len(data)} bytes)")
        with open(dest, "wb") as f:
            f.write(data)
        return (fifa, "ok")
    except Exception as e:  # noqa: BLE001
        return (fifa, f"ERROR {e}")


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    results = []
    with ThreadPoolExecutor(max_workers=12) as ex:
        results = list(ex.map(fetch, FIFA_TO_FLAGCDN.items()))
    ok = [f for f, s in results if s == "ok"]
    bad = [(f, s) for f, s in results if s != "ok"]
    print(f"Downloaded {len(ok)}/{len(FIFA_TO_FLAGCDN)} flags into {OUT_DIR}")
    if bad:
        print("Failures:")
        for f, s in bad:
            print(f"  {f}: {s}")
        sys.exit(1)


if __name__ == "__main__":
    main()
