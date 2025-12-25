class PulseDetector {
  double highThreshold;
  double lowThreshold;
  int debounceMs;

  final List<double> _window = [];
  final int windowSize = 5;

  DateTime _lastPulse = DateTime.fromMillisecondsSinceEpoch(0);
  bool _armed = true;

  PulseDetector({
    required this.highThreshold,
    required this.lowThreshold,
    required this.debounceMs,
  });

  bool process(double value) {
    _window.add(value);
    if (_window.length > windowSize) _window.removeAt(0);

    final avg =
        _window.reduce((a, b) => a + b) / _window.length;

    final now = DateTime.now();

    if (_armed &&
        avg > highThreshold &&
        now.difference(_lastPulse).inMilliseconds > debounceMs) {
      _armed = false;
      _lastPulse = now;
      return true;
    }

    if (!_armed && avg < lowThreshold) {
      _armed = true;
    }

    return false;
  }
}
