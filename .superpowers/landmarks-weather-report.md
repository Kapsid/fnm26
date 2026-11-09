# Landmarks + weather report (feat/landmarks-weather)

Branch `feat/landmarks-weather` from `main` 50d67e0a. Not pushed, not merged.

## Part 1: 24 new landmarks (30 -> 54)

Where city names come from: `StadiumSpec.from` calls `Landmarks.forCity(ground.city)`.
`ground.city` comes from `assets/data/national_stadiums.json` (real grounds),
`country_cities.json` (tournament host cities) and `stadium_build_cities.json`
(user-built grounds). All of them spell cities in English. Local spellings were
added as well, for a ground renamed in the world editor.

| City (data spelling) | Kind | Also matched |
|---|---|---|
| Vienna | `riesenrad` | Wien, Vienne |
| Brussels | `atomium` | Bruxelles, Brussel |
| Warsaw | `palaceOfCulture` | Warszawa |
| Munich | `frauenkirche` | München, Muenchen, Monaco di Baviera |
| Stockholm | `stockholmCityHall` | |
| Helsinki | `helsinkiCathedral` | Helsingfors |
| Edinburgh | `edinburghCastle` | Dùn Èideann |
| Dublin | `dublinSpire` | Baile Átha Cliath |
| Kyiv | `motherland` | Kiev, Kyjiv, Kijów, Kiew |
| Bucharest | `palaceOfParliament` | București (comma-s), Bucureşti (cedilla-s), Bukurest |
| **Zagreb** (swap) | `zagrebCathedral` | |
| Riyadh | `kingdomCentre` | Riyad, Ar Riyad |
| Doha | `aspireTorch` | Ad Dawhah |
| Tehran | `azadi` | Teheran |
| Delhi | `indiaGate` | New Delhi |
| Bangkok | `watArun` | Krung Thep |
| Shanghai | `orientalPearl` | |
| **Philadelphia** (swap) | `independenceHall` | |
| Montevideo | `palacioSalvo` | |
| Bogotá | `monserrate` | Bogota, Santa Fe de Bogotá |
| Santiago | `costanera` (Andes + Gran Torre) | Santiago de Chile |
| Casablanca | `hassanII` | |
| Nairobi | `kicc` | |
| Auckland | `skyTower` | Tāmaki Makaurau |

`fold()` gained `ș ț ă ā`, so București (comma below) folds to "bucuresti".
Look-alike names elsewhere stay unmatched: Santiago de Cuba, Santiago de los
Caballeros, Wiener Neustadt, Helsingborg (tested).

### Swaps
- **St Petersburg -> Zagreb (Cathedral twin spires).** Russia is not in the game:
  there is no RUS in `nations.json` and no Russian city in any data file. Zagreb is
  Croatia's main ground (Maksimir) and had no landmark.
- **Washington -> Philadelphia (Independence Hall).** No US ground is in
  Washington. Philadelphia is in `national_stadiums.json`. I avoided the Space
  Needle (Seattle) and the Golden Gate (San Francisco) because both names and
  shapes are trademarks.

### Drawing
- Each landmark is a path one unit tall, in the existing style (`landmark_paths.dart`).
- New helpers: `_bar`, `_circle` and `_merlons`.
- The Riesenrad is cut as "disc minus gaps". A plain union of ring paths filled the
  whole wheel solid.
- No lit windows for the non-buildings (wheel, Atomium, statue, spire, arches,
  mountains, towers).

Previews are in `~/Downloads/landmarks-preview/`: 24 PNGs, each showing day and
night in a real stadium backdrop. I inspected them all and redrew three:
- The Riesenrad rendered as a solid disc.
- The Oriental Pearl's spheres were too small.
- The Aspire stadium arch was hidden below the roof.

All 24 read as their landmark at backdrop scale.

## Part 2: weather

`WeatherKind` = `clear, rain, snow, haze, heavyRain, thunderstorm, fog, windy, dustStorm, frostyNight`.
- The new kinds are appended at the end, so the old indices are unchanged.
- `rain` keeps its name and now means **light rain**. The label changed from "Rain"
  to "Light rain" in all 28 languages. `heavyRain` is the separate heavy kind.

### Climate rules (`MatchWeather.of`)
`MatchWeather.of` gained an optional `kickOffHours`. `matchConditionsShown` passes
the fixture's own deterministic kick-off time, so the venue card and the 2D TV
still agree, which is tested. The rules, in the order they are checked:

| Rule | Where and when | Chance |
|---|---|---|
| Gulf, hot months Apr–Oct | QAT UAE KSA KUW BHR OMA IRQ | dust 6%, haze 64% (taken from the old 70% haze) |
| Gulf, cool months | same | dust 3%, haze 22% |
| Sahel, dry season Nov–Apr | MLI NIG CHA BFA SEN MTN SDN GAM | dust 8%, haze 6%, light rain 3% |
| Snow | lat ≥ 45 only | unchanged |
| Thunderstorm, wet season (northern-month 5–10) | storm belt: Southeast Asia, West/Central Africa, CONMEBOL except Chile, CONCACAF with lat < 26 | 6% |
| Thunderstorm, afternoon kick-off (13:00–19:30) | same | ×1.4 |
| Thunderstorm, dry season | same | 1.2% |
| Thunderstorm, Jun–Aug | USA | 4% |
| Windy, Sep–Apr | British Isles, ISL, FRO, GRL | 8% |
| Windy, summer | same | 4% |
| Windy | NZL | 6% |
| Windy (Patagonia's share) | ARG, CHI | 3% |
| Fog, Oct–Feb, evening | lat ≥ 44 | 8% |
| Fog, Oct–Feb, otherwise | lat ≥ 44 | 3.5% |
| Rain total | unchanged, scaled by (1 − snow) | wet-season tropics .26, dry .16 |
| Heavy share of rain | wet tropics / wet north / elsewhere | 45% / 30% / 25% |
| Frosty night, Nov–Mar, kick-off 17:30–22:30 | lat ≥ 44 | 9% (taken from clear) |

### Frequencies
Measured over 1,200 fixtures per month, with kick-offs spread over 13:00–20:45. Figures are percentages.

| ground | months | clear | rain (light) | snow | haze | heavyRain | thunderstorm | fog | windy | dustStorm | frostyNight |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ENG | Oct-Mar | 35.8 | 24.9 | 12.6 | - | 9.9 | - | 4.6 | 8.3 | - | 3.8 |
| ENG | Jun-Aug | 54.7 | 28.8 | - | - | 12.5 | - | - | 4.0 | - | - |
| SCO | Oct-Mar | 29.1 | 21.2 | 23.6 | - | 9.2 | - | 4.4 | 8.6 | - | 3.8 |
| ISL | Oct-Mar | 30.5 | 20.6 | 23.5 | - | 9.3 | - | 4.5 | 8.0 | - | 3.5 |
| NZL | all year | 81.7 | 9.0 | - | - | 3.0 | - | - | 6.4 | - | - |
| ARG | all year | 84.9 | 6.1 | - | - | 1.9 | 4.2 | - | 3.0 | - | - |
| NOR | Dec-Feb | 26.4 | 16.7 | 39.6 | - | 8.0 | - | 5.1 | - | - | 4.2 |
| POL | Nov-Mar | 56.9 | 14.1 | 15.7 | - | 4.5 | - | 4.7 | - | - | 4.1 |
| CZE | Oct-Feb | 56.7 | 14.4 | 14.9 | - | 4.4 | - | 5.9 | - | - | 3.6 |
| GER | Jun-Aug | 78.1 | 16.1 | - | - | 5.8 | - | - | - | - | - |
| ESP | all year | 88.2 | 8.7 | - | - | 3.1 | - | - | - | - | - |
| ITA | Nov-Feb | 88.1 | 9.2 | - | - | 2.8 | - | - | - | - | - |
| BRA | Dec-Mar | 74.8 | 9.6 | - | - | 7.5 | 8.1 | - | - | - | - |
| BRA | Jun-Aug | 83.7 | 11.0 | - | - | 3.9 | 1.4 | - | - | - | - |
| COL | May-Oct | 74.6 | 10.3 | - | - | 7.5 | 7.6 | - | - | - | - |
| THA | May-Oct | 74.5 | 9.8 | - | - | 7.8 | 7.8 | - | - | - | - |
| THA | Dec-Mar | 83.7 | 10.9 | - | - | 4.0 | 1.5 | - | - | - | - |
| NGA | Jun-Sep | 74.9 | 9.1 | - | - | 8.3 | 7.8 | - | - | - | - |
| MEX | Jun-Oct | 74.6 | 9.5 | - | - | 8.2 | 7.7 | - | - | - | - |
| USA | Jun-Aug | 88.3 | 4.9 | - | - | 1.7 | 5.1 | - | - | - | - |
| USA | Dec-Feb | 88.1 | 9.1 | - | - | 2.8 | - | - | - | - | - |
| QAT | Apr-Oct | 28.8 | - | - | 65.1 | - | - | - | - | 6.1 | - |
| QAT | Nov-Mar | 75.0 | - | - | 22.2 | - | - | - | - | 2.8 | - |
| MLI | Nov-Apr | 83.3 | 3.1 | - | 5.8 | - | - | - | - | 7.8 | - |
| SEN | Jul-Sep | 73.7 | 9.6 | - | - | 8.4 | 8.4 | - | - | - | - |
| KEN | all year | 84.0 | 12.1 | - | - | 3.9 | - | - | - | - | - |
| JPN | all year | 87.1 | 10.2 | - | - | 2.7 | - | - | - | - | - |
| AUS | all year | 88.0 | 9.0 | - | - | 3.0 | - | - | - | - | - |

Clear is the most common weather everywhere except Qatar in summer (haze) and a
Nordic midwinter (snow). Both exceptions were already there before this change.

### Drawing
- **Baked into the ground image** (`stadium_features.dart`):
  - Darker skies for heavy rain, wind and storms; a near-black storm sky.
  - Fog: a cold grey wash over the sky and a veil over the ground, thickest at the
    far stand, so the far stand and the landmark drown. It is visibly different
    from the warm haze.
  - Dust storm: an ochre wash and veil.
  - Frosty night: a crisp deep-blue sky and rime at the pitch edges. The rime is
    drawn after the grade so it reads under the floodlights.
  - Wet sheen on the grass for every rain kind, stronger for heavy rain and storms.
  - Wind: flags stream and ripple off their poles, and crowd scarves stream downwind.
- **Animated** (`weather_painter.dart`):
  - Each kind is one cached tile, scrolled, as before. Heavy rain is denser and
    longer. Wind slants the rain hard (driven snow when the season is snowy).
    Fog banks drift slowly; dust wisps and grit blow across.
  - Lightning: a soft flash, a gradient wash with a peak alpha of 0.3, eased
    double pulse. At most one flash per 24 s window, and only two windows in
    three: about 1.7 a minute. A thin forked bolt shows only at the peak.
  - Per-frame cost: four image blits, plus one rect and one path during a flash.
    Paints, shaders and bolt paths are cached per size, and the blit loop was
    unrolled, so no list is allocated per frame.
  - Breath (`WeatherOverlay.paintBreath`) is drawn by `ActorsPainter` when the
    weather is a frosty night. It uses one static `Paint` and one `drawCircle`
    per man per frame.
- **Venue card icons:** `water_drop` (heavy rain), `thunderstorm`, `foggy`, `air`
  (windy), `grain` (dust storm), `severe_cold` (frosty night).
- **Labels:** six new `matchWeather*` keys in all 28 languages, added via
  `copy/strings.csv` -> `import_copy` -> `gen-l10n`, with no em dashes. I also
  changed the haze label where it said "fog", so the two never share a word:
  pl Zamglenie, vi Mù khô, bg Омара, ro Pâclă.

Previews of each weather kind at a real stadium are in `~/Downloads/weather-preview/`:
11 PNGs, including windy rain in Dublin and windy snow in Reykjavík. I inspected
them all and strengthened the dust and fog veils, the frost and the flag ripple.

## Save safety
- **Not stored.** Weather is derived per fixture by `MatchWeather.of`. Nothing in
  `lib/data`, the DB or SharedPreferences stores `WeatherKind`. Nothing indexes it
  or calls `byName` on it outside tests.
- **`pitchForcedWeatherProvider`** is a test pin (null in the app), not persisted.
- **`matchConditionsShown`** is still drawn from the fixture and the save seed
  only. Kick-off is computed first and then fed into the weather, so the 2D TV and
  the card still agree, which is tested.
- **Renaming `rain` was avoided.** It keeps its name; only its label changed.
- **Cosmetic only:**
  - New test: no file in `lib/domain` outside `stadium/` mentions `WeatherKind`
    or `MatchWeather`.
  - The existing `pitch_mode_test` "plays the same in any weather" test now loops
    over all ten kinds and passes.
- **Visible change:** existing fixtures may show different weather than before,
  because the bands moved. This is cosmetic and nothing is stored.

## Tests
- `test/unit/pitch/match_weather_test.dart` (new):
  - clear is the most common weather;
  - each new kind falls in a 2.5–11% band in its home climates;
  - never-rules: no snow, fog or frost in the tropics; no dust in ISL, NOR, ENG,
    NZL or BRA; no storms in the north, the Gulf or Chile; no wind in BRA, GER,
    QAT, THA or USA; no frost at afternoon kick-offs; fog likelier in the evening;
  - determinism;
  - cosmetic-only source check;
  - enum order;
  - lightning rate: 10–30 flashes in 10 minutes, and never in other kinds;
  - `animates` per kind;
  - tiles cached for every kind, warm and cold.
- `ground_look_test`:
  - 54 kinds;
  - every second-set city is in `national_stadiums.json` and maps to its kind;
  - local spellings, and look-alike names stay unmatched;
  - the new silhouettes are one unit tall.
- `stadium_signature_test`: "wet" now counts rain + heavy rain (an intended
  change).
- **Goldens:** 9 new `pitch_mock` scenes, inspected: `phone_heavy_rain`,
  `phone_thunderstorm` (at the flash peak, bolt visible), `phone_fog`,
  `phone_windy`, `phone_dust_storm`, `phone_frosty_night` (with breath), and
  `phone_landmark_vienna`, `phone_landmark_brussels`, `phone_landmark_shanghai`.
  No existing golden changed.
- **Runs:**
  - `test/unit/pitch` + `test/unit/l10n`: 393 passed.
  - Match and pitch widget tests (36 files) + all of `test/golden`: 536
    passed, 3 golden diffs, all intended. I inspected and refreshed them:
    - `match_phone_pitch_theme_wc` and `_bronze`: the venue line now reads
      "Light rain" instead of "Rain".
    - `pitch_mock_phone_doha`: Doha now shows the Aspire Torch.
  - No other existing golden moved. I removed the untracked failure images
    from the run; the tracked `test/golden/failures` files are untouched.

## Concerns
- **Atomium image rights.** The Atomium's owners have long claimed rights over
  pictures of it. Belgium's 2016 freedom-of-panorama law probably covers it, but
  this is the same kind of risk as the Eiffel night lighting. It is also drawn
  floodlit at night. The Motherland statue (Ukraine, limited panorama freedom)
  is a smaller version of the same question. Owner's call.
- **England snow.** England gets ~12% snow over Oct–Mar, which is high. This is
  pre-existing (the lat ≥ 45 winter rule) and I left it alone.
- **Stale testers.** Four `flutter_tester` processes about 8.7 h old, from
  another session, are still running. `while pgrep ...` therefore never ends;
  I waited on my own runs instead and did not kill them.
- **Shootout view.** It does not draw breath (the shootout painter was left alone).
