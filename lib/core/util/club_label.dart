import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// A club's name as the manager reads it: the career world's name for it in
/// the app's language ([ActiveWorld.clubLabel]) when it gives one, else the
/// stored name, except the no-club value ([ClubService.freeAgent]), which is
/// stored in English and shown in the manager's language. Every screen that
/// prints a club goes through here (the editor too), so a free agent never
/// reads in English inside a Czech career.
String clubName(AppLocalizations l, String club) =>
    club == ClubService.freeAgent
    ? l.editorPlayerFreeAgent
    : ActiveWorld.current.clubLabel(club) ?? club;
