import 'package:fnm/features/match/sound/match_audio.dart';

/// A [MatchAudio] that plays nothing and writes down what it was asked:
/// `play roar 0.53`, `start crowdFull 0.21`, `volume crowdThin 0.07`,
/// `stop crowdFull`, `stopAll`.
class FakeMatchAudio implements MatchAudio {
  final List<String> calls = [];

  /// The loops playing now, at their last volume.
  final Map<SoundLoop, double> loops = {};

  /// The cues played, in order.
  List<SoundCue> get cues => [
    for (final c in calls)
      if (c.startsWith('play ')) SoundCue.values.byName(c.split(' ')[1]),
  ];

  @override
  Future<void> play(SoundCue cue, double volume) async =>
      calls.add('play ${cue.name} ${volume.toStringAsFixed(2)}');

  @override
  Future<void> startLoop(SoundLoop loop, double volume, {Duration? fade}) {
    loops[loop] = volume;
    calls.add('start ${loop.name} ${volume.toStringAsFixed(2)}');
    return Future.value();
  }

  @override
  Future<void> setLoopVolume(
    SoundLoop loop,
    double volume, {
    Duration? fade,
  }) async {
    if (!loops.containsKey(loop)) return;
    loops[loop] = volume;
    calls.add('volume ${loop.name} ${volume.toStringAsFixed(2)}');
  }

  @override
  Future<void> stopLoop(SoundLoop loop, {Duration? fade}) async {
    loops.remove(loop);
    calls.add('stop ${loop.name}');
  }

  @override
  Future<void> stopAll() async {
    loops.clear();
    calls.add('stopAll');
  }
}
