class PulseDetector {
  double threshold;
  int debounceMs;

  DateTime _lastPulse = DateTime.fromMillisecondsSinceEpoch(0);
  double _prevValue = 0;

  PulseDetector({
    required this.threshold,
    required this.debounceMs,
  });

  bool process(double value) {
    final now = DateTime.now();

    final isRising = value > _prevValue;
    final passedThreshold = value > threshold;
    final debounceOk =
        now.difference(_lastPulse).inMilliseconds > debounceMs;

    _prevValue = value;

    if (isRising && passedThreshold && debounceOk) {
      _lastPulse = now;
      return true;
    }
    return false;
  }
}
