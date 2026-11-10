import 'package:fnm/domain/services/profanity/profanity_words.dart';

/// Whether a name is fit to show, in every language the game speaks: slurs,
/// sexual words and strong swearing are refused ([profanityWords]), real
/// names that merely hold such a stem are not ([profanityAllowlist]).
///
/// Pure and deterministic: the editor asks it as a name is typed, the pack
/// checks ask it of an imported database, and the career masks what it
/// refuses ([mask]) when it reads a world, so the same answer comes back
/// everywhere.
///
/// A name is read word by word. Before a word is compared it is folded:
/// lower case, accents dropped (an `=` entry keeps them), leetspeak read as
/// letters (`0 1 3 4 5 7 @ $ ! |`), and a run of one letter matches that
/// letter once or more ("fuuuck"). Single letters spaced or dotted apart
/// ("f.u.c.k", "b i t c h") are read as one word.
abstract final class ProfanityFilter {
  /// Whether [text] holds nothing refused.
  static bool isClean(String text) {
    if (_clean[text] case final known?) return known;
    // Bounded: a pack of tens of thousands of names is checked on every
    // edit, and almost all of them are the same names as the last time.
    if (_clean.length >= _cacheMax) _clean.clear();
    return _clean[text] = _spans(text).isEmpty;
  }

  static final Map<String, bool> _clean = {};
  static const int _cacheMax = 200000;

  /// Whether [text] holds a refused word.
  static bool isOffensive(String text) => !isClean(text);

  /// [text] with every refused word masked: its first letter kept (and what
  /// stands before it, the `@` of a handle), every other letter or digit of
  /// it an asterisk ("Fuck United" reads "F*** United", "@cunt" "@c***").
  /// [text] itself when it is clean.
  static String mask(String text) {
    if (isClean(text)) return text;
    final spans = _spans(text);
    if (spans.isEmpty) return text;
    final out = StringBuffer();
    var at = 0;
    for (final (start, end) in spans) {
      out.write(text.substring(at, start));
      var kept = false;
      for (final r in text.substring(start, end).runes) {
        final ch = String.fromCharCode(r);
        if (!kept) {
          out.write(ch);
          kept = _letter.hasMatch(ch);
        } else {
          out.write(_maskable.hasMatch(ch) ? '*' : ch);
        }
      }
      at = end;
    }
    out.write(text.substring(at));
    return out.toString();
  }

  /// [text] masked ([mask]) when it is a string, as it is otherwise.
  static String? maskOrNull(String? text) => text == null ? null : mask(text);

  static final _maskable = RegExp(r'[\p{L}\p{N}@$!|]', unicode: true);

  /// The start and end (UTF-16 offsets into [text]) of each refused word,
  /// in order.
  static List<(int, int)> _spans(String text) {
    if (text.isEmpty) return const [];
    final words = _words(text);
    final out = <(int, int)>[];
    for (final w in words) {
      // A refused letter inside a refused joined word: the joined one
      // covers it.
      if (out.isNotEmpty && w.start < out.last.$2) {
        if (w.end > out.last.$2 && _refused(w)) {
          out[out.length - 1] = (out.last.$1, w.end);
        }
        continue;
      }
      if (_refused(w)) out.add((w.start, w.end));
    }
    return out;
  }

  static final Set<String> _allowed = {
    for (final a in profanityAllowlist)
      if (!a.endsWith('*')) a,
  };
  static final List<String> _allowedStems = [
    for (final a in profanityAllowlist)
      if (a.endsWith('*')) a.substring(0, a.length - 1),
  ];

  static bool _refused(_Word w) {
    final plain = w.folded('i');
    if (_allowed.contains(plain)) return false;
    for (final a in _allowedStems) {
      if (plain.startsWith(a)) return false;
    }
    final variants = w.hasAmbiguous ? const ['i', 'l'] : const ['i'];
    for (final v in variants) {
      if (_rules.folded.matches(w.folded(v))) return true;
      if (_rules.accented.matches(w.accented(v))) return true;
    }
    return false;
  }

  // --- Reading a name into words -----------------------------------------

  /// What stands for a letter in leetspeak; `!` and `|` stand for i or l
  /// ([_Word.hasAmbiguous]) and `1` for either too.
  static const Map<String, String> _leet = {
    '0': 'o',
    '3': 'e',
    '4': 'a',
    '5': 's',
    '7': 't',
    '@': 'a',
    r'$': 's',
  };
  static const Set<String> _ambiguous = {'1', '!', '|'};

  static final _letter = RegExp(r'\p{L}', unicode: true);
  static final _mark = RegExp(r'\p{M}', unicode: true);
  static final _gap = RegExp(r'^[\s.\-_*,/\\+~·]{1,3}$');

  static List<_Word> _words(String text) {
    // Every character, folded, with where it stands in [text].
    final units = <_Unit>[];
    var i = 0;
    for (final r in text.runes) {
      final ch = String.fromCharCode(r);
      final start = i;
      i += ch.length;
      final ascii = r < 0x80;
      final asciiLetter =
          ascii && ((r >= 0x41 && r <= 0x5A) || (r >= 0x61 && r <= 0x7A));
      if (!ascii && _mark.hasMatch(ch)) {
        // A combining accent belongs to the letter before it.
        if (units.isNotEmpty && units.last.end == start) {
          final u = units.last;
          units[units.length - 1] = _Unit(
            u.folded,
            u.accented + ch,
            u.start,
            i,
            u.kind,
          );
        }
        continue;
      }
      if (asciiLetter || (!ascii && _letter.hasMatch(ch))) {
        final lower = asciiLetter
            ? String.fromCharCode(r | 0x20)
            : ch.toLowerCase();
        units.add(
          _Unit(
            asciiLetter ? lower : fold(lower),
            lower,
            start,
            i,
            _Kind.letter,
          ),
        );
      } else if (_leet[ch] case final l?) {
        units.add(_Unit(l, l, start, i, _Kind.leet));
      } else if (_ambiguous.contains(ch)) {
        units.add(_Unit('', '', start, i, _Kind.ambiguous));
      }
    }

    // Runs of letters (and leetspeak touching them) as words.
    final runs = <List<_Unit>>[];
    List<_Unit>? run;
    for (final u in units) {
      if (run != null && run.last.end == u.start) {
        run.add(u);
      } else {
        runs.add(run = [u]);
      }
    }
    final words = <_Word>[];
    for (final r in runs) {
      // A trailing "!" or "|" ends a word ("Hello!"); one inside is a letter.
      var end = r.length;
      while (end > 0 && r[end - 1].kind == _Kind.ambiguous) {
        end--;
      }
      final units = r.sublist(0, end);
      if (!units.any((u) => u.kind == _Kind.letter)) continue;
      words.add(_Word(units));
    }

    // Single letters spaced or dotted apart, read as one word as well.
    final out = <_Word>[...words];
    var k = 0;
    while (k < words.length) {
      if (words[k].units.length != 1) {
        k++;
        continue;
      }
      var j = k;
      while (j + 1 < words.length &&
          words[j + 1].units.length == 1 &&
          _gap.hasMatch(text.substring(words[j].end, words[j + 1].start))) {
        j++;
      }
      if (j > k) {
        out.add(_Word([for (var m = k; m <= j; m++) ...words[m].units]));
      }
      k = j + 1;
    }
    // A joined word is checked in its own right; the single letters it
    // holds never match an entry, so no two refused words overlap.
    out.sort((a, b) => a.start.compareTo(b.start));
    return out;
  }

  // --- Folding ------------------------------------------------------------

  /// [lower] (one lower-case character) without its accent; a character
  /// with none comes back as it is.
  static String foldChar(String lower) => _fold[lower] ?? lower;

  /// [s] folded as the filter compares it: lower case, accents dropped.
  static String fold(String s) {
    final out = StringBuffer();
    for (final r in s.toLowerCase().runes) {
      final ch = String.fromCharCode(r);
      if (_mark.hasMatch(ch)) continue;
      out.write(foldChar(ch));
    }
    return out.toString();
  }

  static const Map<String, String> _fold = {
    // Latin.
    'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a', 'ā': 'a',
    'ă': 'a', 'ą': 'a', 'ǎ': 'a', 'ạ': 'a', 'ả': 'a', 'ấ': 'a', 'ầ': 'a',
    'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a', 'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a',
    'ặ': 'a', 'æ': 'ae', 'ç': 'c', 'č': 'c', 'ć': 'c', 'ĉ': 'c', 'ċ': 'c',
    'ď': 'd', 'đ': 'd', 'ð': 'd', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'ě': 'e', 'ē': 'e', 'ę': 'e', 'ė': 'e', 'ĕ': 'e', 'ẹ': 'e', 'ẻ': 'e',
    'ẽ': 'e', 'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e', 'ğ': 'g',
    'ĝ': 'g', 'ġ': 'g', 'ģ': 'g', 'ĥ': 'h', 'ħ': 'h', 'í': 'i', 'ì': 'i',
    'î': 'i', 'ï': 'i', 'ı': 'i', 'ī': 'i', 'ĩ': 'i', 'į': 'i', 'ǐ': 'i',
    'ỉ': 'i', 'ị': 'i', 'ĵ': 'j', 'ķ': 'k', 'ľ': 'l', 'ĺ': 'l', 'ł': 'l',
    'ļ': 'l', 'ŀ': 'l', 'ñ': 'n', 'ň': 'n', 'ń': 'n', 'ņ': 'n', 'ó': 'o',
    'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o', 'ő': 'o', 'ō': 'o',
    'ŏ': 'o', 'ǒ': 'o', 'ơ': 'o', 'ọ': 'o', 'ỏ': 'o', 'ố': 'o', 'ồ': 'o',
    'ổ': 'o', 'ỗ': 'o', 'ộ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', 'ỡ': 'o',
    'ợ': 'o', 'œ': 'oe', 'ř': 'r', 'ŕ': 'r', 'ŗ': 'r', 'š': 's', 'ś': 's',
    'ş': 's', 'ș': 's', 'ŝ': 's', 'ß': 'ss', 'ť': 't', 'ţ': 't', 'ț': 't',
    'ŧ': 't', 'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ů': 'u', 'ű': 'u',
    'ū': 'u', 'ũ': 'u', 'ų': 'u', 'ŭ': 'u', 'ǔ': 'u', 'ư': 'u', 'ụ': 'u',
    'ủ': 'u', 'ứ': 'u', 'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u', 'ý': 'y',
    'ÿ': 'y', 'ŷ': 'y', 'ỳ': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ž': 'z',
    'ź': 'z', 'ż': 'z', 'þ': 'th',
    // Cyrillic.
    'ё': 'е', 'ї': 'і', 'й': 'и',
    // Greek.
    'ά': 'α', 'έ': 'ε', 'ή': 'η', 'ί': 'ι', 'ϊ': 'ι', 'ΐ': 'ι', 'ό': 'ο',
    'ύ': 'υ', 'ϋ': 'υ', 'ΰ': 'υ', 'ώ': 'ω', 'ς': 'σ',
  };

  // --- The word list, compiled ---------------------------------------------

  static final _Rules _rules = _Rules.of(
    profanityWords.values.expand((l) => l),
  );
}

enum _Kind { letter, leet, ambiguous }

class _Unit {
  const _Unit(this.folded, this.accented, this.start, this.end, this.kind);

  /// The character lower-cased, accents dropped (leetspeak read).
  final String folded;

  /// The character lower-cased, accents kept (leetspeak read).
  final String accented;
  final int start;
  final int end;
  final _Kind kind;
}

class _Word {
  _Word(this.units);

  final List<_Unit> units;

  int get start => units.first.start;
  int get end => units.last.end;

  /// Whether a character of it reads as i or l (`1`, `!`, `|`).
  bool get hasAmbiguous => units.any((u) => u.kind == _Kind.ambiguous);

  String folded(String ambiguousAs) => units
      .map((u) => u.kind == _Kind.ambiguous ? ambiguousAs : u.folded)
      .join();

  String accented(String ambiguousAs) => units
      .map((u) => u.kind == _Kind.ambiguous ? ambiguousAs : u.accented)
      .join();
}

/// The word list, compiled: the entries compared folded, and the
/// accent-sensitive (`=`) ones compared as typed.
class _Rules {
  _Rules(this.folded, this.accented);

  factory _Rules.of(Iterable<String> entries) {
    final f = _Table();
    final a = _Table();
    for (var e in entries) {
      final keepAccents = e.startsWith('=');
      if (keepAccents) e = e.substring(1);
      final anywhere = e.startsWith('*') && e.endsWith('*') && e.length > 2;
      final prefix = !anywhere && e.endsWith('*');
      final core = e.replaceAll('*', '');
      final text = keepAccents
          ? core.toLowerCase()
          : ProfanityFilter.fold(core);
      (keepAccents ? a : f).add(
        _Runs.of(text),
        anywhere
            ? _Mode.any
            : prefix
            ? _Mode.prefix
            : _Mode.word,
      );
    }
    return _Rules(f, a);
  }

  final _Table folded;
  final _Table accented;
}

enum _Mode { word, prefix, any }

/// A word as runs of one letter: "fuuuck" is f, u, c, k, with u three times.
/// Entries and words are compared run by run, so a run in a word matches a
/// run of the same letter in an entry when it is at least as long: "fuck"
/// refuses "fuuuck", "ass" never refuses "as".
class _Runs {
  _Runs(this.letters, this.counts);

  factory _Runs.of(String text) {
    final letters = <String>[];
    final counts = <int>[];
    for (final r in text.runes) {
      final ch = String.fromCharCode(r);
      if (letters.isNotEmpty && letters.last == ch) {
        counts[counts.length - 1]++;
      } else {
        letters.add(ch);
        counts.add(1);
      }
    }
    return _Runs(letters, counts);
  }

  final List<String> letters;
  final List<int> counts;
}

/// One form's entries (folded, or accented), by their letters with each run
/// once, to the least each run must repeat.
class _Table {
  final Map<_Mode, Map<String, List<List<int>>>> _byMode = {
    for (final m in _Mode.values) m: {},
  };

  /// The most runs an entry has: no longer stretch of a word is looked up.
  int _longest = 0;

  void add(_Runs entry, _Mode mode) {
    if (entry.letters.isEmpty) return;
    (_byMode[mode]![entry.letters.join()] ??= []).add(entry.counts);
    if (entry.letters.length > _longest) _longest = entry.letters.length;
  }

  /// Whether [word] (one form of it) holds an entry as its mode allows.
  bool matches(String word) {
    final w = _Runs.of(word);
    final n = w.letters.length;
    bool fits(List<List<int>>? found, int from) =>
        found != null &&
        found.any((min) {
          for (var i = 0; i < min.length; i++) {
            if (w.counts[from + i] < min[i]) return false;
          }
          return true;
        });

    if (fits(_byMode[_Mode.word]![w.letters.join()], 0)) return true;
    final prefix = _byMode[_Mode.prefix]!;
    final any = _byMode[_Mode.any]!;
    for (var from = 0; from < n; from++) {
      final key = StringBuffer();
      for (var k = from; k < n && k - from < _longest; k++) {
        key.write(w.letters[k]);
        final s = key.toString();
        if (from == 0 && fits(prefix[s], 0)) return true;
        if (fits(any[s], from)) return true;
      }
    }
    return false;
  }
}
