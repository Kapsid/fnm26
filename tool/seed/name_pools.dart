// Fictional first/last name pools grouped by broad culture region.
//
// Each FIFA nation maps to one of these regions (see nations_data.dart). Names
// are invented, nationality-appropriate combinations — no real players — to
// avoid any likeness/licensing concerns while keeping squads believable.
//
// Pools are deliberately broad approximations; a handful of nations share a
// region, which is fine (real surnames recur across borders too).

class NamePool {
  const NamePool({required this.first, required this.last});

  final List<String> first;
  final List<String> last;
}

const Map<String, NamePool> namePools = {
  'english': NamePool(
    first: [
      'Jack', 'Harry', 'Callum', 'Mason', 'Reece', 'Tyler', 'Connor', 'Liam',
      'Ethan', 'Aaron', 'Joel', 'Kyle', 'Lewis', 'Dylan', 'Marcus', 'Nathan',
    ],
    last: [
      'Walker', 'Hughes', 'Bennett', 'Carter', 'Wright', 'Hayes', 'Marsh',
      'Doyle', 'Pearce', 'Bridges', 'Holt', 'Reeves', 'Sutton', 'Mercer',
      'Whitaker', 'Ashworth', 'Grimshaw', 'Lowery', 'Banks', 'Fielding',
    ],
  ),
  'spanish': NamePool(
    first: [
      'Diego', 'Javier', 'Sergio', 'Pablo', 'Adrián', 'Iván', 'Rubén', 'Marco',
      'Hugo', 'Álvaro', 'Mateo', 'Nicolás', 'Bruno', 'Emilio', 'Gonzalo',
      'Andrés',
    ],
    last: [
      'García', 'Romero', 'Vargas', 'Castro', 'Herrera', 'Mendoza', 'Reyes',
      'Ortega', 'Domínguez', 'Cabrera', 'Aguilar', 'Salazar', 'Peralta',
      'Montero', 'Bravo', 'Quintero', 'Navarro', 'Carrillo', 'Fuentes',
      'Solano',
    ],
  ),
  'portuguese': NamePool(
    first: [
      'João', 'Tiago', 'Rúben', 'Diogo', 'André', 'Bruno', 'Rafael', 'Gonçalo',
      'Vítor', 'Caio', 'Lucas', 'Matheus', 'Felipe', 'Rodrigo', 'Henrique',
      'Bernardo',
    ],
    last: [
      'Ribeiro', 'Cardoso', 'Teixeira', 'Moreira', 'Fonseca', 'Pinto',
      'Barbosa', 'Lemos', 'Macedo', 'Antunes', 'Tavares', 'Coelho', 'Nogueira',
      'Marques', 'Azevedo', 'Câmara', 'Esteves', 'Pacheco', 'Vasques',
      'Quintas',
    ],
  ),
  'french': NamePool(
    first: [
      'Lucas', 'Hugo', 'Théo', 'Maxime', 'Clément', 'Antoine', 'Nathan',
      'Romain', 'Léo', 'Mathis', 'Gabriel', 'Florian', 'Bastien', 'Adrien',
      'Yanis', 'Enzo',
    ],
    last: [
      'Mercier', 'Lefèvre', 'Rousseau', 'Girard', 'Moreau', 'Lambert',
      'Fontaine', 'Chevalier', 'Dubois', 'Renard', 'Marchand', 'Brun',
      'Gauthier', 'Perret', 'Noël', 'Maillot', 'Vidal', 'Charpentier',
      'Loiseau', 'Benoît',
    ],
  ),
  'german': NamePool(
    first: [
      'Lukas', 'Jonas', 'Felix', 'Niklas', 'Maximilian', 'Tim', 'Florian',
      'Moritz', 'Leon', 'Jan', 'Tobias', 'Erik', 'David', 'Marcel', 'Philipp',
      'Fabian',
    ],
    last: [
      'Brandt', 'Keller', 'Vogel', 'Schuster', 'Engel', 'Brückner', 'Hartmann',
      'Krause', 'Lorenz', 'Sommer', 'Wagner', 'Böhm', 'Frank', 'Albrecht',
      'Reinhardt', 'Kühn', 'Stein', 'Wolff', 'Busch', 'Haas',
    ],
  ),
  'dutch': NamePool(
    first: [
      'Daan', 'Sven', 'Bram', 'Lars', 'Thijs', 'Stijn', 'Jeroen', 'Ruben',
      'Tim', 'Joost', 'Niels', 'Koen', 'Bas', 'Sander', 'Wout', 'Mees',
    ],
    last: [
      'de Bruin', 'van Dijk', 'Bakker', 'Jansen', 'Visser', 'Smit', 'Mulder',
      'de Vries', 'Bos', 'Kuiper', 'van Leeuwen', 'Dekker', 'Hendriks',
      'Vermeer', 'Brouwer', 'Maas', 'Willems', 'Kok', 'Prins', 'Scholten',
    ],
  ),
  'italian': NamePool(
    first: [
      'Marco', 'Lorenzo', 'Matteo', 'Andrea', 'Davide', 'Simone', 'Federico',
      'Alessandro', 'Riccardo', 'Stefano', 'Gianluca', 'Antonio', 'Luca',
      'Nicolò', 'Tommaso', 'Emanuele',
    ],
    last: [
      'Ferrari', 'Bianchi', 'Conti', 'Greco', 'Marino', 'Gallo', 'Costa',
      'Rizzo', 'Moretti', 'Barbieri', 'Fontana', 'Caruso', 'Ferrara', 'Longo',
      'Martini', 'Serra', 'Vitale', 'Palumbo', 'De Luca', 'Bruno',
    ],
  ),
  'nordic': NamePool(
    first: [
      'Erik', 'Magnus', 'Henrik', 'Anders', 'Mikkel', 'Kasper', 'Emil', 'Oskar',
      'Viktor', 'Jonas', 'Rasmus', 'Sander', 'Aron', 'Elias', 'Mathias',
      'Felix',
    ],
    last: [
      'Berg', 'Johansson', 'Larsen', 'Nilsson', 'Hansen', 'Lindqvist',
      'Andersen', 'Holm', 'Dahl', 'Eriksson', 'Sørensen', 'Lund', 'Bakke',
      'Strand', 'Moen', 'Sandberg', 'Halonen', 'Virtanen', 'Pedersen',
      'Karlsen',
    ],
  ),
  'slavic': NamePool(
    first: [
      'Ivan', 'Marek', 'Tomáš', 'Pavel', 'Dmytro', 'Andriy', 'Jakub', 'Filip',
      'Oleksandr', 'Miroslav', 'Lukasz', 'Kamil', 'Vlad', 'Sergei', 'Bohdan',
      'Patrik',
    ],
    last: [
      'Novák', 'Kovács', 'Petrov', 'Marek', 'Kowalski', 'Horák', 'Volkov',
      'Shevchenko', 'Nowak', 'Pospíšil', 'Bondar', 'Wójcik', 'Sokolov',
      'Kučera', 'Melnyk', 'Zieliński', 'Procházka', 'Lewandowicz', 'Tkachenko',
      'Urban',
    ],
  ),
  'balkan': NamePool(
    first: [
      'Luka', 'Marko', 'Stefan', 'Nikola', 'Ivan', 'Dragan', 'Filip', 'Andrej',
      'Vedad', 'Armin', 'Besart', 'Egzon', 'Dejan', 'Vladan', 'Petar', 'Goran',
    ],
    last: [
      'Petrović', 'Jovanović', 'Marković', 'Horvat', 'Babić', 'Kovačević',
      'Vuković', 'Đurić', 'Tomić', 'Ristić', 'Hodžić', 'Krasniqi', 'Berisha',
      'Stanković', 'Ilić', 'Pavlović', 'Novak', 'Matić', 'Savić', 'Radić',
    ],
  ),
  'greek': NamePool(
    first: [
      'Giorgos', 'Dimitris', 'Nikos', 'Kostas', 'Vasilis', 'Yannis', 'Stelios',
      'Andreas', 'Christos', 'Petros', 'Thanasis', 'Manolis', 'Sotiris',
      'Alexis', 'Panagiotis', 'Lefteris',
    ],
    last: [
      'Papadopoulos', 'Nikolaou', 'Georgiou', 'Vasileiou', 'Pappas',
      'Antoniou', 'Makris', 'Dimitriou', 'Alexiou', 'Christodoulou',
      'Samaras', 'Fotiadis', 'Karagiannis', 'Petrou', 'Stavrou', 'Manolas',
      'Iliadis', 'Vlachos', 'Sideris', 'Roussos',
    ],
  ),
  'turkic': NamePool(
    first: [
      'Emre', 'Burak', 'Kerem', 'Yusuf', 'Arda', 'Cenk', 'Ozan', 'Hakan',
      'Murat', 'Serkan', 'Timur', 'Nuri', 'Bekir', 'Aziz', 'Ruslan',
      'Bakhtiyar',
    ],
    last: [
      'Yılmaz', 'Demir', 'Kaya', 'Şahin', 'Çelik', 'Yıldız', 'Aydın', 'Arslan',
      'Doğan', 'Koç', 'Aslan', 'Polat', 'Erdoğan', 'Korkmaz', 'Türk',
      'Nazarov', 'Aliyev', 'Karimov', 'Bayramov', 'Tursunov',
    ],
  ),
  'arabic': NamePool(
    first: [
      'Mohamed', 'Ahmed', 'Youssef', 'Omar', 'Karim', 'Hassan', 'Tarek',
      'Bilal', 'Khalil', 'Walid', 'Sami', 'Nader', 'Anas', 'Riyad', 'Faisal',
      'Ziyad',
    ],
    last: [
      'Al-Rashid', 'Haddad', 'Mansour', 'Nasser', 'Saleh', 'Khalil', 'Aziz',
      'Hamdan', 'Bouazizi', 'El-Amrani', 'Cherif', 'Ben Ali', 'Trabelsi',
      'Maazi', 'Zidane', 'Belkacem', 'Naceur', 'Rahmani', 'Othmani', 'Sayed',
    ],
  ),
  'westAfrican': NamePool(
    first: [
      'Kwame', 'Kofi', 'Emmanuel', 'Samuel', 'Daniel', 'Ibrahim', 'Mamadou',
      'Sékou', 'Yaw', 'Chinedu', 'Sadio', 'Ousmane', 'Abdoulaye', 'Cheikh',
      'Moussa', 'Babatunde',
    ],
    last: [
      'Mensah', 'Owusu', 'Adjei', 'Okafor', 'Eze', 'Diallo', 'Touré', 'Koné',
      'Cissé', 'Bamba', 'Asante', 'Boateng', 'Obi', 'Nwosu', 'Sangaré',
      'Camara', 'Keita', 'Diop', 'Yeboah', 'Adeyemi',
    ],
  ),
  'bantu': NamePool(
    first: [
      'Thabo', 'Sipho', 'Tendai', 'Blessing', 'Themba', 'Joseph', 'Peter',
      'Brian', 'Innocent', 'Gift', 'Lwandle', 'Kagiso', 'Tinashe', 'Bongani',
      'Mpho', 'Lerato',
    ],
    last: [
      'Ndlovu', 'Mokoena', 'Dlamini', 'Moyo', 'Khumalo', 'Nkomo', 'Mabaso',
      'Banda', 'Phiri', 'Zulu', 'Mthembu', 'Sibanda', 'Chirwa', 'Maluleke',
      'Nyirenda', 'Mwangi', 'Ochieng', 'Kamau', 'Mutua', 'Otieno',
    ],
  ),
  'eastAsian': NamePool(
    first: [
      'Haruto', 'Sota', 'Ren', 'Yuto', 'Min-jun', 'Ji-ho', 'Seung-min', 'Wei',
      'Hao', 'Jun', 'Takumi', 'Riku', 'Do-yun', 'Tae-yang', 'Feng', 'Kenji',
    ],
    last: [
      'Tanaka', 'Sato', 'Suzuki', 'Watanabe', 'Yamamoto', 'Kim', 'Lee', 'Park',
      'Choi', 'Jung', 'Wang', 'Zhang', 'Chen', 'Liu', 'Nakamura', 'Kobayashi',
      'Yoshida', 'Han', 'Yang', 'Huang',
    ],
  ),
  'southeastAsian': NamePool(
    first: [
      'Somchai', 'Anan', 'Chai', 'Tuan', 'Minh', 'Bayu', 'Putra', 'Rizki',
      'Aldo', 'Hafiz', 'Arif', 'Nguyen', 'Thanh', 'Surya', 'Eko', 'Dimas',
    ],
    last: [
      'Saetang', 'Wong', 'Tran', 'Pham', 'Nguyen', 'Wijaya', 'Saputra',
      'Pratama', 'Hidayat', 'Tan', 'Lim', 'Santos', 'Reyes', 'Dela Cruz',
      'Bautista', 'Kaur', 'Rahman', 'Iskandar', 'Chai', 'Pich',
    ],
  ),
  'southAsian': NamePool(
    first: [
      'Arjun', 'Rohan', 'Vikram', 'Sandeep', 'Karan', 'Imran', 'Bilal',
      'Sahil', 'Pranav', 'Dev', 'Aakash', 'Nikhil', 'Farhan', 'Manish',
      'Sunil', 'Rahul',
    ],
    last: [
      'Sharma', 'Singh', 'Patel', 'Kumar', 'Das', 'Khan', 'Reddy', 'Nair',
      'Gurung', 'Thapa', 'Hossain', 'Iqbal', 'Mehta', 'Chowdhury', 'Rana',
      'Pillai', 'Bose', 'Malik', 'Shrestha', 'Banerjee',
    ],
  ),
  'pacific': NamePool(
    first: [
      'Tane', 'Manu', 'Ari', 'Sione', 'Tevita', 'Joeli', 'Ratu', 'Iosefa',
      'Pita', 'Kalani', 'Noa', 'Eroni', 'Viliami', 'Semi', 'Aisea', 'Tama',
    ],
    last: [
      'Tuilagi', 'Vakatawa', 'Nailatikau', 'Tukana', 'Rabuka', 'Faleolo',
      'Latu', 'Tupou', 'Naidu', 'Singh', 'Waqa', 'Bolanavanua', 'Seru',
      'Cama', 'Ravula', 'Tagicakibau', 'Vunisa', 'Lomu', 'Finau', 'Halafihi',
    ],
  ),
};
