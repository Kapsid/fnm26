import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/features/press/press_copy.dart';
import 'package:fnm/l10n/app_localizations.dart';

void main() {
  for (final locale in const [Locale('en'), Locale('cs')]) {
    test(
      '${locale.languageCode}: every answer has words, none of them empty',
      () async {
        final l = await AppLocalizations.delegate.load(locale);
        for (final a in AnswerKind.values) {
          for (var seed = 0; seed < 8; seed++) {
            final text = answerLabel(l, a, playerName: 'Novák', seed: seed);
            expect(text.trim(), isNotEmpty, reason: a.name);
            expect(text.contains('—'), isFalse, reason: 'em dash in ${a.name}');
          }
        }
      },
    );
  }

  test('only crisis and job-verdict questions talk about his job', () async {
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    final job = RegExp(
      'resign|sack|your job|your future|step down',
      caseSensitive: false,
    );
    // Walk every beat kind for every reason via press_copy's helper that lists
    // all question variants: expose `allQuestionVariants(l)` returning
    // (ConferenceReason?, BeatKind, String) triples for this test.
    final variants = allQuestionVariants(l);
    // 24 moments, 30 reaction and player questions, 24 throwbacks.
    expect(variants, hasLength(78));
    for (final (reason, kind, text) in variants) {
      final allowed =
          kind == BeatKind.moment &&
          (reason == ConferenceReason.crisis ||
              reason == ConferenceReason.jobVerdict);
      if (!allowed) {
        expect(job.hasMatch(text), isFalse, reason: '$reason $kind: $text');
      }
    }
  });
}
