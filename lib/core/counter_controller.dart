import 'package:flutter/material.dart';
import 'pulse_detector.dart';
import 'target_alert.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  bool running = false;
  
  double threshold = 70.0;
  int debounce = 200;
  int target = 100;
  
  bool isSoundEnabled = true;
  bool isVibrationEnabled = true;

  double sensorValue = 0;
  double maxDetectedValue = 0.0;

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
    if (v > maxDetectedValue) maxDetectedValue = v;
    
    if (detector.process(v)) {
      onPulse();
    }
    notifyListeners();
  }

  void autoCalibrate() {
    if (maxDetectedValue > 5) {
      threshold = maxDetectedValue * 0.75; // ۷۵ درصد اوج سیگنال
      _rebuildDetector();
      notifyListeners();
    }
  }

  void onPulse() {
    if (!running) return;
    count++;
    alert.check(
      count: count,
      target: target,
      soundEnabled: isSoundEnabled,
      vibrationEnabled: isVibrationEnabled,
    );
    notifyListeners();
  }

  void setThreshold(double v) {
    threshold = v;
    _rebuildDetector();
    notifyListeners();
  }

  void setTarget(int v) {
    target = v;
    notifyListeners();
  }

  void setDebounce(int v) {
    debounce = v;
    _rebuildDetector();
    notifyListeners();
  }

  void toggleSound(bool v) => {isSoundEnabled = v, notifyListeners()};
  void toggleVibration(bool v) => {isVibrationEnabled = v, notifyListeners()};

  void start() => {running = true, notifyListeners()};
  void stop() => {running = false, notifyListeners()};
  
  void reset() {
    count = 0;
    maxDetectedValue = 0;
    alert.reset();
    notifyListeners();
  }

  void manualIncrement() => {count++, notifyListeners()};
  void manualDecrement() => {if (count > 0) count--, notifyListeners()};

  Color get counterColor {
    if (count >= target) return Colors.red;
    if (target - count <= 5) return Colors.orange;
    return Colors.white;
  }
}
