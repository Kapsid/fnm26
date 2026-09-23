import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The year's academy intake, as report rows.
///
/// Only the boys who have just arrived — [PlayerLifecycle.intakeAge] — out of a
/// pyramid that holds every age from eleven to twenty.
///
/// The rating is context; the STARS are the message. An eleven-year-old's
/// overall says almost nothing about what he becomes, and the read here is the
/// deliberately vague sub-17 one: two stars wide either way, and never settled
/// until he has actually played. What the manager is being told is what the
/// coaches think — which is the only thing anybody could honestly tell him.
List<SquadDevRow> intakeRows(List<Player> pyramid) => [
  for (final p in pyramid)
    if (p.age == PlayerLifecycle.intakeAge)
      SquadDevRow(
        name: p.name,
        age: p.age,
        position: p.position.label,
        rating: p.overall,
        status: SquadDevStatus.arrived,
        stars: Prospects.scoutedStars(p.id, age: p.age),
        // From his real ceiling, not from the stars beside it: the stars are
        // what the coaches think, and at eleven what they think is two stars
        // wide. The badge is the game telling the truth, which it can only
        // afford to do because it is rare.
        wonderkid: Prospects.trueStars(p.id, age: p.age) >= 5,
      ),
];

/// The line above the table, or null when there is nothing to say.
///
/// Only a POSITIVE shift is reported, and the note names WHICH of the two
/// causes did it. A nation sliding down the rankings draws a negative talent
/// shift into its intake, and announcing that as though the academy had paid
/// off would be a lie in the manager's own inbox.
///
/// [academyBonus] is the federation's money plus the manager's own eye;
/// [standingBonus] is what the senior side earned by climbing the world
/// ranking and winning things. Half of what this batch is about is mechanics
/// the manager could not see working, so when the standing is what brought a
/// better crop through, the note says so.
String? intakeNote(
  AppLocalizations l, {
  required double academyBonus,
  required double standingBonus,
}) {
  final academy = academyBonus > 0;
  final standing = standingBonus > 0;
  if (academy && standing) return l.msgIntakeNoteBoth;
  if (standing) return l.msgIntakeNoteStanding;
  if (academy) return l.msgIntakeNoteAcademy;
  return null;
}
