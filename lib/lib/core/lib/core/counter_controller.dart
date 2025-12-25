import 'package:flutter/material.dart';
import 'pulse_detector.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  double threshold = 70;
  int debounce = 200;
  bool running = false;

  late PulseDetector detector;

  CounterController() {
    detector = PulseDetector(
      threshold: threshold,
      debounceMs: debounce,
    );
  }

  void onPulse() {
    if (!running) return;
    count++;
    notifyListeners();
  }

  void start() {
    running = true;
    notifyListeners();
  }

  void stop() {
    running = false;
    notifyListeners();
  }

  void reset() {
    count = 0;
    notifyListeners();
  }

  void setThreshold(double v) {
    threshold = v;
    detector.threshold = v;
    notifyListeners();
  }

  void setDebounce(int v) {
    debounce = v;
    detector.debounceMs = v;
    notifyListeners();
  }
}
