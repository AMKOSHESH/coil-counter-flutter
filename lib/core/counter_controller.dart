import 'package:flutter/material.dart';
import 'pulse_detector.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  double threshold = 70;
  int debounce = 200;
  bool running = false;
  double sensorValue = 0;

  late PulseDetector detector;

  CounterController() {
    detector = PulseDetector(
      threshold: threshold,
      debounceMs: debounce,
    );
  }

  // این همان تابعی است که سیستم پیدا نمی‌کرد
  void updateSensorValue(double v) {
    sensorValue = v;
    notifyListeners();
  }

  void onPulse() {
    if (!running) return;
    count++;
    notifyListeners();
  }

  void start() => {running = true, notifyListeners()};
  void stop() => {running = false, notifyListeners()};
  void reset() => {count = 0, notifyListeners()};

  void setThreshold(double v) {
    threshold = v;
    detector.threshold = v;
    notifyListeners();
  }
}
