import 'package:flutter/material.dart';
import 'pulse_detector.dart';
import 'target_alert.dart';

enum SensorType { magnetometer, microphone }

class CounterController extends ChangeNotifier {
  int count = 0;
  bool running = false;

  double threshold = 70;
  int debounce = 200;

  int target = 100;
  int alertDistance = 5;

  SensorType sensorType = SensorType.magnetometer;

  double sensorValue = 0;

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
    notifyListeners();

    if (detector.process(v)) {
      onPulse();
    }
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

  void start() { running = true; notifyListeners(); }
  void stop() { running = false; notifyListeners(); }
  void reset() { count = 0; notifyListeners(); }

  void setThreshold(double v) {
    threshold = v;
    _rebuildDetector();
    notifyListeners();
  }

  void setTarget(int v) {
    target = v;
    notifyListeners();
  }

  void setAlertDistance(int v) {
    alertDistance = v;
    notifyListeners();
  }

  void setSensorType(SensorType t) {
    sensorType = t;
    notifyListeners();
  }
}
