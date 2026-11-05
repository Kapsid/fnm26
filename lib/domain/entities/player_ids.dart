/// The id spaces of stored players, as plain domain constants.
library;

/// The first id the seed gives a generated fringe player. Every stored id
/// below it is a core player; every stored id from it up to [kFringeIdLimit]
/// is fringe padding (`PoolGenerator` gives 80 a nation, from here).
const int kFirstFringeId = 10000000;

/// The end (exclusive) of the space fringe ids may take. The seed's
/// nations sit just above [kFirstFringeId]; the dormant nations a later
/// update wakes (Belarus, Zanzibar, Greenland) took theirs from 20 006 000.
/// Room for every nation to come; nothing else is ever stored between it
/// and the ids a world pack makes.
const int kFringeIdLimit = 100000000;
