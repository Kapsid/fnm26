import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing a nation's name in the case the sentence around it needs.
///
/// [Nation.name] is already the manager's own language, but it is the
/// NOMINATIVE — the form a table, a scoreboard or a list wants, and the form
/// a Czech sentence almost never wants once a preposition is in front of it.
/// Czech declines, so "Hrát proti Litva" is not Czech; it is the nominative
/// wearing a preposition. The forms live beside the names in [NationNames]
/// and are chosen here, at the display edge, where the locale is known.

/// The nation that goes after "proti": the dative in Czech, the plain name in
/// every language that has no cases.
///
/// [unknown] is what to print when the nation is not in the map at all, which
/// is the caller's own "unknown opponent" copy.
String nationAgainst(AppLocalizations l, Nation? nation, String unknown) =>
    nation == null
    ? unknown
    : NationNames.displayDative(nation.code, nation.name, l.localeName);
