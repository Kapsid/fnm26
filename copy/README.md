# Editing the game's text

`strings.csv` is every string in the game — in one file.
**Double-click it**: it opens in Numbers or Excel as a ten-column
spreadsheet. Change the words, save, hand it back.

## The loop

```bash
dart run tool/export_copy.dart             # app → copy/strings.csv
#   ... edit the file ...
dart run tool/import_copy.dart --dry-run   # what would change
dart run tool/import_copy.dart             # copy/strings.csv → app
flutter gen-l10n                           # rebuild the typed strings
```

Re-export whenever you like: an unedited round trip changes nothing, so it is
always safe to regenerate the file and start again.

## The columns

| column | what it is |
|---|---|
| `key` | what the code looks up. **Don't touch it.** |
| `where` | a note saying where the string appears. Yours to read, not to edit. |
| `placeholders` | which `{words}` this string must keep. Also just a note. |
| `en` | the English. **Edit freely.** |
| `cs` `fr` `it` `pl` `es` `de` | Czech, French, Italian, Polish, Spanish, German. **Edit freely.** Leave a cell blank to keep what's there. A language whose `lib/l10n/app_<code>.arb` does not exist is skipped on import. |

## The rules

Two, and the importer enforces both — if any row breaks them **nothing at all
is written**, so you can never end up half-translated:

1. **Keep every `{placeholder}`.** `{player} wants a word` may become
   `{player} is asking for a word`, but not `The player is asking for a word` —
   the code passes a name in, and a string with nowhere to put it crashes the
   screen it is on. Renaming one (`{player}` → `{name}`) is the same mistake
   and is caught the same way.

2. **Leave plural machinery alone.** A row flagged `PLURAL` looks like
   `{count, plural, =1{1 point} other{{count} points}}`. Translate the words
   inside the braces; leave `{count, plural,` and the variable
   exactly as they are, and keep an `other` branch. Each language uses its own
   categories (Czech has `few`, Polish has `few` and `many`) and they are
   already there.

If a row is refused the importer names it, says which language, and says what
went wrong. Fix that row and run it again.

## Spreadsheet notes

- Commas inside a sentence are fine — the file is properly quoted, and so is
  anything you type.
- A line break inside a string is written `\n`. Keep it where you want the
  break.
- The file is UTF-8 with a BOM so Excel reads the Czech correctly. **Save it
  back as CSV UTF-8**, not "CSV (Macintosh)" or "CSV (Windows)", or the
  diacritics will come back broken.
- Tab-separated works too, if your spreadsheet insists on it.
- If the importer says the header line is wrong, a spreadsheet has rewritten
  it (`;` instead of `,` is the usual culprit — a European locale). Re-export
  and paste your edits into the fresh file.
