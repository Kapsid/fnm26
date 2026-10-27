/// Full names of real Finland internationals, past and present, that a
/// golden generation member must never be given.
///
/// The game's Finnish name pools are real Finnish first names and surnames, so
/// a pairing drawn from them can land on a real footballer's full name. For
/// the ordinary pool that is a coincidence among hundreds of players; for the
/// Young Finns cohort, a fixed squad every manager meets, it would read as
/// the campaign naming a real player, which the game never does. The namer
/// skips any name on this list (see `DriftPlayerRepository`).
///
/// Not exhaustive and not meant to be: it covers the best-known men of the
/// national side across the decades, which is where a match would be noticed.
const Set<String> realFinlandInternationals = {
  // Not a footballer, but famous enough in Finland to read as a real name.
  'Olli Jokinen',
  'Jari Litmanen',
  'Sami Hyypiä',
  'Teemu Pukki',
  'Lukas Hradecky',
  'Glen Kamara',
  'Joel Pohjanpalo',
  'Robin Lod',
  'Jere Uronen',
  'Joona Toivio',
  'Paulus Arajuuri',
  'Tim Sparv',
  'Jukka Raitala',
  'Pyry Soiri',
  'Fredrik Jensen',
  'Rasmus Schüller',
  'Leo Väisänen',
  'Robert Ivanov',
  'Marcus Forss',
  'Benjamin Källman',
  'Onni Valakari',
  'Juhani Ojala',
  'Niko Hämäläinen',
  'Anssi Jaakkola',
  'Jesse Joronen',
  'Viljami Sinisalo',
  'Ilmari Niskanen',
  'Matti Peltola',
  'Oliver Antman',
  'Topi Keskinen',
  'Adam Ståhl',
  'Kaan Kairinen',
  'Daniel Håkans',
  'Mikael Forssell',
  'Jonatan Johansson',
  'Antti Niemi',
  'Jussi Jääskeläinen',
  'Shefki Kuqi',
  'Joonas Kolkka',
  'Mika Väyrynen',
  'Aki Riihilahti',
  'Petri Pasanen',
  'Hannu Tihinen',
  'Toni Kuivasto',
  'Teemu Tainio',
  'Alexei Eremenko',
  'Roman Eremenko',
  'Perparim Hetemaj',
  'Mehmet Hetemaj',
  'Kasper Hämäläinen',
  'Riku Riski',
  'Roope Riski',
  'Niklas Moisander',
  'Markus Halsti',
  'Thomas Lam',
  'Jani Lyyski',
  'Berat Sadik',
  'Tim Väyrynen',
  'Joni Kauko',
  'Lassi Lappalainen',
  'Sauli Väisänen',
  'Jaakko Oksanen',
  'Arttu Hoskonen',
  'Miro Tenho',
  'Nikolai Alho',
  'Mikko Sumusalo',
  'Petteri Forsell',
  'Pekka Lagerblom',
  'Jari Ilola',
  'Mika Nurmela',
  'Antti Pohja',
  'Ari Hjelm',
  'Mixu Paatelainen',
  'Jari Mäkelä',
  'Janne Saarinen',
  'Jarkko Wiss',
  'Simo Valakari',
  'Sami Mahlio',
  'Juha Reini',
  'Daniel Sjölund',
  'Përparim Hetemaj',
  'Peter Enckelman',
  'Otto-Pekka Jurvainen',
};

/// Full names of real Greenland internationals and famous Greenlanders that
/// no Greenland player may be given.
///
/// Greenland's name pools are real Greenlandic and Danish first names and
/// surnames, so a pairing can land on a real person's full name, and with a
/// nation this small any such match would be noticed. The namer steps over
/// every name on this list for Greenland (see `DriftPlayerRepository`).
///
/// From the men's national side as listed on Wikipedia (squads, recent
/// call-ups, notable players, coaches), Jesper Grønkjær (born in Nuuk), and
/// well-known Greenlandic public figures the pools could produce. Spelling
/// variants (with and without the middle name, æ/ae) are listed separately.
const Set<String> realGreenlandInternationals = {
  'Adam Ejler Hansen',
  'Adam Hansen',
  'Akkajuk Mathaeussen',
  'Akkajuk Mathæussen',
  'Anda Kuitse',
  'Anders H. Petersen',
  'Anders Petersen',
  'Angaangaq Angakkorsuaq',
  'Angutivik Gundel-Collin',
  'Aputsiaq Birch',
  'Aqqalu Jerimiassen',
  'Aqqaluaq B. Egede',
  'Aqqaluaq Biilmann Egede',
  'Aqqaluaq Egede',
  'Aqqaluk Lynge',
  'Ari Hermann',
  'Ari Jean Hermann',
  'Augo Lynge',
  'Bastian Rosing',
  'Brian Kleist',
  'Brian Rosing Kleist',
  'Elisaeus Kreutzmann',
  'Gustav Hammond Krogh',
  'Hans Enoksen',
  'Hans Frederik Olsen',
  'Hans Lynge',
  'Hans Olsen',
  'Inuuteq Storch',
  'Isak Kleist',
  'Isak Nielsen Kleist',
  'Jan Nielsen',
  'Jens Egede',
  'Jens Frederik Nielsen',
  'Jens Immanuelsen',
  'Jens Jorgen Egede',
  'Jens Jørgen Egede',
  'Jens Napaattooq',
  'Jens Tang Olesen',
  'Jens-Frederik Nielsen',
  'Jesper Grønkjær',
  'John Rasmus Eldevig',
  'John-Ludvig Broberg',
  'Jonathan Motzfeldt',
  'Jonathan Petersen',
  'Jonathan Rosing',
  'Juaaka Lyberth',
  'Jørgen Brønlund',
  'Jørgen Kreutzmann',
  'Jørgen Rosbach',
  'Kaali Lund Mathæussen',
  'Kaali Mathaeussen',
  'Kaali Mathæussen',
  'Kaarale Andreassen',
  'Kaassannguaq Zeeb',
  'Kalistat Lund',
  'Karl Ingemann',
  'Kassaaaluk Kristensen',
  'Kassaaluk Kristensen',
  'Kenneth Kleist',
  'Kim Kielsen',
  'Knud Rasmussen',
  'Kristian Lyberth',
  'Kuupik Kleist',
  'Kârale Andreassen',
  'Lars Emil Johansen',
  'Lars Lundblad',
  'Lars Olsvig',
  'Lars-Emil Johansen',
  'Leifeeraq Karlsen',
  'Maasi Maqe',
  'Malik Jensen',
  'Mathias Storch',
  'Michael Nohr',
  'Miilu Jensen',
  'Mikkel Kvist Willumsen',
  'Mininnguaq Kleist',
  'Morten Hamm',
  'Morten Rutkjær',
  'Moses Olsen',
  'Mute B. Egede',
  'Mute Bourup Egede',
  'Mute Egede',
  'Múte B. Egede',
  'Múte Bourup Egede',
  'Múte Egede',
  'Nemo Thomsen',
  'Nick Reimer',
  'Niels Erik Eriksen',
  'Niels Eriksen',
  'Niels Møller',
  'Niklas Johansen',
  'Niklas Kreutzmann',
  'Niklas Thorleifsen',
  'Noah Molgaard',
  'Noah Mølgaard',
  'Norsaq Lund Mathæussen',
  'Norsaq Mathaeussen',
  'Norsaq Mathæussen',
  'Nukannguaq Zeeb',
  'Nukappiaaluk Hansen',
  'Patrick Frederiksen',
  'Pavia Mølgaard',
  'Pele Broberg',
  'Per Bech Thomsen',
  'Peri Fleischer',
  'Peter Berthelsen',
  'Poul Krarup',
  'Qulutannguaq Tittussen',
  'Rene Eriksen Petersen',
  'René Eriksen Petersen',
  'René Olsen',
  'Robert Peary',
  'Sepp Piontek',
  'Simon Simonsen',
  'Siverth Heilmann',
  'Siverth K. Heilmann',
  'Steen Cortsen',
  'Søren Kreutzmann',
  'Tekle Ghebrelul',
  'Thomas Høegh',
  'Thue Christiansen',
  'Tue Lund',
  'Tue Zethsen Lund',
  'Tønnes Berthelsen',
  'Ulf Abrahamsen',
  'Uusaqqak Qujaukitsoq',
  'Uvdlo Jakobsen',
  'Vittus Qujaukitsoq',
  'Vitus Kofoed',
  'Vitus Qujaukitsoq',
};

/// Famous Greenlanders that only a career on the full pools (see
/// `namePoolsV3Kind`) is kept from producing.
///
/// The older pools can already give these names, so guarding them in every
/// career would move the names of players in a career that already had
/// Greenland. A career on the full pools has no names to lose, so the namer
/// steps over these there as well as over [realGreenlandInternationals].
const Set<String> realGreenlandFullPoolNames = {
  'Erik Jensen',
  'Hans Egede',
  'Henrik Lund',
  'Minik Rosing',
  'Rasmus Lyberth',
  'Simon Lynge',
};

/// Real Greenlanders whose names only the current pools (see
/// `namePoolsV4Kind`) can produce: they pair a pool first name with one of
/// the Greenlandic surnames those pools added. Pele Maratse is the mayor of
/// Tiilerilaaq; Karl Pivat stood for the 1971 provincial council. Guarded
/// only there, as no older career can be given them anyway.
const Set<String> realGreenlandPoolsV4Names = {
  'Karl Pivat',
  'Pele Maratse',
};

/// The real-name guard per nation, applied by the namer only to dormant
/// nations (see `DormantNations`): widening it to an ordinary nation would
/// rename players in that nation's existing saves.
const Map<int, Set<String>> guardedNamesByNation = {
  212: realGreenlandInternationals,
};

/// The extra real-name guard per nation for careers on the full pools (see
/// [realGreenlandFullPoolNames]).
const Map<int, Set<String>> guardedNamesFullPoolsByNation = {
  212: realGreenlandFullPoolNames,
};

/// The extra real-name guard per nation for careers on the current pools
/// (see [realGreenlandPoolsV4Names]).
const Map<int, Set<String>> guardedNamesPoolsV4ByNation = {
  212: realGreenlandPoolsV4Names,
};
