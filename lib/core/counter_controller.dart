import 'package:flutter/material.dart';
import 'pulse_detector.dart';
import 'target_alert.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  bool running = false;

  double threshold = 70;
  int debounce = 200;

  int target = 100;
  int alertDistance = 5;

  double sensorValue = 0;
  double maxSensorValue = 100;

  late PulseDetector detector;
  final TargetAlert alert = TargetAlert();

  CounterController() {
    _rebuildDetector();
  }

  void _rebuildDetector() {
    detector = PulseDetector(
      highThreshold: threshold,
      lowThreshold: threshold * 0.8,
      debounceMs: debounce,
    );
  }

  void updateSensor(double v) {
    sensorValue = v;
    if (v > maxSensorValue) maxSensorValue = v;

    if (detector.process(v)) {
      onPulse();
    }
    notifyListeners();
  }

  void onPulse() {
    if (!running) return;
    count++;
    alert.check(
      count: count,
      target: target,
      alertDistance: alertDistance,
    );
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
    alert.reset();
    notifyListeners();
  }

  void setThreshold(double v) {
    threshold = v;
    _rebuildDetector();
    notifyListeners();
  }

  void setDebounce(int v) {
    debounce = v;
    _rebuildDetector();
    notifyListeners();
  }

  void setTarget(int v) {
    target = v;
    notifyListeners();
  }


    void manualIncrement() {
    count++;
    notifyListeners();
  }

  void manualDecrement() {
    if (count > 0) {
      count--;
      notifyListeners();
    }
  }

  Color get counterColor {
    if (count >= target) return Colors.red;
    if (target - count <= 1) return Colors.orange;
    if (target - count <= alertDistance) return Colors.yellow;
    return Colors.white;
  }
}
