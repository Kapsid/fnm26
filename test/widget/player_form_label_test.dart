import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/tactics/player_form_look.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The call-up row shows form as an icon only, so every form needs a word of
/// its own in every language: two forms sharing a label would make the icon
/// unexplainable again.
void main() {
  for (final code in const ['en', 'cs', 'fr', 'it', 'pl', 'es', 'de']) {
    test('$code: every form has its own label and its own icon', () async {
      final l = await AppLocalizations.delegate.load(Locale(code));
      final labels = [for (final f in PlayerForm.values) formLabel(l, f)];
      expect(labels.toSet(), hasLength(PlayerForm.values.length));
      expect(labels.every((s) => s.trim().isNotEmpty), isTrue);
      final icons = {for (final f in PlayerForm.values) formLook(f).icon};
      expect(icons, hasLength(PlayerForm.values.length));
    });
  }
}
