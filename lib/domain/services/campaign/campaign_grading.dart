/// How a campaign's goal turns into stars. Pure: the progress provider reads
/// the tables and runs, these decide what they are worth.
library;

/// Stars for a finish [ordinal] (0 not qualified, 2 group … 7 champions): one
/// per threshold met, so `[2, 3, 4]` gives 1 for qualifying, 2 for the last
/// 16 and 3 for a quarter-final or better; `[2, 3, 7]` makes the third star
/// the title.
int starsForFinish(int ordinal, List<int> thresholds) =>
    thresholds.where((t) => ordinal >= t).length.clamp(0, 3);

/// Stars for a rivalry. Finishing above the rival is the goal itself and the
/// first star; qualifying for the finals adds the second; winning both
/// meetings adds the third, but only on top of qualifying, so beating the
/// rival twice cannot stand in for the tournament.
int grudgeStars({
  required bool aboveRival,
  required bool qualified,
  required bool wonBoth,
}) => aboveRival ? 1 + (qualified ? 1 : 0) + (qualified && wonBoth ? 1 : 0) : 0;

/// Stars for beating a set of rivals, then going far in the continental
/// finals. Beating every rival is the goal and the first star; qualifying for
/// the finals (any cycle, [bestOrdinal] is the best finish across them) adds
/// the second, and a quarter-final or better the third. Neither tournament
/// star counts without the rivals beaten.
int beatRivalsStars({required bool beatAll, required int bestOrdinal}) =>
    beatAll ? 1 + (bestOrdinal >= 2 ? 1 : 0) + (bestOrdinal >= 4 ? 1 : 0) : 0;

/// Stars for a golden generation's three tiers, each judged across all the
/// campaign's cycles: a World Championship finals place is one, a continental
/// title two, the world title three. The highest tier reached counts on its
/// own, so a continental title without a World Championship place is still
/// two (the owner listed the tiers as separate goals, and the world title
/// already implies the place).
int worldThenTitlesStars({
  required bool qualifiedWorld,
  required bool wonContinental,
  required bool wonWorld,
}) => wonWorld
    ? 3
    : wonContinental
    ? 2
    : qualifiedWorld
    ? 1
    : 0;

/// Stars for a run from the bottom to the top table, each tier judged
/// across all the campaign's cycles: a continental championship place is
/// one, a World Championship place two, winning either three. The highest
/// tier reached counts on its own (as in [worldThenTitlesStars]).
int qualifyBothThenTitleStars({
  required bool qualifiedContinental,
  required bool qualifiedWorld,
  required bool wonTitle,
}) => wonTitle
    ? 3
    : qualifiedWorld
    ? 2
    : qualifiedContinental
    ? 1
    : 0;

/// Stars for a treble of titles in one cycle, each star needing every title
/// before it (the owner's ladder): the continental championship is one; that
/// and the World Championship two; both and the Nations Cup three. A world
/// title without the continental one earns nothing, and the Nations Cup only
/// counts on top of both.
int titleTrebleStars({
  required bool wonContinental,
  required bool wonWorld,
  required bool wonNationsCup,
}) => !wonContinental
    ? 0
    : !wonWorld
    ? 1
    : wonNationsCup
    ? 3
    : 2;
