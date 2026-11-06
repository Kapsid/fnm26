import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

/// The Pitch view's clock: screen time into the match's picture, driven by
/// a [Ticker] while it plays.
///
/// The value is screen time (what `PitchScript.sample` takes); [match] reads
/// it back as a match minute through the [pacer]. The pacer already fits
/// the match to the chosen speed (slow, mid, fast); [speed] is a further
/// playback rate on top of it, 1 by default.
///
/// It stops by itself at the final whistle ([total]). Breaks (half-time,
/// talks, a tactics sheet) are the screen's to make: it [pause]s and
/// [play]s again.
class PitchClock extends ChangeNotifier implements ValueListenable<Duration> {
  PitchClock({
    required TickerProvider vsync,
    required PitchPacer pacer,
    Duration start = Duration.zero,
    double speed = 1,
  }) : _pacer = pacer,
       _speed = speed,
       _value = start {
    _ticker = vsync.createTicker(_tick);
    _value = _clamp(start);
  }

  late final Ticker _ticker;
  PitchPacer _pacer;
  double _speed;
  Duration _value;

  /// Where the clock stood, and the ticker's elapsed time, when it last
  /// started or changed speed.
  Duration _anchorValue = Duration.zero;
  Duration _anchorElapsed = Duration.zero;
  Duration _lastElapsed = Duration.zero;

  @override
  Duration get value => _value;

  PitchPacer get pacer => _pacer;

  /// A new pacing (a re-simulated match, or another speed): the clock keeps
  /// its screen time, clamped to the new length. Seek with [seekToMatch]
  /// to keep the match minute instead.
  set pacer(PitchPacer p) {
    _pacer = p;
    _jump(_value);
  }

  Duration get total => _pacer.total;

  bool get playing => _ticker.isActive;

  /// At the final whistle.
  bool get finished => _value >= total;

  /// The match minute the clock is in.
  ({int minute, int stoppage, double within}) get match =>
      _pacer.matchAt(_value);

  /// Screen seconds per real second, on top of the pacer's own speed.
  double get speed => _speed;
  set speed(double s) {
    assert(s > 0, 'a clock runs forward');
    _reanchor();
    _speed = s;
  }

  void play() {
    if (_ticker.isActive || finished) return;
    _anchorValue = _value;
    _anchorElapsed = Duration.zero;
    _lastElapsed = Duration.zero;
    _ticker.start();
    notifyListeners();
  }

  void pause() {
    if (!_ticker.isActive) return;
    _ticker.stop();
    notifyListeners();
  }

  /// Jumps to screen time [to] (clamped to the match), playing on if it
  /// was playing.
  void seek(Duration to) => _jump(to);

  /// Jumps to the start of match minute [minute] (+[stoppage]), [within]
  /// (0 to 1) of the way through it.
  void seekToMatch(int minute, int stoppage, {double within = 0}) =>
      _jump(_pacer.screenAt(minute, stoppage, within: within));

  void _jump(Duration to) {
    _value = _clamp(to);
    _reanchor();
    if (finished && _ticker.isActive) _ticker.stop();
    notifyListeners();
  }

  void _reanchor() {
    _anchorValue = _value;
    _anchorElapsed = _lastElapsed;
  }

  Duration _clamp(Duration d) =>
      d < Duration.zero ? Duration.zero : (d > total ? total : d);

  void _tick(Duration elapsed) {
    _lastElapsed = elapsed;
    final run = elapsed - _anchorElapsed;
    _value = _clamp(_anchorValue + run * _speed);
    if (finished) _ticker.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
