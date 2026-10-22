import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/caps.dart';

void main() {
  group('capsFor', () {
    test('is plain toUpperCase for the languages without special rules', () {
      for (final code in [
        'en',
        'cs',
        'fr',
        'it',
        'pl',
        'es',
        'de',
        'pt',
        'nl',
        'id',
      ]) {
        expect(
          capsFor('říjen kick-off ü', code),
          'říjen kick-off ü'.toUpperCase(),
          reason: code,
        );
      }
      expect(capsFor('čvn', 'cs'), 'ČVN');
    });

    test('Turkish and Azerbaijani raise the dotted and dotless i apart', () {
      expect(capsFor('istanbul', 'tr'), 'İSTANBUL');
      expect(capsFor('ılık', 'tr'), 'ILIK');
      expect(capsFor('Diyarbakır şimdi', 'tr'), 'DİYARBAKIR ŞİMDİ');
      expect(capsFor('ilk', 'az'), 'İLK');
      // A capital I already in the word is the dotless one and stays put.
      expect(capsFor('Işık', 'tr'), 'IŞIK');
      // Everyone else keeps the ordinary mapping.
      expect(capsFor('istanbul', 'en'), 'ISTANBUL');
    });

    test('Greek capitals drop the tonos', () {
      expect(capsFor('Ελληνικά', 'el'), 'ΕΛΛΗΝΙΚΑ');
      expect(capsFor('Τετάρτη', 'el'), 'ΤΕΤΑΡΤΗ');
      expect(capsFor('άέήίόύώ', 'el'), 'ΑΕΗΙΟΥΩ');
      expect(capsFor('Άέ', 'el'), 'ΑΕ');
      // Dialytika with tonos keeps the dialytika.
      expect(capsFor('ΐ ΰ', 'el'), 'Ϊ Ϋ');
      // Final sigma raises to the ordinary capital.
      expect(capsFor('αγώνας', 'el'), 'ΑΓΩΝΑΣ');
      // Latin inside a Greek string is raised the ordinary way.
      expect(capsFor('Ελλάδα vs Brazil (idé)', 'el'), 'ΕΛΛΑΔΑ VS BRAZIL (IDÉ)');
    });
  });
}
