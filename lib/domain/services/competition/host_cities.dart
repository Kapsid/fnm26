/// Extra host cities, biggest first, for the nations big enough to stage a
/// large finals on their own.
///
/// The seed's per-country city list (`assets/data/country_cities.json`) stops
/// at eight, which is plenty for a qualifier's national stadium and for the
/// clubs it names, but a 48-team World Championship is played in sixteen
/// grounds. These cities are appended after the seed list (duplicates skipped)
/// ONLY when venues are generated; they live apart from the seed file so the
/// club names derived from it do not move in existing saves.
///
/// A nation missing here just offers its seed cities; the venue split hands
/// any shortfall to a co-host, and a solo host plays in what it has.
const Map<int, List<String>> extraHostCities = {
  // Europe
  4: ['St. Pölten', 'Wels', 'Ried im Innkreis'], // Austria
  7: [
    'Mechelen', 'Ostend', 'Kortrijk', 'Sint-Truiden', //
    'Waregem', 'Mons', 'Namur', 'Beveren',
  ], // Belgium
  10: ['Šibenik', 'Velika Gorica', 'Slavonski Brod'], // Croatia
  12: ['Teplice', 'Zlín'], // Czechia
  13: [
    'Vejle', 'Horsens', 'Silkeborg', 'Viborg', //
    'Kolding', 'Lyngby', 'Næstved', 'Hjørring',
  ], // Denmark
  14: [
    'Leicester', 'Southampton', 'Brighton', 'Bristol', //
    'Sunderland', 'Middlesbrough', 'Wolverhampton', 'Derby',
  ], // England
  18: [
    'Toulouse', 'Montpellier', 'Lens', 'Rennes', //
    'Strasbourg', 'Reims', 'Nancy', 'Le Havre',
  ], // France
  20: [
    'Gelsenkirchen', 'Düsseldorf', 'Mönchengladbach', 'Bremen', //
    'Hanover', 'Nuremberg', 'Kaiserslautern', 'Freiburg',
  ], // Germany
  22: ['Ioannina', 'Tripoli', 'Kalamata'], // Greece
  26: [
    'Verona', 'Palermo', 'Bari', 'Cagliari', //
    'Udine', 'Parma', 'Salerno', 'Catania',
  ], // Italy
  36: [
    'Arnhem', 'Nijmegen', 'Heerenveen', 'Tilburg', //
    'Breda', 'Zwolle', 'Almere', 'Sittard',
  ], // Netherlands
  39: ['Kristiansand', 'Sandefjord'], // Norway
  40: [
    'Białystok', 'Lublin', 'Katowice', 'Bydgoszcz', //
    'Kielce', 'Gliwice', 'Zabrze', 'Radom',
  ], // Poland
  41: [
    'Aveiro', 'Leiria', 'Vila do Conde', 'Barcelos', //
    'Viseu', 'Chaves', 'Famalicão', 'Estoril',
  ], // Portugal
  43: [
    'Brașov', 'Oradea', 'Arad', 'Sibiu', //
    'Bacău', 'Pitești', 'Târgu Mureș', 'Brăila',
  ], // Romania
  46: ['Inverness', 'Livingston'], // Scotland
  47: ['Kruševac', 'Novi Pazar', 'Zrenjanin'], // Serbia
  50: [
    'Vigo', 'Gijón', 'Valladolid', 'Palma', //
    'Las Palmas', 'A Coruña', 'Pamplona', 'Elche',
  ], // Spain
  51: [
    'Västerås', 'Linköping', 'Jönköping', 'Halmstad', //
    'Kalmar', 'Sundsvall', 'Umeå', 'Östersund',
  ], // Sweden
  52: ['Thun', 'Winterthur'], // Switzerland
  53: [
    'Gaziantep', 'Kayseri', 'Samsun', 'Eskişehir', //
    'Diyarbakır', 'Sivas', 'Kocaeli', 'Mersin',
  ], // Türkiye
  54: [
    'Kryvyi Rih', 'Mykolaiv', 'Luhansk', 'Vinnytsia', //
    'Kherson', 'Chernihiv', 'Sumy', 'Uzhhorod',
  ], // Ukraine
  // South America
  56: [
    'Tucumán', 'Salta', 'San Juan', 'Santiago del Estero', //
    'Bahía Blanca', 'Paraná', 'Corrientes', 'Neuquén',
  ], // Argentina
  58: [
    'Brasília', 'Manaus', 'Belém', 'Goiânia', //
    'Natal', 'Cuiabá', 'Florianópolis', 'Campinas',
  ], // Brazil
  59: [
    'La Serena', 'Coquimbo', 'Iquique', 'Talca', //
    'Puerto Montt', 'Osorno', 'Chillán', 'Arica',
  ], // Chile
  60: [
    'Pereira', 'Santa Marta', 'Ibagué', 'Pasto', //
    'Villavicencio', 'Neiva', 'Montería', 'Armenia',
  ], // Colombia
  61: [
    'Esmeraldas', 'Riobamba', 'Ibarra', 'Santo Domingo', //
    'Latacunga', 'Quevedo', 'Babahoyo', 'Milagro',
  ], // Ecuador
  63: [
    'Iquitos', 'Pucallpa', 'Tacna', 'Ica', //
    'Juliaca', 'Cajamarca', 'Ayacucho', 'Huánuco',
  ], // Peru
  64: ['Tacuarembó', 'Florida', 'Colonia del Sacramento'], // Uruguay
  65: [
    'Puerto La Cruz', 'Maturín', 'Cumaná', 'San Cristóbal', //
    'Valera', 'Acarigua', 'Los Teques', 'Cabimas',
  ], // Venezuela
  // North and Central America
  74: [
    'Quebec City', 'Halifax', 'Victoria', 'Saskatoon', //
    'Regina', 'Mississauga', 'Kitchener', 'Windsor',
  ], // Canada
  88: [
    'Torreón', 'San Luis Potosí', 'Aguascalientes', 'Ciudad Juárez', //
    'Mazatlán', 'Morelia', 'Veracruz', 'Pachuca',
  ], // Mexico
  99: [
    'Boston', 'Philadelphia', 'Houston', 'San Francisco', //
    'Denver', 'Washington', 'Minneapolis', 'Phoenix',
  ], // United States
  // Africa
  101: [
    'Batna', 'Biskra', 'Tlemcen', 'Chlef', //
    'Djelfa', 'Sidi Bel Abbès', 'Mostaganem', 'Skikda',
  ], // Algeria
  115: [
    'Luxor', 'Aswan', 'Zagazig', 'Asyut', //
    'Faiyum', 'Damanhur', 'Minya', 'Mahalla al-Kubra',
    // The new capital's 93,000-seat stadium (see national_stadiums.json).
    'New Administrative Capital',
  ], // Egypt
  135: [
    'Kenitra', 'Tetouan', 'Safi', 'El Jadida', //
    'Nador', 'Béni Mellal', 'Khouribga', 'Laayoune',
  ], // Morocco
  139: [
    'Uyo', 'Jos', 'Ilorin', 'Abeokuta', //
    'Owerri', 'Calabar', 'Warri', 'Aba',
  ], // Nigeria
  146: [
    'East London', 'Rustenburg', 'Mbombela', 'Pietermaritzburg', //
    'Kimberley', 'George', 'Potchefstroom', 'Welkom',
  ], // South Africa
  // Asia and Oceania
  156: [
    'Wollongong', 'Hobart', 'Townsville', 'Geelong', //
    'Cairns', 'Darwin', 'Sunshine Coast', 'Launceston',
  ], // Australia
  162: [
    'Chongqing', 'Hangzhou', 'Nanjing', "Xi'an", //
    'Qingdao', 'Shenyang', 'Jinan', 'Changsha',
  ], // China PR
  166: [
    'Pune', 'Ahmedabad', 'Jaipur', 'Lucknow', //
    'Guwahati', 'Bhubaneswar', 'Thiruvananthapuram', 'Shillong',
  ], // India
  167: [
    'Yogyakarta', 'Denpasar', 'Padang', 'Pekanbaru', //
    'Balikpapan', 'Samarinda', 'Bogor', 'Surakarta',
  ], // Indonesia
  168: [
    'Kermanshah', 'Rasht', 'Kerman', 'Urmia', //
    'Zahedan', 'Hamadan', 'Arak', 'Yazd',
  ], // Iran
  170: [
    'Fukuoka', 'Sendai', 'Niigata', 'Shizuoka', //
    'Kawasaki', 'Kashima', 'Kyoto', 'Oita',
  ], // Japan
  188: [
    'Khobar', 'Tabuk', 'Hail', 'Najran', //
    'Jazan', 'Al-Ahsa', 'Khamis Mushait', 'Yanbu',
  ], // Saudi Arabia
  190: [
    'Jeonju', 'Changwon', 'Cheongju', 'Pohang', //
    'Jeju', 'Seogwipo', 'Gangneung', 'Goyang',
  ], // South Korea
};
