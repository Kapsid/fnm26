import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Finds text by what it READS as, ignoring the zero-width break
/// opportunities [WholeText] inserts between the letters of a long word.
///
/// `find.text` compares the raw string a [Text] was given, so a name long
/// enough to need wrapping would never match it — the letters are separated by
/// invisible characters that are not part of the name.
Finder findName(String text) => find.byWidgetPredicate(
  (w) => w is Text && w.data?.replaceAll(breakOpportunity, '') == text,
  description: 'text reading "$text"',
);
