import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';

/// What the land round one city is like, as far as the backdrop behind its
/// ground cares. Cosmetic only: no match reads it.
enum CityFeature {
  /// On the coast or round a harbour: the sea on the horizon, harbour
  /// cranes and a lighthouse.
  coast,

  /// On a river: the water and a bridge across it in the middle distance.
  river,

  /// High mountains close by: snowy peaks on the horizon.
  mountains,

  /// Desert round it: dunes and haze on the horizon.
  desert,

  /// Forest or a great park round it: wooded hills, trees in front.
  forest,

  /// An old town: old roofs and a tower among the buildings.
  oldTown,

  /// An industrial town: factory chimneys over the roofs.
  industrial,
}

/// The game's stadium cities, tagged by what is round them ([CityFeature]):
/// every capital and every city a national team plays its home games in
/// (the five biggest grounds a home game rotates over, see `HomeGround`),
/// and a few more. A city that is not in the table keeps its country's look
/// (see [NationBackdrops.table]).
///
/// Keyed by nation code and city, the city matched as [Landmarks.fold]
/// matches it (case and accents ignored), so two cities of one name in two
/// countries (Valencia, Tripoli, Georgetown) are each their own.
abstract final class CityGeography {
  /// [city]'s features in the country [nationCode], or null when the table
  /// does not know it.
  static Set<CityFeature>? of(String nationCode, String city) {
    final code = nationCode.toUpperCase();
    final tags = _index[code]?[Landmarks.fold(city)];
    if (tags != null) return _parse(tags);
    if (_islands.contains(code)) return const {CityFeature.coast};
    return null;
  }

  /// The far layer behind a ground in a city with [features], in a country
  /// whose own is [country] (of [confederation]): the country's, unless the
  /// features say otherwise. Snowy peaks for a mountain city, the sea for a
  /// coastal one, dunes in the desert, wooded hills round a forest or a
  /// park; and an inland city never looks out to sea, nor up at a range it
  /// is nowhere near.
  static Horizon horizonFor(
    Horizon country,
    Set<CityFeature> features,
    Confederation confederation,
  ) {
    if (features.contains(CityFeature.mountains)) {
      switch (country) {
        case Horizon.andes ||
            Horizon.alps ||
            Horizon.atlas ||
            Horizon.volcanoes ||
            Horizon.fjords:
          return country;
        case _:
          if (features.contains(CityFeature.desert) ||
              country == Horizon.desert) {
            return Horizon.atlas;
          }
          return confederation == Confederation.southAmerica
              ? Horizon.andes
              : Horizon.alps;
      }
    }
    if (features.contains(CityFeature.coast)) {
      return country == Horizon.fjords ? Horizon.fjords : Horizon.sea;
    }
    if (features.contains(CityFeature.desert)) return Horizon.desert;
    if (features.contains(CityFeature.forest)) return Horizon.forestHills;
    return switch (country) {
      // Inland, no peaks near: the land round it, not the country's coast
      // or its ranges.
      Horizon.sea ||
      Horizon.fjords ||
      Horizon.alps ||
      Horizon.andes ||
      Horizon.volcanoes => Horizon.forestHills,
      Horizon.atlas => Horizon.plains,
      _ => country,
    };
  }

  /// How many cities the table tags, every nation's together.
  static int get taggedCities =>
      _table.values.fold(0, (n, cities) => n + cities.length);

  /// Every (nation code, city) the table tags, as written.
  static Iterable<(String, String)> get entries sync* {
    for (final e in _table.entries) {
      for (final city in e.value.keys) {
        yield (e.key, city);
      }
    }
  }

  /// Nations that are islands small enough that every ground in them is on
  /// the coast, whatever city it stands in.
  static const Set<String> _islands = {
    'AIA', 'ATG', 'ARU', 'BAH', 'BRB', 'BER', 'VGB', 'CAY', 'CUW', 'DMA', //
    'GRN', 'MSR', 'SKN', 'LCA', 'VIN', 'TCA', 'VIR', 'MLT', 'STP', 'SEY', //
    'COM', 'MDV', 'GUM', 'MAC', 'SGP', 'BHR', 'ASA', 'COK', 'FIJ', 'NCL', //
    'SAM', 'SOL', 'TAH', 'TGA', 'VAN', 'FRO', 'MRI', 'CPV', 'TLS',
  };

  static final Map<String, Map<String, String>> _index = {
    for (final e in _table.entries)
      e.key: {for (final c in e.value.entries) Landmarks.fold(c.key): c.value},
  };

  static final Map<String, Set<CityFeature>> _parsed = {};

  static Set<CityFeature> _parse(String tags) => _parsed[tags] ??= {
    for (final ch in tags.split(''))
      ?switch (ch) {
        'c' => CityFeature.coast,
        'r' => CityFeature.river,
        'm' => CityFeature.mountains,
        'd' => CityFeature.desert,
        'f' => CityFeature.forest,
        'o' => CityFeature.oldTown,
        'i' => CityFeature.industrial,
        _ => null,
      },
  };

  /// c coast or harbour, r river, m mountains near, d desert, f forest or
  /// park, o old town, i industrial; '-' none of them (an inland city with
  /// nothing round it that the backdrop shows, which still keeps it off its
  /// country's coast).
  static const Map<String, Map<String, String>> _table = {
    // --- Europe ------------------------------------------------------------
    'ALB': {
      'Tirana': 'm',
      'Shkodër': 'mo',
      'Elbasan': 'i',
      'Durrës': 'c',
      'Vlorë': 'c',
      'Korçë': 'mo',
    },
    'AND': {
      'Andorra la Vella': 'mr',
      'Escaldes-Engordany': 'm',
      'Encamp': 'm',
      'Sant Julià de Lòria': 'm',
    },
    'ARM': {
      'Yerevan': 'mo',
      'Gyumri': 'mo',
      'Vanadzor': 'mi',
      'Abovyan': 'm',
      'Kapan': 'm',
    },
    'AUT': {
      'Vienna': 'rfo',
      'Graz': 'o',
      'Linz': 'ri',
      'Salzburg': 'mo',
      'Wals-Siezenheim': 'm',
      'Innsbruck': 'mo',
      'Klagenfurt': 'm',
    },
    'AZE': {
      'Baku': 'co',
      'Ganja': 'o',
      'Sumqayit': 'ci',
      'Lankaran': 'cf',
      'Gabala': 'mf',
    },
    'BLR': {
      'Minsk': 'r',
      'Gomel': 'r',
      'Mogilev': 'r',
      'Vitebsk': 'ro',
      'Grodno': 'ro',
      'Brest': 'ro',
      'Borisov': 'r',
    },
    'BEL': {
      'Brussels': 'o',
      'Antwerp': 'rio',
      'Ghent': 'ro',
      'Bruges': 'o',
      'Liège': 'ri',
      'Charleroi': 'i',
      'Genk': 'i',
    },
    'BIH': {
      'Sarajevo': 'mo',
      'Banja Luka': 'r',
      'Tuzla': 'i',
      'Zenica': 'mi',
      'Mostar': 'mro',
    },
    'BUL': {
      'Sofia': 'm',
      'Plovdiv': 'o',
      'Varna': 'c',
      'Burgas': 'c',
      'Ruse': 'r',
      'Stara Zagora': '-',
    },
    'CRO': {
      'Zagreb': 'fo',
      'Split': 'co',
      'Rijeka': 'ci',
      'Osijek': 'r',
      'Zadar': 'co',
      'Varaždin': 'o',
    },
    'CYP': {
      'Nicosia': 'o',
      'Limassol': 'c',
      'Larnaca': 'c',
      'Paphos': 'co',
      'Paralimni': 'c',
    },
    'CZE': {
      'Prague': 'ro',
      'Brno': 'o',
      'Ostrava': 'i',
      'Plzeň': 'io',
      'Liberec': 'mf',
      'Olomouc': 'o',
      'Teplice': 'fi',
    },
    'DEN': {
      'Copenhagen': 'co',
      'Aarhus': 'c',
      'Odense': 'o',
      'Aalborg': 'c',
      'Esbjerg': 'ci',
      'Brøndby': '-',
    },
    'ENG': {
      'London': 'ro',
      'Manchester': 'i',
      'Liverpool': 'ci',
      'Birmingham': 'i',
      'Newcastle': 'ri',
      'Leeds': 'i',
    },
    'EST': {
      'Tallinn': 'co',
      'Tartu': 'ro',
      'Narva': 'ri',
      'Pärnu': 'c',
      'Viljandi': 'o',
    },
    'FIN': {
      'Helsinki': 'c',
      'Tampere': 'ri',
      'Turku': 'co',
      'Oulu': 'c',
      'Lahti': 'f',
    },
    'FRA': {
      'Paris': 'ro',
      'Marseille': 'c',
      'Lyon': 'ro',
      'Lille': 'io',
      'Nice': 'cm',
      'Bordeaux': 'ro',
    },
    'GEO': {
      'Tbilisi': 'mro',
      'Batumi': 'cm',
      'Kutaisi': 'mr',
      'Rustavi': 'i',
      'Gori': 'm',
    },
    'GER': {
      'Berlin': 'r',
      'Munich': 'o',
      'Hamburg': 'ri',
      'Cologne': 'ro',
      'Dortmund': 'i',
      'Frankfurt': 'r',
      'Gelsenkirchen': 'i',
      'Stuttgart': 'f',
    },
    'GIB': {
      'Gibraltar': 'c',
      'Westside': 'c',
      'North District': 'c',
      'South District': 'c',
    },
    'GRE': {
      'Athens': 'o',
      'Thessaloniki': 'c',
      'Piraeus': 'ci',
      'Patras': 'c',
      'Heraklion': 'c',
    },
    'HUN': {
      'Budapest': 'ro',
      'Debrecen': '-',
      'Szeged': 'r',
      'Miskolc': 'i',
      'Győr': 'r',
    },
    'ISL': {
      'Reykjavík': 'c',
      'Kópavogur': 'c',
      'Hafnarfjörður': 'c',
      'Akureyri': 'cm',
      'Akranes': 'c',
      'Keflavík': 'c',
    },
    'ISR': {
      'Jerusalem': 'o',
      'Tel Aviv': 'c',
      'Haifa': 'c',
      'Beersheba': 'd',
      'Netanya': 'c',
    },
    'ITA': {
      'Rome': 'ro',
      'Milan': 'i',
      'Naples': 'co',
      'Turin': 'mr',
      'Florence': 'ro',
      'Genoa': 'c',
      'Bari': 'co',
    },
    'KAZ': {
      'Astana': 'r',
      'Almaty': 'm',
      'Shymkent': '-',
      'Karaganda': 'i',
      'Aktobe': '-',
    },
    'KVX': {
      'Pristina': '-',
      'Prizren': 'mo',
      'Mitrovica': 'i',
      'Peja': 'm',
      'Gjilan': '-',
    },
    'LVA': {
      'Riga': 'cro',
      'Daugavpils': 'r',
      'Liepāja': 'c',
      'Jelgava': 'r',
      'Jūrmala': 'cf',
    },
    'LIE': {
      'Vaduz': 'mr',
      'Schaan': 'm',
      'Triesen': 'm',
      'Balzers': 'm',
      'Eschen': 'm',
    },
    'LTU': {
      'Vilnius': 'ro',
      'Kaunas': 'ro',
      'Klaipėda': 'c',
      'Panevėžys': '-',
      'Marijampolė': '-',
    },
    'LUX': {
      'Luxembourg City': 'o',
      'Esch-sur-Alzette': 'i',
      'Differdange': 'i',
      'Dudelange': 'i',
      'Ettelbruck': 'f',
    },
    'MLT': {'Valletta': 'co'},
    'MDA': {
      'Chișinău': 'f',
      'Tiraspol': 'r',
      'Bălți': '-',
      'Bender': 'r',
      'Orhei': 'r',
    },
    'MNE': {
      'Podgorica': 'm',
      'Nikšić': 'm',
      'Budva': 'co',
      'Bar': 'c',
      'Bijelo Polje': 'm',
      'Cetinje': 'mo',
    },
    'NED': {
      'Amsterdam': 'ro',
      'Rotterdam': 'ci',
      'Eindhoven': 'i',
      'The Hague': 'c',
      'Utrecht': 'o',
      'Enschede': '-',
      'Heerenveen': '-',
    },
    'MKD': {
      'Skopje': 'mo',
      'Bitola': 'm',
      'Kumanovo': '-',
      'Tetovo': 'm',
      'Prilep': '-',
      'Ohrid': 'mo',
    },
    'NIR': {
      'Belfast': 'ci',
      'Derry': 'ro',
      'Ballymena': '-',
      'Portadown': '-',
      'Coleraine': 'r',
    },
    'NOR': {
      'Oslo': 'cf',
      'Bergen': 'cm',
      'Trondheim': 'c',
      'Stavanger': 'c',
      'Kristiansand': 'c',
    },
    'POL': {
      'Warsaw': 'r',
      'Kraków': 'ro',
      'Łódź': 'i',
      'Wrocław': 'ro',
      'Poznań': 'o',
      'Gdańsk': 'cio',
      'Chorzów': 'i',
    },
    'POR': {
      'Lisbon': 'cro',
      'Porto': 'cro',
      'Braga': 'o',
      'Guimarães': 'o',
      'Coimbra': 'ro',
    },
    'IRL': {
      'Dublin': 'c',
      'Cork': 'c',
      'Limerick': 'r',
      'Galway': 'c',
      'Waterford': 'c',
    },
    'ROU': {
      'Bucharest': '-',
      'Cluj-Napoca': 'o',
      'Timișoara': 'o',
      'Iași': 'o',
      'Constanța': 'c',
      'Craiova': '-',
    },
    'SMR': {
      'City of San Marino': 'o',
      'Serravalle': '-',
      'Borgo Maggiore': '-',
      'Domagnano': '-',
      'Fiorentino': '-',
    },
    'SCO': {
      'Glasgow': 'ri',
      'Edinburgh': 'co',
      'Aberdeen': 'c',
      'Dundee': 'c',
      'Kilmarnock': '-',
    },
    'SRB': {
      'Belgrade': 'ro',
      'Novi Sad': 'r',
      'Niš': 'o',
      'Kragujevac': 'i',
      'Subotica': 'o',
    },
    'SVK': {
      'Bratislava': 'ro',
      'Košice': 'o',
      'Žilina': 'm',
      'Trnava': 'o',
      'Dunajská Streda': '-',
    },
    'SVN': {
      'Ljubljana': 'mo',
      'Maribor': 'mr',
      'Celje': 'm',
      'Koper': 'c',
      'Murska Sobota': '-',
    },
    'ESP': {
      'Madrid': '-',
      'Barcelona': 'c',
      'Valencia': 'co',
      'Seville': 'ro',
      'Bilbao': 'ri',
      'Málaga': 'c',
    },
    'SWE': {
      'Stockholm': 'co',
      'Gothenburg': 'ci',
      'Malmö': 'c',
      'Uppsala': 'o',
      'Norrköping': 'ri',
      'Helsingborg': 'c',
    },
    'SUI': {
      'Zurich': 'o',
      'Geneva': 'm',
      'Basel': 'ri',
      'Bern': 'mro',
      'Lausanne': 'm',
      'St. Gallen': 'm',
    },
    'TUR': {
      'Istanbul': 'co',
      'Ankara': '-',
      'Izmir': 'c',
      'Bursa': 'm',
      'Antalya': 'cm',
      'Trabzon': 'c',
      'Konya': 'd',
    },
    'UKR': {
      'Kyiv': 'r',
      'Kharkiv': 'i',
      'Odesa': 'c',
      'Dnipro': 'ri',
      'Donetsk': 'i',
      'Lviv': 'o',
    },
    'WAL': {
      'Cardiff': 'co',
      'Swansea': 'c',
      'Newport': 'ri',
      'Wrexham': '-',
      'Llanelli': 'c',
    },
    'GRL': {
      'Nuuk': 'cm',
      'Sisimiut': 'c',
      'Ilulissat': 'c',
      'Qaqortoq': 'c',
      'Aasiaat': 'c',
    },

    // --- South America -----------------------------------------------------
    'ARG': {
      'Buenos Aires': 'cr',
      'Córdoba': '-',
      'Rosario': 'ri',
      'La Plata': 'c',
      'Mendoza': 'm',
      'Avellaneda': 'ci',
    },
    'BOL': {
      'La Paz': 'm',
      'Santa Cruz de la Sierra': 'f',
      'Cochabamba': 'm',
      'El Alto': 'm',
      'Sucre': 'mo',
      'Oruro': 'mi',
    },
    'BRA': {
      'São Paulo': 'i',
      'Rio de Janeiro': 'cf',
      'Brasília': '-',
      'Belo Horizonte': 'i',
      'Porto Alegre': 'r',
      'Salvador': 'co',
      'Recife': 'c',
      'Fortaleza': 'c',
    },
    'CHI': {
      'Santiago': 'm',
      'Valparaíso': 'co',
      'Concepción': 'ci',
      'Viña del Mar': 'c',
      'Antofagasta': 'cd',
    },
    'COL': {
      'Bogotá': 'm',
      'Medellín': 'm',
      'Cali': 'f',
      'Barranquilla': 'c',
      'Cartagena': 'co',
      'Pereira': 'mf',
    },
    'ECU': {
      'Quito': 'm',
      'Guayaquil': 'cr',
      'Cuenca': 'mo',
      'Manta': 'c',
    },
    'PAR': {
      'Asunción': 'r',
      'Ciudad del Este': 'r',
      'Luque': '-',
      'Encarnación': 'r',
    },
    'PER': {
      'Lima': 'cd',
      'Arequipa': 'md',
      'Trujillo': 'cd',
      'Cusco': 'mo',
    },
    'URU': {
      'Montevideo': 'c',
      'Salto': 'r',
      'Paysandú': 'r',
      'Maldonado': 'c',
      'Rivera': '-',
    },
    'VEN': {
      'Caracas': 'm',
      'Maracaibo': 'ci',
      'Valencia': '-',
      'Mérida': 'm',
      'Maturín': '-',
      'Ciudad Guayana': 'ri',
    },

    // --- North and Central America, the Caribbean --------------------------
    'BLZ': {
      'Belize City': 'c',
      'Belmopan': 'f',
      'San Ignacio': 'f',
      'Orange Walk': 'f',
      'Dangriga': 'c',
    },
    'CAN': {
      'Toronto': 'c',
      'Montreal': 'ro',
      'Vancouver': 'cm',
      'Ottawa': 'r',
      'Calgary': 'm',
      'Edmonton': 'r',
    },
    'CRC': {
      'San José': 'm',
      'Alajuela': 'm',
      'Cartago': 'm',
      'Heredia': 'm',
      'Liberia': '-',
    },
    'CUB': {
      'Havana': 'co',
      'Santiago de Cuba': 'cm',
      'Cienfuegos': 'c',
      'Pinar del Río': 'f',
      'Santa Clara': '-',
    },
    'DMA': {'Roseau': 'cm', 'Portsmouth': 'cm'},
    'DOM': {
      'Santo Domingo': 'co',
      'Santiago de los Caballeros': 'm',
      'San Cristóbal': '-',
      'San Pedro de Macorís': 'c',
      'La Romana': 'c',
    },
    'SLV': {
      'San Salvador': 'm',
      'Santa Ana': 'm',
      'San Miguel': 'm',
      'Santa Tecla': 'm',
      'Usulután': 'm',
    },
    'GUA': {
      'Guatemala City': 'm',
      'Quetzaltenango': 'm',
      'Escuintla': 'm',
      'Cobán': 'f',
      'Mazatenango': '-',
    },
    'GUY': {
      'Georgetown': 'c',
      'Linden': 'ri',
      'New Amsterdam': 'cr',
      'Bartica': 'rf',
      'Anna Regina': 'c',
    },
    'HAI': {
      'Port-au-Prince': 'c',
      'Cap-Haïtien': 'c',
      'Gonaïves': 'c',
      'Les Cayes': 'c',
      'Delmas': '-',
    },
    'HON': {
      'Tegucigalpa': 'm',
      'San Pedro Sula': 'm',
      'La Ceiba': 'c',
      'Choluteca': '-',
      'Comayagua': 'o',
    },
    'JAM': {
      'Kingston': 'c',
      'Montego Bay': 'c',
      'Spanish Town': 'o',
      'Portmore': 'c',
      'Mandeville': 'f',
    },
    'MEX': {
      'Mexico City': 'm',
      'Guadalajara': 'o',
      'Monterrey': 'mi',
      'Puebla': 'mo',
      'Toluca': 'm',
    },
    'NCA': {
      'Managua': 'm',
      'León': 'mo',
      'Granada': 'o',
      'Estelí': 'f',
      'Matagalpa': 'f',
      'Chinandega': 'm',
    },
    'PAN': {
      'Panama City': 'c',
      'Colón': 'c',
      'David': '-',
      'La Chorrera': '-',
      'Santiago de Veraguas': '-',
    },
    'PUR': {
      'San Juan': 'co',
      'Bayamón': '-',
      'Carolina': 'c',
      'Ponce': 'c',
      'Mayagüez': 'c',
    },
    'SUR': {
      'Paramaribo': 'ro',
      'Nieuw Nickerie': 'c',
      'Lelydorp': 'f',
      'Moengo': 'f',
      'Albina': 'r',
    },
    'TRI': {
      'Port of Spain': 'c',
      'San Fernando': 'ci',
      'Couva': 'c',
      'Arima': 'f',
      'Scarborough': 'c',
    },
    'USA': {
      'New York': 'cr',
      'Los Angeles': 'c',
      'Chicago': 'c',
      'Atlanta': 'f',
      'Seattle': 'cm',
      'Dallas': '-',
      'Kansas City': 'r',
      'Houston': 'ci',
      'Philadelphia': 'r',
    },

    // --- Africa ------------------------------------------------------------
    'ALG': {
      'Algiers': 'co',
      'Oran': 'c',
      'Constantine': 'o',
      'Annaba': 'c',
      'Tizi Ouzou': 'm',
    },
    'ANG': {
      'Luanda': 'c',
      'Huambo': '-',
      'Benguela': 'c',
      'Lubango': 'm',
      'Cabinda': 'c',
    },
    'BEN': {
      'Cotonou': 'c',
      'Porto-Novo': 'c',
      'Parakou': '-',
      'Abomey-Calavi': '-',
      'Djougou': '-',
    },
    'BOT': {
      'Gaborone': '-',
      'Francistown': '-',
      'Lobatse': '-',
      'Molepolole': '-',
      'Maun': 'r',
    },
    'BFA': {
      'Ouagadougou': '-',
      'Bobo-Dioulasso': 'o',
      'Koudougou': '-',
      'Banfora': '-',
      'Ouahigouya': '-',
    },
    'BDI': {
      'Bujumbura': 'c',
      'Gitega': 'f',
      'Muyinga': '-',
      'Ngozi': '-',
      'Rumonge': 'c',
    },
    'CMR': {'Douala': 'ci', 'Yaoundé': 'f', 'Garoua': 'r'},
    'CTA': {
      'Bangui': 'r',
      'Bimbo': 'r',
      'Bouar': '-',
      'Berbérati': 'f',
      'Carnot': 'f',
    },
    'CHA': {
      "N'Djamena": 'r',
      'Moundou': 'r',
      'Sarh': 'r',
      'Abéché': 'd',
      'Kélo': '-',
    },
    'COM': {'Moroni': 'cm'},
    'CGO': {
      'Brazzaville': 'r',
      'Pointe-Noire': 'ci',
      'Dolisie': 'f',
      'Owando': 'f',
    },
    'COD': {
      'Kinshasa': 'r',
      'Lubumbashi': 'i',
      'Kisangani': 'rf',
      'Goma': 'm',
      'Mbuji-Mayi': 'i',
    },
    'DJI': {
      'Djibouti City': 'cd',
      'Ali Sabieh': 'd',
      'Tadjoura': 'cd',
      'Obock': 'cd',
      'Dikhil': 'd',
    },
    'EGY': {
      'Cairo': 'rd',
      'Alexandria': 'c',
      'Giza': 'rd',
      'Port Said': 'c',
      'New Administrative Capital': 'd',
    },
    'EQG': {
      'Malabo': 'cm',
      'Bata': 'c',
      'Mongomo': 'f',
      'Ebebiyin': 'f',
      'Aconibe': 'f',
    },
    'ERI': {
      'Asmara': 'm',
      'Massawa': 'cd',
      'Keren': 'm',
      'Assab': 'cd',
      'Mendefera': 'm',
    },
    'SWZ': {
      'Mbabane': 'm',
      'Lobamba': 'm',
      'Manzini': '-',
      'Siteki': '-',
      'Nhlangano': 'm',
    },
    'ETH': {
      'Addis Ababa': 'm',
      'Bahir Dar': 'r',
      'Hawassa': 'f',
      'Dire Dawa': 'd',
      'Adama': '-',
    },
    'GAB': {
      'Libreville': 'c',
      'Port-Gentil': 'ci',
      'Franceville': 'f',
      'Oyem': 'f',
      'Moanda': 'i',
    },
    'GAM': {
      'Banjul': 'c',
      'Bakau': 'c',
      'Serekunda': 'c',
      'Brikama': '-',
      'Farafenni': 'r',
    },
    'GHA': {
      'Accra': 'c',
      'Kumasi': 'f',
      'Tamale': '-',
      'Sekondi-Takoradi': 'ci',
      'Cape Coast': 'co',
    },
    'GUI': {
      'Conakry': 'c',
      'Nzérékoré': 'f',
      'Kankan': 'r',
      'Labé': 'm',
    },
    'GNB': {
      'Bissau': 'c',
      'Bafatá': 'r',
      'Gabú': '-',
      'Bissorã': '-',
      'Canchungo': '-',
    },
    'CIV': {
      'Abidjan': 'c',
      'Yamoussoukro': '-',
      'Bouaké': '-',
      'San-Pédro': 'c',
    },
    'KEN': {
      'Nairobi': 'f',
      'Mombasa': 'co',
      'Kisumu': 'c',
      'Eldoret': 'f',
    },
    'LES': {
      'Maseru': 'm',
      'Teyateyaneng': 'm',
      'Mafeteng': 'm',
      'Hlotse': 'm',
      'Maputsoe': 'm',
    },
    'LBR': {
      'Monrovia': 'c',
      'Gbarnga': 'f',
      'Kakata': 'f',
      'Buchanan': 'c',
      'Ganta': 'f',
    },
    'LBY': {
      'Tripoli': 'co',
      'Benghazi': 'c',
      'Misrata': 'c',
      'Zawiya': 'c',
    },
    'MAD': {
      'Antananarivo': 'o',
      'Toamasina': 'c',
      'Antsirabe': 'm',
      'Fianarantsoa': 'o',
      'Mahajanga': 'c',
    },
    'MWI': {
      'Lilongwe': '-',
      'Blantyre': 'm',
      'Mzuzu': 'f',
      'Zomba': 'm',
      'Kasungu': '-',
    },
    'MLI': {'Bamako': 'r', 'Sikasso': '-', 'Mopti': 'r', 'Ségou': 'r'},
    'MTN': {
      'Nouakchott': 'cd',
      'Nouadhibou': 'cd',
      'Kiffa': 'd',
      'Kaédi': 'r',
      'Rosso': 'r',
    },
    'MAR': {
      'Rabat': 'co',
      'Casablanca': 'c',
      'Marrakesh': 'mo',
      'Fez': 'o',
      'Tangier': 'c',
      'Agadir': 'c',
    },
    'MOZ': {
      'Maputo': 'c',
      'Matola': 'ci',
      'Beira': 'c',
      'Nampula': '-',
      'Chimoio': 'm',
    },
    'NAM': {
      'Windhoek': 'md',
      'Walvis Bay': 'cd',
      'Swakopmund': 'cd',
      'Rundu': 'r',
      'Oshakati': '-',
    },
    'NIG': {
      'Niamey': 'r',
      'Zinder': 'd',
      'Maradi': 'd',
      'Agadez': 'do',
      'Tahoua': 'd',
    },
    'NGA': {
      'Abuja': 'f',
      'Lagos': 'c',
      'Kano': 'o',
      'Ibadan': '-',
      'Port Harcourt': 'ci',
      'Uyo': 'f',
    },
    'RWA': {'Kigali': 'f', 'Butare': '-', 'Rubavu': 'm', 'Musanze': 'm'},
    'SEN': {
      'Dakar': 'c',
      'Rufisque': 'c',
      'Thiès': '-',
      'Kaolack': 'r',
      'Ziguinchor': 'r',
    },
    'SLE': {
      'Freetown': 'c',
      'Bo': 'f',
      'Kenema': 'f',
      'Makeni': '-',
      'Koidu': 'i',
    },
    'SOM': {
      'Mogadishu': 'c',
      'Hargeisa': 'd',
      'Kismayo': 'c',
      'Bosaso': 'cd',
      'Baidoa': 'd',
    },
    'RSA': {
      'Johannesburg': 'i',
      'Cape Town': 'cm',
      'Durban': 'c',
      'Pretoria': 'f',
      'Port Elizabeth': 'c',
      'Soweto': '-',
    },
    'SSD': {
      'Juba': 'r',
      'Wau': 'r',
      'Malakal': 'r',
      'Yei': 'f',
      'Aweil': '-',
    },
    'SDN': {
      'Khartoum': 'rd',
      'Omdurman': 'rd',
      'Wad Madani': 'r',
      'Port Sudan': 'cd',
    },
    'TAN': {
      'Dar es Salaam': 'c',
      'Dodoma': '-',
      'Mwanza': 'c',
      'Arusha': 'm',
      'Zanzibar City': 'co',
    },
    'TOG': {
      'Lomé': 'c',
      'Kara': '-',
      'Sokodé': '-',
      'Kpalimé': 'm',
      'Atakpamé': 'm',
    },
    'TUN': {'Tunis': 'co', 'Sfax': 'ci', 'Sousse': 'co', 'Bizerte': 'c'},
    'UGA': {'Kampala': 'f', 'Jinja': 'r', 'Lira': '-', 'Mbarara': '-'},
    'ZAM': {'Lusaka': '-', 'Ndola': 'i', 'Kitwe': 'i', 'Chingola': 'i'},
    'ZIM': {'Harare': '-', 'Bulawayo': 'i', 'Mutare': 'm', 'Gweru': '-'},
    'ZAN': {
      'Zanzibar City': 'co',
      'Chake-Chake': 'c',
      'Wete': 'c',
      'Mkoani': 'c',
      'Mkokotoni': 'c',
    },

    // --- Asia --------------------------------------------------------------
    'AFG': {
      'Kabul': 'm',
      'Kandahar': 'd',
      'Herat': 'o',
      'Mazar-i-Sharif': 'd',
      'Jalalabad': 'm',
    },
    'AUS': {
      'Sydney': 'c',
      'Melbourne': 'c',
      'Brisbane': 'r',
      'Perth': 'cr',
      'Adelaide': 'c',
    },
    'BAN': {
      'Dhaka': 'r',
      'Chittagong': 'c',
      'Sylhet': 'f',
      'Rajshahi': 'r',
      'Mymensingh': 'r',
    },
    'BHU': {
      'Thimphu': 'm',
      'Paro': 'm',
      'Punakha': 'm',
      'Phuentsholing': 'f',
      'Gelephu': 'f',
    },
    'BRU': {
      'Bandar Seri Begawan': 'r',
      'Kuala Belait': 'c',
      'Seria': 'ci',
      'Tutong': 'c',
      'Bangar': 'f',
    },
    'CAM': {
      'Phnom Penh': 'r',
      'Siem Reap': 'f',
      'Battambang': 'r',
      'Sihanoukville': 'c',
    },
    'CHN': {
      'Beijing': 'o',
      'Shanghai': 'cr',
      'Guangzhou': 'r',
      'Shenzhen': 'c',
      'Hangzhou': 'fo',
      'Dalian': 'c',
    },
    'TPE': {
      'Taipei': 'm',
      'Kaohsiung': 'ci',
      'Taichung': '-',
      'Tainan': 'o',
      'Hsinchu': 'c',
    },
    'HKG': {
      'Hong Kong': 'cm',
      'Kowloon': 'c',
      'Sha Tin': 'm',
      'Tsuen Wan': 'c',
      'Yuen Long': '-',
    },
    'IND': {
      'Mumbai': 'c',
      'Delhi': 'o',
      'Kolkata': 'r',
      'Chennai': 'c',
      'Kochi': 'c',
    },
    'IDN': {
      'Jakarta': 'c',
      'Surabaya': 'ci',
      'Bandung': 'm',
      'Malang': 'm',
      'Palembang': 'r',
    },
    'IRN': {
      'Tehran': 'm',
      'Mashhad': '-',
      'Isfahan': 'o',
      'Tabriz': 'm',
      'Shiraz': 'o',
    },
    'IRQ': {'Baghdad': 'r', 'Basra': 'r', 'Karbala': 'd', 'Najaf': 'd'},
    'JPN': {
      'Tokyo': 'c',
      'Yokohama': 'c',
      'Osaka': 'c',
      'Saitama': '-',
      'Shizuoka': 'c',
    },
    'JOR': {'Amman': 'd', 'Zarqa': 'di', 'Irbid': '-', 'Russeifa': 'd'},
    'KUW': {
      'Kuwait City': 'cd',
      'Hawalli': 'cd',
      'Salmiya': 'cd',
      'Jahra': 'd',
    },
    'KGZ': {
      'Bishkek': 'm',
      'Osh': 'm',
      'Jalal-Abad': 'm',
      'Karakol': 'm',
      'Tokmok': 'm',
    },
    'LAO': {
      'Vientiane': 'r',
      'Savannakhet': 'r',
      'Luang Prabang': 'ro',
      'Pakse': 'r',
      'Thakhek': 'r',
    },
    'LIB': {
      'Beirut': 'c',
      'Tripoli': 'c',
      'Sidon': 'co',
      'Tyre': 'co',
      'Jounieh': 'cm',
    },
    'MAS': {
      'Kuala Lumpur': '-',
      'Johor Bahru': 'c',
      'Penang': 'c',
      'Ipoh': 'f',
      'Malacca': 'co',
    },
    'MNG': {
      'Ulaanbaatar': 'm',
      'Erdenet': 'i',
      'Darkhan': 'i',
      'Choibalsan': 'r',
      'Mörön': '-',
    },
    'MYA': {
      'Yangon': 'r',
      'Mandalay': 'r',
      'Naypyidaw': '-',
      'Mawlamyine': 'c',
    },
    'NEP': {
      'Kathmandu': 'mo',
      'Pokhara': 'm',
      'Lalitpur': 'mo',
      'Biratnagar': '-',
      'Bharatpur': 'f',
    },
    'PRK': {'Pyongyang': 'r', 'Hamhung': 'i', 'Chongjin': 'ci'},
    'OMA': {
      'Muscat': 'c',
      'Seeb': 'c',
      'Sohar': 'c',
      'Salalah': 'c',
      'Sur': 'c',
    },
    'PAK': {
      'Karachi': 'c',
      'Lahore': 'o',
      'Islamabad': 'm',
      'Faisalabad': 'i',
      'Peshawar': 'o',
    },
    'PLE': {
      'Jericho': 'd',
      'Ramallah': '-',
      'Gaza City': 'c',
      'Nablus': '-',
      'Jenin': '-',
    },
    'PHI': {
      'Manila': 'c',
      'Cebu City': 'c',
      'Davao City': 'c',
      'Bacolod': 'c',
      'Iloilo City': 'c',
    },
    'QAT': {
      'Doha': 'cd',
      'Al Rayyan': 'd',
      'Al Wakrah': 'cd',
      'Al Khor': 'cd',
      'Lusail': 'cd',
    },
    'KSA': {
      'Riyadh': 'd',
      'Jeddah': 'cd',
      'Mecca': 'd',
      'Khobar': 'cd',
      'Dammam': 'cd',
    },
    'KOR': {
      'Seoul': 'mr',
      'Busan': 'c',
      'Incheon': 'c',
      'Daegu': '-',
      'Suwon': 'o',
    },
    'SRI': {
      'Colombo': 'c',
      'Kandy': 'm',
      'Galle': 'co',
      'Jaffna': 'c',
      'Negombo': 'c',
    },
    'SYR': {
      'Damascus': 'o',
      'Aleppo': 'o',
      'Homs': '-',
      'Latakia': 'c',
      'Hama': 'r',
    },
    'TJK': {'Dushanbe': 'm', 'Khujand': 'r', 'Hisor': 'm', 'Kulob': 'm'},
    'THA': {
      'Bangkok': 'r',
      'Chiang Mai': 'm',
      'Buriram': '-',
      'Hat Yai': '-',
    },
    'TKM': {
      'Ashgabat': 'd',
      'Türkmenabat': 'r',
      'Daşoguz': 'd',
      'Mary': 'd',
    },
    'UAE': {
      'Abu Dhabi': 'cd',
      'Dubai': 'cd',
      'Sharjah': 'cd',
      'Al Ain': 'd',
    },
    'UZB': {
      'Tashkent': '-',
      'Samarkand': 'o',
      'Bukhara': 'do',
      'Namangan': '-',
      'Qarshi': 'd',
    },
    'VIE': {
      'Hanoi': 'r',
      'Ho Chi Minh City': 'r',
      'Haiphong': 'ci',
      'Can Tho': 'r',
    },
    'YEM': {
      'Sanaa': 'mo',
      'Aden': 'c',
      'Taiz': 'm',
      'Hodeidah': 'c',
      'Mukalla': 'c',
    },

    // --- Oceania -----------------------------------------------------------
    'NZL': {
      'Auckland': 'c',
      'Wellington': 'c',
      'Christchurch': '-',
      'Hamilton': 'r',
      'Dunedin': 'c',
    },
    'PNG': {
      'Port Moresby': 'c',
      'Lae': 'c',
      'Mount Hagen': 'm',
      'Madang': 'c',
      'Kokopo': 'c',
    },
  };
}
