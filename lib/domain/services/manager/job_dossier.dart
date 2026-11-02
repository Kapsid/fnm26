import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// One line of a job dossier's scouting verdict: what stands out about a
/// squad a manager is thinking of taking on. The judgement is the domain's;
/// the words belong to the copy (see `jobDossierNoteText`).
enum JobDossierNote {
  strongAttack,
  bluntAttack,
  strongMidfield,
  weakMidfield,
  strongDefence,
  thinDefence,
  safeKeeper,
  shakyKeeper,
  oldSquad,
  youngCore,
  oneStar,
  deepSquad,
  thinSquad,
}

/// A squad read for the job dossier at the end of a cycle: the team's rating,
/// its best men and what stands out, all from the pool's own numbers.
class JobDossierRead {
  const JobDossierRead({
    required this.rating,
    required this.top,
    required this.notes,
    required this.star,
  });

  /// How many of the best players the dossier lists.
  static const int topCount = 5;

  /// The team's rating: the mean overall of its best eleven, the number the
  /// AI reads a side's strength by (`AiTactics.readStrength`).
  final int rating;

  /// The [topCount] best players, best first.
  final List<Player> top;

  /// What stands out, strongest point first; empty for a side with no
  /// strength or hole worth a line.
  final List<JobDossierNote> notes;

  /// The man who carries them, when [notes] holds [JobDossierNote.oneStar].
  final Player? star;

  /// Reads [pool] (the nation as the world fields it).
  ///
  /// The units are each line's best men (a goalkeeper, four defenders, four
  /// midfielders, two forwards) against the side's own rating, so "a strong
  /// attack" means strong for THIS nation: a minnow's forwards can be its
  /// best asset without being any good. At most one strength and one
  /// weakness are named, the plainest of each, and then one line on the
  /// squad's shape (age, a lone star, depth).
  factory JobDossierRead.of(List<Player> pool) {
    final sorted = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));
    final xi = sorted.take(11).toList();
    if (xi.isEmpty) {
      return const JobDossierRead(rating: 0, top: [], notes: [], star: null);
    }
    final rating = xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;

    double? unit(PositionCategory c, int n) {
      final men = sorted.where((p) => p.category == c).take(n).toList();
      if (men.isEmpty) return null;
      return men.fold<int>(0, (s, p) => s + p.overall) / men.length;
    }

    // Each unit's gap to the side's rating, measured against how far that
    // gap usually runs across the world's pools (a goalkeeper is one man and
    // swings far more than four defenders do), and the notes it earns.
    final units = <(double, JobDossierNote, JobDossierNote)>[
      for (final (c, n, typical, spread, good, bad) in const [
        (
          PositionCategory.forward,
          2,
          -0.2,
          1.0,
          JobDossierNote.strongAttack,
          JobDossierNote.bluntAttack,
        ),
        (
          PositionCategory.midfielder,
          4,
          0.1,
          0.65,
          JobDossierNote.strongMidfield,
          JobDossierNote.weakMidfield,
        ),
        (
          PositionCategory.defender,
          4,
          -0.1,
          0.65,
          JobDossierNote.strongDefence,
          JobDossierNote.thinDefence,
        ),
        (
          PositionCategory.goalkeeper,
          1,
          -1.4,
          2.1,
          JobDossierNote.safeKeeper,
          JobDossierNote.shakyKeeper,
        ),
      ])
        if (unit(c, n) case final avg?)
          ((avg - rating - typical) / spread, good, bad),
    ];
    final notes = <JobDossierNote>[];
    final best = [...units]..sort((a, b) => b.$1.compareTo(a.$1));
    if (best.isNotEmpty && best.first.$1 >= _unitStandsOut) {
      notes.add(best.first.$2);
    }
    if (best.isNotEmpty && best.last.$1 <= -_unitStandsOut) {
      notes.add(best.last.$3);
    }

    // And one line on the squad's shape, the most telling first.
    Player? star;
    final meanAge = xi.fold<int>(0, (s, p) => s + p.age) / xi.length;
    final young = xi.where((p) => p.age <= 23).length;
    final bench = sorted.skip(11).take(12).toList();
    final benchGap = bench.isEmpty
        ? double.infinity
        : rating - bench.fold<int>(0, (s, p) => s + p.overall) / bench.length;
    if (sorted.length > 1 &&
        sorted[0].overall - sorted[1].overall >= _starLead &&
        sorted[0].overall - rating >= _starOverSide) {
      star = sorted[0];
      notes.add(JobDossierNote.oneStar);
    } else if (meanAge >= _oldAge) {
      notes.add(JobDossierNote.oldSquad);
    } else if (young >= _youngCore || meanAge <= _youngAge) {
      notes.add(JobDossierNote.youngCore);
    } else if (benchGap >= _thinBench) {
      notes.add(JobDossierNote.thinSquad);
    } else if (benchGap <= _deepBench) {
      notes.add(JobDossierNote.deepSquad);
    }
    return JobDossierRead(
      rating: rating.round(),
      top: sorted.take(topCount).toList(),
      notes: notes,
      star: star,
    );
  }

  /// How many of its usual spreads a unit sits from the usual before it is
  /// a strength or a weakness: about one side in six either way.
  static const double _unitStandsOut = 1;

  /// The best man's lead over the second best, and over the side's rating,
  /// before he is the one carrying them.
  static const int _starLead = 2;
  static const double _starOverSide = 3.3;

  /// The best eleven's mean age from which the squad is an old one, and
  /// up to which it is a young one.
  static const double _oldAge = 27.6;
  static const double _youngAge = 24.5;

  /// Men of 23 or under in the best eleven that make a young core.
  static const int _youngCore = 6;

  /// The gap between the best eleven and the next twelve, in rating, beyond
  /// which the squad is thin, and within which it is deep.
  static const double _thinBench = 3.2;
  static const double _deepBench = 1.8;
}
