import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The one joke the app tells in one language only.
///
/// "Csaplárova past" — Csaplár's trap — is a Czech football in-joke: a side two
/// goals down at half time is exactly where it wants to be. It is the easter
/// egg on the two afternoons a half-time score turns over, and it is CZECH
/// ONLY, on purpose. An English reader has never heard of it, so a translated
/// in-joke would be a confusing sentence rather than a joke, and the English
/// wordings for those events are ordinary press-room and supporter English
/// about the same match.
///
/// That makes it the one place in the app where the two languages deliberately
/// say different things, which is exactly the shape a well-meaning later sweep
/// would "fix": either by translating the Czech back into English, or by
/// pushing the joke into the English copy where it means nothing. This test is
/// what stops both.
void main() {
  Map<String, Object?> arb(String locale) =>
      jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
          as Map<String, Object?>;

  /// The copy itself, without the `@key` metadata blocks. The DESCRIPTIONS are
  /// deliberately allowed to name the joke and explain it in English — that is
  /// a note to whoever edits the copy next, and no player ever reads one.
  Map<String, String> copy(String locale) => {
    for (final e in arb(locale).entries)
      if (!e.key.startsWith('@') && e.value is String)
        e.key: e.value! as String,
  };

  /// Every key whose Czech carries the joke: the two Y templates, six wordings
  /// apiece, and the two press questions, four apiece.
  const joke = [
    'yTurnedItRound0',
    'yTurnedItRound1',
    'yTurnedItRound2',
    'yTurnedItRound3',
    'yTurnedItRound4',
    'yTurnedItRound5',
    'yThrewItAway0',
    'yThrewItAway1',
    'yThrewItAway2',
    'yThrewItAway3',
    'yThrewItAway4',
    'yThrewItAway5',
    'pressAskComeback1',
    'pressAskComeback2',
    'pressAskComeback3',
    'pressAskComeback4',
    'pressAskCollapse1',
    'pressAskCollapse2',
    'pressAskCollapse3',
    'pressAskCollapse4',
  ];

  test('the Czech tells the joke, in every wording of it', () {
    final cs = copy('cs');
    for (final key in joke) {
      expect(cs[key], isNotNull, reason: '$key has no Czech at all');
      expect(
        cs[key],
        contains('Csaplár'),
        reason:
            '$key is the Czech easter egg and has lost the joke: a manager '
            'playing in Czech gets a flat sentence where the point was',
      );
    }
  });

  test('no English string anywhere in the app carries it', () {
    final offenders = [
      for (final e in copy('en').entries)
        if (e.value.contains('Csapl')) '${e.key}: "${e.value}"',
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'an English reader has no idea what Csaplár\'s trap is, so this '
          'reads as a confusing sentence rather than a joke:\n  '
          '${offenders.join('\n  ')}',
    );
  });

  test('the English still says something about the same afternoon', () {
    final en = copy('en');
    for (final key in joke) {
      expect(
        en[key]?.trim(),
        isNotEmpty,
        reason:
            '$key has no English: the joke being Czech-only does not mean the '
            'event goes unreported in English',
      );
    }
  });

  test('and the two languages are not the same sentence', () {
    final en = copy('en');
    final cs = copy('cs');
    for (final key in joke) {
      expect(
        cs[key],
        isNot(en[key]),
        reason: '$key is untranslated: a Czech save would show the English',
      );
    }
  });
}
