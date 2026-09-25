import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Every word the manager reads about a position, a role, his morale, his
/// federation or a competition, in BOTH languages.
///
/// The report this answers is a list of English left standing in a Czech app:
/// "Buoyant" on the hub badge, the federation's buildings, "European
/// Championship Qualifiers" on the hub, the positions and the roles. Each had
/// the same cause (a label getter in `lib/domain`) and each is now a translator
/// at the display edge — so each translator is checked here against BOTH
/// locales, value by value, with no gaps and no two values sharing a word.
void main() {
  final locales = <String, AppLocalizations>{
    'en': AppLocalizationsEn(),
    'cs': AppLocalizationsCs(),
  };

  void everyValueDistinct<T>(
    String what,
    List<T> values,
    String Function(AppLocalizations, T) label,
  ) {
    for (final entry in locales.entries) {
      final seen = <String, T>{};
      for (final v in values) {
        final text = label(entry.value, v);
        expect(
          text.trim(),
          isNotEmpty,
          reason: '$what $v has no ${entry.key} wording',
        );
        expect(
          seen.containsKey(text),
          isFalse,
          reason:
              '$what $v and ${seen[text]} both read "$text" in ${entry.key}, '
              'so the manager cannot tell them apart',
        );
        seen[text] = v;
      }
    }
  }

  test('every position is written out in both languages', () {
    everyValueDistinct('position', PlayerPosition.values, positionName);
  });

  test('every tactical role, and its blurb, is written in both languages', () {
    everyValueDistinct('role', PlayerRole.values, playerRoleLabel);
    everyValueDistinct('role blurb', PlayerRole.values, playerRoleBlurb);
  });

  test('every federation department and building is written in both', () {
    everyValueDistinct('department', Department.values, departmentLabel);
    everyValueDistinct('department blurb', Department.values, departmentBlurb);
    everyValueDistinct('building', Department.values, departmentBuildingName);
  });

  test('every confederation is written in both languages', () {
    everyValueDistinct(
      'confederation',
      Confederation.values,
      (l, c) => confederationLabel(l, c),
    );
  });

  test('the morale scale is a Czech word at every band', () {
    // The band the manager reported by name is the top one.
    expect(moraleLabel(locales['en']!, 90), 'Buoyant');
    expect(moraleLabel(locales['cs']!, 90), 'Výborná');
    for (final l in locales.values) {
      final words = {
        for (final m in [90, 70, 50, 30, 10]) moraleLabel(l, m),
      };
      expect(
        words,
        hasLength(5),
        reason: 'the five morale bands do not read as five different things',
      );
      for (final w in words) {
        expect(w.trim(), isNotEmpty);
      }
    }
  });

  group('competition names', () {
    test('a continental cup qualifying campaign is translated', () {
      // The stored name is the CUP's name plus " Qualifiers", which the
      // continent-keyed branch could not read — so a Czech manager's hub said
      // "European Championship Qualifiers".
      for (final entry in ContinentalCups.byConfederation.entries) {
        final stored = '${entry.value.name} Qualifiers';
        final cs = competitionLabel(locales['cs']!, stored);
        expect(
          cs,
          isNot(stored),
          reason: '$stored is printed back untranslated in Czech',
        );
        expect(
          cs,
          contains(continentalCupLabel(locales['cs']!, entry.key)),
          reason: '$stored loses the name of the cup it qualifies for',
        );
      }
    });

    test('the two big competitions read as the manager asked', () {
      final cs = locales['cs']!;
      expect(competitionLabel(cs, 'World Championship'), 'Světový šampionát');
      expect(
        competitionLabel(cs, 'Continental Championship'),
        'Kontinentální šampionát',
      );
      expect(
        competitionLabel(cs, 'European Championship'),
        'Evropský šampionát',
      );
    });

    test('the career records say the HIGHEST win, not the best one', () {
      // "Nejlepší výhra" reads as "the nicest win"; a margin is the highest.
      expect(locales['cs']!.careerBestWin, 'Nejvyšší výhra');
    });

    test('a name the table has never heard of survives unchanged', () {
      for (final l in locales.values) {
        expect(competitionLabel(l, 'Some Old Cup'), 'Some Old Cup');
      }
    });
  });

  group('the screens that print a stored competition name', () {
    // The translator is no use to a screen that does not call it, and four
    // screens did not: the hub's group table and its pre-draw placeholder, the
    // round results heading, and the board's objectives (wherever they are
    // shown — the objective providers word them once, for both the hub and the
    // end-of-cycle report). Each printed the canonical English straight out of
    // the save. These pin the CALL, because that is what was missing; the
    // wording itself is checked above.
    const wiring = {
      'lib/features/hub/hub_screen.dart': [
        'competitionLabel(l, group.competition)',
        'competitionLabel(l, competition)',
      ],
      'lib/features/results/round_results_screen.dart': [
        'competitionLabel(l, results.competition)',
      ],
      'lib/features/hub/objective_providers.dart': [
        'competitionLabel(l, name)',
      ],
    };
    for (final entry in wiring.entries) {
      test(entry.key, () {
        final source = File(entry.key).readAsStringSync();
        for (final call in entry.value) {
          expect(
            source,
            contains(call),
            reason:
                '${entry.key} no longer routes a stored competition name '
                'through competitionLabel, so it prints the English the save '
                'holds. If the call moved, move this line with it.',
          );
        }
      });
    }
  });

  test('the live match tab strip and interval copy exist in Czech', () {
    final cs = locales['cs']!;
    for (final s in [
      cs.matchTabTimeline,
      cs.matchTabStats,
      cs.matchTabLineups,
      cs.matchPenalty,
      cs.matchStateLevel,
      cs.matchStateLead(3),
      cs.matchStateTrail(1),
      cs.matchPossessionShare(60),
    ]) {
      expect(s.trim(), isNotEmpty);
    }
    // Czech counts in three: one goal, a few goals, many goals. A plural that
    // lost its branches reads "Vedete o 3 gól".
    expect(cs.matchStateLead(1), isNot(contains('1')));
    expect(cs.matchStateLead(3), isNot(cs.matchStateLead(7)));
    expect(cs.matchStateTrail(3), isNot(cs.matchStateTrail(7)));
  });
}
