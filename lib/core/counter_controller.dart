import 'package:flutter/material.dart';
import 'pulse_detector.dart';
import 'target_alert.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  bool running = false;
  
  double threshold = 70;
  int debounce = 200;
  int target = 100;
  
  bool isSoundEnabled = true;      // جدید
  bool isVibrationEnabled = true;  // جدید

  double sensorValue = 0;
  double maxDetectedValue = 0;     // برای کالیبراسیون خودکار

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
    if (v > maxDetectedValue) maxDetectedValue = v; // ثبت بالاترین مقدار برای کالیبراسیون
    
    if (detector.process(v)) {
      onPulse();
    }
    notifyListeners();
  }

  // ۱. پیدا کردن خودکار سطح تریگر
  void autoCalibrate() {
    if (maxDetectedValue > 5) {
      threshold = maxDetectedValue * 0.7; // ۷۰ درصد اوج را تریگر میزاریم
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
      alertDistance: 5,
      soundEnabled: isSoundEnabled,
      vibrationEnabled: isVibrationEnabled,
    );
    notifyListeners();
  }

  // تنظیمات دستی
  void setThreshold(double v) {
    threshold = v;
    _rebuildDetector();
    notifyListeners();
  }

  void toggleSound(bool v) { isSoundEnabled = v; notifyListeners(); }
  void toggleVibration(bool v) { isVibrationEnabled = v; notifyListeners(); }
  
  void start() { running = true; notifyListeners(); }
  void stop() { running = false; notifyListeners(); }
  void reset() { count = 0; maxDetectedValue = 0; alert.reset(); notifyListeners(); }
  void setTarget(int v) { target = v; notifyListeners(); }
}
