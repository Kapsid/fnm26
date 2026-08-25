// The shared format for the hand-editable copy file — see `copy/README.md`.
//
// CSV, quoted per RFC 4180, because the file exists to be opened in a
// spreadsheet: Numbers and Excel both open a .csv by double-click and both
// make a .tsv into a chore. A field is quoted only when it needs to be, so a
// one-string change is still a one-line diff in git.
//
// Reading accepts a TAB-separated file too, decided per line from the header.
// A spreadsheet that insists on exporting tabs is a thing that happens, and
// refusing the file over a delimiter would be a refusal about nothing.

/// The columns, in order.
const List<String> kColumns = ['key', 'where', 'placeholders', 'en', 'cs'];

/// A real line break inside a value is written as these two characters. The
/// format is line-based — a field holding an actual newline would be read as
/// the start of a new row — and an escape a translator can SEE is one they can
/// put back where they want it.
const String kNewlineEscape = r'\n';

/// Writes one row. Quotes a field only when the field needs it.
String encodeRow(List<String> fields, {String delimiter = ','}) =>
    fields.map((f) => _encodeField(f, delimiter)).join(delimiter);

String _encodeField(String value, String delimiter) {
  final flat = value.replaceAll('\r\n', '\n').replaceAll('\n', kNewlineEscape);
  final needsQuotes =
      flat.contains(delimiter) || flat.contains('"') || flat.contains('\t');
  if (!needsQuotes) return flat;
  return '"${flat.replaceAll('"', '""')}"';
}

/// Which delimiter [headerLine] uses, or null when it is neither — which means
/// the file is not one of ours and should be refused rather than guessed at.
String? delimiterOf(String headerLine) {
  for (final d in [',', '\t']) {
    final parsed = decodeRow(headerLine, d);
    if (parsed.length == kColumns.length &&
        List.generate(kColumns.length, (i) => parsed[i].trim()).join(',') ==
            kColumns.join(',')) {
      return d;
    }
  }
  return null;
}

/// Splits one line into its fields, honouring quotes.
///
/// Written out rather than pulled in as a package: the whole grammar is three
/// rules (a quote opens a field, two quotes inside one mean a literal quote, a
/// delimiter outside quotes ends a field), and a dependency for that would be
/// one more thing between an edited spreadsheet and the game.
List<String> decodeRow(String line, String delimiter) {
  final out = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var i = 0;
  while (i < line.length) {
    final ch = line[i];
    if (inQuotes) {
      if (ch == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          field.write('"');
          i += 2;
          continue;
        }
        inQuotes = false;
        i++;
        continue;
      }
      field.write(ch);
      i++;
      continue;
    }
    if (ch == '"' && field.isEmpty) {
      inQuotes = true;
      i++;
      continue;
    }
    if (line.startsWith(delimiter, i)) {
      out.add(field.toString());
      field.clear();
      i += delimiter.length;
      continue;
    }
    field.write(ch);
    i++;
  }
  out.add(field.toString());
  return out;
}

/// Turns the written form of a value back into the real one.
String unescapeValue(String value) => value.replaceAll(kNewlineEscape, '\n');
